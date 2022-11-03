/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file about: protoc
 */
package protoc

import google.protobuf.*
import google.protobuf.compiler.*
from std import collection.*
from std import unicode.*

/**
 * The Function is cj_generator
 *
 * @param inbuf of ArrayList<UInt8>
 * @param outbuf of ArrayList<UInt8>
 *
 * @return Type of Unit
 * @since 0.29.3
 */
public func cj_generator(inbuf: ArrayList<UInt8>, outbuf: ArrayList<UInt8>): Unit {
    let req = CodeGeneratorRequest()
    req.unpack(inbuf)

    let resp = CodeGeneratorResponse()

    // A collection of files that need to generate code
    let genfiles = HashSet<String>()
    for (path in req.fileToGenerate) {
        genfiles.put(path)
    }
    // Processing files that require code generation
    for (desc in req.protoFile) {
        if (genfiles.contains(desc.name)) {
            fileProcess(desc, resp.file.add())
        }
    }
    resp.pack(outbuf)
}

/* Get file name */
func getFileName(path: String): String {
    let sp = path.split('/')
    sp[sp.size - 1].replace(".proto", ".pb.cj")
}

/* Get dest path by package name */
func getDestPath(package_: String): String {
    if (package_ == "") { "" } else { package_.replace('.', '/') + '/' }
}

class LineSepOut {
    LineSepOut (
        let outbuf: StringBuilder,
        let sep!: String = ",",     // Separator
        let sn!: Int64 = 12,        // Number of spaces automatically added to a new line
        let ln!: Int64 = 120 - sep.size    // One line limit characters
    ) {
        ss = " " * sn
        cn = sn
    }

    let ss: String
    var cn: Int64
    var first = true

    /* Append s */
    func append(s: String) {
        if (first) {
            cn += s.size
            outbuf.append(ss).append(s)
            first = false
            return
        }
        // Not the first, append separator
        cn += sep.size
        outbuf.append(sep)
        // Judge whether line feed is required
        if (cn + 1 + s.size > ln) {
            cn = sn + s.size
            outbuf.append('\n').append(ss).append(s)
        } else {
            cn += 1 + s.size
            outbuf.append(' ').append(s)
        }
    }

    /* Reset */
    func reset() {
        cn = sn
        first = true
    }
}

/* save or process context of every proto file */
class GenCodeHelper {
    /* Get type name based on nesting level */
    let nested = ArrayList<String>()
    func getNestedTypeName(name: String) {
        if (nested.isEmpty()) { return name }
        let sb = StringBuilder()
        for (n in nested) {
            sb.append(n).append('_')
        }
        sb.append(name).toString()
    }

    /* package prefix of the proto file */
    let pkgPrefix: String
    GenCodeHelper (package_: String, let proto2: Bool) {
        pkgPrefix = if (package_ == "") { "." } else { ".${package_}." }
    }

    // pkg Dictionary order reverse
    static func pkgCmp(a: String, b: String) {
        if (a == b) { Ordering.EQ } else if (a < b) { Ordering.GT } else { Ordering.LT }
    }

    /* Get all dependent packages */
    let packages = ArrayList<String>()
    func getDependencyPackages(desc: FileDescriptorProto) {
        let pkgs = HashSet<String>()
        for (dep in desc.dependency) {
            if (let Some(i) = dep.lastIndexOf('/')) {
                let pkg = dep.substring(0, i).replace('/', '.')
                if (desc.package_ == "protobuf" && pkg != "protobuf") {
                    /* Dependency on external packages is not allowed in protobuf packages, and circular dependency on packages is not allowed in Cangjie */
                    throw Exception() // todo
                }
                if (pkg != desc.package_ && pkg != "protobuf") {
                    /* Save packages other than `desc` itself and protobuf */
                    pkgs.put(pkg)
                }
            }
        }
        packages.append(pkgPrefix)
        for (p in pkgs) { packages.append(".${p}.") }
        packages.sortBy(pkgCmp)
        pkgs
    }

