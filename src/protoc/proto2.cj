// gencode for proto2

package protoc

/* field variable define */
func getFieldVarDefine2(field: FieldDescriptorProto) {
    if (field.label == LABEL_REPEATED) {
        return getFieldVarDefine(field)
    }

    if (field.type_ == TYPE_STRING) {
        let defaultValue = if (field.hasDefaultValue) { "\"${field.defaultValue}\"" } else { "" }
        return "private var p_${field.jsonName} = Pb2String(${defaultValue})"
    }

    if (field.type_ == TYPE_MESSAGE) {
        return "private var p_${field.jsonName} = Pb2Message<${field.typeName}>()"
    }

    return "private var p_${field.jsonName}: ?${typeConvert(field)} = None"
}

/* field is not empty expr */
func getFieldNoEmptyExpr2(field: FieldDescriptorProto) {
    if (field.label == LABEL_REPEATED) {
        return "!${getMessagePropName(field.jsonName)}.isEmpty()"
    }

    if (field.type_ == TYPE_STRING || field.type_ == TYPE_MESSAGE) {
        return "let Some(i_vtmp) = p_${field.jsonName}.data"
    }

    return "let Some(i_vtmp) = p_${field.jsonName}"
}

/* field clear expr */
func getFieldClearExpr2(field: FieldDescriptorProto) {
    if (field.label == LABEL_REPEATED) {
        return "${getMessagePropName(field.jsonName)}.clear()"
    }

    if (field.type_ == TYPE_STRING) {
        return "p_${field.jsonName}.clear()"
    }

    if (field.type_ == TYPE_MESSAGE) {
        return "p_${field.jsonName}.removeFrom(this)"
    }

    return "p_${field.jsonName} = None"
}

/* field size expr */
func getFieldSizeExpr2(field: FieldDescriptorProto) {
    if (field.label == LABEL_REPEATED) {
        return getFieldSizeExpr(field)
    }

    return "i_tmp += ${tagSize(UInt32(field.number))} + " + namedSize("i_vtmp", field)
}

/* field hashCode expr */
func getFieldHashExpr2(field: FieldDescriptorProto) {
    if (field.label == LABEL_REPEATED) {
        return "i_tmp.write(${getMessagePropName(field.jsonName)}.hashCode())"
    }

    let arg = match (field.type_) {
        case TYPE_BYTES | TYPE_STRING | TYPE_MESSAGE | TYPE_ENUM => "i_vtmp.hashCode()"
        case _ => "i_vtmp"
    }

    return "i_tmp.write(${arg})"
}

/* field unpack expr */
func getFieldUnpackExpr2(field: FieldDescriptorProto) {
    if (field.label == LABEL_REPEATED) {
        return getFieldUnpackExpr(field)
    }

    if (field.type_ == TYPE_STRING) {
        return "p_${field.jsonName}.unpack(src)"
    }

    if (field.type_ == TYPE_MESSAGE) {
        return "p_${field.jsonName}.getOrDefault(this).unpack(subReader(src))"
    }

    if (field.hasDefaultValue) {
        return namedParseSrc(getMessagePropName(field.jsonName), "src", field)
    }

    return namedParseSrc("p_${field.jsonName}", "src", field)
}

/* normal field prop var expr */
func getFieldPropVarExpr2(field: FieldDescriptorProto) {
    if (!field.hasDefaultValue) {
        return "get() { p_${field.jsonName}.getOrThrow() } set(i_tmp) { p_${field.jsonName} = i_tmp; markDirty() }"
    }

    match (field.type_) {
        case TYPE_DOUBLE | TYPE_FLOAT => if (!field.defaultValue.contains('.')) { field.defaultValue = if (field.defaultValue[0] == '-') { "-.${field.defaultValue.substring(1)}" } else { ".${field.defaultValue}" } }
        case TYPE_STRING => ()
        case TYPE_BYTES => throw Exception("NOT SUPPORT BYTES DEFAULT VALUE")
        case _=> ()
    }

    return "get() { p_${field.jsonName} ?? ${field.defaultValue} } set(i_tmp) { p_${field.jsonName} = if (i_tmp == ${field.defaultValue}) { None } else { i_tmp }; markDirty() }"
}

/* message class and member variable define */
func genCodeMessageFieldClass2(typeName: String, fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("public class ${typeName} <: Message & TypedMessage<${typeName}> {\n")

    for (field in fields where !field.hasOneofIndex) {
        append("    ${getFieldVarDefine2(field)}\n")
    }

    for ((name, _) in helper.oneofDecl) {
        append("    private var p_${name} = ${typeName}_Oneof_${titleCase(name)}.None\n")
    }
}

