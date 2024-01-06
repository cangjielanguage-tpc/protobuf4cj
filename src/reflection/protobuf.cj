package reflection

/* alias */
public type Type = FieldDescriptor_Type
public type Label = FieldDescriptor_Label

extend Type {
    public func defaultValue(): Field {
        match (this) {
            case DOUBLE => .0
            case FLOAT => Float32(.0)
            case INT64 | SFIXED64 | SINT64 => Int64(0)
            case INT32 | SFIXED32 | SINT32 => Int32(0)
            case UINT64 | FIXED64 => UInt64(0)
            case UINT32 | FIXED32 => UInt32(0)
            case BOOL => false
            case STRING => ""
            case BYTES => BytesSlice()
            case _ => throw InvalidArgumentException()
        }
    }

    public func parseValue(src: BytesReader): Field {
        match (this) {
            case BOOL => src.parseBool()
            case DOUBLE => src.parseFloat64()
            case FIXED64 => src.parseFixed64()
            case SFIXED64 => src.parseSFixed32()
            case FLOAT => src.parseFloat32()
            case FIXED32 => src.parseFixed32()
            case SFIXED32 => src.parseSFixed32()
            case BYTES => src.parseBytesSlice()
            case STRING => src.parseString()
            case SINT64 => src.parseSInt64()
            case SINT32 => src.parseSInt32()
            case UINT64 => src.parseUInt64()
            case UINT32 => src.parseUInt32()
            case INT64 => src.parseInt64()
            case INT32 => src.parseInt32()
            case _ => throw InvalidArgumentException()
        }
    }

    public func wireNum(): WireNum {
        match (this) {
            case BOOL => VARINT
            case DOUBLE => BIT64
            case FIXED64 => BIT64
            case SFIXED64 => BIT64
            case FLOAT => BIT32
            case FIXED32 => BIT32
            case SFIXED32 => BIT32
            case BYTES => PREFIXED
            case STRING => PREFIXED
            case MESSAGE => PREFIXED
            case SINT64 => VARINT
            case SINT32 => VARINT
            case ENUM => VARINT
            case UINT64 => VARINT
            case UINT32 => VARINT
            case INT64 => VARINT
            case INT32 => VARINT
            case _ => throw InvalidArgumentException()
        }
    }
}

public func isDefaultValue(val: Field): Bool {
    match (val) {
        case v: Float64 => v == .0
        case v: Float32 => v == .0
        case v: Int64 => v == 0
        case v: UInt64 => v == 0
        case v: Int32 => v == 0
        case v: UInt32 => v == 0
        case v: Bool => !v
        case v: EnumValue => v.value() == 0
        case v: String => v.isEmpty()
        case v: Message => v.isEmpty()
        case v: BytesSlice => v.isEmpty()
        case v: Repeated => v.isEmpty()
        case _ => throw InvalidArgumentException()
    }
}

public func clearToDefaultValue(val: Field): ?Field {
    match (val) {
        case v: Repeated => v.clear()
        case v: Message => v.clear()
        case v: Float64 => if (v != .0) { return .0 }
        case v: Float32 => if (v != .0) { return Float32(.0) }
        case v: Int64 => if (v != 0) { return Int64(0) }
        case v: UInt64 => if (v != 0) { return UInt64(0) }
        case v: Int32 => if (v != 0) { return Int32(0) }
        case v: UInt32 => if (v != 0) { return UInt32(0) }
        case v: Bool => if (v) { return false }
        case v: String => if (!v.isEmpty()) { return "" }
        case v: BytesSlice => if (!v.isEmpty()) { return BytesSlice() }
        case v: EnumValue => if (v.value() != 0) { return Prototype.createEnum(v.getTypeDescriptor()) }
        case _ => throw InvalidArgumentException()
    }

    return None
}

/* compares non-repeated fileds. */
public func equalsTo(left: Field, right: Field): Bool {
    match ((left, right)) {
        case (a: Float64, b: Float64) => a == b
        case (a: Float32, b: Float32) => a == b
        case (a: Int64, b: Int64) => a == b
        case (a: UInt64, b: UInt64) => a == b
        case (a: Int32, b: Int32) => a == b
        case (a: UInt32, b: UInt32) => a == b
        case (a: Bool, b: Bool) => a == b
        case (a: EnumValue, b: EnumValue) => a == b
        case (a: String, b: String) => a == b
        case (a: Message, b: Message) => a == b
        case (a: BytesSlice, b: BytesSlice) => a == b
        case _ => false
    }
}