    func getTypeName(typeName: String) {
        for (p in packages) {
            if (typeName.startsWith(p)) {
                if (p == pkgPrefix) {
                    return String.join(typeName.substring(p.size).split('.'), delimiter: "_")
                }
                return p.substring(1) + String.join(typeName.substring(p.size).split('.'), delimiter: "_")
            }
        }
        throw Exception() // todo
    }

    // For type_ Message, special process if it is a map
    func setMessageTypeName(f: FieldDescriptorProto, ns: ArrayList<DescriptorProto>) {
        do {
            if (f.label != LABEL_REPEATED) { break }
            let sp = f.typeName.split('.')
            let entry = sp[sp.size - 1]
            if (!entry.endsWith("Entry")) { break }
            // Looking for entry in nestedtype
            for (n in ns) {
                if (n.field.size != 2 || n.name != entry) { continue }
                if (!n.hasOptions || !n.options.hasMapEntry || !n.options.mapEntry) { break }
                /* save map entry's fields */
                return f.typeName = getEntryTypeInfo(n.field[0]) + "," + getEntryTypeInfo(n.field[1])
            }
        } while (false)
        /* normal message field */
        f.typeName = getTypeName(f.typeName)
    }

    let outbuf = StringBuilder()
    var oneofDecl = ArrayList<OneofDescriptorProto>()
}

func fileProcess(desc: FileDescriptorProto, file: CodeGeneratorResponse_File) {
    // Destination file path
    if (desc.hasPackage == false) { desc.package_ = "" }
    file.name = getDestPath(desc.package_) + getFileName(desc.name)
    let proto2 = if (desc.hasSyntax) { desc.syntax == "proto2" } else { true }
    let helper = GenCodeHelper(desc.package_, proto2)
    // Header information
    genCodeHeader(desc, helper)
    // all message
    for (msg in desc.messageType) {
        genCodeMessage(msg, helper)
    }
    // all enum
    for (e in desc.enumType) {
        genCodeEnum(e, helper)
    }
    // all service
    for (ser in desc.service) {
        genCodeService(ser, helper)
    }
    // all extension
    for (ext in desc.extension) {
        genCodeExtension(ext, helper)
    }
    // Target file content
    file.content = helper.outbuf.toString()
}

func genCodeHeader(desc: FileDescriptorProto, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append
    // package
    if (desc.package_ != "") { append("package ${desc.package_}\n\n") }
    // import
    append("from std import collection.*\n")
    if (desc.package_ != "protobuf") {
        append("from protobuf import protobuf.*\n")
    }
    if (!desc.service.isEmpty() && desc.package_ != "grpc") {
        append("from protobuf import grpc.*\n")
    }
    for (pkg in helper.getDependencyPackages(desc)) {
        append("import ${pkg}.*\n")
    }
}

func getEntryTypeInfo(entry: FieldDescriptorProto) {
    match (entry.type_) {
        case TYPE_DOUBLE => "Float64,,Float64Unpacker"
        case TYPE_FLOAT => "Float64,,Float64Unpacker"
        case TYPE_INT64 => "Int64,,Int64Unpacker"
        case TYPE_UINT64 => "UInt64,,UInt64Unpacker"
        case TYPE_INT32 => "Int32,,Int32Unpacker"
        case TYPE_UINT32 => "UInt32,,UInt32Unpacker"
        case TYPE_ENUM => "${entry.typeName},,EnumUnpacker<${entry.typeName}>"
        case TYPE_BOOL => "Bool,,BoolUnpacker"
        case TYPE_STRING => "String,,StringUnpacker"
        case TYPE_MESSAGE => "${entry.typeName},,MessageUnpacker<${entry.typeName}>"
        case TYPE_BYTES => "Bytes,,BytesUnpacker"
        case TYPE_FIXED64 => "UInt64,Fixed64,Fixed64Unpacker"
        case TYPE_FIXED32 => "UInt32,Fixed32,Fixed32Unpacker"
        case TYPE_SFIXED32 => "Int32,SFixed32,SFixed32Unpacker"
        case TYPE_SFIXED64 => "Int64,SFixed64,SFixed64Unpacker"
        case TYPE_SINT32 => "Int32,SInt32,SInt32Unpacker"
        case TYPE_SINT64 => "Int64,SInt64,SInt64Unpacker"
        case _=> throw Exception()
    }
}

