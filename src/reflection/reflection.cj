package reflection

public struct Reflection {
    public Reflection(private let message: Message) {
        descriptor = message.getDescriptor()
    }

    private let descriptor: MessageDescriptor

    /* check and set value. throws if failed. */
    public func setValue(field: FieldDescriptor, val: Field): Unit {
        if (field.isRepeated()) {
            throw InvalidOperationException()
        }

        if (!match (field.type_) {
            case DOUBLE => val is Float64
            case FLOAT => val is Float32
            case INT64 | SFIXED64 | SINT64 => val is Int64
            case INT32 | SFIXED32 | SINT32 => val is Int32
            case UINT64 | FIXED64 => val is UInt64
            case UINT32 | FIXED32 => val is UInt32
            case BOOL => val is Bool
            case STRING => val is String
            case BYTES => val is BytesSlice
            case ENUM => typecast<EnumValue>(val).getTypeDescriptor().fullName == field.enumType.getOrThrow().fullName
            case MESSAGE => typecast<Message>(val).getDescriptor().fullName == field.messageType.getOrThrow().fullName
            case _ => false
        }) {
            throw InvalidArgumentException()
        }

        message.m_set(field.tag, val)
    }

    /**
     * returns whether the field is empty.
     * for the repeated field, return whether it is a empty collection.
     * for the proto2 non-repeated field. return whether it is `None`.
     * otherwise return whether it is the default value of its type.
     */
    public func isEmpty(field: FieldDescriptor): Bool { isDefaultValue(message.m_get(field.tag) ?? return true) }

    /**
     * returns whether the field has a set value.
     * return false only if proto2 non-repeated field with `None` value.
     */
    public func hasValue(field: FieldDescriptor): Bool { isPresent(message.m_get(field.tag)) }

    /* repeated field contains index. throws if failed. */
    public func hasIndex(field: FieldDescriptor, index: Int64): Bool { getRepeatedHandle(field).hasItem(index) }
    /* map field contains key. throws if failed. */
    public func hasKey(field: FieldDescriptor, key: Field): Bool { getMapHandle(field).hasItem(key) }

    /* get repeated and map field's items count, returns ITEM_NONREPEATED(-1) if non-repeated, ITEM_NOTEXISTS(-2) if not exists. */
    public static const ITEM_NONREPEATED = -1
    public static const ITEM_NOTEXISTS = -2
    public func getItemCount(field: FieldDescriptor): Int64 {
        match (message.m_get(field.tag)) {
            case Some(val: Repeated) => val.size
            case Some(_) => ITEM_NONREPEATED
            case None => ITEM_NOTEXISTS
        }
    }

    /**
     * clear to default value.
     * for the repeated field, clear to empty.
     * for proto2 non-repeated field. reset to `None`.
     * otherwise reset to the default value of its type.
     */
    public func clearValue(field: FieldDescriptor): Unit { message.m_reset(field.tag) }
    /* remove item from repeated field by index. throws if failed. */
    public func clearIndex(field: FieldDescriptor, index: Int64): Unit { getRepeatedHandle(field).delItem(index) }
    /* remove item from map field by key. throws if failed. */
    public func clearKey(field: FieldDescriptor, key: Field): Unit { getMapHandle(field).delItem(key) }

    /* get field value. throws if failed. */
    public func getValue(field: FieldDescriptor): Field { message.m_get(field.tag).getOrThrow() }
    /* get repeated handle. throws if failed. */
    public func getRepeatedHandle(field: FieldDescriptor): RepeatedHandle { getRepeatedHandle(field, getValue(field)) }
    /* get map handle. throws if failed. */
    public func getMapHandle(field: FieldDescriptor): MapHandle { getMapHandle(field, getValue(field)) }

