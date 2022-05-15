package protoc

import google.protobuf.*
import google.protobuf.compiler.*
import collection.*

public func cj_generator(inbuf: Buffer<UInt8>, outbuf: Buffer<UInt8>): Unit {
    let req = CodeGeneratorRequest()
    req.unpack(inbuf)

    let resp = CodeGeneratorResponse()
    // 需要生成代码的文件集合
    let genfiles = HashSet<String>()
    for (path in req.fileToGenerate) {
        genfiles.put(path)
    }
    // 处理需要生成代码的文件
    for (desc in req.protoFile) {
        if (genfiles.contains(desc.name)) {
            // debug, 保存desc为json
            let dbgFile = resp.file.add()
            dbgFile.name = desc.name.replace(".proto", ".raw.json")
            dbgFile.content = desc.toString()
            fileProcess(desc, resp.file.add())
        }
    }
    resp.pack(outbuf)
}

/* 获取文件名 */
func getFileName(path: String): String {
    let sp = path.split('/')
    sp[sp.size() - 1]
}

class GenCodeHelper {
    /* 根据嵌套层级获取类型名 */
    let nested = Buffer<String>()
    func getNestedTypeName(name: String) {
        if (nested.isEmpty()) { return name }
        let sb = StringBuilder()
        for (n in nested) {
            sb.append(n).append('_')
        }
        sb.append(name).toString()
    }

    let pkgPrefix: String
    GenCodeHelper (pkg: String, let proto2: Bool) { pkgPrefix = ".${pkg}." }