func getUnpacker(f: FieldDescriptorProto) {
    if (f.type_ == TYPE_MESSAGE && f.typeName.contains(',')) {
        let types = f.typeName.split(",")
        return "MapUnpacker<${types[0]}, ${types[3]}>(${f.number}, ${types[2]}.unbox, ${types[5]}.unbox)"
    }

    let ac = match (f.type_) {
        case TYPE_DOUBLE => "Float64Unpacker"
        case TYPE_FLOAT => "Float32Unpacker"
        case TYPE_INT64 => "Int64Unpacker"
        case TYPE_UINT64 => "UInt64Unpacker"
        case TYPE_INT32 => "Int32Unpacker"
        case TYPE_FIXED64 => "Fixed64Unpacker"
        case TYPE_FIXED32 => "Fixed32Unpacker"
        case TYPE_BOOL => "BoolUnpacker"
        case TYPE_STRING => "StringUnpacker"
        case TYPE_MESSAGE => "MessageUnpacker<${f.typeName}>"
        case TYPE_BYTES => "BytesUnpacker"
        case TYPE_UINT32 => "UInt32Unpacker"
        case TYPE_ENUM => "EnumUnpacker<${f.typeName}>"
        case TYPE_SFIXED32 => "SFixed32Unpacker"
        case TYPE_SFIXED64 => "SFixed64Unpacker"
        case TYPE_SINT32 => "SInt32Unpacker"
        case TYPE_SINT64 => "SInt64Unpacker"
        case _ => throw Exception() // todo
    }

    // Process repeated
    if (f.label != LABEL_REPEATED) { return ac + ".instance" }
    if (f.hasOptions && f.options.hasPacked && f.options.packed) { return ac + ".packedInstance" }
    ac + ".repeatInstance(${f.number})"
}

func getFieldSetName(f: FieldDescriptorProto) {
    if (f.type_ == TYPE_MESSAGE && f.typeName.contains(',')) {
        let types = f.typeName.split(",")
        var ret = "MapField<${types[0]}, ${types[3]}>(${f.number}, v"
        if (types[1] != "") { ret += ", kb: ${types[1]}.box" }
        if (types[4] != "") { ret += ", vb: ${types[4]}.box" }
        return ret + ')'
    }

    let vt = match (f.type_) { /* 包装类型 */
        case TYPE_FIXED32 => "Fixed32"
        case TYPE_FIXED64 => "Fixed64"
        case TYPE_SFIXED32 => "SFixed32"
        case TYPE_SFIXED64 => "SFixed64"
        case TYPE_SINT32 => "SInt32"
        case TYPE_SINT64 => "SInt64"
        case _ => ""
    }

    if (f.label != LABEL_REPEATED) {
        if (vt.isEmpty()) {
            return "v"
        }
        return vt + "(v)"
    }

    let pt = match (f.type_) {
        case TYPE_DOUBLE => "Float64"
        case TYPE_FLOAT => "Float32"
        case TYPE_INT64 | TYPE_SFIXED64 | TYPE_SINT64 => "Int64"
        case TYPE_UINT64 | TYPE_FIXED64 => "UInt64"
        case TYPE_INT32 | TYPE_SFIXED32 | TYPE_SINT32 => "Int32"
        case TYPE_BOOL => "Bool"
        case TYPE_STRING => "String"
        case TYPE_BYTES => "Bytes"
        case TYPE_UINT32 | TYPE_FIXED32 => "UInt32"
        case _ => f.typeName
    }

    if (f.hasOptions && f.options.hasPacked && f.options.packed) {
        return if (vt.isEmpty()) { "PackedField<${pt}>(v)" } else { "Packed${vt}(v)" }
    }

    if (vt.isEmpty()) { "RepeatField<${pt}>(${f.number}, v)" } else { "Repeat${vt}(${f.number}, v)" }
}

