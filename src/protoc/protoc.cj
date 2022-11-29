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
from protobuf import protobuf.tagSize
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
    func nestedPush(name: String) { nested.append(name) }
    func nestedPop() { nested.remove(nested.size - 1) }
    func getNestedTypeName(name: String) {
        if (nested.isEmpty()) { return name }
        let sb = StringBuilder()
        for (n in nested) {
            sb.append(n).append('_')
        }
        sb.append(name).toString()
    }

    /* proto file outbuf */
    let outbuf = StringBuilder()
    /* package prefix of the proto file */
    let pkgPrefix: String
    GenCodeHelper (package_: String, let proto2: Bool) {
        pkgPrefix = if (package_ == "") { "." } else { ".${package_}." }
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
                    throw Exception("CIRCULAR DEPENDENCY")
                }
                if (pkg != desc.package_ && pkg != "protobuf") {
                    /* Save packages other than `desc` itself and protobuf */
                    pkgs.put(pkg)
                }
            }
        }
        packages.append(pkgPrefix)
        for (p in pkgs) { packages.append(".${p}.") }
        packages.sortBy { a, b => if (a == b) { Ordering.EQ } else if (a < b) { Ordering.GT } else { Ordering.LT } }
        pkgs
    }

    /* set enum/message type name */
    func setFieldsTypeName(fields: ArrayList<FieldDescriptorProto>, nestedType: ArrayList<DescriptorProto>) {
        for (f in fields) {
            match (f.type_) {
                case TYPE_ENUM => f.typeName = getTypeName(f.typeName)
                case TYPE_MESSAGE => setMessageTypeName(f, nestedType)
                case _ => ()
            }
        }
    }

    private func getTypeName(typeName: String) {
        for (p in packages) {
            if (typeName.startsWith(p)) {
                if (p == pkgPrefix) {
                    return String.join(typeName.substring(p.size).split('.'), delimiter: "_")
                }
                return p.substring(1) + String.join(typeName.substring(p.size).split('.'), delimiter: "_")
            }
        }
        throw Exception("INVALID TYPE NAME")
    }

    // special process type_ message if it is a map
    private func setMessageTypeName(f: FieldDescriptorProto, ns: ArrayList<DescriptorProto>) {
        do {
            if (f.label != LABEL_REPEATED) { break }

            let entryName = "${titleCase(f.jsonName)}Entry"
            if (!f.typeName.endsWith(entryName)) { break }

            // looking for entry in nestedtype
            for (n in ns) {
                // other nested message
                if (n.field.size != 2 || n.name != entryName) { continue }

                // not map entry
                if (!n.hasOptions || !n.options.hasMapEntry || !n.options.mapEntry) { break }

                // save map entry's fields
                f.mapEntry = n.field
                f.typeName = "HashMap<${typeConvert(n.field[0])}, ${typeConvert(n.field[1])}>"
                return
            }
        } while (false)
        /* normal message field */
        f.typeName = getTypeName(f.typeName)
    }

    let oneofDecl = ArrayList<(String, ArrayList<FieldDescriptorProto>)>()
    func calcOneofDecl(decls: ArrayList<OneofDescriptorProto>, fields: ArrayList<FieldDescriptorProto>) {
        oneofDecl.clear()
        for (decl in decls) {
            decl.name = lowerCamelCase(decl.name)
            oneofDecl.append((decl.name, ArrayList<FieldDescriptorProto>()))
        }
        for (field in fields where field.hasOneofIndex) {
            oneofDecl[Int64(field.oneofIndex)][1].append(field)
        }
    }
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
    for (pkg in helper.getDependencyPackages(desc)) {
        append("import ${pkg}.*\n")
    }
}

func genCodeMessageExtension(typeName: String, extensions: ArrayList<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    // todo
}

func genCodeMessage(msg: DescriptorProto, helper: GenCodeHelper): Unit {
    let typeName = helper.getNestedTypeName(msg.name)
    let fields = msg.field
    let extensions = msg.extension

    // nested push
    helper.nestedPush(msg.name)

    // gen nested message
    for (m in msg.nestedType) { genCodeMessage(m, helper) }

    // gen nested enum
    for (e in msg.enumType) { genCodeEnum(e, helper) }

    // nested pop
    helper.nestedPop()

    // set enum/message/map type name
    helper.setFieldsTypeName(fields, msg.nestedType)

    // no generating map code
    if (fields.size == 2 && msg.hasOptions && msg.options.hasMapEntry && msg.options.mapEntry) { return }

    // preprocess oneof decl
    helper.calcOneofDecl(msg.oneofDecl, fields)

    // fields
    if (helper.proto2) { genCodeMessageField2 } else { genCodeMessageField } (typeName, fields, helper)

    // extensions
    genCodeMessageExtension(typeName, extensions, helper)

    // oneof group enum
    genCodeOneofGroup(typeName, helper)

    // todo extension range
    // todo reserved range
}

