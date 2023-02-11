/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

package protobuf

from std import collection.*

public type Tag = UInt32
public type WireNum = UInt8
public type Bytes = Array<Byte>
public type BytesSlice = RoArray<Byte>

/* ffi, typecast by bits */
foreign func itof(v: UInt32): Float32
foreign func ltod(v: UInt64): Float64
foreign func ftoi(v: Float32): UInt32
foreign func dtol(v: Float64): UInt64

public let VARINT: WireNum = 0
public let BIT64: WireNum = 1
public let PREFIXED: WireNum = 2
public let BIT32: WireNum = 5

/* protobuf wire type define. */
public class WireType <: ToString {
    private WireType(public let value: WireNum, private let name: String) { }
    public func toString() { name }

    public static func parse(val: WireNum): WireType {
        match (val) {
            case 0 => VARINT
            case 1 => BIT64
            case 2 => PREFIXED
            case 5 => BIT32
            case v => throw ParseValueExecption("WireType")
        }
    }

    public static let VARINT = WireType(VARINT, "VARINT")
    public static let BIT64 = WireType(BIT64, "BIT64")
    public static let PREFIXED = WireType(PREFIXED, "PREFIXED")
    public static let BIT32 = WireType(BIT32, "BIT32")
}

/* packed size of tag. */
public func tagSize(tag: Tag) {
    if (tag < (1 << 4)) { return 1 }
    if (tag < (1 << 11)) { return 2 }
    if (tag < (1 << 18)) { return 3 }
    if (tag < (1 << 25)) { return 4 }
    return 5
}

/* packed size by varint encoding. */
public func varintSize(val: UInt64) {
    if (val < (1 << 7)) { return 1 }
    if (val < (1 << 14)) { return 2 }
    if (val < (1 << 21)) { return 3 }
    if (val < (1 << 28)) { return 4 }
    if (val < (1 << 35)) { return 5 }
    if (val < (1 << 42)) { return 6 }
    if (val < (1 << 49)) { return 7 }
    if (val < (1 << 56)) { return 8 }
    if (val < (1 << 63)) { return 9 }
    return 10
}

/* packed size by varint encoding. */
@overflowWrapping
public func varintSize(val: Int64) {
    if (val < 0) { return 10 }
    if (val < (1 << 7)) { return 1 }
    if (val < (1 << 14)) { return 2 }
    if (val < (1 << 21)) { return 3 }
    if (val < (1 << 28)) { return 4 }
    if (val < (1 << 35)) { return 5 }
    if (val < (1 << 42)) { return 6 }
    if (val < (1 << 49)) { return 7 }
    if (val < (1 << 56)) { return 8 }
    return 9
}

/* packed size by varint encoding. */
@overflowWrapping
public func varintSize(val: UInt32) {
    if (val < (1 << 7)) { return 1 }
    if (val < (1 << 14)) { return 2 }
    if (val < (1 << 21)) { return 3 }
    if (val < (1 << 28)) { return 4 }
	return 5
}

/* packed size by varint encoding. */
@overflowWrapping
public func varintSize(val: Int32) {
    if (val < 0) { return 10 }
    if (val < (1 << 7)) { return 1 }
    if (val < (1 << 14)) { return 2 }
    if (val < (1 << 21)) { return 3 }
    if (val < (1 << 28)) { return 4 }
    return 5
}

/* the zigzag-encoded 64-bit unsigned integer form of a 64-bit signed integer. */
@overflowWrapping
public func zigzag(val: Int64) {
    (UInt64(val) << 1) ^ UInt64(val >> 63)
}

/* the zigzag-encoded 32-bit unsigned integer form of a 32-bit signed integer. */
@overflowWrapping
public func zigzag(val: Int32) {
    (UInt32(val) << 1) ^ UInt32(val >> 31)
}

/* unzigzag a zigzag-encoded 64-bit unsigned integer to a 64-bit signed integer. */
@overflowWrapping
public func unzigzag(val: UInt64) {
    Int64((val >> 1) ^ -(val & 1))
}

/* unzigzag a zigzag-encoded 32-bit unsigned integer to a 32-bit signed integer. */
@overflowWrapping
public func unzigzag(val: UInt32) {
    Int32((val >> 1) ^ -(val & 1))
}

/* packed size of sint64. */
public func sintSize(val: Int64) {
    varintSize(zigzag(val))
}

/* packed size of sint32. */
public func sintSize(val: Int32) {
    varintSize(zigzag(val))
}

@overflowWrapping
public func binSize(val: BytesSlice) {
    let size = val.size
    varintSize(size) + size
}

@overflowWrapping
public func binSize(val: String) {
    let size = val.utf8View.size
    varintSize(size) + size
}

@overflowWrapping
public func binSize<M>(val: M) where M <: Message {
    let size = val.size
    varintSize(size) + size
}

public interface Int32Enum <: ToString & ToJson {
    func value(): Int32
    func toJson(): Json { toString() }
}

public interface Enum<E> <: Int32Enum & Equatable<E> where E <: Enum<E> {
    operator func==(e: E): Bool
    operator func!=(e: E) { !(this == e) }

    static func parse(v: Int32): E
    static func parse(v: String): E
}

public interface Message <: ToString {
    prop let size: Int64
    func isEmpty(): Bool
    func clear(): Unit
    func clone(): Message

    /* abstract generic function is not allowed in interface */
    /* func unpack<T>(src: T): Unit where T <: BytesReader */
    /* func pack<T>(out: T): Unit where T <: BytesWriter */

    func unpacki(src: BytesReader): Unit
    func packi(out: BytesWriter): Unit

    /* unpack from collection. */
    func unpack(src: Collection<Byte>): Unit {
        unpacki(SimpleReader(src))
    }

    /* unpack from bytes slice */
    func unpack(src: BytesSlice): Unit {
        unpacki(SimpleReader(src))
    }

    /* pack message to bytes */
    func pack(): Bytes {
        let out = SimpleWriter(size)
        packi(out)
        out.data
    }
}

public interface TypedMessage<M> where M <: Message {
    func clone(): M
    static func empty(): M
    static func fromBytes(src: Collection<Byte>): M
    static func fromBytes(src: BytesReader): M
}

public interface AddMessage<M> {
    func add(): M
}

extend ArrayList<M> <: AddMessage<M> where M <: TypedMessage<M> {
    public func add(): M { let m = M.empty(); this.append(m); m }
}