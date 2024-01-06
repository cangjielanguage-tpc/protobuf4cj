package reflection

public struct EnumPrototype {
    public EnumPrototype(
        public let newInstance: (Int32) -> EnumValue,
        public let newRepeated: () -> Repeated,
        public let newMapField: (Type) -> Repeated,
        public let toRepeatedHandle: (Field) -> RepeatedHandle,
        public let toMapHandle: (Type, Field) -> MapHandle
    ) {}
}

public struct MessagePrototype {
    public MessagePrototype(
        public let newInstance: () -> Message,
        public let newRepeated: () -> Repeated,
        public let newMapField: (Type) -> Repeated,
        public let toRepeatedHandle: (Field) -> RepeatedHandle,
        public let toMapHandle: (Type, Field) -> MapHandle
    ) {}
}

public class Prototype {
    private static let enumType = HashMap<String, EnumPrototype>()
    private static let messageType = HashMap<String, MessagePrototype>()

    public static func getMessagePrototype(fullName: String): ?MessagePrototype { messageType.get(fullName) }
    public static func getEnumPrototype(fullName: String): ?EnumPrototype { enumType.get(fullName) }

    private static func newMapField<T>(keyType: Type): Repeated where T <: Field {
        match (keyType) {
            case INT64 | SFIXED64 | SINT64 => MapField<Int64, T>()
            case INT32 | SFIXED32 | SINT32 => MapField<Int32, T>()
            case UINT64 | FIXED64 => MapField<UInt64, T>()
            case UINT32 | FIXED32 => MapField<UInt32, T>()
            case BOOL => MapField<Bool, T>()
            case STRING => MapField<String, T>()
            case _ => throw InvalidArgumentException()
        }
    }

    private static func newMapMessage<M>(keyType: Type): Repeated where M <: Message & TypedMessage<M> {
        match (keyType) {
            case INT64 | SFIXED64 | SINT64 => MapMessage<Int64, M>()
            case INT32 | SFIXED32 | SINT32 => MapMessage<Int32, M>()
            case UINT64 | FIXED64 => MapMessage<UInt64, M>()
            case UINT32 | FIXED32 => MapMessage<UInt32, M>()
            case BOOL => MapMessage<Bool, M>()
            case STRING => MapMessage<String, M>()
            case _ => throw InvalidArgumentException()
        }
    }

    private static func toMapField<T>(keyType: Type, field: Field): MapHandle where T <: Field {
        match (keyType) {
            case INT64 | SFIXED64 | SINT64 => typecast<MapField<Int64, T>>(field)
            case INT32 | SFIXED32 | SINT32 => typecast<MapField<Int32, T>>(field)
            case UINT64 | FIXED64 => typecast<MapField<UInt64, T>>(field)
            case UINT32 | FIXED32 => typecast<MapField<UInt32, T>>(field)
            case BOOL => typecast<MapField<Bool, T>>(field)
            case STRING => typecast<MapField<String, T>>(field)
            case _ => throw InvalidArgumentException()
        }
    }

    private static func toMapMessage<M>(keyType: Type, field: Field): MapHandle where M <: Message & TypedMessage<M> {
        match (keyType) {
            case INT64 | SFIXED64 | SINT64 => typecast<MapMessage<Int64, M>>(field)
            case INT32 | SFIXED32 | SINT32 => typecast<MapMessage<Int32, M>>(field)
            case UINT64 | FIXED64 => typecast<MapMessage<UInt64, M>>(field)
            case UINT32 | FIXED32 => typecast<MapMessage<UInt32, M>>(field)
            case BOOL => typecast<MapMessage<Bool, M>>(field)
            case STRING => typecast<MapMessage<String, M>>(field)
            case _ => throw InvalidArgumentException()
        }
    }

    public static func registerEnumPrototype<E>(fullName: String): Unit where E <: EnumValue & TypedEnum<E> {
        enumType[fullName] = EnumPrototype(E.parse, { => RepeatedField<E>() }, newMapField<E>, { f => typecast<RepeatedField<E>>(f) }, toMapField<E>)
    }

    public static func registerMessagePrototype<M>(fullName: String): Unit where M <: Message & TypedMessage<M> {
        messageType[fullName] = MessagePrototype(M.empty, { => RepeatedMessage<M>() }, newMapMessage<M>, { f => typecast<RepeatedMessage<M>>(f) }, toMapMessage<M>)
    }

    public static func createMessage(descriptor: MessageDescriptor): Message {
        getMessagePrototype(descriptor.fullName).getOrThrow().newInstance()
    }

    public static func createMessage(typeName: String): Message {
        getMessagePrototype(typeName).getOrThrow().newInstance()
    }

    public static func createEnum(descriptor: EnumDescriptor, number: Int32): EnumValue {
        getEnumPrototype(descriptor.fullName).getOrThrow().newInstance(number)
    }

    public static func createEnum(typeName: String, number: Int32): EnumValue {
        getEnumPrototype(typeName).getOrThrow().newInstance(number)
    }