func genCodeEnum(e: EnumDescriptorProto, helper: GenCodeHelper): Unit {
    let typeName = helper.getNestedTypeName(e.name)
    let values = e.value
    let append: (String) -> StringBuilder = helper.outbuf.append
    let sepOut = LineSepOut(helper.outbuf, sep: " |", sn: 4)

    // enum items
    append("\npublic enum ${typeName} <: Enum<${typeName}> {\n")
    for (v in values) { sepOut.append("${getEnumItemName(v.name)}") }
    append("\n\n")

    // value
    append("    public func value(): Int32 {\n        match(this) {\n")
    for (v in values) { append("            case ${getEnumItemName(v.name)} => ${v.number}\n") }
    append("        }\n    }\n")

    // toString
    append("\n    public func toString(): String {\n        match(this) {\n")
    for (v in values) { append("            case ${getEnumItemName(v.name)} => \"${v.name}\"\n") }
    append("        }\n    }\n")

    // operator ==
    append("\n    public operator func==(e: ${typeName}) {\n        match((this, e)) {\n")
    for (v in values) { append("            case (${getEnumItemName(v.name)}, ${getEnumItemName(v.name)}) => true\n") }
    append("            case _ => false\n        }\n    }\n")

    // isEmpty & empty
    if (!helper.proto2) {
        append("\n    public func isEmpty() { match (this) { case ${getEnumItemName(values[0].name)} => true case _ => false } }\n")
        append("\n    public static func empty(): ${typeName} { ${getEnumItemName(values[0].name)} }\n")
    }

    // parse
    append("\n    public static func parse(value: Int32): ${typeName} {\n        match(value) {\n")
    for (v in values) { append("            case ${v.number} => ${getEnumItemName(v.name)}\n") }
    append("            case e => throw InvalidEnumValueException(\"${typeName}\", e)\n        }\n    }\n")

    // parse, from string
    append("\n    public static func parse(value: String): ${typeName} {\n        match(value) {\n")
    for (v in values) { append("            case \"${v.name}\" => ${getEnumItemName(v.name)}\n") }
    append("            case e => throw UnmatchedEnumStringException(\"${typeName}\", e)\n        }\n    }\n")

    // done
    append("}\n")
}

func genCodeService(ser: ServiceDescriptorProto, helper: GenCodeHelper): Unit {
    // ignore
}

func genCodeExtension(ext: FieldDescriptorProto, helper: GenCodeHelper): Unit {
    // todo
}

/* gen oneof group type define (enum) */
func genCodeOneofGroup(typeName: String, helper: GenCodeHelper): Unit {
    for ((name, fields) in helper.oneofDecl) {
        let append: (String) -> StringBuilder = helper.outbuf.append
        let sepOut = LineSepOut(helper.outbuf, sep: " |", sn: 4)
        let groupType = "${typeName}_Oneof_${titleCase(name)}"

        append("\npublic enum ${groupType} <: OneofGroup {\n")
        for (f in fields) { sepOut.append("${titleCase(f.jsonName)}(${typeConvert(f)})") }
        sepOut.append("None\n\n")

        // gen clone()
        append("    public func clone(): ${groupType} {\n")
        append("        match (this) {\n")
        for (field in fields where field.type_ == TYPE_BYTES || field.type_ == TYPE_MESSAGE) { append("            case ${titleCase(field.jsonName)}(v) => ${titleCase(field.jsonName)}(v.clone())\n") }
        append("            case _ => this\n")
        append("        }\n")
        append("    }\n")

        // gen toString() and which()
        append("    public func toString() {\n")
        append("        match (this) {\n")
        for (field in fields) { append("            case ${titleCase(field.jsonName)}(v) => \"${titleCase(field.jsonName)}(\${v})\"\n") }
        append("            case None => \"None\"\n")
        append("        }\n")
        append("    }\n\n")
        append("    public func which() {\n")
        append("        match (this) {\n")
        for (field in fields) { append("            case ${titleCase(field.jsonName)}(_) => \"${field.jsonName}\"\n") }
        append("            case None => \"\"\n")
        append("        }\n")
        append("    }\n")
        append("}\n")
    }
}