    /* get non-repeated field. throws if failed. */
    public func getFloat64(field: FieldDescriptor): Float64 { typecast(getValue(field)) }
    public func getFloat32(field: FieldDescriptor): Float32 { typecast(getValue(field)) }
    public func getInt64(field: FieldDescriptor): Int64 { typecast(getValue(field)) }
    public func getInt32(field: FieldDescriptor): Int32 { typecast(getValue(field)) }
    public func getUInt64(field: FieldDescriptor): UInt64 { typecast(getValue(field)) }
    public func getUInt32(field: FieldDescriptor): UInt32 { typecast(getValue(field)) }
    public func getBool(field: FieldDescriptor): Bool { typecast(getValue(field)) }
    public func getString(field: FieldDescriptor): String { typecast(getValue(field)) }
    public func getBytes(field: FieldDescriptor): BytesSlice { typecast(getValue(field)) }
    public func getEnum(field: FieldDescriptor): EnumValue { typecast(getValue(field)) }
    public func getMessage(field: FieldDescriptor): Message { typecast(getValue(field)) }

    /* set non-repeated field. throws if failed. */
    public func setFloat64(field: FieldDescriptor, val: Float64): Unit { setValue(field, val) }
    public func setFloat32(field: FieldDescriptor, val: Float32): Unit { setValue(field, val) }
    public func setInt64(field: FieldDescriptor, val: Int64): Unit { setValue(field, val) }
    public func setInt32(field: FieldDescriptor, val: Int32): Unit { setValue(field, val) }
    public func setUInt64(field: FieldDescriptor, val: UInt64): Unit { setValue(field, val) }
    public func setUInt32(field: FieldDescriptor, val: UInt32): Unit { setValue(field, val) }
    public func setBool(field: FieldDescriptor, val: Bool): Unit { setValue(field, val) }
    public func setString(field: FieldDescriptor, val: String): Unit { setValue(field, val) }
    public func setBytes(field: FieldDescriptor, val: BytesSlice): Unit { setValue(field, val) }
    public func setEnum(field: FieldDescriptor, val: EnumValue): Unit { setValue(field, val) }
    public func setMessage(field: FieldDescriptor, val: Message): Unit { setValue(field, val) }


    /* get repeated field. throws if failed. */
    public func getRepeatedFloat64(field: FieldDescriptor): RepeatedField<Float64> { typecast(getValue(field)) }
    public func getRepeatedFloat32(field: FieldDescriptor): RepeatedField<Float32> { typecast(getValue(field)) }
    public func getRepeatedInt64(field: FieldDescriptor): RepeatedField<Int64> { typecast(getValue(field)) }
    public func getRepeatedInt32(field: FieldDescriptor): RepeatedField<Int32> { typecast(getValue(field)) }
    public func getRepeatedUInt64(field: FieldDescriptor): RepeatedField<UInt64> { typecast(getValue(field)) }
    public func getRepeatedUInt32(field: FieldDescriptor): RepeatedField<UInt32> { typecast(getValue(field)) }
    public func getRepeatedBool(field: FieldDescriptor): RepeatedField<Bool> { typecast(getValue(field)) }
    public func getRepeatedString(field: FieldDescriptor): RepeatedField<String> { typecast(getValue(field)) }
    public func getRepeatedBytes(field: FieldDescriptor): RepeatedField<BytesSlice> { typecast(getValue(field)) }
    public func getRepeatedEnum<E>(field: FieldDescriptor): RepeatedField<E> where E <: EnumValue & TypedEnum<E> { typecast(getValue(field)) }
    public func getRepeatedMessage<M>(field: FieldDescriptor): RepeatedMessage<M> where M <: Message & TypedMessage<M> { typecast(getValue(field)) }

    /* set item to repeated field by index, throws if failed. */
    public func setFloat64(field: FieldDescriptor, index: Int64, val: Float64): Unit { getRepeatedHandle(field).setItem(index, val) }
    public func setFloat32(field: FieldDescriptor, index: Int64, val: Float32): Unit { getRepeatedHandle(field).setItem(index, val) }
    public func setInt64(field: FieldDescriptor, index: Int64, val: Int64): Unit { getRepeatedHandle(field).setItem(index, val) }
    public func setInt32(field: FieldDescriptor, index: Int64, val: Int32): Unit { getRepeatedHandle(field).setItem(index, val) }
    public func setUInt64(field: FieldDescriptor, index: Int64, val: UInt64): Unit { getRepeatedHandle(field).setItem(index, val) }
    public func setUInt32(field: FieldDescriptor, index: Int64, val: UInt32): Unit { getRepeatedHandle(field).setItem(index, val) }
    public func setBool(field: FieldDescriptor, index: Int64, val: Bool): Unit { getRepeatedHandle(field).setItem(index, val) }
    public func setString(field: FieldDescriptor, index: Int64, val: String): Unit { getRepeatedHandle(field).setItem(index, val) }
    public func setBytes(field: FieldDescriptor, index: Int64, val: BytesSlice): Unit { getRepeatedHandle(field).setItem(index, val) }
    public func setEnum(field: FieldDescriptor, index: Int64, val: EnumValue): Unit { getRepeatedHandle(field).setItem(index, val) }
    public func setMessage(field: FieldDescriptor, index: Int64, val: Message): Unit { getRepeatedHandle(field).setItem(index, val) }

