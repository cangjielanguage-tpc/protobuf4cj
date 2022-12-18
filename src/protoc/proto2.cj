// gencode for proto2

package protoc

/* field variable define */
func getFieldVarDefine2(field: FieldDescriptorProto) {
    if (field.label == LABEL_REPEATED) {
        return getFieldVarDefine(field)
    }

    "private var m_${field.jsonName}: ?${typeConvert(field)} = None"
}

/* field is not empty expr */
func getFieldNoEmptyExpr2(field: FieldDescriptorProto) {
    if (field.label == LABEL_REPEATED) {
        return "!${getMessagePropName(field.jsonName)}.isEmpty()"
    }

    "let Some(i_vtmp) = m_${field.jsonName}"
}

/* field clear expr */
func getFieldClearExpr2(field: FieldDescriptorProto) {
    if (field.label == LABEL_REPEATED) {
        return "${getMessagePropName(field.jsonName)}.clear()"
    }

    "m_${field.jsonName} = None"
}

/* field clone expr */
func getFieldCloneExpr2(field: FieldDescriptorProto) {
    if (field.label == LABEL_REPEATED) {
        return getFieldCloneExpr(field)
    }

    "m_${field.jsonName} = m_${field.jsonName}" + match (field.type_) {
        case TYPE_MESSAGE | TYPE_BYTES => "?.clone()"
        case _ => ""
    }
}

/* field size expr */
func getFieldSizeExpr2(field: FieldDescriptorProto) {
    if (field.label == LABEL_REPEATED) {
        return getFieldSizeExpr(field)
    }

    "i_tmp += ${tagSize(UInt32(field.number))} + " + namedSize("i_vtmp", field)
}

/* field pack expr */
func getFieldPackExpr2(field: FieldDescriptorProto) {
    if (field.label == LABEL_REPEATED) {
        return getFieldPackExpr(field)
    }

    namedPack("i_vtmp", field)
}

/* field unpack expr */
func getFieldUnpackExpr2(field: FieldDescriptorProto) {
    if (field.label == LABEL_REPEATED) {
        return getFieldUnpackExpr(field)
    }

    namedParseSrc(match (field.type_) {
        case TYPE_MESSAGE => "m_${field.jsonName} = m_${field.jsonName} ?? ${field.typeName}(); m_${field.jsonName}?"
        case _ => if (field.hasDefaultValue) { getMessagePropName(field.jsonName) } else { "m_${field.jsonName}" }
    }, "src", field)
}

/* field to string expr */
func getFieldToStringExpr2(field: FieldDescriptorProto) {
    if (field.label == LABEL_REPEATED) {
        return getMessagePropName(field.jsonName)
    }

    "i_vtmp"
}

/* normal field prop var expr */
func getFieldPropVarExpr2(field: FieldDescriptorProto) {
    if (!field.hasDefaultValue) {
        return "get() { m_${field.jsonName}.getOrThrow() } set(i_tmp) { m_${field.jsonName} = i_tmp }"
    }

    match (field.type_) {
        case TYPE_DOUBLE | TYPE_FLOAT => if (!field.defaultValue.contains('.')) { field.defaultValue = if (field.defaultValue[0] == '-') { "-.${field.defaultValue.substring(1)}" } else { ".${field.defaultValue}" } }
        case TYPE_STRING => field.defaultValue = "\"${field.defaultValue}\""
        case TYPE_BYTES => throw Exception("NOT SUPPORT BYTES DEFAULT VALUE")
        case _=> ()
    }

    "get() { m_${field.jsonName} ?? ${field.defaultValue} } set(i_tmp) { m_${field.jsonName} = if (i_tmp == ${field.defaultValue}) { None } else { i_tmp } }"
}

