// gencode for proto3

package protoc

/* field variable define */
func getFieldVarDefine(field: FieldDescriptorProto) {
    "public var " + getMessagePropName(field.jsonName) + " = " +
    if (field.type_ == TYPE_MESSAGE && field.typeName.endsWith(">")) { /* map */
        "${field.typeName}(0)"
    } else if (field.label == LABEL_REPEATED) { /* repeated fields */
        "ArrayList<${typeConvert(field)}>()"
    } else {    /* normal fields */
        initValue(field)
    }
}

/* field is not empty expr */
func getFieldNoEmptyExpr(field: FieldDescriptorProto) {
    let name = getMessagePropName(field.jsonName)

    /* repeated fields */
    if (field.label == LABEL_REPEATED) {
        return "!${name}.isEmpty()"
    }

    /* normal fields */
    namedNoEmpty(name, field)
}

/* field clear expr */
func getFieldClearExpr(field: FieldDescriptorProto) {
    let name = getMessagePropName(field.jsonName)

    /* repeated fields */
    if (field.label == LABEL_REPEATED) {
        return "${name}.clear()"
    }

    /* normal fields */
    match (field.type_) {
        case TYPE_DOUBLE | TYPE_FLOAT => "${name} = .0"
        case TYPE_BOOL => "${name} = false"
        case TYPE_ENUM => "${name} = ${field.typeName}.empty()"
        case TYPE_STRING => "${name} = \"\""
        case TYPE_MESSAGE => "${name} = ${field.typeName}()"
        case TYPE_BYTES => "${name} = Bytes()"
        case _=> "${name} = 0"
    }
}

/* field clone expr */
func getFieldCloneExpr(field: FieldDescriptorProto) {
    let name = getMessagePropName(field.jsonName)

    /* map */
    if (field.type_ == TYPE_MESSAGE && field.typeName.endsWith(">")) {
        return "${name} = mapClone(${name})"
    }

    /* normal fields */
    if (field.label != LABEL_REPEATED) {
        return "${name} = ${name}" + match (field.type_) {
            case TYPE_MESSAGE | TYPE_BYTES => ".clone()"
            case _ => ""
        }
    }

    /* repeated fields */
    match (field.type_) {
        case TYPE_MESSAGE | TYPE_BYTES => "${name} = ArrayList(${name}.size, { i => ${name}[i].clone() })"
        case _ => "${name} = ${name}.clone()"
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
        return "i_tmp += ${tsize} + ${namedSize(name, field)}"
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
        return namedPack(name, field)
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
        case TYPE_BYTES | TYPE_STRING => "for (i_itmp in ${name}) { ${packTagOut(field.number, PREFIXED)}; out.packBin(i_itmp) }"
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
        return "let i_stmp = subReader(src); var i_ktmp = ${initValue(ek)}; var i_vtmp = ${initValue(ev)}; while (!i_stmp.isEmpty()) { match (i_stmp.parseTag()[0]) { case 1 => ${namedParseSrc("i_ktmp", "i_stmp", ek)} case 2 => ${namedParseSrc("i_vtmp", "i_stmp", ev)} case _ => throw ParseValueExecption(\"map\") } }; ${name}[i_ktmp] = i_vtmp"
    }

    /* normal fields */
    if (field.label != LABEL_REPEATED) {
        return namedParseSrc(name, "src", field)
    }

    /* packed repeated fields */
    if (field.hasOptions && field.options.hasPacked && field.options.packed) {
        return "let i_stmp = subReader(src); while (!i_stmp.isEmpty()) { " + match (field.type_) {
            case TYPE_DOUBLE => "${name}.append(i_stmp.parseFloat64())"
            case TYPE_FLOAT => "${name}.append(i_stmp.parseFloat32())"
            case TYPE_INT64 => "${name}.append(i_stmp.parseInt64())"
            case TYPE_UINT64 => "${name}.append(i_stmp.parseUInt64())"
            case TYPE_INT32 => "${name}.append(i_stmp.parseInt32())"
            case TYPE_UINT32 => "${name}.append(i_stmp.parseUInt32())"
            case TYPE_ENUM => "${name}.append(${field.typeName}.parse(i_stmp.parseInt32()))"
            case TYPE_BOOL => "${name}.append(i_stmp.parseBool())"
            case TYPE_FIXED64 => "${name}.append(i_stmp.parseFixed64())"
            case TYPE_FIXED32 => "${name}.append(i_stmp.parseFixed32())"
            case TYPE_SFIXED32 => "${name}.append(i_stmp.parseSFixed32())"
            case TYPE_SFIXED64 => "${name}.append(i_stmp.parseSFixed64())"
            case TYPE_SINT32 => "${name}.append(i_stmp.parseSInt32())"
            case TYPE_SINT64 => "${name}.append(i_stmp.parseSInt64())"
            case _=> throw Exception("UNSUPPORTED TYPE")
        } + " }"
    }

    /* repeated fields */
    match (field.type_) {
        case TYPE_DOUBLE => "${name}.append(src.parseFloat64())"
        case TYPE_FLOAT => "${name}.append(src.parseFloat32())"
        case TYPE_INT64 => "${name}.append(src.parseInt64())"
        case TYPE_UINT64 => "${name}.append(src.parseUInt64())"
        case TYPE_INT32 => "${name}.append(src.parseInt32())"
        case TYPE_UINT32 => "${name}.append(src.parseUInt32())"
        case TYPE_ENUM => "${name}.append(${field.typeName}.parse(src.parseInt32()))"
        case TYPE_BOOL => "${name}.append(src.parseBool())"
        case TYPE_STRING => "${name}.append(src.parseString())"
        case TYPE_MESSAGE => "${name}.add().unpack(subReader(src))"
        case TYPE_BYTES => "${name}.append(src.parseBytes())"
        case TYPE_FIXED64 => "${name}.append(src.parseFixed64())"
        case TYPE_FIXED32 => "${name}.append(src.parseFixed32())"
        case TYPE_SFIXED32 => "${name}.append(src.parseSFixed32())"
        case TYPE_SFIXED64 => "${name}.append(src.parseSFixed64())"
        case TYPE_SINT32 => "${name}.append(src.parseSInt32())"
        case TYPE_SINT64 => "${name}.append(src.parseSInt64())"
        case _=> throw Exception("UNSUPPORTED TYPE")
    }
}

