// gencode for proto3

package protoc

/* field variable define */
func getFieldVarDefine(field: FieldDescriptorProto) {
    let name = getMessagePropName(field.jsonName)
    let pName = "p_${field.jsonName}"

    if (field.type_ == TYPE_MESSAGE) {
        if (field.typeName.endsWith(">")) {
            /* map */
            return "public let ${name} = ${field.typeName}(0)"
        }

        if (field.label == LABEL_REPEATED) {
            /* repeated message */
            return "public let ${name} = RepeatedMessage<${field.typeName}>()"
        }

        /* normal message */
        return "private var ${pName} = ${field.typeName}()"
    }

    if (field.type_ == TYPE_STRING) {
        if (field.label == LABEL_REPEATED) {
            /* repeated string */
            return "public let ${name} = RepeatedString()"
        }

        /* normal string */
        return "private var ${pName} = Pb3String()"
    }

    /* repeated fields */
    if (field.label == LABEL_REPEATED) {
        return "public let ${name} = RepeatedField<${typeConvert(field)}>()"
    }

    /* normal fields */
    return "private var ${pName} = ${initValue(field)}"
}

/* field is not empty expr */
func getFieldNoEmptyExpr(field: FieldDescriptorProto) {
    /* repeated fields */
    if (field.label == LABEL_REPEATED) {
        return "!${getMessagePropName(field.jsonName)}.isEmpty()"
    }

    /* normal fields */
    namedNoEmpty("p_${field.jsonName}", field)
}

/* field clear expr */
func getFieldClearExpr(field: FieldDescriptorProto) {
    /* repeated fields */
    if (field.label == LABEL_REPEATED) {
        return "${getMessagePropName(field.jsonName)}.clear()"
    }

    let pName = "p_${field.jsonName}"

    /* normal fields */
    match (field.type_) {
        case TYPE_DOUBLE | TYPE_FLOAT => "${pName} = .0"
        case TYPE_BOOL => "${pName} = false"
        case TYPE_ENUM => "${pName} = ${field.typeName}.empty()"
        case TYPE_STRING | TYPE_MESSAGE => "${pName}.clear()"
        case TYPE_BYTES => "${pName} = BytesSlice()"
        case _=> "${pName} = 0"
    }
}

/* field size expr */
func getFieldSizeExpr(field: FieldDescriptorProto) {
    let name = getMessagePropName(field.jsonName)
    let tsize = tagSize(UInt32(field.number))

    /* map */
    if (field.type_ == TYPE_MESSAGE && field.typeName.endsWith(">")) {
        let ek = field.mapEntry[0]
        let ev = field.mapEntry[1]
        return "for ((i_ktmp, i_vtmp) in ${name}) { var i_stmp = 0; if (${namedNoEmpty("i_ktmp", ek)}) { i_stmp += 1 + ${namedSize("i_ktmp", ek)} }; if (${namedNoEmpty("i_vtmp", ev)}) { i_stmp += 1 + ${namedSize("i_vtmp", ev)} }; i_tmp += ${tsize} + varintSize(i_stmp) + i_stmp }"
    }

    /* normal fields */
    if (field.label != LABEL_REPEATED) {
        return "i_tmp += ${tsize} + " + namedSize("p_${field.jsonName}", field)
    }

    /* packed repeated fields */
    if (field.hasOptions && field.options.hasPacked && field.options.packed) {
        return match (field.type_) {
            case TYPE_BOOL => "let i_stmp = ${name}.size"
            case TYPE_DOUBLE | TYPE_FIXED64 | TYPE_SFIXED64 => "let i_stmp = 8 * ${name}.size"
            case TYPE_FIXED32 | TYPE_SFIXED32 | TYPE_FLOAT => "let i_stmp = 4 * ${name}.size"
            case TYPE_ENUM => "var i_stmp = 0; for (i_itmp in ${name}) { i_stmp += varintSize(i_itmp.value()) }"
            case TYPE_SINT32 | TYPE_SINT64 => "var i_stmp = 0; for (i_itmp in ${name}) { i_stmp += sintSize(i_itmp) }"
            case _ => "var i_stmp = 0; for (i_itmp in ${name}) { i_stmp += varintSize(i_itmp) }"
        } + "; i_tmp += ${tsize} + varintSize(i_stmp) + i_stmp"
    }

    /* repeated fields */
    match (field.type_) {
        case TYPE_BOOL => "i_tmp += (${tsize} + 1) * ${name}.size"
        case TYPE_DOUBLE | TYPE_FIXED64 | TYPE_SFIXED64 => "i_tmp += (${tsize} + 8) * ${name}.size"
        case TYPE_FIXED32 | TYPE_SFIXED32 | TYPE_FLOAT => "i_tmp += (${tsize} + 4) * ${name}.size"
        case TYPE_BYTES | TYPE_STRING | TYPE_MESSAGE => "for (i_itmp in ${name}) { i_tmp += ${tsize} + binSize(i_itmp) }"
        case TYPE_ENUM => "for (i_itmp in ${name}) { i_tmp += ${tsize} + varintSize(i_itmp.value()) }"
        case TYPE_SINT32 | TYPE_SINT64 => "for (i_itmp in ${name}) { i_tmp += ${tsize} + sintSize(i_itmp) }"
        case _ => "for (i_itmp in ${name}) { i_tmp += ${tsize} + varintSize(i_itmp) }"
    }
}