/* gen proto2 message codes */
func genCodeMessageField2(typeName: String, fields: ArrayList<FieldDescriptorProto>, helper: GenCodeHelper): Unit {
    let append: (String) -> StringBuilder = helper.outbuf.append

    // class define
    append("\npublic class ${typeName} <: Message & TypedMessage<${typeName}> {\n")

    // var define
    for (field in fields where !field.hasOneofIndex) { append("    ${getFieldVarDefine2(field)}\n") }
    for ((name, _) in helper.oneofDecl) { append("    public var ${getMessagePropName(name)} = ${typeName}_Oneof_${titleCase(name)}.None\n") }

    // unknown fields
    append("    public var unknownFields = ArrayList<MessageUnknownField>()\n")

    // normal field props
    for (field in fields where field.label != LABEL_REPEATED && !field.hasOneofIndex) {
        append("\n    public func clear${upperCamelCase(field.jsonName)}() { m_${field.jsonName} = None }")
        append("\n    public prop let has${upperCamelCase(field.jsonName)}: Bool { get() { match (m_${field.jsonName}) { case None => false case _ => true } } }")
        append("\n    public prop var ${getMessagePropName(field.jsonName)}: ${typeConvert(field)} { ${getFieldPropVarExpr2(field)} }\n")
    }

    // oneof field props
    for ((name, ofields) in helper.oneofDecl) {
        append("\n    /* oneof ${name} */\n")
        for (field in ofields) { append("    public prop var ${getMessagePropName(field.jsonName)}: ${typeConvert(field)} { get() { match (${getMessagePropName(name)}) { case ${titleCase(field.jsonName)}(i_vtmp) => i_vtmp case _ => throw UnexpectedOneofException() } } set(i_vtmp) { ${getMessagePropName(name)} = ${titleCase(field.jsonName)}(i_vtmp) } }\n") }
    }

    // prop size
    append("\n    public prop let size: Int64 { get() {\n        var i_tmp = 0\n")
    for (field in fields where !field.hasOneofIndex) { append("        if (${getFieldNoEmptyExpr2(field)}) { ${getFieldSizeExpr2(field)} }\n") }
    for ((name, ofields) in helper.oneofDecl) {
        append("        match (${getMessagePropName(name)}) {\n")
        for (field in ofields) { append("            case ${titleCase(field.jsonName)}(i_vtmp) => i_tmp += ${tagSize(UInt32(field.number))} + ${namedSize("i_vtmp", field)}\n") }
        append("            case _ => ()\n        }\n")
    }
    append("        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }\n        return i_tmp\n    } }\n")

    // func isEmpty
    append("\n    public func isEmpty(): Bool {\n")
    for (field in fields where !field.hasOneofIndex) { append("        if (${getFieldNoEmptyExpr2(field)}) { return false }\n") }
    for ((name, ofields) in helper.oneofDecl) {
        append("        match (${getMessagePropName(name)}) {\n")
        for (field in ofields) { append("            case ${titleCase(field.jsonName)}(i_vtmp) => return false\n") }
        append("            case _ => ()\n        }\n")
    }
    append("        if (!unknownFields.isEmpty()) { return false }\n        return true\n    }\n")

    // func clear
    append("\n    public func clear(): Unit {\n")
    for (field in fields where !field.hasOneofIndex) { append("        ${getFieldClearExpr2(field)}\n") }
    for ((name, _) in helper.oneofDecl) { append("        ${getMessagePropName(name)} = None\n") }
    append("        unknownFields.clear()\n    }\n")

    // func clone
    append("\n    public func clone(): ${typeName} {\n        let i_tmp = ${typeName}()\n")
    for (field in fields where !field.hasOneofIndex) { append("        i_tmp.${getFieldCloneExpr2(field)}\n") }
    for ((name, _) in helper.oneofDecl) { append("        i_tmp.${getMessagePropName(name)} = ${getMessagePropName(name)}.clone()\n") }
    append("        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }\n        return i_tmp\n    }\n")

    // func unpack
    append("\n    public func unpack<T>(src: T): Unit where T <: BytesReader & SubReader<T> {\n        while (!src.isEmpty()) {\n            let i_tmp = src.parseTag()\n            match (i_tmp[0]) {\n")
    for (field in fields where !field.hasOneofIndex) { append("                case ${field.number} => ${getFieldUnpackExpr2(field)}\n") }
    for ((name, ofields) in helper.oneofDecl) { for (field in ofields) { append("                case ${field.number} => ${getOneofFieldUnapckExpr(name, field)}\n") } }
    append("                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))\n            }\n        }\n    }\n")

    // func pack
    append("\n    public func pack<T>(out: T): Unit where T <: BytesWriter {\n        check()\n")
    for (field in fields where !field.hasOneofIndex) { append("        if (${getFieldNoEmptyExpr2(field)}) { ${getFieldPackExpr2(field)} }\n") }
    for ((name, ofields) in helper.oneofDecl) {
        append("        match (${getMessagePropName(name)}) {\n")
        for (field in ofields) { append("            case ${titleCase(field.jsonName)}(i_vtmp) => ${namedPack("i_vtmp", field)}\n") }
        append("            case _ => ()\n        }\n")
    }
    append("        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }\n    }\n")

    // func check
    append("\n    public func check(): Unit /* throws RequiredFieldNotSetException */ {\n")
    for (field in fields where !field.hasDefaultValue && field.label == LABEL_REQUIRED) { append("        match (m_${field.jsonName}) { case None => throw RequiredFieldNotSetException(\"${field.jsonName}\") case _ => () }\n") }
    append("    }\n")

    // func toString
    append("\n    public func toString(): String {\n        var i_tmp = StructPrinter()\n")
    for (field in fields where !field.hasOneofIndex) { append("        if (${getFieldNoEmptyExpr2(field)}) { i_tmp.append(\"${field.jsonName}\", ${getFieldToStringExpr2(field)}) }\n") }
    for ((name, ofields) in helper.oneofDecl) {
        append("        match (${getMessagePropName(name)}) {\n")
        for (field in ofields) { append("            case ${titleCase(field.jsonName)}(i_vtmp) => i_tmp.append(\"${field.jsonName}\", i_vtmp)\n") }
        append("            case _ => ()\n        }\n")
    }
    append("        if (!unknownFields.isEmpty()) { i_tmp.append(\"unknownFields\", unknownFields) }\n        return i_tmp.done().toString()\n    }\n\n")

    // impl interface
    append(getImplIterfaceApi(typeName))

    // end
    append("}\n")
}