func getPropType(f: FieldDescriptorProto) {
    if (f.type_ == TYPE_MESSAGE && f.typeName.contains(',')) {
        let types = f.typeName.split(",")
        return "HashMap<${types[0]}, ${types[3]}>"
    }

    let pt = match (f.type_) {
        case TYPE_DOUBLE => "Float64"
        case TYPE_FLOAT => "Float32"
        case TYPE_INT64 | TYPE_SFIXED64 | TYPE_SINT64 => "Int64"
        case TYPE_UINT64 | TYPE_FIXED64 => "UInt64"
        case TYPE_INT32 | TYPE_SFIXED32 | TYPE_SINT32 => "Int32"
        case TYPE_BOOL => "Bool"
        case TYPE_STRING => "String"
        case TYPE_BYTES => "Bytes"
        case TYPE_UINT32 | TYPE_FIXED32 => "UInt32"
        case _ => f.typeName
    }
    if (f.label == LABEL_REPEATED) { "ArrayList<${pt}>" } else { pt }
}

let staticInitCodes =
"""
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag
"""

let memberInitCodes =
"""
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
"""

let staticParserCodes =
"""
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
"""

func genCodeMessageField(typeName: String, fields: ArrayList<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append
    let sepOut = LineSepOut(helper.outbuf)

    // class
    let base = if (helper.proto2) { "MessageLite2" } else { "MessageLite" }
    append("\npublic class ${typeName} <: ${base} {\n")

    if (fields.isEmpty()) {
        append("    public func clone(): ${typeName} { ${typeName}() }\n}\n")
        return
    }

    // static init and calc special fields
    let spec = initSpecialFields(fields, helper)

    // s_init
    // unpacker
    append("\n    static func s_init() {\n        s_unpackers = HashMap<Tag, Unpacker>([\n")
    for (f in fields) { sepOut.append("(${f.number}, ${getUnpacker(f)})") }
    append("\n        ])\n")

    // names
    append("\n        s_names = HashMap<Tag, String>([\n")
    sepOut.reset()
    for (f in fields) { sepOut.append("(${f.number}, \"${f.jsonName}\")") }
    append("\n        ])\n")

    // nameTags
    append("\n        s_nameTags = HashMap<String, Tag>([\n")
    sepOut.reset()
    for (f in fields) { sepOut.append("(\"${f.jsonName}\", ${f.number})") }
    append("\n        ])\n")

    // gen special fields, and init() codes
    genCodeSpecialFields(sepOut, spec, helper)

    // clone
    append("\n    public func clone(): ${typeName} { let m = ${typeName}(); m.m_fieldsClone(this); m }\n")

    // props
    for (f in fields) {
        append("\n    public prop var ${getMessagePropName(f.jsonName)}: ${getPropType(f)} {\n")
        append("        get( ) { get(${f.number}) }\n")
        append("        set(v) { set(${f.number}, ${getFieldSetName(f)}) }\n")
        append("    }\n")
    }

    // proto2 hasXXX props
    if (helper.proto2) {
        var newline = true
        for (f in fields where f.label != LABEL_REPEATED) {
            if (newline) { append("\n"); newline = false }
            append("    public prop let has${titleCase(f.jsonName)}: Bool { get() { m_fields.contains(${f.number}) } }\n")
        }
    }

    // oneof props
    genCodeOneofProps(typeName, fields, helper)

    // props end
    append("}\n")
}