/* field hashCode expr */
func getFieldHashExpr(field: FieldDescriptorProto) {
    if (field.label == LABEL_REPEATED) {
        return "i_tmp.write(${getMessagePropName(field.jsonName)}.hashCode())"
    }

    let arg = match (field.type_) {
        case TYPE_BYTES | TYPE_MESSAGE => "p_${field.jsonName}.hashCode()"
        case TYPE_STRING => "p_${field.jsonName}.data.hashCode()"
        case TYPE_ENUM => "p_${field.jsonName}.value()"
        case _ => "p_${field.jsonName}"
    }

    return "i_tmp.write(${arg})"
}

/* field pack expr */
func getFieldPackExpr(field: FieldDescriptorProto) {
    let name = getMessagePropName(field.jsonName)

    /* map */
    if (field.type_ == TYPE_MESSAGE && field.typeName.endsWith(">")) {
        let ek = field.mapEntry[0]
        let ev = field.mapEntry[1]
        return "for ((i_ktmp, i_vtmp) in ${name}) { ${packTagOut(field.number, PREFIXED)}; var i_stmp = 0; if (${namedNoEmpty("i_ktmp", ek)}) { i_stmp += 1 + ${namedSize("i_ktmp", ek)} }; if (${namedNoEmpty("i_vtmp", ev)}) { i_stmp += 1 + ${namedSize("i_vtmp", ev)} }; out.packVarint(i_stmp); if (${namedNoEmpty("i_ktmp", ek)}) { ${namedPack("i_ktmp", ek)} }; if (${namedNoEmpty("i_vtmp", ev)}) { ${namedPack("i_vtmp", ev)} } }"
    }

    /* normal fields */
    if (field.label != LABEL_REPEATED) {
        if (field.type_ == TYPE_STRING) {
            return "${packTagOut(field.number, PREFIXED)}; out.packBin(p_${field.jsonName}.data)"
        }

        return namedPack("p_${field.jsonName}", field)
    }

    /* packed repeated fields */
    if (field.hasOptions && field.options.hasPacked && field.options.packed) {
        return "${packTagOut(field.number, PREFIXED)}; " + match (field.type_) {
            case TYPE_BOOL => "out.packVarint(${name}.size); for (i_itmp in ${name}) { out.packBool(i_itmp) }"
            case TYPE_DOUBLE | TYPE_FIXED64 | TYPE_SFIXED64 => "out.packVarint(8 * ${name}.size); for (i_itmp in ${name}) { out.packFixed(i_itmp) }"
            case TYPE_FIXED32 | TYPE_SFIXED32 | TYPE_FLOAT => "out.packVarint(4 * ${name}.size); for (i_itmp in ${name}) { out.packFixed(i_itmp) }"
            case TYPE_ENUM => "var i_stmp = 0; for (i_itmp in ${name}) { i_stmp += varintSize(i_itmp.value()) }; out.packVarint(i_stmp); for (i_itmp in ${name}) { out.packVarint(i_itmp.value()) }"
            case TYPE_SINT32 | TYPE_SINT64 => "var i_stmp = 0; for (i_itmp in ${name}) { i_stmp += sintSize(i_itmp) }; out.packVarint(i_stmp); for (i_itmp in ${name}) { out.packSInt(i_itmp) }"
            case _ => "var i_stmp = 0; for (i_itmp in ${name}) { i_stmp += varintSize(i_itmp) }; out.packVarint(i_stmp); for (i_itmp in ${name}) { out.packVarint(i_itmp) }"
        }
    }

    /* repeated fields */
    match (field.type_) {
        case TYPE_BOOL => "for (i_itmp in ${name}) { ${packTagOut(field.number, VARINT)}; out.packBool(i_itmp) }"
        case TYPE_DOUBLE | TYPE_FIXED64 | TYPE_SFIXED64 => "for (i_itmp in ${name}) { ${packTagOut(field.number, BIT64)}; out.packFixed(i_itmp) }"
        case TYPE_FIXED32 | TYPE_SFIXED32 | TYPE_FLOAT => "for (i_itmp in ${name}) { ${packTagOut(field.number, BIT32)}; out.packFixed(i_itmp) }"
        case TYPE_BYTES => "for (i_itmp in ${name}) { ${packTagOut(field.number, PREFIXED)}; out.packBin(i_itmp) }"
        case TYPE_STRING => "s_pack(${field.number}, ${name}, out)"
        case TYPE_MESSAGE => "for (i_itmp in ${name}) { ${packTagOut(field.number, PREFIXED)}; out.packVarint(i_itmp.size); i_itmp.pack(out) }"
        case TYPE_ENUM => "for (i_itmp in ${name}) { ${packTagOut(field.number, VARINT)}; out.packVarint(i_itmp.value()) }"
        case TYPE_SINT32 | TYPE_SINT64 => "for (i_itmp in ${name}) { ${packTagOut(field.number, VARINT)}; out.packSInt(i_itmp) }"
        case _ => "for (i_itmp in ${name}) { ${packTagOut(field.number, VARINT)}; out.packVarint(i_itmp) }"
    }
}