    public static func createEnum(descriptor: EnumDescriptor, name: String): EnumValue {
        getEnumPrototype(descriptor.fullName).getOrThrow().newInstance(descriptor.findEnumValueByName(name).getOrThrow().number)
    }

    public static func createEnum(descriptor: EnumDescriptor): EnumValue {
        getEnumPrototype(descriptor.fullName).getOrThrow().newInstance(descriptor.values[0].number)
    }

    public static func createRepeatedFields(descriptor: FieldDescriptor): Repeated {
        if (let Some((keyType, valType, typeName)) <- descriptor.getMapEntry()) {
            return match (valType) {
                case MESSAGE => getMessagePrototype(typeName).getOrThrow().newMapField(keyType)
                case ENUM => getEnumPrototype(typeName).getOrThrow().newMapField(keyType)
                case INT64 | SFIXED64 | SINT64 => newMapField<Int64>(keyType)
                case INT32 | SFIXED32 | SINT32 => newMapField<Int32>(keyType)
                case UINT64 | FIXED64 => newMapField<UInt64>(keyType)
                case UINT32 | FIXED32 => newMapField<UInt32>(keyType)
                case DOUBLE => newMapField<Float64>(keyType)
                case FLOAT => newMapField<Float32>(keyType)
                case BYTES => newMapField<BytesSlice>(keyType)
                case STRING => newMapField<String>(keyType)
                case BOOL => newMapField<Bool>(keyType)
                case _ => throw InvalidArgumentException()
            }
        }

        return match (descriptor.type_) {
            case MESSAGE => getMessagePrototype(descriptor.messageType.getOrThrow().fullName).getOrThrow().newRepeated()
            case ENUM => getEnumPrototype(descriptor.enumType.getOrThrow().fullName).getOrThrow().newRepeated()
            case INT64 | SFIXED64 | SINT64 => RepeatedField<Int64>()
            case INT32 | SFIXED32 | SINT32 => RepeatedField<Int32>()
            case UINT64 | FIXED64 => RepeatedField<UInt64>()
            case UINT32 | FIXED32 => RepeatedField<UInt32>()
            case DOUBLE => RepeatedField<Float64>()
            case FLOAT => RepeatedField<Float32>()
            case BYTES => RepeatedField<BytesSlice>()
            case STRING => RepeatedField<String>()
            case BOOL => RepeatedField<Bool>()
            case _ => throw InvalidArgumentException()
        }
    }

    /* cangjie not support convert Field to RepeatedHandle directly */
    public static func typecastRepatedHandle(descriptor: FieldDescriptor, field: Field): RepeatedHandle {
        match (descriptor.type_) {
            case INT64 | SFIXED64 | SINT64 => typecast<RepeatedField<Int64>>(field)
            case INT32 | SFIXED32 | SINT32 => typecast<RepeatedField<Int32>>(field)
            case UINT64 | FIXED64 => typecast<RepeatedField<UInt64>>(field)
            case UINT32 | FIXED32 => typecast<RepeatedField<UInt32>>(field)
            case BOOL => typecast<RepeatedField<Bool>>(field)
            case STRING => typecast<RepeatedField<String>>(field)
            case BYTES => typecast<RepeatedField<BytesSlice>>(field)
            case DOUBLE => typecast<RepeatedField<Float64>>(field)
            case FLOAT => typecast<RepeatedField<Float32>>(field)
            case ENUM => getEnumPrototype(descriptor.enumType.getOrThrow().fullName).getOrThrow().toRepeatedHandle(field)
            case MESSAGE => getMessagePrototype(descriptor.messageType.getOrThrow().fullName).getOrThrow().toRepeatedHandle(field)
            case _ => throw InvalidArgumentException()
        }
    }

    /* cangjie not support convert Field to MapHandle directly */
    public static func typecastMapHandle(descriptor: FieldDescriptor, field: Field): MapHandle {
        if (let Some((keyType, valType, typeName)) <- descriptor.getMapEntry()) {
            return match (valType) {
                case MESSAGE => getMessagePrototype(typeName).getOrThrow().toMapHandle(keyType, field)
                case ENUM => getEnumPrototype(typeName).getOrThrow().toMapHandle(keyType, field)
                case INT64 | SFIXED64 | SINT64 => toMapField<Int64>(keyType, field)
                case INT32 | SFIXED32 | SINT32 => toMapField<Int32>(keyType, field)
                case UINT64 | FIXED64 => toMapField<UInt64>(keyType, field)
                case UINT32 | FIXED32 => toMapField<UInt32>(keyType, field)
                case DOUBLE => toMapField<Float64>(keyType, field)
                case FLOAT => toMapField<Float32>(keyType, field)
                case BYTES => toMapField<BytesSlice>(keyType, field)
                case STRING => toMapField<String>(keyType, field)
                case BOOL => toMapField<Bool>(keyType, field)
                case _ => throw InvalidArgumentException()
            }
        }

        throw InvalidArgumentException()
    }
}