/* init special fields, including default value, required fields, oneof fields */
func initSpecialFields(fields: ArrayList<FieldDescriptorProto>, helper: GenCodeHelper) {
    let dvs = ArrayList<String>()
    let reqs = ArrayList<Int32>()
    let oneofs = ArrayList<String>()
    let append: (String) -> StringBuilder = helper.outbuf.append

    if (helper.proto2) {
        for (f in fields) {
            /* required fields */
            if (f.label == LABEL_REQUIRED) {
                reqs.append(f.number)
            }

            /* try to get default value, support string, numbers, bool, enum only */
            if (!f.hasDefaultValue) { continue }
            let dv = match (f.type_) {
                case TYPE_STRING => "\"${f.defaultValue}\""
                case TYPE_BOOL | TYPE_INT64 | TYPE_DOUBLE => f.defaultValue
                case TYPE_ENUM => "${getPropType(f)}.${f.defaultValue}"
                case TYPE_BYTES => throw Exception("bytes field unsupport default option")
                case _ => "${getPropType(f)}(${f.defaultValue})"
            }
            dvs.append("(${f.number}, ${dv})")
        }
    }

    if (!helper.oneofDecl.isEmpty()) {
        for (f in fields) {
            if (!f.hasOneofIndex) { continue }
            oneofs.append("(${f.number}, ${f.oneofIndex})")
        }
    }

    append(staticInitCodes)
    /* static member variables of special fields */
    if (!dvs.isEmpty()) { append("    static var s_defaultValue = s_initHashMapTagMessageFile\n") }
    if (!reqs.isEmpty()) { append("    static var s_requiredFields = s_initArrayTag\n") }
    if (!oneofs.isEmpty()) { append("    static var s_oneofIndex = s_initHashMapTagInt64\n") }

    (dvs, reqs, oneofs)
}

/* gen special fields codes, init() is surrounded by special fields, gen together. */
func genCodeSpecialFields(sepOut: LineSepOut, spec: (ArrayList<String>, ArrayList<Int32>, ArrayList<String>), helper: GenCodeHelper) {
    let (dvs, reqs, oneofs) = spec
    let append: (String) -> StringBuilder = sepOut.outbuf.append

    // default value
    if (!dvs.isEmpty()) {
        append("\n        s_defaultValue = HashMap<Tag, MessageField>([\n")
        sepOut.reset()
        for (dv in dvs) {
            sepOut.append(dv)
        }
        append("\n        ])\n")
    }

    // required fields
    if (!reqs.isEmpty()) {
        append("\n        s_requiredFields = Array<Tag>([\n")
        sepOut.reset()
        for (req in reqs) {
            sepOut.append("${req}")
        }
        append("\n        ])\n")
    }

    // oneof fields
    if (!oneofs.isEmpty()) {
        append("\n        s_oneofIndex = HashMap<Tag, Int64>([\n")
        sepOut.reset()
        for (oneof in oneofs) {
            sepOut.append(oneof)
        }
        append("\n        ])\n")
    }

    // set special fields in init
    append(memberInitCodes)
    if (!dvs.isEmpty()) { append("        m_defaultValue = s_defaultValue\n") }
    if (!reqs.isEmpty()) { append("        m_requiredFields = s_requiredFields\n") }
    if (!oneofs.isEmpty()) {
        append("        m_oneofIndex = s_oneofIndex\n")
        append("        m_oneofCase = Array<Tag>(${helper.oneofDecl.size}, item: UNSETCASE)\n")
    }

    // init end
    append("    }\n")
}