    let packages = Buffer<String>()
    /* 获取所有依赖的package */
    func getDependencyPackages(desc: FileDescriptorProto) {
        let pkgs = HashSet<String>()
        for (dep in desc.dependency) {
            match (dep.lastIndexOf('/')) {
                case None => continue
                case Some(i) =>
                    let pkg = dep.substring(0, i).replace('/', '.')
                    if (desc.package_ == "protobuf" && pkg != "protobuf") {
                        /* protobuf包内不允许依赖外部包, cangjie不允许包循环依赖 */
                        throw Exception() // todo
                    }
                    if (pkg != desc.package_ && pkg != "protobuf") {
                        /* 保存除自己、protobuf以外的包 */
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

    // 对于TYPE_MESSAGE, 如果是map, 需要作特殊处理
    func getMessageTypeName(f: FieldDescriptorProto, ns: Buffer<DescriptorProto>) {
        do {
            try { if (f.label.value() != 3) { break } } catch (_) { break }
            let sp = f.typeName.split('.')
            let entry = sp[sp.size() - 1]
            if (!entry.endsWith("Entry")) { break }
            // nestedType中寻找entry
            for (n in ns) {
                if (n.field.size() != 2 || n.name != entry) { continue }
                try { if (n.options.mapEntry != true) { break } } catch (_) { break }
                // 找到netry
                return "${getPropType(n.field[0])}, ${getPropType(n.field[1])}, ${getAccesor(n.field[0])}, ${getAccesor(n.field[1])}"
            }
        } while (false)
        getTypeName(f.typeName)
    }

    // pkg 字典序逆序
    static func pkgCmp(a: String, b: String) {
        if (a == b) { Ordering.EQ } else if (a < b) { Ordering.GT } else { Ordering.LT }
    }

    let outbuf = StringBuilder()
    var oneofNum = 0
}

func fileProcess(desc: FileDescriptorProto, file: CodeGeneratorResponse_File) {
    // 目标文件路径
    file.name = desc.package_.replace('.', '/') + '/' + getFileName(desc.name).replace(".proto", "_pb.cj")
    // todo 暂时没有has接口, 使用try catch代替
    let proto2 = try { desc.syntax != "proto3" } catch (_) { true }
    let helper = GenCodeHelper(desc.package_, proto2)
    // 头部信息
    genCodeHeader(desc, helper)
    // 所有message
    for (msg in desc.messageType) {
        genCodeMessage(msg, helper)
    }
    // 所有enum
    for (e in desc.enumType) {
        genCodeEnum(e, helper)
    }
    // 所有service
    for (ser in desc.service) {
        genCodeService(ser, helper)
    }
    // 所有extension
    for (ext in desc.extension) {
        genCodeExtension(ext, helper)
    }
    // 目标文件内容
    file.content = helper.outbuf.toString()
}

func genCodeHeader(desc: FileDescriptorProto, helper: GenCodeHelper): Unit {
    let outbuf = helper.outbuf
    // package
    outbuf.append("package ${desc.package_}\n")
    // import
    outbuf.append("\nfrom std import collection.*\n")
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
    // 处理 repeated
    if (f.label.value() != 3) { return ac }
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
    if (f.label.value() == 3) { "Buffer<${pt}>" } else { pt }
}

func genCodeMessageField(typeName: String, fields: Buffer<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let outbuf = helper.outbuf
    // class
    outbuf.append("\npublic class ${typeName} <: MessageLite {\n")

    // accessors
    outbuf.append("    private static let accessors = HashMap<Tag, Accessor>([\n")
    var i = 0
    for (f in fields) {
        outbuf.append("        (${f.number}, ${getAccesor(f)}())")
        i++; outbuf.append(if (i == fields.size()) { '\n' } else { ",\n" } )
    }
    outbuf.append("    ])\n    protected func getAccessors() { accessors }\n")

    // names
    outbuf.append("\n    private static let names = HashMap<Tag, String>([\n")
    i = 0
    for (f in fields) {
        outbuf.append("        (${f.number}, \"${f.name}\")")
        i++; outbuf.append(if (i == fields.size()) { '\n' } else { ",\n" } )
    }
    outbuf.append("    ])\n    protected func getNames() { names }\n")

    // default value
    let dvs = Buffer<String>()
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
        outbuf.append("\n    private static let m_dv = HashMap<Tag, Any>([\n        ")
        var dot = false
        for (dv in dvs) {
            if (dot) { outbuf.append(", ") } else { dot = true }
            outbuf.append(dv)
        }
        outbuf.append("\n    ])\n    protected override func getDefaultValue(): ?HashMap<Tag, Any> { m_dv }\n")
    }

    // oneof
    if (helper.oneofNum != 0) {
        outbuf.append("\n    private let oneofCase = Array<Tag>(${helper.oneofNum}, item: UNSETCASE)\n")
        outbuf.append("    protected override func getOneofCase(): ?Array<Tag> { oneofCase }\n")
        outbuf.append("    private static let oneofIdx = HashMap<Tag, Int64>([\n        ")
        var dot = false
        for (f in fields) {
            try { f.oneofIndex } catch (_) { continue }
            if (dot) { outbuf.append(", ") } else { dot = true }
            outbuf.append("(${f.number}, ${f.oneofIndex})")
        }
        outbuf.append("\n    ])\n    protected override func getOneofIndex(): ?HashMap<Tag, Int64> { oneofIdx }\n")
    }

    // clone
    outbuf.append("\n    public func clone() { let rv = ${typeName}(); rv.fields = fieldsClone(); rv }\n")
    if (!helper.proto2) {
        outbuf.append("    protected override func proto2() { false }\n")
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

func genCodeMessageExtension(typeName: String, extensions: Buffer<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    // todo
}

func genCodeMessage(msg: DescriptorProto, helper: GenCodeHelper): Unit {
    let typeName = helper.getNestedTypeName(msg.name)
    let fields = msg.field
    let extensions = msg.extension

    helper.nested.append(msg.name)
    // 内嵌message
    for (m in msg.nestedType) {
        genCodeMessage(m, helper)
    }
    // 内嵌enum
    for (e in msg.enumType) {
        genCodeEnum(e, helper)
    }
    helper.nested.remove(helper.nested.size() - 1)

    for (f in fields) {
        // 设置typeName
        match (f.type_) {
            case TYPE_ENUM => f.typeName = helper.getTypeName(f.typeName)
            case TYPE_MESSAGE => f.typeName = helper.getMessageTypeName(f, msg.nestedType)
            case _ => ()
        }
        // 设置propName
        f.name = getMessagePropName(f.jsonName)
    }

    // mapEntry设置typeName但不用生成message
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

    // enum
    outbuf.append("\npublic enum ${typeName} {")
    // todo 换行
    var sp = false
    for (v in values) {
        v.name = getEnumItemName(v.name)
        if (sp) { outbuf.append('|') } else { sp = true }
        outbuf.append(" ${v.name} ")
    }
    outbuf.append("}\n")

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

/* 定义保留字 */
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
let messageRsvdWords = HashSet<String>([ /* todo 优化命名, 减少与保留字的碰撞 */
    "getAccessors", "getNames", "getDefaultValue", "unknownFields", "fields",
    "proto2", "fieldsClone", "pack", "unpack", "has", "clear", "accessors",
    "names", "getOneofCase", "getOneofIndex"
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