/* field unpack expr */
func getFieldUnpackExpr(field: FieldDescriptorProto) {
    let name = getMessagePropName(field.jsonName)

    /* map */
    if (field.type_ == TYPE_MESSAGE && field.typeName.endsWith(">")) {
        let ek = field.mapEntry[0]
        let ev = field.mapEntry[1]
        return "let i_stmp = subReader(src); " +
        "var i_ktmp = ${initValue(ek)}; " +
        "var i_vtmp = ${initValue(ev)}; " +
        "while (!i_stmp.isEmpty()) { " +
            "match (i_stmp.parseTag()[0]) { " +
                "case 1 => ${namedParseSrc("i_ktmp", "i_stmp", ek)} " +
                "case 2 => ${namedParseSrc("i_vtmp", "i_stmp", ev)} " +
                "case _ => throw ParseValueExecption(\"map\") " +
            "} " +
        "}; " +
        "s_add(${name}, i_ktmp, i_vtmp)"
    }

    /* normal fields */
    if (field.label != LABEL_REPEATED) {
        if (field.type_ == TYPE_STRING) {
            return "p_${field.jsonName}.unpack(src)"
        }

        return namedParseSrc("p_${field.jsonName}", "src", field)
    }

    /* packed repeated fields */
    if (field.hasOptions && field.options.hasPacked && field.options.packed) {
        return "let i_stmp = subReader(src); while (!i_stmp.isEmpty()) { s_add(${name}, " +
        match (field.type_) {
            case TYPE_DOUBLE => "i_stmp.parseFloat64()"
            case TYPE_FLOAT => "i_stmp.parseFloat32()"
            case TYPE_INT64 => "i_stmp.parseInt64()"
            case TYPE_UINT64 => "i_stmp.parseUInt64()"
            case TYPE_INT32 => "i_stmp.parseInt32()"
            case TYPE_UINT32 => "i_stmp.parseUInt32()"
            case TYPE_ENUM => "${field.typeName}.parse(i_stmp.parseInt32())"
            case TYPE_BOOL => "i_stmp.parseBool()"
            case TYPE_FIXED64 => "i_stmp.parseFixed64()"
            case TYPE_FIXED32 => "i_stmp.parseFixed32()"
            case TYPE_SFIXED32 => "i_stmp.parseSFixed32()"
            case TYPE_SFIXED64 => "i_stmp.parseSFixed64()"
            case TYPE_SINT32 => "i_stmp.parseSInt32()"
            case TYPE_SINT64 => "i_stmp.parseSInt64()"
            case _=> throw Exception("UNSUPPORTED TYPE")
        } +
        ") }"
    }

    /* repeated fields */
    return "s_add(${name}, " +
    match (field.type_) {
        case TYPE_DOUBLE => "src.parseFloat64()"
        case TYPE_FLOAT => "src.parseFloat32()"
        case TYPE_INT64 => "src.parseInt64()"
        case TYPE_UINT64 => "src.parseUInt64()"
        case TYPE_INT32 => "src.parseInt32()"
        case TYPE_UINT32 => "src.parseUInt32()"
        case TYPE_ENUM => "${field.typeName}.parse(src.parseInt32())"
        case TYPE_BOOL => "src.parseBool()"
        case TYPE_STRING => "src"
        case TYPE_MESSAGE => "src"
        case TYPE_BYTES => "src.parseBytesSlice()"
        case TYPE_FIXED64 => "src.parseFixed64()"
        case TYPE_FIXED32 => "src.parseFixed32()"
        case TYPE_SFIXED32 => "src.parseSFixed32()"
        case TYPE_SFIXED64 => "src.parseSFixed64()"
        case TYPE_SINT32 => "src.parseSInt32()"
        case TYPE_SINT64 => "src.parseSInt64()"
        case _=> throw Exception("UNSUPPORTED TYPE")
    } +
    ")"
}