/* oneof field prop get expr */
func getFieldOneofPropGetExpr(name: String, field: FieldDescriptorProto) {
    let group = getMessagePropName(name)
    let setRet = "${group} = ${titleCase(field.jsonName)}(i_vtmp); i_vtmp"
    let noneExpr = match (field.type_) {
        case TYPE_MESSAGE => "let i_vtmp = ${field.typeName}(); ${setRet}"
        case TYPE_BYTES => "let i_vtmp = Bytes(); ${setRet}"
        case _ => zeroValue(field)
    }

    "match (${group}) { " +
        "case ${titleCase(field.jsonName)}(i_vtmp) => i_vtmp " +
        "case None => ${noneExpr} " +
        "case _ => throw UnmatchedOneofCaseException(\"${field.jsonName}\", ${getMessagePropName(name)}.which()) " +
    "}"
}

/* gen proto3 message codes */
func genCodeMessageField(typeName: String, fields: ArrayList<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    // class define
    append("\npublic class ${typeName} <: Message & TypedMessage<${typeName}> {\n")

    // var define
    for (field in fields where !field.hasOneofIndex) { append("    ${getFieldVarDefine(field)}\n") }
    for ((name, _) in helper.oneofDecl) { append("    public var ${getMessagePropName(name)} = ${typeName}_Oneof_${titleCase(name)}.None\n") }

    // unknown fields
    append("    public var unknownFields = ArrayList<MessageUnknownField>()\n")

    // oneof field props
    for ((name, ofields) in helper.oneofDecl) {
        append("\n    /* oneof ${name} */\n")
        for (field in ofields) { append("    public prop var ${getMessagePropName(field.jsonName)}: ${typeConvert(field)} { get() { ${getFieldOneofPropGetExpr(name, field)} } set(i_vtmp) { ${getMessagePropName(name)} = ${typeName}_Oneof_${titleCase(name)}.${titleCase(field.jsonName)}(i_vtmp) } }\n") }
    }

    // prop size
    append("\n    public prop let size: Int64 { get() {\n        var i_tmp = 0\n")
    for (field in fields where !field.hasOneofIndex) { append("        if (${getFieldNoEmptyExpr(field)}) { ${getFieldSizeExpr(field)} }\n") }
    for ((name, ofields) in helper.oneofDecl) {
        append("        match (${getMessagePropName(name)}) {\n")
        for (field in ofields) { append("            case ${titleCase(field.jsonName)}(i_vtmp) where ${namedNoEmpty("i_vtmp", field)} => i_tmp += ${tagSize(UInt32(field.number))} + ${namedSize("i_vtmp", field)}\n") }
        append("            case _ => ()\n        }\n")
    }
    append("        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }\n        return i_tmp\n    } }\n")

    // func isEmpty
    append("\n    public func isEmpty(): Bool {\n")
    for (field in fields where !field.hasOneofIndex) { append("        if (${getFieldNoEmptyExpr(field)}) { return false }\n") }
    for ((name, ofields) in helper.oneofDecl) {
        append("        match (${getMessagePropName(name)}) {\n")
        for (field in ofields) { append("            case ${titleCase(field.jsonName)}(i_vtmp) where ${namedNoEmpty("i_vtmp", field)} => return false\n") }
        append("            case _ => ()\n        }\n")
    }
    append("        if (!unknownFields.isEmpty()) { return false }\n        return true\n    }\n")

    // func clear
    append("\n    public func clear(): Unit {\n")
    for (field in fields where !field.hasOneofIndex) { append("        ${getFieldClearExpr(field)}\n") }
    for ((name, _) in helper.oneofDecl) { append("        ${getMessagePropName(name)} = None\n") }
    append("        unknownFields.clear()\n    }\n")

    // func clone
    append("\n    public func clone(): ${typeName} {\n        let i_tmp = ${typeName}()\n")
    for (field in fields where !field.hasOneofIndex) { append("        i_tmp.${getFieldCloneExpr(field)}\n") }
    for ((name, _) in helper.oneofDecl) { append("        i_tmp.${getMessagePropName(name)} = ${getMessagePropName(name)}.clone()\n") }
    append("        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }\n        return i_tmp\n    }\n")

    // func unpack
    append("\n    public func unpack<T>(src: T): Unit where T <: BytesReader {\n        while (!src.isEmpty()) {\n            let i_tmp = src.parseTag()\n            match (i_tmp[0]) {\n")
    for (field in fields where !field.hasOneofIndex) { append("                case ${field.number} => ${getFieldUnpackExpr(field)}\n") }
    for ((name, ofields) in helper.oneofDecl) { for (field in ofields) { append("                case ${field.number} => ${getOneofFieldUnapckExpr(typeName, name, field)}\n") } }
    append("                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))\n            }\n        }\n    }\n")

    // func pack
    append("\n    public func pack<T>(out: T): Unit where T <: BytesWriter {\n")
    for (field in fields where !field.hasOneofIndex) { append("        if (${getFieldNoEmptyExpr(field)}) { ${getFieldPackExpr(field)} }\n") }
    for ((name, ofields) in helper.oneofDecl) {
        append("        match (${getMessagePropName(name)}) {\n")
        for (field in ofields) { append("            case ${titleCase(field.jsonName)}(i_vtmp) where ${namedNoEmpty("i_vtmp", field)} => ${namedPack("i_vtmp", field)}\n") }
        append("            case _ => ()\n        }\n")
    }
    append("        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }\n    }\n")

    // func toString
    append("\n    public func toString(): String {\n        var i_tmp = StructPrinter()\n")
    for (field in fields where !field.hasOneofIndex) { append("        if (${getFieldNoEmptyExpr(field)}) { i_tmp.append(\"${field.jsonName}\", ${getMessagePropName(field.jsonName)}) }\n") }
    for ((name, ofields) in helper.oneofDecl) {
        append("        match (${getMessagePropName(name)}) {\n")
        for (field in ofields) { append("            case ${titleCase(field.jsonName)}(i_vtmp) where ${namedNoEmpty("i_vtmp", field)} => i_tmp.append(\"${field.jsonName}\", i_vtmp)\n") }
        append("            case _ => ()\n        }\n")
    }
    append("        if (!unknownFields.isEmpty()) { i_tmp.append(\"unknownFields\", unknownFields) }\n        return i_tmp.done().toString()\n    }\n\n")

    // impl interface
    append(getImplIterfaceApi(typeName))

    // end
    append("}\n")
}