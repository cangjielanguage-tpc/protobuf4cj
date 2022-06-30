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
            // save `desc` as json, for developing.
            let dbgFile = resp.file.add()
            dbgFile.name = desc.name.replace(".proto", ".raw.json")
            dbgFile.content = desc.toString()
            fileProcess(desc, resp.file.add())
        }
    }
    resp.pack(outbuf)
}

/* Get file name */
func getFileName(path: String): String {
    let sp = path.split('/')
    sp[sp.size() - 1].replace(".proto", ".pb.cj")
}

/* Get dest path by package name */
func getDestPath(package_: String): String {
    if (package_ == "") { "" } else { package_.replace('.', '/') + '/' }
}

class LineSepOut {
    LineSepOut (
        let outbuf: StringBuilder,
        let sep!: String = ",",     // Separator
        let sn!: Int64 = 8,         // Number of spaces automatically added to a new line
        let ln!: Int64 = 120 - sep.size()    // One line limit characters
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
            cn += s.size()
            outbuf.append(ss).append(s)
            first = false
            return
        }
        // Not the first, append separator
        cn += sep.size()
        outbuf.append(sep)
        // Judge whether line feed is required
        if (cn + 1 + s.size() > ln) {
            cn = sn + s.size()
            outbuf.append('\n').append(ss).append(s)
        } else {
            cn += 1 + s.size()
            outbuf.append(' ').append(s)
        }
    }

    /* Reset */
    func reset() {
        cn = sn
        first = true
    }
}

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

    let pkgPrefix: String
    GenCodeHelper (package_: String, let proto2: Bool) {
        pkgPrefix = if (package_ == "") { "." } else { ".${package_}." }
    }

    let packages = ArrayList<String>()
    /* Get all dependent packages */
    func getDependencyPackages(desc: FileDescriptorProto) {
        let pkgs = HashSet<String>()
        for (dep in desc.dependency) {
            match (dep.lastIndexOf('/')) {
                case None => continue
                case Some(i) =>
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
                    return String.join(typeName.substring(p.size()).split('.'), delimiter: "_")
                }
                return p.substring(1) + String.join(typeName.substring(p.size()).split('.'), delimiter: "_")
            }
        }
        throw Exception() // todo
    }

    // For type_ Message. If it is a map, special processing is required
    func getMessageTypeName(f: FieldDescriptorProto, ns: ArrayList<DescriptorProto>) {
        do {
            if (f.label != LABEL_REPEATED) { break }
            let sp = f.typeName.split('.')
            let entry = sp[sp.size() - 1]
            if (!entry.endsWith("Entry")) { break }
            // Looking for entry in nestedtype
            for (n in ns) {
                if (n.field.size() != 2 || n.name != entry) { continue }
                try { if (n.options.mapEntry != true) { break } } catch (_) { break }
                // Find netry
                return "${getPropType(n.field[0])}, ${getPropType(n.field[1])}, ${getAccesor(n.field[0])}, ${getAccesor(n.field[1])}"
            }
        } while (false)
        getTypeName(f.typeName)
    }

    // pkg Dictionary order reverse
    static func pkgCmp(a: String, b: String) {
        if (a == b) { Ordering.EQ } else if (a < b) { Ordering.GT } else { Ordering.LT }
    }

    let outbuf = StringBuilder()
    var oneofNum = 0
}

func fileProcess(desc: FileDescriptorProto, file: CodeGeneratorResponse_File) {
    // Destination file path
    desc.package_ = try { desc.package_ } catch (_) { "" }
    file.name = getDestPath(desc.package_) + getFileName(desc.name)
    let proto2 = try { desc.syntax != "proto3" } catch (_) { true }
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
    let outbuf = helper.outbuf
    // package
    if (desc.package_ != "") { outbuf.append("package ${desc.package_}\n\n") }
    // import
    outbuf.append("from std import collection.*\n")
    if (desc.package_ != "protobuf") {
        outbuf.append("import protobuf.*\n")
    }
    for (pkg in helper.getDependencyPackages(desc)) {
        // todo public imports
        outbuf.append("import ${pkg}.*\n")
    }
}