/* oneof field prop get expr */
func getFieldOneofPropGetExpr(name: String, field: FieldDescriptorProto) {
    "match (p_${name}) { " +
        "case ${titleCase(field.jsonName)}(i_vtmp) => i_vtmp " +
        "case _ => throw UnexpectedOneofException() " +
    "}"
}

/* oneof field prop set expr */
func getFieldOneofPropSetExpr(typeName: String, name: String, field: FieldDescriptorProto) {
    let set = "p_${name} = ${typeName}_Oneof_${titleCase(name)}.${titleCase(field.jsonName)}(i_vtmp)"

    if (field.type_ == TYPE_MESSAGE) {
        return "m_assign(p_${name}, i_vtmp); ${set}; markDirty()"
    }

    return "m_assign(p_${name}); ${set}; markDirty()"
}

/* message class and member variable define */
func genCodeMessageFieldClass(typeName: String, fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("public class ${typeName} <: Message & TypedMessage<${typeName}> {\n")

    for (field in fields where !field.hasOneofIndex) {
        append("    ${getFieldVarDefine(field)}\n")
    }

    for ((name, _) in helper.oneofDecl) {
        append("    private var p_${name} = ${typeName}_Oneof_${titleCase(name)}.None\n")
    }
}

/* message init */
func genCodeMessageFieldInit(fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("    public init() {\n")

    for (field in fields where !field.hasOneofIndex) {
        if (field.label == LABEL_REPEATED) {
            append("        m_init(${getMessagePropName(field.jsonName)})\n")
            continue
        }

        if (field.type_ == TYPE_MESSAGE) {
            append("        m_init(p_${field.jsonName})\n")
        }
    }

    append("        m_innerInit()\n")
    append("    }\n")
}