    /* add item to repeated field (insert). throws if failed. */
    public func addFloat64(field: FieldDescriptor, index: Int64, val: Float64): Unit { getRepeatedHandle(field).addItem(index, val) }
    public func addFloat32(field: FieldDescriptor, index: Int64, val: Float32): Unit { getRepeatedHandle(field).addItem(index, val) }
    public func addInt64(field: FieldDescriptor, index: Int64, val: Int64): Unit { getRepeatedHandle(field).addItem(index, val) }
    public func addInt32(field: FieldDescriptor, index: Int64, val: Int32): Unit { getRepeatedHandle(field).addItem(index, val) }
    public func addUInt64(field: FieldDescriptor, index: Int64, val: UInt64): Unit { getRepeatedHandle(field).addItem(index, val) }
    public func addUInt32(field: FieldDescriptor, index: Int64, val: UInt32): Unit { getRepeatedHandle(field).addItem(index, val) }
    public func addBool(field: FieldDescriptor, index: Int64, val: Bool): Unit { getRepeatedHandle(field).addItem(index, val) }
    public func addString(field: FieldDescriptor, index: Int64, val: String): Unit { getRepeatedHandle(field).addItem(index, val) }
    public func addBytes(field: FieldDescriptor, index: Int64, val: BytesSlice): Unit { getRepeatedHandle(field).addItem(index, val) }
    public func addEnum(field: FieldDescriptor, index: Int64, val: EnumValue): Unit { getRepeatedHandle(field).addItem(index, val) }
    public func addMessage(field: FieldDescriptor, index: Int64, val: Message): Unit { getRepeatedHandle(field).addItem(index, val) }

    /* add item to repeated field (push_back). throws if failed. */
    public func addFloat64(field: FieldDescriptor, val: Float64): Unit { getRepeatedHandle(field).addItem(val) }
    public func addFloat32(field: FieldDescriptor, val: Float32): Unit { getRepeatedHandle(field).addItem(val) }
    public func addInt64(field: FieldDescriptor, val: Int64): Unit { getRepeatedHandle(field).addItem(val) }
    public func addInt32(field: FieldDescriptor, val: Int32): Unit { getRepeatedHandle(field).addItem(val) }
    public func addUInt64(field: FieldDescriptor, val: UInt64): Unit { getRepeatedHandle(field).addItem(val) }
    public func addUInt32(field: FieldDescriptor, val: UInt32): Unit { getRepeatedHandle(field).addItem(val) }
    public func addBool(field: FieldDescriptor, val: Bool): Unit { getRepeatedHandle(field).addItem(val) }
    public func addString(field: FieldDescriptor, val: String): Unit { getRepeatedHandle(field).addItem(val) }
    public func addBytes(field: FieldDescriptor, val: BytesSlice): Unit { getRepeatedHandle(field).addItem(val) }
    public func addEnum(field: FieldDescriptor, val: EnumValue): Unit { getRepeatedHandle(field).addItem(val) }
    public func addMessage(field: FieldDescriptor, val: Message): Unit { getRepeatedHandle(field).addItem(val) }


    /* get map field. throws if failed. */
    public func getMapField<K, V>(field: FieldDescriptor): MapField<K, V> where K <: Field & Equatable<K>, V <: Field { typecast(getValue(field)) }
    public func getMapMessage<K, M>(field: FieldDescriptor): MapMessage<K, M> where K <: Field & Equatable<K>, M <: Message & TypedMessage<M> { typecast(getValue(field)) }