/* oneof unpack expr */
func getOneofFieldUnapckExpr(name: String, field: FieldDescriptorProto) {
    if (field.type_ == TYPE_MESSAGE) {
        return "let i_vtmp = ${field.typeName}(); i_vtmp.unpack(src); ${getMessagePropName(name)} = ${titleCase(field.jsonName)}(i_vtmp)"
    }

    "${getMessagePropName(name)} = ${titleCase(field.jsonName)}(" + match (field.type_) {
        case TYPE_DOUBLE => "float64Parse(src)"
        case TYPE_FLOAT => "float32Parse(src)"
        case TYPE_INT64 => "int64Parse(src)"
        case TYPE_UINT64 => "uint64Parse(src)"
        case TYPE_INT32 => "int32Parse(src)"
        case TYPE_UINT32 => "uint32Parse(src)"
        case TYPE_ENUM => "${field.typeName}.parse(int32Parse(src))"
        case TYPE_BOOL => "boolParse(src)"
        case TYPE_STRING => "stringParse(src)"
        case TYPE_BYTES => "bytesParse(src)"
        case TYPE_FIXED64 => "fixed64Parse(src)"
        case TYPE_FIXED32 => "fixed32Parse(src)"
        case TYPE_SFIXED32 => "sfixed32Parse(src)"
        case TYPE_SFIXED64 => "sfixed64Parse(src)"
        case TYPE_SINT32 => "sint32Parse(src)"
        case TYPE_SINT64 => "sint64Parse(src)"
        case _ => throw Exception("UNSUPPORTED TYPE")
    } + ")"
}

/* impl interface api */
func getImplIterfaceApi(typeName: String) {
    "    public func packi(out: Bytes) { pack(out) }\n" +
    "    public func packi(out: BytesWriter) { match (out) { case i_tmp: Bytes => pack(i_tmp) case _ => pack(out) } }\n" +
    "    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }\n" +
    "    public func unpack(src: Collection<Byte>) { unpack(SimpleReader(src)) }\n" +
    "\n" +
    "    public static func empty() { ${typeName}() }\n" +
    "    public static func fromBytes(src: Collection<Byte>) { let i_tmp = ${typeName}(); i_tmp.unpack(src); i_tmp }\n" +
    "    public static func fromBytes(src: BytesReader) { let i_tmp = ${typeName}(); i_tmp.unpacki(src); i_tmp }\n"
}

/* convert pb type to cj type */
func typeConvert(field: FieldDescriptorProto) {
    match (field.type_) {
        case TYPE_DOUBLE => "Float64"
        case TYPE_FLOAT => "Float32"
        case TYPE_INT64 => "Int64"
        case TYPE_UINT64 => "UInt64"
        case TYPE_INT32 => "Int32"
        case TYPE_UINT32 => "UInt32"
        case TYPE_ENUM => "${field.typeName}"
        case TYPE_BOOL => "Bool"
        case TYPE_STRING => "String"
        case TYPE_MESSAGE => "${field.typeName}"
        case TYPE_BYTES => "Bytes"
        case TYPE_FIXED64 => "UInt64"
        case TYPE_FIXED32 => "UInt32"
        case TYPE_SFIXED32 => "Int32"
        case TYPE_SFIXED64 => "Int64"
        case TYPE_SINT32 => "Int32"
        case TYPE_SINT64 => "Int64"
        case _=> throw Exception("UNSUPPORTED TYPE")
    }
}

/* typed init value */
func initValue(field: FieldDescriptorProto) {
    match (field.type_) {
        case TYPE_DOUBLE => ".0"
        case TYPE_FLOAT => "Float32(.0)"
        case TYPE_INT64 => "0"
        case TYPE_UINT64 => "UInt64(0)"
        case TYPE_INT32 => "Int32(0)"
        case TYPE_UINT32 => "UInt32(0)"
        case TYPE_ENUM => "${field.typeName}.empty()"
        case TYPE_BOOL => "false"
        case TYPE_STRING => "\"\""
        case TYPE_MESSAGE => "${field.typeName}()"
        case TYPE_BYTES => "Bytes()"
        case TYPE_FIXED64 => "UInt64(0)"
        case TYPE_FIXED32 => "UInt32(0)"
        case TYPE_SFIXED32 => "Int32(0)"
        case TYPE_SFIXED64 => "0"
        case TYPE_SINT32 => "Int32(0)"
        case TYPE_SINT64 => "0"
        case _=> throw Exception("UNSUPPORTED TYPE")
    }
}

/* auto type zero value */
func zeroValue(field: FieldDescriptorProto) {
    match (field.type_) {
        case TYPE_DOUBLE | TYPE_FLOAT => ".0"
        case TYPE_BOOL => "false"
        case TYPE_ENUM => "${field.typeName}.empty()"
        case TYPE_MESSAGE => "${field.typeName}()"
        case TYPE_BYTES => "Bytes()"
        case TYPE_STRING => "\"\""
        case _=> "0"
    }
}