/* message props define */
func genCodeMessageFieldProps(typeName: String, fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    // normal field props
    for (field in fields where !field.hasOneofIndex && field.label != LABEL_REPEATED) {
        let name = getMessagePropName(field.jsonName)
        let pName = "p_${field.jsonName}"

        append("\n")
        if (field.type_ == TYPE_STRING) {
            append("    public prop var ${name}: String { get() { ${pName}.get() } set(i_vtmp) { ${pName}.set(i_vtmp); markDirty() } }\n")
        } else if (field.type_ == TYPE_MESSAGE) {
            append("    public prop var ${name}: ${field.typeName} { get() { ${pName} } set(i_vtmp) { m_assign(${pName}, i_vtmp); ${pName} = i_vtmp; markDirty() } }\n")
        } else {
            append("    public prop var ${name}: ${typeConvert(field)} { get() { ${pName} } set(i_vtmp) { ${pName} = i_vtmp; markDirty() } }\n")
        }
    }

    // oneof field props
    for ((name, ofields) in helper.oneofDecl) {
        append("\n")
        append("    public prop var ${name}: ${typeName}_Oneof_${titleCase(name)} { get() { p_${name} } set(i_vtmp) { m_assign(p_${name}, i_vtmp); p_${name} = i_vtmp; markDirty() } }\n")
        for (field in ofields) {
            append("\n")
            append("    public prop let has${titleCase(field.jsonName)}: Bool { get() { match(p_${name}) { case ${titleCase(field.jsonName)}(_) => true case _ => false } } }\n")
            append("    public prop var ${getMessagePropName(field.jsonName)}: ${typeConvert(field)} { get() { ${getFieldOneofPropGetExpr(name, field)} } set(i_vtmp) { ${getFieldOneofPropSetExpr(typeName, name, field)} } }\n")
        }
    }
}

/* message m_size */
func genCodeMessageFieldSize(fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("    protected func m_size(): Int64 {\n")
    append("        var i_tmp = 0\n")

    /* normal fields size */
    for (field in fields where !field.hasOneofIndex) {
        append("        " + match {
            case field.type_ != TYPE_STRING => "if (${getFieldNoEmptyExpr(field)}) { ${getFieldSizeExpr(field)} }"
            case field.label == LABEL_REPEATED =>
                let name = getMessagePropName(field.jsonName)
                "if (!${name}.isEmpty()) { i_tmp += m_size(${name}, ${tagSize(UInt32(field.number))}) }"
            case _ => "if (!p_${field.jsonName}.isEmpty()) { i_tmp += ${tagSize(UInt32(field.number))} + binSize(p_${field.jsonName}.data) }"
        } + "\n")
    }

    /* oneof fields size */
    for ((name, ofields) in helper.oneofDecl) {
        append("        match (p_${name}) {\n")
        for (field in ofields) {
            append("            case ${titleCase(field.jsonName)}(i_vtmp) => i_tmp += ${tagSize(UInt32(field.number))} + ${namedSize("i_vtmp", field)}\n")
        }
        append("            case _ => ()\n        }\n")
    }

    append("        return i_tmp\n")
    append("    }\n")
}

/* message m_size */
func genCodeMessageFieldHash(fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("    protected func m_hashCode(): Int64 {\n")
    append("        var i_tmp = DefaultHasher()\n")

    /* normal fields size */
    for (field in fields where !field.hasOneofIndex) {
        append("        if (${getFieldNoEmptyExpr(field)}) { ${getFieldHashExpr(field)} }\n")
    }

    /* oneof fields size */
    for ((name, ofields) in helper.oneofDecl) {
        append("        if (!p_${name}.isEmpty()) { i_tmp.write(p_${name}.hashCode()) }\n")
    }

    append("        return i_tmp.finish()\n")
    append("    }\n")
}