/* compares repeated fileds. */
public func equalsTo(field: FieldDescriptor, left: Repeated, right: Repeated): Bool {
    if (left.size != right.size) {
        return false
    }

    if (field.isMap()) {
        let that = getMapHandle(field, right)
        for ((k, v) in getMapHandle(field, left).getIterator()) {
            equalsTo(k, that.getItem(k) ?? return false)
        }

        return true
    }

    let ai = getRepeatedHandle(field, left).getIterator()
    let bi = getRepeatedHandle(field, right).getIterator()
    while (match ((ai.next(), bi.next())) {
        case (None, None) => return true
        case (Some(a), Some(b)) => equalsTo(a, b)
        case _ => false
    }) { }

    return false
}

public func packSize(type_: Type, val: Field): Int64 {
    match (type_) {
        case BOOL => 1
        case DOUBLE | FIXED64 | SFIXED64 => 8
        case FIXED32 | SFIXED32 | FLOAT => 4
        case BYTES => binSize(typecast<BytesSlice>(val))
        case STRING => binSize(typecast<String>(val))
        case MESSAGE => binSize(typecast<Message>(val))
        case SINT64 => sintSize(typecast<Int64>(val))
        case SINT32 => sintSize(typecast<Int32>(val))
        case ENUM => varintSize(typecast<EnumValue>(val))
        case UINT64 => varintSize(typecast<UInt64>(val))
        case UINT32 => varintSize(typecast<UInt32>(val))
        case INT64 => varintSize(typecast<Int64>(val))
        case INT32 => varintSize(typecast<Int32>(val))
        case _ => throw InvalidArgumentException()
    }
}

public func packSizeOfPacked(type_: Type, val: RepeatedHandle): Int64 {
    match (type_) {
        case BOOL => val.size
        case DOUBLE | FIXED64 | SFIXED64 => val.size * 8
        case FIXED32 | SFIXED32 | FLOAT => val.size * 4
        case _ =>
            var size = 0
            for (v in val.getIterator()) {
                size += packSize(type_, v)
            }
            size
    }
}

public func packSizeWithTag(field: FieldDescriptor, val: Field): Int64 {
    /* map field */
    if (let Some((keyType, valType, _)) <- field.getMapEntry()) {
        var size = 0
        for ((k, v) in getMapHandle(field, val).getIterator()) {
            var pairSize = 0
            if (!isDefaultValue(k)) {
                pairSize += 1 + packSize(keyType, k)
            }
            if (!isDefaultValue(v)) {
                pairSize += 1 + packSize(valType, v)
            }
            size += tagSize(field.tag) + varintSize(pairSize) + pairSize
        }
        return size
    }

    /* packed repeated fields */
    if (field.isPacked()) {
        var size = packSizeOfPacked(field.type_, getRepeatedHandle(field, val))
        return tagSize(field.tag) + varintSize(size) + size
    }

    /* repeated fields */
    if (field.isRepeated()) {
        var size = 0
        for (v in getRepeatedHandle(field, val).getIterator()) {
            size += tagSize(field.tag) + packSize(field.type_, v)
        }
        return size
    }

    /* normal fields */
    return tagSize(field.tag) + packSize(field.type_, val)
}

public func packOut(type_: Type, val: Field, out: BytesWriter): Unit {
    match (type_) {
        case BOOL => out.packBool(typecast<Bool>(val))
        case DOUBLE => out.packFixed(typecast<Float64>(val))
        case FIXED64 => out.packFixed(typecast<UInt64>(val))
        case SFIXED64 => out.packFixed(typecast<Int64>(val))
        case FLOAT => out.packFixed(typecast<Float32>(val))
        case FIXED32 => out.packFixed(typecast<UInt32>(val))
        case SFIXED32 => out.packFixed(typecast<Int32>(val))
        case BYTES => out.packBin(typecast<BytesSlice>(val))
        case STRING => out.packBin(typecast<String>(val))
        case MESSAGE => out.packBin(typecast<Message>(val))
        case SINT64 => out.packSInt(typecast<Int64>(val))
        case SINT32 => out.packSInt(typecast<Int32>(val))
        case ENUM => out.packVarint(typecast<EnumValue>(val))
        case UINT64 => out.packVarint(typecast<UInt64>(val))
        case UINT32 => out.packVarint(typecast<UInt32>(val))
        case INT64 => out.packVarint(typecast<Int64>(val))
        case INT32 => out.packVarint(typecast<Int32>(val))
        case _ => throw InvalidArgumentException()
    }
}