func genCodeMessageParser(typeName: String, helper: GenCodeHelper) {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\nextend ${typeName} <: MessageParser<${typeName}> {\n")
    append("    public static func fromJson(src: JsonObject) { let m = ${typeName}(); m.unpack(src); m }\n")
    append("    public static func fromBytes(src: BytesReader) { let m = ${typeName}(); m.unpack(src); m }\n")
    // cangjie 0.32.5, static default implementation in interface is forbidden now
    append(staticParserCodes)
    append("}\n")
}

func genCodeMessageExtension(typeName: String, extensions: ArrayList<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    // todo
}

func genCodeMessage(msg: DescriptorProto, helper: GenCodeHelper): Unit {
    let typeName = helper.getNestedTypeName(msg.name)
    let fields = msg.field
    let extensions = msg.extension

    helper.nested.append(msg.name)
    // Embedded message
    for (m in msg.nestedType) {
        genCodeMessage(m, helper)
    }
    // Embedded enum
    for (e in msg.enumType) {
        genCodeEnum(e, helper)
    }
    helper.nested.remove(helper.nested.size - 1)

    for (f in fields) {
        // Set typename
        match (f.type_) {
            case TYPE_ENUM => f.typeName = helper.getTypeName(f.typeName)
            case TYPE_MESSAGE => helper.setMessageTypeName(f, msg.nestedType)
            case _ => ()
        }
    }

    // Mapentry sets typename without generating message
    if (fields.size == 2 && msg.hasOptions && msg.options.hasMapEntry && msg.options.mapEntry) { return }

    helper.oneofDecl = msg.oneofDecl
    // fields
    genCodeMessageField(typeName, fields, helper)
    // parser
    genCodeMessageParser(typeName, helper)
    // extensions
    genCodeMessageExtension(typeName, extensions, helper)
    // oneof group enum
    genCodeOneofGroup(typeName, fields, helper)

    // todo extension range
    // todo reserved range
}

func genCodeEnum(e: EnumDescriptorProto, helper: GenCodeHelper): Unit {
    let typeName = helper.getNestedTypeName(e.name)
    let values = e.value
    let append: (String) -> StringBuilder = helper.outbuf.append
    let sepOut = LineSepOut(helper.outbuf, sep: "", sn: 4)

    // enum
    append("\npublic enum ${typeName} <: Enum<${typeName}> {\n")
    for (v in values) {
        sepOut.append("| ${getEnumItemName(v.name)}")
    }
    append("\n\n")

    // value
    append("    public func value(): Int32 {\n        match(this) {\n")
    for (v in values) {
        append("            case ${getEnumItemName(v.name)} => ${v.number}\n")
    }
    append("        }\n    }\n")
    // toString
    append("\n    public func toString(): String {\n        match(this) {\n")
    for (v in values) {
        append("            case ${getEnumItemName(v.name)} => \"${v.name}\"\n")
    }
    append("        }\n    }\n")
    // parse
    append("\n    public static func parse(value: Int32): ${typeName} {\n        match(value) {\n")
    for (v in values) {
        append("            case ${v.number} => ${getEnumItemName(v.name)}\n")
    }
    append("            case e => throw InvalidEnumValueException(\"${typeName}\", e)\n")
    append("        }\n    }\n")
    // parse, from string
    append("\n    public static func parse(value: String): ${typeName} {\n        match(value) {\n")
    for (v in values) {
        append("            case \"${v.name}\" => ${getEnumItemName(v.name)}\n")
    }
    append("            case e => throw UnmatchedEnumStringException(\"${typeName}\", e)\n")
    append("        }\n    }\n")
    // extend Enum end
    append("}\n")
}

func genCodeService(ser: ServiceDescriptorProto, helper: GenCodeHelper): Unit {
    // ignore
}

/* gen oneof group type define (enum) */
func genCodeOneofGroup(typeName: String, fields: ArrayList<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    for ((index, decl) in withIndex(helper.oneofDecl)) {
        let append: (String) -> StringBuilder = helper.outbuf.append
        let sepOut = LineSepOut(helper.outbuf, sep: "", sn: 4)
        let names = ArrayList<String>()

        append("\npublic enum ${typeName}_Oneof_${titleCase(decl.name)} <: OneofGroup {\n")
        for (f in fields) {
            if (!f.hasOneofIndex || f.oneofIndex != Int32(index)) { continue }
            sepOut.append("| ${titleCase(f.jsonName)}(${getPropType(f)})")
            names.append(f.jsonName)
        }
        sepOut.append("| None\n\n")

        // gen toString() and which()
        append("    public func toString() {\n")
        append("        match (this) {\n")
        for (name in names) {
            append("            case ${titleCase(name)}(v) => \"${titleCase(name)}(\${v})\"\n")
        }
        append("            case None => \"None\"\n")
        append("        }\n")
        append("    }\n\n")
        append("    public func which() {\n")
        append("        match (this) {\n")
        for (name in names) {
            append("            case ${titleCase(name)}(_) => \"${name}\"\n")
        }
        append("            case None => \"\"\n")
        append("        }\n")
        append("    }\n")
        append("}\n")
    }
}

/* gen oenof group props for message */
func genCodeOneofProps(typeName: String, fields: ArrayList<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    if (helper.oneofDecl.isEmpty()) {
        return
    }

    let group = Array<ArrayList<FieldDescriptorProto>>(helper.oneofDecl.size) { i => ArrayList() }
    for (f in fields) {
        if (!f.hasOneofIndex) { continue }
        group[Int64(f.oneofIndex)].append(f)
    }

    let append: (String) -> StringBuilder = helper.outbuf.append
    for ((index, decl) in withIndex(helper.oneofDecl)) {
        let propType = "${typeName}_Oneof_${titleCase(decl.name)}"
        append("\n    public prop var ${getMessagePropName(decl.name)}: ${propType} {\n")
        append("        get( ) {\n")
        append("            match (m_oneofCase[${index}]) {\n")
        for (f in group[index]) {
            append("                case ${f.number} => ${propType}.${titleCase(f.jsonName)}(get(${f.number}))\n")
        }
        append("                case _ => ${propType}.None\n")
        append("            }\n")
        append("        }\n\n")
        append("        set(o) {\n")
        append("            match (o) {\n")
        for (f in group[index]) {
            append("                case ${titleCase(f.jsonName)}(v) => set(${f.number}, v)\n")
        }
        append("                case None => m_oneofClear(${index})\n")
        append("            }\n")
        append("        }\n")
        append("    }\n")
    }
}

func genCodeExtension(ext: FieldDescriptorProto, helper: GenCodeHelper): Unit {
    // todo
}

/* Define reserved words */
let cangjieKeyWords = HashSet<String>([
    "abstract", "as", "break", "case", "catch", "class", "continue", "do",
    "else", "enum", "extend", "false", "finally", "for", "foreign", "from",
    "func", "if", "import", "in", "init", "interface", "is", "let", "macro",
    "match", "mut", "open", "operator", "override", "package", "private",
    "prop", "protected", "public", "quote", "record", "redef", "return",
    "spawn", "static", "super", "synchronized", "this", "throw", "true", "try",
    "type", "This", "unsafe", "var", "where", "while"
])
let protobufRsvdWords = HashSet<String>([
    "protobuf", "protoc", "toString", "toJson", "packSize", "pack", "isEmpty"
])
let messageRsvdWords = HashSet<String>([
    "s_initHashMapTagUnpacker", "s_initHashMapTagString", "s_initHashMapTagMessageFile",
    "s_initHashMapTagInt64", "s_initHashMapStringTag", "s_initArrayTag", "m_packCheck", "m_unpacker",
    "m_names", "m_nameTags", "m_defaultValue", "m_requiredFields", "m_oneofIndex", "m_oneofCase", "has",
    "unknownFields", "m_fields", "m_fieldsClone", "m_requiredFieldsCheck", "unpack", "get_", "fromJson", "fromBytes",
    "s_onceMutex", "s_newOnce", "s_once", "s_unpackers", "s_names", "s_nameTags"
])
let enumRsvdWords = HashSet<String>([
    "value", "parse"
])
let grpcRsvdWords = HashSet<String>([
    "m_path", "m_dispatch", "fn", "ctx", "req", "resp", "m_chan", "m_refused",
    "sendRequest", "getRequest", "setRequest", "setStatus", "getWriter", "getReader", "getStream",
    "writer", "reader", "stream", "serverStream", "clientStream"
])

func getEnumItemName(name: String) {
    if (cangjieKeyWords.contains(name) || enumRsvdWords.contains(name)) {
        return name + '_'
    }
    name
}

func getMessagePropName(name: String) {
    if (cangjieKeyWords.contains(name) || messageRsvdWords.contains(name)) {
        return name + '_'
    }
    name
}

func titleCase(str: String) {
    "${str[0].toUpperCase()}${str.substring(1)}"
}

/* lower camel case */
func getServiceFuncName(name: String) {
    let arr = "${name[0].toLowerCase()}${name.substring(1)}".split('_')

    for (i in 1..arr.size) {
        arr[i] = titleCase(arr[i])
    }

    let name = String.join(arr)

    if (cangjieKeyWords.contains(name) || grpcRsvdWords.contains(name)) {
        return name + '_'
    }
    name
}
