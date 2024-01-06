package reflection

public interface EnumValue <: Int32Enum {
    static func descriptor(): EnumDescriptor
    func getTypeDescriptor(): EnumDescriptor { descriptor() }
    func getValueDescriptor(): EnumValueDescriptor {
        for (desc in getTypeDescriptor().values where desc.number == value()) {
            return desc
        }

        throw Exception()
    }

    func getTypeName(): String { getTypeDescriptor().fullName[1 .. ] }
}

/* enum value by reflection dynamic */
public struct DynamicEnum <: EnumValue & TypedEnum<DynamicEnum> {
    public DynamicEnum(
        public let enumType: EnumDescriptor,
        public let enumValue: EnumValueDescriptor
    ) {
        if (enumType.findEnumValueByNumber(enumValue.number).getOrThrow().name != enumValue.name) {
            throw InvalidArgumentException()
        }
    }

    public init(enumType: EnumDescriptor, number: Int32) {
        this.enumType = enumType
        this.enumValue = enumType.findEnumValueByNumber(number).getOrThrow()
    }

    public init(enumType: EnumDescriptor, name: String) {
        this.enumType = enumType
        this.enumValue = enumType.findEnumValueByName(name).getOrThrow()
    }

    public static func descriptor(): EnumDescriptor { throw DescriptorException("dynamic enum no static type descriptor") }
    public func getTypeDescriptor(): EnumDescriptor { enumType }
    public func getValueDescriptor(): EnumValueDescriptor { enumValue }
    public func getTypeName(): String { getTypeDescriptor().fullName[1 .. ] }
    public func value(): Int32 { enumValue.number }
    public func hashCode(): Int64 { Int64(enumValue.number) }
    public func toString(): String { enumValue.name }

    public operator func!=(e: Int32Enum): Bool { !(this == e) }
    public operator func==(e: Int32Enum): Bool { getTypeName() == e.getTypeName() && value() == e.value() }
    public operator func==(that: DynamicEnum): Bool { enumType.fullName == that.enumType.fullName && enumValue.number == that.enumValue.number }

    public static func parse(_: Int32): DynamicEnum { throw ConstructionException("dynamic enum value no static construction") }
    public static func parse(_: String): DynamicEnum { throw ConstructionException("dynamic enum value no static construction") }
}