public func packOutWithTag(field: FieldDescriptor, val: Field, out: BytesWriter): Unit {
    /* map field */
    if (let Some((keyType, valType, _)) <- field.getMapEntry()) {
        for ((k, v) in getMapHandle(field, val).getIterator()) {
            var pairSize = 0
            if (!isDefaultValue(k)) {
                pairSize += 1 + packSize(keyType, k)
            }
            if (!isDefaultValue(v)) {
                pairSize += 1 + packSize(valType, v)
            }
            out.packTag(field.tag, field.type_.wireNum())
            out.packVarint(pairSize)
            if (!isDefaultValue(k)) {
                out.packTag(1, keyType.wireNum())
                packOut(keyType, k, out)
            }
            if (!isDefaultValue(v)) {
                out.packTag(2, valType.wireNum())
                packOut(valType, v, out)
            }
        }
        return
    }

    /* packed repeated fields */
    if (field.isPacked()) {
        let repeat = getRepeatedHandle(field, val)
        out.packTag(field.tag, PREFIXED)
        out.packVarint(packSizeOfPacked(field.type_, repeat))
        for (v in repeat.getIterator()) {
            packOut(field.type_, v, out)
        }
        return
    }

    /* repeated fields */
    if (field.isRepeated()) {
        let wireNum = field.type_.wireNum()
        for (v in getRepeatedHandle(field, val).getIterator()) {
            out.packTag(field.tag, wireNum)
            packOut(field.type_, v, out)
        }
        return
    }

    /* normal fields */
    out.packTag(field.tag, field.type_.wireNum())
    packOut(field.type_, val, out)
}

public func defaultValue(type_: FieldDescriptor_Type, typeName: String): Field {
    match (type_) {
        case ENUM => Prototype.createEnum(DescriptorPool.getEnumDescriptor(typeName).getOrThrow())
        case MESSAGE => Prototype.createMessage(typeName)
        case type_ => type_.defaultValue()
    }
}

public func parseValue(type_: FieldDescriptor_Type, typeName: String, src: BytesReader): Field {
    match (type_) {
        case ENUM => Prototype.createEnum(typeName, src.parseInt32())
        case MESSAGE => let msg = Prototype.createMessage(typeName); msg.unpacki(subReader(src)); msg
        case type_ => type_.parseValue(src)
    }
}

public func parseValue(field: FieldDescriptor, reflection: Reflection, src: BytesReader, wireNum: WireNum): Unit {
    /* map field */
    if (let Some((keyType, valType, typeName)) <- field.getMapEntry()) {
        let map = reflection.getMapHandle(field)
        let sub = subReader(src)
        if (sub.isEmpty()) {
            return map.setItem(keyType.defaultValue(), defaultValue(valType, typeName))
        }

        let tag = sub.parseTag()[0]
        let key = if (tag == 1) { keyType.parseValue(sub) } else { keyType.defaultValue() }
        let val = match {
            case tag == 2 => parseValue(valType, typeName, sub)      /* key is default, tag 2 has read before */
            case sub.isEmpty() => defaultValue(valType, typeName)    /* val is default */
            case _ => sub.parseTag(); parseValue(valType, typeName, sub)
        }
        return map.setItem(key, val)
    }

    /* packed field */
    if (wireNum == PREFIXED && field.type_.wireNum() != PREFIXED) {
        let repeat = reflection.getRepeatedHandle(field)
        let sub = subReader(src)
        while (!sub.isEmpty()) {
            repeat.addItem(field.type_.parseValue(sub))
        }
        return
    }

    /* repeated field */
    if (field.isRepeated()) {
        return reflection.getRepeatedHandle(field).addItem(parseValue(field.type_, field.typeName, src))
    }

    reflection.setValue(field, parseValue(field.type_, field.typeName, src))
}