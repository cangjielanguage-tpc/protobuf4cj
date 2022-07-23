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
            // let dbgFile = resp.file.add()
            // dbgFile.name = desc.name.replace(".proto", ".raw.json")
            // dbgFile.content = desc.stringify()
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
        let sn!: Int64 = 12,        // Number of spaces automatically added to a new line
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
                    return String.join(typeName.substring(p.size()).split('.'), delimiter: "_")
                }
                return p.substring(1) + String.join(typeName.substring(p.size()).split('.'), delimiter: "_")
            }
        }
        throw Exception() // todo
    }

    // For type_ Message, special process if it is a map
    func setMessageTypeName(f: FieldDescriptorProto, ns: ArrayList<DescriptorProto>) {
        do {
            if (f.label.value() != LABEL_REPEATED.value()) { break }
            let sp = f.typeName.split('.')
            let entry = sp[sp.size() - 1]
            if (!entry.endsWith("Entry")) { break }
            // Looking for entry in nestedtype
            for (n in ns) {
                if (n.field.size() != 2 || n.name != entry) { continue }
                try { if (n.options.mapEntry != true) { break } } catch (_) { break }
                /* save map entry's fields */
                return f.typeName = getEntryTypeInfo(n.field[0]) + "," + getEntryTypeInfo(n.field[1])
            }
        } while (false)
        /* normal message field */
        f.typeName = getTypeName(f.typeName)
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
        outbuf.append("from protobuf import protobuf.*\n")
    }
    if (!desc.service.isEmpty() && desc.package_ != "grpc") {
        outbuf.append("from protobuf import grpc.*\n")
    }
    for (pkg in helper.getDependencyPackages(desc)) {
        outbuf.append("import ${pkg}.*\n")
    }
}