/* named no empty */
func namedNoEmpty(name: String, field: FieldDescriptorProto) {
    match (field.type_) {
        case TYPE_DOUBLE | TYPE_FLOAT => "${name} != .0"
        case TYPE_BOOL => "${name}"
        case TYPE_ENUM | TYPE_MESSAGE | TYPE_STRING | TYPE_BYTES => "!${name}.isEmpty()"
        case _ => "${name} != 0"
    }
}

/* named size */
func namedSize(name: String, field: FieldDescriptorProto) {
    match (field.type_) {
        case TYPE_BOOL => "1"
        case TYPE_DOUBLE | TYPE_FIXED64 | TYPE_SFIXED64 => "8"
        case TYPE_FIXED32 | TYPE_SFIXED32 | TYPE_FLOAT => "4"
        case TYPE_BYTES | TYPE_STRING | TYPE_MESSAGE => "binSize(${name})"
        case TYPE_ENUM => "varintSize(${name}.value())"
        case TYPE_SINT32 | TYPE_SINT64 => "sintSize(${name})"
        case _ => "varintSize(${name})"
    }
}

/* named pack */
func namedPack(name: String, field: FieldDescriptorProto) {
    match (field.type_) {
        case TYPE_BOOL => "tagPack(${field.number}, VARINT, out); boolPack(${name}, out)"
        case TYPE_DOUBLE | TYPE_FIXED64 | TYPE_SFIXED64 => "tagPack(${field.number}, BIT64, out); fixedPack(${name}, out)"
        case TYPE_FIXED32 | TYPE_SFIXED32 | TYPE_FLOAT => "tagPack(${field.number}, BIT32, out); fixedPack(${name}, out)"
        case TYPE_BYTES | TYPE_STRING => "tagPack(${field.number}, PREFIXED, out); binPack(${name}, out)"
        case TYPE_MESSAGE => "tagPack(${field.number}, PREFIXED, out); varintPack(${name}.size, out); ${name}.pack(out)"
        case TYPE_ENUM => "tagPack(${field.number}, VARINT, out); varintPack(${name}.value(), out)"
        case TYPE_SINT32 | TYPE_SINT64 => "tagPack(${field.number}, VARINT, out); sintPack(${name}, out)"
        case _ => "tagPack(${field.number}, VARINT, out); varintPack(${name}, out)"
    }
}

/* named parse src */
func namedParseSrc(name: String, src: String, field: FieldDescriptorProto) {
    name + match (field.type_) {
        case TYPE_DOUBLE => " = float64Parse(${src})"
        case TYPE_FLOAT => " = float32Parse(${src})"
        case TYPE_INT64 => " = int64Parse(${src})"
        case TYPE_UINT64 => " = uint64Parse(${src})"
        case TYPE_INT32 => " = int32Parse(${src})"
        case TYPE_UINT32 => " = uint32Parse(${src})"
        case TYPE_ENUM => " = ${field.typeName}.parse(int32Parse(${src}))"
        case TYPE_BOOL => " = boolParse(${src})"
        case TYPE_STRING => " = stringParse(${src})"
        case TYPE_MESSAGE => ".unpack(sub(${src}))"
        case TYPE_BYTES => " = bytesParse(${src})"
        case TYPE_FIXED64 => " = fixed64Parse(${src})"
        case TYPE_FIXED32 => " = fixed32Parse(${src})"
        case TYPE_SFIXED32 => " = sfixed32Parse(${src})"
        case TYPE_SFIXED64 => " = sfixed64Parse(${src})"
        case TYPE_SINT32 => " = sint32Parse(${src})"
        case TYPE_SINT64 => "sint64Parse(${src})"
        case _ => throw Exception("UNSUPPORTED TYPE")
    }
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
    "protobuf", "protoc", "toString", "toJson", "isEmpty", "empty"
])
let messageRsvdWords = HashSet<String>([
    "size", "clear", "clone", "unpack", "pack", "check", "packi", "unpacki",
    "fromBytes", "fromJson", "src", "out"
])
let enumRsvdWords = HashSet<String>([
    "value", "parse"
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

/* upper camel case */
func upperCamelCase(name: String) {
    let arr = titleCase(name).split('_')

    for (i in 1..arr.size) {
        arr[i] = titleCase(arr[i])
    }

    String.join(arr)
}

/* lower camel case */
func lowerCamelCase(name: String) {
    let arr = "${name[0].toLowerCase()}${name.substring(1)}".split('_')

    for (i in 1..arr.size) {
        arr[i] = titleCase(arr[i])
    }

    String.join(arr)
}