/* message m_isEmpty */
func genCodeMessageFieldIsEmpty(fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper) {
    let append: (String) -> StringBuilder = helper.outbuf.append
    let sepOut = LineSepOut(helper.outbuf, sep: " &&", sn: 8)

    append("\n")
    append("    protected func m_isEmpty(): Bool {\n")

    /* normal fields */
    for (field in fields where !field.hasOneofIndex) {
        sepOut.append(if (field.label == LABEL_REPEATED) {
            "${getMessagePropName(field.jsonName)}.isEmpty()"
        } else {
            let pName = "p_${field.jsonName}"
            match (field.type_) {
                case TYPE_DOUBLE | TYPE_FLOAT => "${pName} == .0"
                case TYPE_BOOL => "${pName} == false"
                case TYPE_ENUM | TYPE_BYTES => "${pName}.isEmpty()"
                case TYPE_MESSAGE | TYPE_STRING => "${pName}.isEmpty()"
                case _ => "${pName} == 0"
            }
        })
    }

    /* oneof fields */
    for ((name, _) in helper.oneofDecl) {
        sepOut.append("p_${name}.isEmpty()")
    }

    append("\n")
    append("    }\n")
}

/* message m_clear */
func genCodeMessageFieldClear(fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("    protected func m_clear(): Unit {\n")

    /* normal fields */
    for (field in fields where !field.hasOneofIndex) {
        append("        ${getFieldClearExpr(field)}\n")
    }

    /* oneof fields */
    for ((name, _) in helper.oneofDecl) {
        append("        m_assign(p_${name}); p_${name} = None\n")
    }

    append("    }\n")
}

/* message m_isEmpty */
func genCodeMessageFieldEquat(typeName: String, fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper) {
    let append: (String) -> StringBuilder = helper.outbuf.append
    let sepOut = LineSepOut(helper.outbuf, sep: " &&", sn: 8)

    append("\n")
    append("    public operator func !=(src: ${typeName}): Bool { !(this == src) }\n")
    append("    public operator func ==(src: ${typeName}): Bool {\n")
    /* common pre compare */
    sepOut.append("hashCode() == src.hashCode() && size == src.size && unknownFields == src.unknownFields")

    /* normal fields */
    for (field in fields where !field.hasOneofIndex) {
        sepOut.append(match {
            case field.label == LABEL_REPEATED => "${getMessagePropName(field.jsonName)} == src.${getMessagePropName(field.jsonName)}"
            case field.type_ == TYPE_STRING => "p_${field.jsonName}.data == src.p_${field.jsonName}.data"
            case _ => "p_${field.jsonName} == src.p_${field.jsonName}"
        })
    }

    /* oneof fields */
    for ((name, _) in helper.oneofDecl) {
        sepOut.append("p_${name} == src.p_${name}")
    }

    append("\n")
    append("    }\n")
}

/* message copyFrom */
func genCodeMessageFieldCopyFrom(typeName: String, fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("    public func copyFrom(src: ${typeName}): ${typeName} {\n")

    /* normal fields */
    for (field in fields where !field.hasOneofIndex) {
        let name = getMessagePropName(field.jsonName)
        let pName = "p_${field.jsonName}"

        if (field.label == LABEL_REPEATED) {
            append("        ${name}.copyFrom(src.${name})\n")
        } else if (field.type_ == TYPE_MESSAGE) {
            append("        ${pName}.copyFrom(src.${pName})\n")
        } else {
            append("        ${pName} = src.${pName}\n")
        }
    }

    /* oneof fields */
    for ((name, _) in helper.oneofDecl) {
        append("        m_assign(p_${name}); p_${name} = m_init(src.p_${name}.clone())\n")
    }

    append("        m_innerCopyFrom(src)\n")
    append("        return this\n")
    append("    }\n")
}