    /* get item from map field, throws if failed. */
    public func getFloat64(field: FieldDescriptor, key: Field): Float64 { typecast(getMapHandle(field).getItem(key).getOrThrow()) }
    public func getFloat32(field: FieldDescriptor, key: Field): Float32 { typecast(getMapHandle(field).getItem(key).getOrThrow()) }
    public func getInt64(field: FieldDescriptor, key: Field): Int64 { typecast(getMapHandle(field).getItem(key).getOrThrow()) }
    public func getInt32(field: FieldDescriptor, key: Field): Int32 { typecast(getMapHandle(field).getItem(key).getOrThrow()) }
    public func getUInt64(field: FieldDescriptor, key: Field): UInt64 { typecast(getMapHandle(field).getItem(key).getOrThrow()) }
    public func getUInt32(field: FieldDescriptor, key: Field): UInt32 { typecast(getMapHandle(field).getItem(key).getOrThrow()) }
    public func getBool(field: FieldDescriptor, key: Field): Bool { typecast(getMapHandle(field).getItem(key).getOrThrow()) }
    public func getString(field: FieldDescriptor, key: Field): String { typecast(getMapHandle(field).getItem(key).getOrThrow()) }
    public func getBytes(field: FieldDescriptor, key: Field): BytesSlice { typecast(getMapHandle(field).getItem(key).getOrThrow()) }
    public func getEnum(field: FieldDescriptor, key: Field): EnumValue { typecast(getMapHandle(field).getItem(key).getOrThrow()) }
    public func getMessage(field: FieldDescriptor, key: Field): Message { typecast(getMapHandle(field).getItem(key).getOrThrow()) }

    /* put item to map field. throws if failed. */
    public func putFloat64(field: FieldDescriptor, key: Field, val: Float64): Unit { getMapHandle(field).setItem(key, val) }
    public func putFloat32(field: FieldDescriptor, key: Field, val: Float32): Unit { getMapHandle(field).setItem(key, val) }
    public func putInt64(field: FieldDescriptor, key: Field, val: Int64): Unit { getMapHandle(field).setItem(key, val) }
    public func putInt32(field: FieldDescriptor, key: Field, val: Int32): Unit { getMapHandle(field).setItem(key, val) }
    public func putUInt64(field: FieldDescriptor, key: Field, val: UInt64): Unit { getMapHandle(field).setItem(key, val) }
    public func putUInt32(field: FieldDescriptor, key: Field, val: UInt32): Unit { getMapHandle(field).setItem(key, val) }
    public func putBool(field: FieldDescriptor, key: Field, val: Bool): Unit { getMapHandle(field).setItem(key, val) }
    public func putString(field: FieldDescriptor, key: Field, val: String): Unit { getMapHandle(field).setItem(key, val) }
    public func putBytes(field: FieldDescriptor, key: Field, val: BytesSlice): Unit { getMapHandle(field).setItem(key, val) }
    public func putEnum(field: FieldDescriptor, key: Field, val: EnumValue): Unit { getMapHandle(field).setItem(key, val) }
    public func putMessage(field: FieldDescriptor, key: Field, val: Message): Unit { getMapHandle(field).setItem(key, val) }


    /** 
     * get item from repeated field by index.
     * get item from map with `Int64` key-type by index (as key).
     * throws if failed.
     */
    public func getFloat64(field: FieldDescriptor, index: Int64): Float64 { typecast(getValueByIndex(field, index)) }
    public func getFloat32(field: FieldDescriptor, index: Int64): Float32 { typecast(getValueByIndex(field, index)) }
    public func getInt64(field: FieldDescriptor, index: Int64): Int64 { typecast(getValueByIndex(field, index)) }
    public func getInt32(field: FieldDescriptor, index: Int64): Int32 { typecast(getValueByIndex(field, index)) }
    public func getUInt64(field: FieldDescriptor, index: Int64): UInt64 { typecast(getValueByIndex(field, index)) }
    public func getUInt32(field: FieldDescriptor, index: Int64): UInt32 { typecast(getValueByIndex(field, index)) }
    public func getBool(field: FieldDescriptor, index: Int64): Bool { typecast(getValueByIndex(field, index)) }
    public func getString(field: FieldDescriptor, index: Int64): String { typecast(getValueByIndex(field, index)) }
    public func getBytes(field: FieldDescriptor, index: Int64): BytesSlice { typecast(getValueByIndex(field, index)) }
    public func getEnum(field: FieldDescriptor, index: Int64): EnumValue { typecast(getValueByIndex(field, index)) }
    public func getMessage(field: FieldDescriptor, index: Int64): Message { typecast(getValueByIndex(field, index)) }

