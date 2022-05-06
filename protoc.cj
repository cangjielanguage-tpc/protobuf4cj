package protoc

import egg.*
import protobuf.*
import collection.*

public func cj_generator(inbuf: Bytes, outbuf: Bytes): Unit {
    let req = CodeGeneratorRequest()
    req.unpack(inbuf)

    let resp = CodeGeneratorResponse()
    for (i in 0..req.file_to_generate.size()) {
        // 只取文件名
        let sp = req.file_to_generate[i].split('/')
        fileProcess(sp[sp.size() - 1], req.proto_file[i], resp.file.add())
    }
    resp.pack(outbuf)
}

class GenCodeHelper {
    let nested = Buffer<String>()
    func getTypeName(name: String) {
        if (nested.isEmpty()) { return name }
        let sb = StringBuilder()
        for (n in nested) {
            sb.append(n).append('_')
        }
        sb.append(name).toString()
    }

    let outbuf = StringBuilder()

    // todo cangjie关键字、protobuf保留字检查
}

func fileProcess(name: String, desc: FileDescriptorProto, file: CodeGeneratorResponse_File) {
    // 目标文件路径
    file.name = desc.package_.replace('.', '/') + '/' + name.replace(".proto", "_pb.cj")
    let helper = GenCodeHelper()
    // 头部信息
    genCodeHeader(desc, helper)
    // 所有message
    for (msg in desc.message_type) {
        genCodeMessage(msg, helper)
    }
    // 所有enum
    for (e in desc.enum_type) {
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

/* 计算需要import的所有package */
func getDependencyPackages(deps: Buffer<String>) {
    let pkgs = HashSet<String>(["protobuf"])
    for (dep in deps) {
        match (dep.lastIndexOf('/')) {
            case None => continue
            case Some(i) => pkgs.put(dep.substring(0, i).replace('/', '.'))
        }
    }
    Buffer<String>(pkgs)
}

func genCodeHeader(desc: FileDescriptorProto, helper: GenCodeHelper): Unit {
    let outbuf = helper.outbuf
    // package
    outbuf.append("package ${desc.package_}\n")
    // import
    outbuf.append("\nfrom std import collection.*\n")
    for (pkg in getDependencyPackages(desc.dependency)) {
        // todo public imports
        outbuf.append("import ${pkg}.*\n")
    }
}

func getAccesor(f: FieldDescriptorProto) {
    // todo 计算message enum对应的typeName
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
        case TYPE_MESSAGE => "MessageAccessor<${f.type_name}>"
        case TYPE_BYTES => "BytesAccessor"
        case TYPE_UINT32 => "UInt32Accessor"
        case TYPE_ENUM => "EnumAccessor<${f.type_name}>"
        case TYPE_SFIXED32 => "SFixed32Accessor"
        case TYPE_SFIXED64 => "SFixed64Accessor"
        case TYPE_SINT32 => "SInt32Accessor"
        case TYPE_SINT64 => "SInt64Accessor"
        case _ => throw Exception() // todo
    }
    if (f.label == REPEATED) { "Repeat${ac}" } else { ac }
}

func getPropType(f: FieldDescriptorProto) {
    // todo 计算message enum对应的typeName
    let pt = match (f.type_) {
        case TYPE_DOUBLE => "Float64"
        case TYPE_FLOAT => "Float32"
        case TYPE_INT64 | TYPE_SFIXED64 | TYPE_SINT64 => "Int64"
        case TYPE_UINT64 | TYPE_FIXED64 => "UInt64"
        case TYPE_INT32 | TYPE_SFIXED32 | TYPE_SINT32 => "Int32"
        case TYPE_BOOL => "Bool"
        case TYPE_STRING => "String"
        case TYPE_MESSAGE => f.type_name
        case TYPE_BYTES => "Bytes"
        case TYPE_UINT32 | TYPE_FIXED32 => "UInt32"
        case TYPE_ENUM => f.type_name
        case _ => throw Exception() // todo
    }
    if (f.label == REPEATED) { "Buffer<${pt}>" } else { pt }
}

func genCodeMessageField(typeName: String, fields: Buffer<FieldDescriptorProto>, outbuf: StringBuilder): Unit {
    // class
    outbuf.append("\npublic class ${typeName} <: MessageLite {\n")

    // accessors
    outbuf.append("    static let accessors = HashMap<Tag, Accessor>([\n")
    var i = 0
    for (f in fields) {
        outbuf.append("        (${f.number}, ${getAccesor(f)}())")
        i++; outbuf.append(if (i == fields.size()) { '\n' } else { ",\n" } )
    }
    outbuf.append("    ])\n    protected func getAccessors() { accessors }\n")

    // names // todo 保留字
    outbuf.append("\n    static let names = HashMap<Tag, String>([\n")
    i = 0
    for (f in fields) {
        outbuf.append("        (${f.number}, \"${f.json_name}\")")
        i++; outbuf.append(if (i == fields.size()) { '\n' } else { ",\n" } )
    }
    outbuf.append("    ])\n    protected func getNames() { names }\n")

    // clone
    outbuf.append("\n    public func clone() { let rv = ${typeName}(); rv.fields = fieldsClone(); rv }\n")

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

func genCodeMessageExtension(typeName: String, extensions: Buffer<FieldDescriptorProto>, outbuf: StringBuilder): Unit {
    // todo
}

func genCodeMessage(msg: DescriptorProto, helper: GenCodeHelper): Unit {
    let typeName = helper.getTypeName(msg.name)
    let fields = msg.field
    let extensions = msg.extension
    let outbuf = helper.outbuf

    // fields
    genCodeMessageField(typeName, fields, outbuf)
    // extensions
    genCodeMessageExtension(typeName, extensions, outbuf)
    
    helper.nested.append(msg.name)
    // 内嵌message
    for (m in msg.nested_type) {
        genCodeMessage(m, helper)
    }
    // 内嵌enum
    for (e in msg.enum_type) {
        genCodeEnum(e, helper)
    }

    // todo extension
    // todo oneof
    // todo reserved
    helper.nested.remove(helper.nested.size() - 1)
}

func genCodeEnum(e: EnumDescriptorProto, helper: GenCodeHelper): Unit {
    let typeName = helper.getTypeName(e.name)
    let values = e.value
    let outbuf = helper.outbuf

    // enum
    outbuf.append("\npublic enum ${typeName} {")
    // todo 换行
    var sp = false
    for (v in values) {
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
    outbuf.append("\n    public static func parse(value: Int32): ${typeName} {\n        match(this) {\n")
    for (v in values) {
        outbuf.append("            case ${v.number} => ${v.name}\n")
    }
    outbuf.append("            case e => throw InvalidEnumValueException(\"${typeName}\", e)\n")
    outbuf.append("        }\n    }\n")
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