/* message clone */
func genCodeMessageFieldClone(typeName: String, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("    public func clone(): ${typeName} {\n")
    append("        return ${typeName}().copyFrom(this)\n")
    append("    }\n")
}

/* message unpack */
func genCodeMessageFieldUnpack(typeName: String, fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("    public func unpack<T>(src: T): Unit where T <: BytesReader {\n")
    append("        while (!src.isEmpty()) {\n")
    append("            let i_tmp = src.parseTag()\n")
    append("            match (i_tmp[0]) {\n")

    for (field in fields where !field.hasOneofIndex) {
        append("                case ${field.number} => ${getFieldUnpackExpr(field)}\n")
    }

    for ((name, ofields) in helper.oneofDecl) {
        for (field in ofields) {
            append("                case ${field.number} => ${getOneofFieldUnapckExpr(typeName, name, field)}\n")
        }
    }

    append("                case _ => m_unknown(src, i_tmp)\n")
    append("            }\n")
    append("        }\n")
    append("        markDirty()\n")
    append("    }\n")
}

/* message pack */
func genCodeMessageFieldPack(fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("    public func pack<T>(out: T): Unit where T <: BytesWriter {\n")

    for (field in fields where !field.hasOneofIndex) {
        append("        if (${getFieldNoEmptyExpr(field)}) { ${getFieldPackExpr(field)} }\n")
    }

    for ((name, ofields) in helper.oneofDecl) {
        append("        match (p_${name}) {\n")
        for (field in ofields) {
            append("            case ${titleCase(field.jsonName)}(i_vtmp) => ${namedPack("i_vtmp", field)}\n")
        }
        append("            case _ => ()\n")
        append("        }\n")
    }
    append("        m_unknown(out)\n")
    append("    }\n")
}

/* message toString */
func genCodeMessageFieldToString(fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("    public func toString(): String {\n")
    append("        var i_tmp = StructPrinter()\n")

    for (field in fields where !field.hasOneofIndex) {
        let str = if (field.label == LABEL_REPEATED) {
            getMessagePropName(field.jsonName)
        } else if (field.type_ == TYPE_STRING) {
            "p_${field.jsonName}.get()"
        } else {
            "p_${field.jsonName}"
        }

        append("        if (${getFieldNoEmptyExpr(field)}) { i_tmp.append(\"${field.jsonName}\", ${str}) }\n")
    }

    for ((name, ofields) in helper.oneofDecl) {
        append("        match (p_${name}) {\n")
        for (field in ofields) {
            append("            case ${titleCase(field.jsonName)}(i_vtmp) => i_tmp.append(\"${field.jsonName}\", i_vtmp)\n")
        }
        append("            case _ => ()\n        }\n")
    }

    append("        return i_tmp.done().toString()\n")
    append("    }\n\n")
}

/* gen proto3 message codes */
func genCodeMessageField(typeName: String, fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    // class and member variable define
    genCodeMessageFieldClass(typeName, fields, helper)

    // init define
    genCodeMessageFieldInit(fields, helper)

    // props define
    genCodeMessageFieldProps(typeName, fields, helper)

    // func m_size
    genCodeMessageFieldSize(fields, helper)

    // func m_hashCode
    genCodeMessageFieldHash(fields, helper)

    // func m_isEmpty
    genCodeMessageFieldIsEmpty(fields, helper)

    // func m_clear
    genCodeMessageFieldClear(fields, helper)

    // operator == !=
    genCodeMessageFieldEquat(typeName, fields, helper)

    // func copyFrom
    genCodeMessageFieldCopyFrom(typeName, fields, helper)

    // func clone
    genCodeMessageFieldClone(typeName, helper)

    // func unpack
    genCodeMessageFieldUnpack(typeName, fields, helper)

    // func pack
    genCodeMessageFieldPack(fields, helper)

    // func toString
    genCodeMessageFieldToString(fields, helper)

    // impl interface
    append(getImplIterfaceApi(typeName))

    // end
    append("}\n")
}