    /* get item from repeated field by index. throws if failed. */
    private func getValueByIndex(field: FieldDescriptor, index: Int64): Field {
        if (field.isMap()) {
            return getMapHandle(field).getItem(index).getOrThrow()
        }

        return getRepeatedHandle(field).getItem(index).getOrThrow()
    }
}

/* convert field to specific type, throws if failed. */
public func typecast<T>(val: Field): T { val as T ?? throw BadTypecastException() }
/* convert option filed to option type. */
public func trycast<T>(val: ?Field): ?T { if (let Some(v: T) <- val) { v } else { None } }

/* cangjie not support convert Field to RepeatedHandle directly */
public func getRepeatedHandle(field: FieldDescriptor, val: Field): RepeatedHandle { Prototype.typecastRepatedHandle(field, val) }

/* cangjie not support convert Field to MapHandle directly */
public func getMapHandle(field: FieldDescriptor, val: Field): MapHandle { Prototype.typecastMapHandle(field, val) }

/* earse to specific abstract type by interface */
public interface RepeatedHandle <: ToString {
    prop size: Int64
    func getIterator(): Iterator<Field>
    func hasItem(index: Int64): Bool { index >= 0 && index < size }
    func addItem(item: Field): Unit { addItem(size, item) }
    func addItem(index: Int64, item: Field): Unit
    func delItem(index: Int64): Unit
    func setItem(index: Int64, item: Field): Unit
    func getItem(index: Int64): ?Field
}

public interface MapHandle <: ToString {
    prop size: Int64
    func getIterator(): Iterator<(Field, Field)>
    func hasItem(key: Field): Bool
    func delItem(key: Field): Unit
    func setItem(key: Field, item: Field): Unit
    func getItem(key: Field): ?Field
}

extend RepeatedMessage<M> <: RepeatedHandle where M <: Message & TypedMessage<M> {
    public func getIterator() { return this.iterator() |> map<M, Field> { m => m } }
    public func addItem(index: Int64, item: Field): Unit { this.insert(index, typecast<M>(item)) }
    public func delItem(index: Int64): Unit { this.remove(index) }
    public func setItem(index: Int64, item: Field): Unit { this[index] = typecast<M>(item) }
    public func getItem(index: Int64): ?Field { this.get(index) ?? None }
}

extend RepeatedField<T> <: RepeatedHandle where T <: Field {
    public func getIterator() { return this.iterator() |> map<T, Field> { v => v } }
    public func addItem(index: Int64, item: Field): Unit { this.insert(index, typecast<T>(item)) }
    public func delItem(index: Int64): Unit { this.remove(index) }
    public func setItem(index: Int64, item: Field): Unit { this[index] = typecast<T>(item) }
    public func getItem(index: Int64): ?Field { this.get(index) ?? None }
}

extend MapMessage<K, M> <: MapHandle where K <: Field & Equatable<K>, M <: Message & TypedMessage<M> {
    public func getIterator() { return this.iterator() |> map<(K, M), (Field, Field)> { m => m } }
    public func hasItem(key: Field): Bool { return this.contains(typecast<K>(key)) }
    public func delItem(key: Field): Unit { this.remove(typecast<K>(key)) }
    public func setItem(key: Field, item: Field): Unit { this[typecast<K>(key)] = typecast<M>(item) }
    public func getItem(key: Field): ?Field { this.get(typecast<K>(key)) ?? None }
}

extend MapField<K, T> <: MapHandle where K <: Field & Equatable<K>, T <: Field {
    public func getIterator() { return this.iterator() |> map<(K, T), (Field, Field)> { v => v } }
    public func hasItem(key: Field): Bool { return this.contains(typecast<K>(key)) }
    public func delItem(key: Field): Unit { this.remove(typecast<K>(key)) }
    public func setItem(key: Field, item: Field): Unit { this[typecast<K>(key)] = typecast<T>(item) }
    public func getItem(key: Field): ?Field { this.get(typecast<K>(key)) ?? None }
}