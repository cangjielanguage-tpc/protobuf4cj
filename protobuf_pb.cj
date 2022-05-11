package protobuf

from std import collection.*

public enum WireType { VARINT | BIT64 | PREFIXED | BIT32 }

extend WireType <: Enum<WireType> {
    public func value(): Int32 {
        match(this) {
            case VARINT => 0
            case BIT64 => 1
            case PREFIXED => 2
            case BIT32 => 5
        }
    }

    public func toString(): String {
        match(this) {
            case VARINT => "VARINT"
            case BIT64 => "BIT64"
            case PREFIXED => "PREFIXED"
            case BIT32 => "BIT32"
        }
    }

    public static func parse(value: Int32): WireType {
        match(value) {
            case 0 => VARINT
            case 1 => BIT64
            case 2 => PREFIXED
            case 5 => BIT32
            case e => throw InvalidEnumValueException("WireType", e)
        }
    }

    /* cangjie 0.28.4 bug, xxx should be implemented */
    public func hashCode() { value().hashCode() }
    public operator func ==(right: WireType) { value() == right.value() }
    public operator func !=(right: WireType) { value() != right.value() }
}

extend WireType <: Default<WireType> {
    public static func default() { VARINT }
}