func getAccesor(f: FieldDescriptorProto) {
    let ac = match (f.type_) {
        case TYPE_DOUBLE => "DoubleAccessor"
        case TYPE_FLOAT => "FloatAccessor"
        case TYPE_INT64 => "Int64Accessor"
        case TYPE_UINT64 => "UInt64Accessor"
        case TYPE_INT32 => "Int32Accessor"
        case TYPE_FIXED64 => "Fixed64Accessor"
        case TYPE_FIXED32 => "Fixed32Accessor"
        case TYPE_BOOL => "BoolAccessor"
        case TYPE_STRING => "StringAccessor"
        case TYPE_MESSAGE =>
            if (f.typeName.contains(',')) { return "MapAccessor<${f.typeName}>" }
            else { "MessageAccessor<${f.typeName}>" }
        case TYPE_BYTES => "BytesAccessor"
        case TYPE_UINT32 => "UInt32Accessor"
        case TYPE_ENUM => "EnumAccessor<${f.typeName}>"
        case TYPE_SFIXED32 => "SFixed32Accessor"
        case TYPE_SFIXED64 => "SFixed64Accessor"
        case TYPE_SINT32 => "SInt32Accessor"
        case TYPE_SINT64 => "SInt64Accessor"
        case _ => throw Exception() // todo
    }
    // Process repeated
    if (f.label != LABEL_REPEATED) { return ac }
    try { if (f.options.packed == true) { return "Packed${ac}" } } catch (_) { /* nothing. */ }
    "Repeat${ac}"
}

func getPropType(f: FieldDescriptorProto) {
    if (f.type_ == TYPE_MESSAGE && f.typeName.contains(',')) {
        let len = f.typeName.indexOf(',', f.typeName.indexOf(',').getOrThrow() + 1).getOrThrow()
        return "HashMap<${f.typeName.substring(0, len)}>"
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
        case TYPE_ENUM | TYPE_MESSAGE => f.typeName
        case _ => throw Exception() // todo
    }
    if (f.label == LABEL_REPEATED) { "ArrayList<${pt}>" } else { pt }
}

func genCodeMessageField(typeName: String, fields: ArrayList<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let outbuf = helper.outbuf
    let sepOut = LineSepOut(outbuf)

    // class
    outbuf.append("\npublic class ${typeName} <: MessageLite {\n")

    // accessors
    outbuf.append("    private static let m_accessors = HashMap<Tag, Accessor>([\n")
    for (f in fields) {
        sepOut.append("(${f.number}, ${getAccesor(f)}.getInstance())")
    }
    outbuf.append("\n    ])\n    protected func getAccessors() { m_accessors }\n")

    // names
    outbuf.append("\n    private static let m_names = HashMap<Tag, String>([\n")
    sepOut.reset()
    for (f in fields) {
        sepOut.append("(${f.number}, \"${f.name}\")")
    }
    outbuf.append("\n    ])\n    protected func getNames() { m_names }\n")

    // default value
    let dvs = ArrayList<String>()
    for (f in fields) {
        try { f.defaultValue } catch (_) { continue }
        let dv = match (f.type_) {
            case TYPE_STRING => "\"${f.defaultValue}\""
            case TYPE_BOOL | TYPE_INT64 | TYPE_DOUBLE => f.defaultValue
            case TYPE_ENUM => "${getPropType(f)}.${f.defaultValue}"
            case _ => "${getPropType(f)}(${f.defaultValue})"
        }
        dvs.append("(${f.number}, ${dv})")
    }
    if (!dvs.isEmpty()) {
        outbuf.append("\n    private static let m_dv = HashMap<Tag, Any>([\n")
        sepOut.reset()
        for (dv in dvs) {
            sepOut.append(dv)
        }
        outbuf.append("\n    ])\n    protected override func getDefaultValue(): ?HashMap<Tag, Any> { m_dv }\n")
    }

    // required fields
    let reqs = ArrayList<Int32>()
    for (f in fields) {
        if (f.label == LABEL_REQUIRED) {
            reqs.append(f.number)
        }
    }
    if (!reqs.isEmpty()) {
        outbuf.append("\n    protected static let m_reqs = Array<Tag>([\n")
        sepOut.reset()
        for (req in reqs) {
            sepOut.append("${req}")
        }
        outbuf.append("\n    ])\n    protected override func getRequiredFields(): ?Array<Tag> { m_reqs }\n")
    }

    // oneof
    if (helper.oneofNum != 0) {
        outbuf.append("\n    private let m_oneofCase = Array<Tag>(${helper.oneofNum}, item: UNSETCASE)\n")
        outbuf.append("    protected override func getOneofCase(): ?Array<Tag> { m_oneofCase }\n")
        outbuf.append("    private static let m_oneofIdx = HashMap<Tag, Int64>([\n")
        sepOut.reset()
        for (f in fields) {
            try { f.oneofIndex } catch (_) { continue }
            sepOut.append("(${f.number}, ${f.oneofIndex})")
        }
        outbuf.append("\n    ])\n    protected override func getOneofIndex(): ?HashMap<Tag, Int64> { m_oneofIdx }\n")
    }

    // clone
    outbuf.append("\n    public func clone() { let rv = ${typeName}(); rv.m_fields = m_fieldsClone(); rv }\n")
    if (!helper.proto2) {
        outbuf.append("    protected override func m_proto2() { false }\n")
    }

    // props
    for (f in fields) {
        outbuf.append("\n    public prop var ${f.name}: ${getPropType(f)} {\n")
        outbuf.append("        get() { get<${getPropType(f)}>(${f.number}) }\n")
        outbuf.append("        set(v) { set(${f.number}, v) }\n")
        outbuf.append("    }\n")
    }

    outbuf.append("}\n")

    // extend
    outbuf.append("\nextend ${typeName} <: Default<${typeName}> {\n")
    outbuf.append("    public static func default() { ${typeName}() }\n")
    outbuf.append("}\n")
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
    helper.nested.remove(helper.nested.size() - 1)

    for (f in fields) {
        // Set typename
        match (f.type_) {
            case TYPE_ENUM => f.typeName = helper.getTypeName(f.typeName)
            case TYPE_MESSAGE => f.typeName = helper.getMessageTypeName(f, msg.nestedType)
            case _ => ()
        }
        // Set propname
        f.name = getMessagePropName(f.jsonName)
    }

    // Mapentry sets typename without generating message
    try { if (msg.options.mapEntry) { return } } catch (_) { /* nothing. */ }

    helper.oneofNum = msg.oneofDecl.size()
    // fields
    genCodeMessageField(typeName, fields, helper)
    // extensions
    genCodeMessageExtension(typeName, extensions, helper)

    // todo extension range
    // todo reserved range
}