func getEntryTypeInfo(entry: FieldDescriptorProto) {
    match (entry.type_) {
        case TYPE_DOUBLE => "Float64,,Float64Unpacker"
        case TYPE_FLOAT => "Float64,,Float64Unpacker"
        case TYPE_INT64 => "Int64,,Int64Unpacker"
        case TYPE_UINT64 => "UInt64,,UInt64Unpacker"
        case TYPE_INT32 => "Int32,,Int32Unpacker"
        case TYPE_UINT32 => "Int64,,Int64Unpacker"
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
    if (f.typeName.contains(',')) {
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
    if (f.label.value() != LABEL_REPEATED.value()) { return ac + ".instance" }
    if (f.options.packed) { return ac + ".packedInstance" }
    ac + ".repeatInstance(${f.number})"
}

func getFieldSetName(f: FieldDescriptorProto) {
    if (f.typeName.contains(',')) {
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

    if (f.label.value() != LABEL_REPEATED.value()) {
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

    if (f.options.packed) {
        return if (vt.isEmpty()) { "PackedField<${pt}>(v)" } else { "Packed${vt}(v)" }
    }

    if (vt.isEmpty()) { "RepeatField<${pt}>(${f.number}, v)" } else { "Repeat${vt}(${f.number}, v)" }
}

func getPropType(f: FieldDescriptorProto) {
    if (f.typeName.contains(',')) {
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
    if (f.label.value() == LABEL_REPEATED.value()) { "ArrayList<${pt}>" } else { pt }
}

func genCodeMessageField(typeName: String, fields: ArrayList<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let outbuf = helper.outbuf
    let sepOut = LineSepOut(outbuf)

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

    // required fields
    let reqs = ArrayList<Int32>()
    for (f in fields) {
        if (f.label.value() == LABEL_REQUIRED.value()) {
            reqs.append(f.number)
        }
    }

    // class
    outbuf.append("\npublic class ${typeName} <: MessageLite {\n")

    // static
    outbuf.append("    static let m_once = Once()\n")
    outbuf.append("    static var s_unpackers = s_initHashMapTagUnpacker\n")
    outbuf.append("    static var s_names = s_initHashMapTagString\n")
    outbuf.append("    static var s_nameTags = s_initHashMapStringTag\n")
    if (!dvs.isEmpty()) {
        outbuf.append("    static var s_defaultValue = s_initHashMapTagMessageFile\n")
    }
    if (!reqs.isEmpty()) {
        outbuf.append("    static var s_requiredFields = s_initArrayTag\n")
    }
    if (helper.oneofNum != 0) {
        outbuf.append("    static var s_oneofIndex = s_initHashMapTagInt64\n")
    }

    // s_init
    // unpacker
    outbuf.append("\n    static func s_init() {\n        s_unpackers = HashMap<Tag, Unpacker>([\n")
    for (f in fields) {
        sepOut.append("(${f.number}, ${getUnpacker(f)})")
    }
    outbuf.append("\n        ])\n")

    // names
    outbuf.append("\n        s_names = HashMap<Tag, String>([\n")
    sepOut.reset()
    for (f in fields) {
        sepOut.append("(${f.number}, \"${f.name}\")")
    }
    outbuf.append("\n        ])\n")

    // nameTags
    outbuf.append("\n        s_nameTags = HashMap<String, Tag>([\n")
    sepOut.reset()
    for (f in fields) {
        sepOut.append("(\"${f.name}\", ${f.number})")
    }
    outbuf.append("\n        ])\n")

    // default value
    if (!dvs.isEmpty()) {
        outbuf.append("\n        s_defaultValue = HashMap<Tag, MessageField>([\n")
        sepOut.reset()
        for (dv in dvs) {
            sepOut.append(dv)
        }
        outbuf.append("\n        ])\n")
    }

    // required fields
    if (!reqs.isEmpty()) {
        outbuf.append("\n        s_requiredFields = Array<Tag>([\n")
        sepOut.reset()
        for (req in reqs) {
            sepOut.append("${req}")
        }
        outbuf.append("\n        ])\n")
    }

    // oneof
    if (helper.oneofNum != 0) {
        outbuf.append("\n        s_oneofIndex = HashMap<Tag, Int64>([\n")
        sepOut.reset()
        for (f in fields) {
            try { f.oneofIndex } catch (_) { continue }
            sepOut.append("(${f.number}, ${f.oneofIndex})")
        }
        outbuf.append("\n        ])\n")
    }
    // s_init end
    outbuf.append("    }\n")

    // init
    outbuf.append("\n    public init() {\n")
    outbuf.append("        m_once.once(s_init)\n")
    outbuf.append("        m_unpacker = s_unpackers\n")
    outbuf.append("        m_names = s_names\n")
    outbuf.append("        m_nameTags = s_nameTags\n")
    if (!helper.proto2) { outbuf.append("        m_proto2 = false\n") }
    if (!dvs.isEmpty()) { outbuf.append("        m_defaultValue = s_defaultValue\n") }
    if (!reqs.isEmpty()) { outbuf.append("        m_requiredFields = s_requiredFields\n") }
    if (helper.oneofNum != 0) {
        outbuf.append("        m_oneofIndex = s_oneofIndex\n")
        outbuf.append("        m_oneofCase = Array<Tag>(${helper.oneofNum}, item: UNSETCASE)\n")
    }
    // init end
    outbuf.append("    }\n")

    // clone
    outbuf.append("\n    public func clone() { ${typeName}().m_fieldsClone(this) }\n")

    // props
    for (f in fields) {
        outbuf.append("\n    public prop var ${f.name}: ${getPropType(f)} {\n")
        outbuf.append("        get() { get(${f.number}) }\n")
        outbuf.append("        set(v) { set(${f.number}, ${getFieldSetName(f)}) }\n")
        outbuf.append("    }\n")
    }
    // props end
    outbuf.append("}\n")

    // extend
    outbuf.append("\nextend ${typeName} <: MessageParser<${typeName}> {\n")
    outbuf.append("    public static func fromJson(src: JsonReader) { ${typeName}() }\n")
    outbuf.append("    public static func fromBytes(src: BytesReader) { let m = ${typeName}(); m.unpack(src); m }\n")
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
            case TYPE_MESSAGE => helper.setMessageTypeName(f, msg.nestedType)
            case _ => ()
        }
        // Set propname
        f.name = getMessagePropName(f.jsonName)
        // Set packed option
        try { f.options.packed } catch (_) { f.options.packed = false }
    }

    // Mapentry sets typename without generating message
    try { if (fields.size() == 2 && msg.options.mapEntry) { return } } catch (_) { /* nothing. */ }

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

    // enum不得为空
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
    outbuf.append("\n    /* cangjie 0.30.4 bug, xxx should be implemented */\n")
    outbuf.append("    public func packSize() { value().packSize() }\n")
    outbuf.append("    public func pack(out: BytesWriter) { value().pack(out) }\n")
    outbuf.append("    public func isEmpty() { value() == 0 }\n")
    // extend Enum end
    outbuf.append("}\n")
}

func genCodeService(ser: ServiceDescriptorProto, helper: GenCodeHelper): Unit {
    let outbuf = helper.outbuf

    // calc names
    for (m in ser.method) {
        m.inputType = helper.getTypeName(m.inputType)
        m.outputType = helper.getTypeName(m.outputType)
        m.funcName = getServiceFuncName(m.name)
    }

    // service
    outbuf.append("\npublic abstract class ${ser.name}_Service <: Service {\n")
    outbuf.append("    protected func getServiceName() { \"${helper.pkgPrefix}${ser.name}\" }\n")
    outbuf.append("    protected func m_dispatch(fn: String, ctx: ServerContext) {\n        match (fn) {\n")
    for (m in ser.method) {
        outbuf.append("            case \"${m.name}\" => let req = ${m.inputType}(); getRequest(req); ")
        outbuf.append("setResponse(${m.funcName}(ctx, req))\n")
    }
    outbuf.append("            case _ => throw Exception() // todo\n        }\n    }\n\n")

    // service abstract functions
    for (m in ser.method) {
        outbuf.append("    protected func ${m.funcName}(ctx: ServerContext, req: ${m.inputType}): (${m.outputType}, Status)\n")
    }

    // service end
    outbuf.append("}\n")

    // client
    outbuf.append("\npublic class ${ser.name}_Client <: Stub {\n    public init(chan: Channel) { super(chan) }\n")

    // client functions
    for (m in ser.method) {
        outbuf.append("\n    public func ${m.funcName}(ctx: ClientContext, req: ${m.inputType}, resp: ${m.outputType}) {\n")
        outbuf.append("        m_ctxBind(ctx, \"${m.name}\"); setRequest(ctx, req); getResponse(ctx, resp)\n    }\n")
        outbuf.append("    public func ${m.funcName}(ctx: ClientContext, req: ${m.inputType}) {\n")
        outbuf.append("        let resp = ${m.outputType}(); m_ctxBind(ctx, \"${m.name}\"); setRequest(ctx, req); (resp, getResponse(ctx, resp))\n    }\n")
    }

    // client end
    outbuf.append("}\n")
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
    "protobuf", "protoc", "toString", "stringify", "packSize", "pack", "isEmpty"
])
let messageRsvdWords = HashSet<String>([
    "s_initHashMapTagUnpacker", "s_initHashMapTagString", "s_initHashMapTagMessageFile",
    "s_initHashMapTagInt64", "s_initHashMapStringTag", "s_initArrayTag", "m_proto2", "m_unpacker",
    "m_names", "m_nameTags", "m_defaultValue", "m_requiredFields", "m_oneofIndex", "m_oneofCase",
    "unknownFields", "m_fields", "m_fieldsClone", "m_requiredFieldsCheck", "unpack", "get_",
    "fromJson", "fromBytes"
])
let enumRsvdWords = HashSet<String>([
    "value", "parse"
])
let grpcRsvdWords = HashSet<String>([
    "getServiceName", "m_dispatch", "fn", "ctx", "req", "resp", "m_chan", "m_ctxBind",
    "setRequest", "getRequest", "getRequest", "setRequest"
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

func getServiceFuncName(name: String) {
    if (cangjieKeyWords.contains(name) || grpcRsvdWords.contains(name)) {
        return name + '_'
    }
    name
}