/* message init */
func genCodeMessageFieldInit2(fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("    public init() {\n")

    for (field in fields where !field.hasOneofIndex) {
        if (field.label == LABEL_REPEATED) {
            append("        m_init(${getMessagePropName(field.jsonName)})\n")
            continue
        }
    }

    append("        m_innerInit()\n")
    append("    }\n")
}

/* message props define */
func genCodeMessageFieldProps2(typeName: String, fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    // normal field props
    for (field in fields where !field.hasOneofIndex && field.label != LABEL_REPEATED) {
        let name = getMessagePropName(field.jsonName)
        let uName = upperCamelCase(field.jsonName)
        let pName = "p_${field.jsonName}"

        append("\n")
        if (field.type_ == TYPE_STRING) {
            append("    public func clear${uName}() { ${pName}.clear(); markDirty() }\n")
            append("    public prop let has${uName}: Bool { get() { isPresent(${pName}.data) } }\n")
            append("    public prop var ${name}: ${typeConvert(field)} { get() { ${pName}.get() } set(i_vtmp) { ${pName}.set(i_vtmp); markDirty() } }\n")
        } else if (field.type_ == TYPE_MESSAGE) {
            append("    public func clear${uName}() { ${pName}.removeFrom(this); markDirty() }\n")
            append("    public prop let has${uName}: Bool { get() { isPresent(${pName}.data) } }\n")
            append("    public prop var ${name}: ${field.typeName} { get() { ${pName}.data.getOrThrow() } set(i_vtmp) { ${pName}.set(this, i_vtmp); markDirty() } }\n")
        } else {
            append("    public func clear${uName}() { ${pName} = None; markDirty() }\n")
            append("    public prop let has${uName}: Bool { get() { isPresent(${pName}) } }\n")
            append("    public prop var ${name}: ${typeConvert(field)} { ${getFieldPropVarExpr2(field)} }\n")
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
func genCodeMessageFieldSize2(fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("    protected func m_size(): Int64 {\n")
    append("        var i_tmp = 0\n")

    /* normal fields size */
    for (field in fields where !field.hasOneofIndex) {
        if (field.type_ == TYPE_STRING && field.label == LABEL_REPEATED) {
            let name = getMessagePropName(field.jsonName)
            append("        if (!${name}.isEmpty()) { i_tmp += m_size(${name}, ${tagSize(UInt32(field.number))}) }\n")
        } else {
            append("        if (${getFieldNoEmptyExpr2(field)}) { ${getFieldSizeExpr2(field)} }\n")
        }
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

/* message m_hashCode */
func genCodeMessageFieldHash2(fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("    protected func m_hashCode(): Int64 {\n")
    append("        var i_tmp = DefaultHasher()\n")

    /* normal fields hashCode */
    for (field in fields where !field.hasOneofIndex) {
        append("        if (${getFieldNoEmptyExpr2(field)}) { ${getFieldHashExpr2(field)} }\n")
    }

    /* oneof fields hashCode */
    for ((name, ofields) in helper.oneofDecl) {
        append("        if (!p_${name}.isEmpty()) { i_tmp.write(p_${name}.hashCode()) }\n")
    }

    append("        return i_tmp.finish()\n")
    append("    }\n")
}

/* message m_isEmpty */
func genCodeMessageFieldIsEmpty2(fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper) {
    let append: (String) -> StringBuilder = helper.outbuf.append
    let sepOut = LineSepOut(helper.outbuf, sep: " &&", sn: 8)

    append("\n")
    append("    protected func m_isEmpty(): Bool {\n")

    /* normal fields */
    for (field in fields where !field.hasOneofIndex) {
        sepOut.append(match {
            case field.label == LABEL_REPEATED => "${getMessagePropName(field.jsonName)}.isEmpty()"
            case field.type_ == TYPE_STRING || field.type_ == TYPE_MESSAGE => "isNone(p_${field.jsonName}.data)"
            case _ => "isNone(p_${field.jsonName})"
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
func genCodeMessageFieldClear2(fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("    protected func m_clear(): Unit {\n")

    /* normal fields */
    for (field in fields where !field.hasOneofIndex) {
        append("        ${getFieldClearExpr2(field)}\n")
    }

    /* oneof fields */
    for ((name, _) in helper.oneofDecl) {
        append("        m_assign(p_${name}); p_${name} = None\n")
    }

    append("    }\n")
}

/* message m_isEmpty */
func genCodeMessageFieldEquat2(typeName: String, fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper) {
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
            case field.type_ == TYPE_STRING || field.type_ == TYPE_MESSAGE => "p_${field.jsonName}.data == src.p_${field.jsonName}.data"
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
func genCodeMessageFieldCopyFrom2(typeName: String, fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
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
            append("        ${pName}.copyFrom(this, src.${pName}.data)\n")
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

/* message unpack */
func genCodeMessageFieldUnpack2(typeName: String, fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("    public func unpack<T>(src: T): Unit where T <: BytesReader {\n")
    append("        while (!src.isEmpty()) {\n")
    append("            let i_tmp = src.parseTag()\n")
    append("            match (i_tmp[0]) {\n")

    for (field in fields where !field.hasOneofIndex) {
        append("                case ${field.number} => ${getFieldUnpackExpr2(field)}\n")
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

/* message check */
func genCodeMessageFieldCheck2(fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("    public func check(): Unit /* throws RequiredFieldNotSetException */ {\n")

    for (field in fields where !field.hasOneofIndex && field.label == LABEL_REQUIRED && field.hasDefaultValue == false) {
        let empty = if (field.type_ == TYPE_STRING || field.type_ == TYPE_MESSAGE) {
            "isNone(p_${field.jsonName}.data)"
        } else {
            "isNone(p_${field.jsonName})"
        }
        append("        if (${empty}) { throw RequiredFieldNotSetException(\"${field.jsonName}\") }\n")
    }

    append("    }\n")
}

/* message pack */
func genCodeMessageFieldPack2(fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("    public func pack<T>(out: T): Unit where T <: BytesWriter {\n")
    append("        check()\n")

    for (field in fields where !field.hasOneofIndex) {
        if (field.label == LABEL_REPEATED) {
            append("        if (!${getMessagePropName(field.jsonName)}.isEmpty()) { ${getFieldPackExpr(field)} }\n")
        } else {
            append("        if (${getFieldNoEmptyExpr2(field)}) { ${namedPack("i_vtmp", field)} }\n")
        }
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
func genCodeMessageFieldToString2(fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    append("\n")
    append("    public func toString(): String {\n")
    append("        var i_tmp = StructPrinter()\n")

    for (field in fields where !field.hasOneofIndex) {
        if (field.label == LABEL_REPEATED) {
            let name = getMessagePropName(field.jsonName)
            append("        if (!${name}.isEmpty()) { i_tmp.append(\"${field.jsonName}\", ${name}) }\n")
        } else if (field.type_ == TYPE_STRING) {
            append("        if (isPresent(p_${field.jsonName}.data)) { i_tmp.append(\"${field.jsonName}\", p_${field.jsonName}.get()) }\n")
        } else {
            append("        if (${getFieldNoEmptyExpr2(field)}) { i_tmp.append(\"${field.jsonName}\", i_vtmp) }\n")
        }
    }

    for ((name, ofields) in helper.oneofDecl) {
        append("        if (!p_${name}.isEmpty()) { i_tmp.append(p_${name}.which(), p_${name}) }\n")
    }

    append("        return i_tmp.done().toString()\n")
    append("    }\n\n")
}

/* gen proto2 message codes */
func genCodeMessageField2(typeName: String, fields: RepeatedMessage<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    // class and member variable define
    genCodeMessageFieldClass2(typeName, fields, helper)

    // init define
    genCodeMessageFieldInit2(fields, helper)

    // props define
    genCodeMessageFieldProps2(typeName, fields, helper)

    // func m_size
    genCodeMessageFieldSize2(fields, helper)

    // func m_hashCode
    genCodeMessageFieldHash2(fields, helper)

    // func m_isEmpty
    genCodeMessageFieldIsEmpty2(fields, helper)

    // func m_clear
    genCodeMessageFieldClear2(fields, helper)

    // operator == !=
    genCodeMessageFieldEquat2(typeName, fields, helper)

    // func copyFrom
    genCodeMessageFieldCopyFrom2(typeName, fields, helper)

    // func clone
    genCodeMessageFieldClone(typeName, helper)

    // func unpack
    genCodeMessageFieldUnpack2(typeName, fields, helper)

    // func check
    genCodeMessageFieldCheck2(fields, helper)

    // func pack
    genCodeMessageFieldPack2(fields, helper)

    // func toString
    genCodeMessageFieldToString2(fields, helper)

    // impl interface
    append(getImplIterfaceApi(typeName))

    // end
    append("}\n")
}