func genCodeEnum(e: EnumDescriptorProto, helper: GenCodeHelper): Unit {
    let typeName = helper.getNestedTypeName(e.name)
    let values = e.value
    let outbuf = helper.outbuf
    let sepOut = LineSepOut(outbuf, sep: "", sn: 4)

    // enum
    outbuf.append("\npublic enum ${typeName} {\n")
    for (v in values) {
        v.name = getEnumItemName(v.name)
        sepOut.append("| ${v.name}")
    }
    outbuf.append("\n}\n")

    /* enum不得为空 */
    if (values.isEmpty()) { return }

    // extend Enum
    outbuf.append("\nextend ${typeName} <: Enum<${typeName}> {\n")
    // value
    outbuf.append("    public func value(): Int32 {\n        match(this) {\n")
    for (v in values) {
        outbuf.append("            case ${v.name} => ${v.number}\n")
    }
    outbuf.append("        }\n    }\n")
    // toString
    outbuf.append("\n    public func toString(): String {\n        match(this) {\n")
    for (v in values) {
        outbuf.append("            case ${v.name} => \"${v.name}\"\n")
    }
    outbuf.append("        }\n    }\n")
    // parse
    outbuf.append("\n    public static func parse(value: Int32): ${typeName} {\n        match(value) {\n")
    for (v in values) {
        outbuf.append("            case ${v.number} => ${v.name}\n")
    }
    outbuf.append("            case e => throw InvalidEnumValueException(\"${typeName}\", e)\n")
    outbuf.append("        }\n    }\n")
    // parse, from string
    outbuf.append("\n    public static func parse(value: String): ${typeName} {\n        match(value) {\n")
    for (v in values) {
        outbuf.append("            case \"${v.name}\" => ${v.name}\n")
    }
    outbuf.append("            case e => throw UnmatchedEnumStringException(\"${typeName}\", e)\n")
    outbuf.append("        }\n    }\n")
    // todo cangjie bug
    outbuf.append("\n    /* cangjie 0.28.4 bug, xxx should be implemented */\n")
    outbuf.append("    public func hashCode() { value().hashCode() }\n")
    outbuf.append("    public operator func ==(right: ${typeName}) { value() == right.value() }\n")
    outbuf.append("    public operator func !=(right: ${typeName}) { value() != right.value() }\n")
    // extend Enum end
    outbuf.append("}\n")

    // extend Default
    outbuf.append("\nextend ${typeName} <: Default<${typeName}> {\n")
    outbuf.append("    public static func default() { ${values[0].name} }\n")
    outbuf.append("}\n")
    // todo reserved
}

func genCodeService(ser: ServiceDescriptorProto, helper: GenCodeHelper): Unit {
    // todo
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
    "protobuf", "protoc", "default", "toString"
])
let messageRsvdWords = HashSet<String>([
    "getAccessors", "getNames", "getDefaultValue", "unknownFields", "m_fields",
    "m_proto2", "m_fieldsClone", "pack", "unpack", "has", "clear", "m_accessors",
    "m_names", "getOneofCase", "getOneofIndex", "m_oneofCase", "m_oneofIndex", "m_dv"
])
let enumRsvdWords = HashSet<String>([
    "value", "parse", "hashCode"
])

func getEnumItemName(name: String) {
    if (cangjieKeyWords.contains(name) ||
        protobufRsvdWords.contains(name) ||
        enumRsvdWords.contains(name)) {
        return name + '_'
    }
    name
}

func getMessagePropName(name: String) {
    if (cangjieKeyWords.contains(name) ||
        protobufRsvdWords.contains(name) ||
        messageRsvdWords.contains(name)) {
        return name + '_'
    }
    name
}