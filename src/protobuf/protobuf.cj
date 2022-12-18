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
    5
}

/* pack a tag(with wire-type) out. */
@overflowWrapping
public func tagPack<T>(tag: Tag, w: WireType, out: T) where T <: BytesWriter {
    varintPack(tag << 3 | UInt32(w.value), out)
}

/* pack a tag(with wire-type) out. */
@overflowWrapping
public func tagPack<T>(tag: Tag, w: WireNum, out: T) where T <: BytesWriter {
    varintPack(tag << 3 | UInt32(w), out)
}

/* parse a tag(with wire-type) from src. */
@overflowWrapping
public func tagParse<T>(src: T): (Tag, WireNum) where T <: BytesReader {
    var byte = src.read()
    if ((byte & 0xf8) == 0) {
        throw ParseValueExecption("tag", reason: "invalid tag value")
    }

    var tag = UInt32(byte & 0x7f) >> 3
    let wireType = byte & 7
    if ((byte & 0x80) == 0) {
        return (tag, wireType)
    }

    var shift: UInt8 = 4
    for (i in 1..5) {
        byte = src.read()
        if ((byte & 0x80) == 0) {
            tag |= UInt32(byte) << shift
            return (tag, wireType)
        }

        tag |= UInt32(byte & 0x7f) << shift
        shift += 7
    }

    throw ParseValueExecption("tag", reason: "invalid tag value")
}

/* packed size by varint encoding. */
public func varintSize(val: UInt64) {
    if (val > 0x7fff_ffff_ffff_ffff) { return 10 }
    if (val < (1 << 7)) { return 1 } 
    if (val < (1 << 14)) { return 2 }
    if (val < (1 << 21)) { return 3 }
    if (val < (1 << 28)) { return 4 }
    if (val < (1 << 35)) { return 5 }
    if (val < (1 << 42)) { return 6 }
    if (val < (1 << 49)) { return 7 }
    if (val < (1 << 56)) { return 8 }
    9
}

/* packed size by varint encoding. */
@overflowWrapping
public func varintSize(val: Int64) {
    varintSize(UInt64(val))
}

/* packed size by varint encoding. */
@overflowWrapping
public func varintSize(val: UInt32) {
    varintSize(UInt64(val))
}

/* packed size by varint encoding. */
@overflowWrapping
public func varintSize(val: Int32) {
    varintSize(UInt64(val))
}

/* packed size by varint encoding. */
@overflowWrapping
public func varintSize<E>(val: E) where E <: Int32Enum {
    varintSize(UInt64(val.value()))
}

/* pack out by varint encoding. */
@overflowWrapping
public func varintPack<T>(val: UInt64, out: T) where T <: BytesWriter {
    var v = val
    while (v >= 0x80) {
        out.append(UInt8(v | 0x80))
        v >>= 7
    }
    out.append(UInt8(v))
}

/* pack out by varint encoding. */
@overflowWrapping
public func varintPack<T>(val: Int64, out: T) where T <: BytesWriter {
    varintPack<T>(UInt64(val), out)
}

/* pack out by varint encoding. */
@overflowWrapping
public func varintPack<T>(val: UInt32, out: T) where T <: BytesWriter {
    varintPack<T>(UInt64(val), out)
}

/* pack out by varint encoding. */
@overflowWrapping
public func varintPack<T>(val: Int32, out: T) where T <: BytesWriter {
    varintPack<T>(UInt64(val), out)
}

/* pack out by varint encoding. */
@overflowWrapping
public func varintPack<E, T>(val: E, out: T) where E <: Int32Enum, T <: BytesWriter {
    varintPack<T>(UInt64(val.value()), out)
}

/* get varint data from bytes reader */
@overflowWrapping
public func varintData<T>(src: T): Bytes where T <: BytesReader {
    var byte = src.read()
    if (byte < 128) {
        return [byte]
    }

    let data: Bytes = [byte, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    for (i in 1..10) {
        byte = src.read()
        data[i] = byte
        if (byte < 128) {
            return data[.. i + 1]
        }
    }

    throw ParseValueExecption("varint", reason: "invalid value")
}

/* parse uint64 from varint encoded src. */
@overflowWrapping
public func uint64Parse<T>(src: T) where T <: BytesReader {
    var byte = src.read()
    var rv = UInt64(byte & 0x7f)
    if ((byte & 0x80) == 0) {
        return rv
    }

    var shift: UInt8 = 7
    for (i in 1..10) {
        byte = src.read()
        if ((byte & 0x80) == 0) {
            rv |= UInt64(byte) << shift
            return rv
        }
        rv |= UInt64(byte & 0x7f) << shift
        shift += 7
    }

    throw ParseValueExecption("varint", reason: "invalid value")
}

/* parse int64 from varint encoded src. */
@overflowWrapping
public func int64Parse<T>(src: T) where T <: BytesReader {
    Int64(uint64Parse<T>(src))
}

/* parse uint32 from varint encoded src. */
@overflowWrapping
public func uint32Parse<T>(src: T) where T <: BytesReader {
    UInt32(uint64Parse<T>(src))
}

/* parse int32 from varint encoded src. */
@overflowWrapping
public func int32Parse<T>(src: T) where T <: BytesReader {
    Int32(uint64Parse<T>(src))
}

/* parse enum from varint encoded src. */
@overflowWrapping
public func enumParse<E, T>(src: T) where E <: Enum<E>, T <: BytesReader {
    E.parse(Int32(uint64Parse<T>(src)))
}

public func boolPack<T>(val: Bool, out: T) where T <: BytesWriter {
    out.append(if (val) { 1 } else { 0 })
}

public func boolParse<T>(src: T) where T <: BytesReader {
    src.read() != 0
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

/* pack out sint64. */
public func sintPack<T>(val: Int64, out: T) where T <: BytesWriter {
    varintPack<T>(zigzag(val), out)
}

/* pack out sint32. */
public func sintPack<T>(val: Int32, out: T) where T <: BytesWriter {
    varintPack<T>(zigzag(val), out)
}

/* parse sint64. */
@overflowWrapping
public func sint64Parse<T>(src: T) where T <: BytesReader {
    unzigzag((uint64Parse<T>(src)))
}

/* parse sint32. */
@overflowWrapping
public func sint32Parse<T>(src: T) where T <: BytesReader {
    unzigzag((uint32Parse<T>(src)))
}

@overflowWrapping
public func fixedPack(val: UInt64, out: BytesWriter) {
    out.append(UInt8(val))
    out.append(UInt8(val >> 8))
    out.append(UInt8(val >> 16))
    out.append(UInt8(val >> 24))
    out.append(UInt8(val >> 32))
    out.append(UInt8(val >> 40))
    out.append(UInt8(val >> 48))
    out.append(UInt8(val >> 56))
}

@overflowWrapping
public func fixedPack(val: Int64, out: BytesWriter) {
    out.append(UInt8(val))
    out.append(UInt8(val >> 8))
    out.append(UInt8(val >> 16))
    out.append(UInt8(val >> 24))
    out.append(UInt8(val >> 32))
    out.append(UInt8(val >> 40))
    out.append(UInt8(val >> 48))
    out.append(UInt8(val >> 56))
}

@overflowWrapping
public func fixedPack<T>(val: UInt32, out: T) where T <: BytesWriter {
    out.append(UInt8(val))
    out.append(UInt8(val >> 8))
    out.append(UInt8(val >> 16))
    out.append(UInt8(val >> 24))
}

@overflowWrapping
public func fixedPack<T>(val: Int32, out: T) where T <: BytesWriter {
    out.append(UInt8(val))
    out.append(UInt8(val >> 8))
    out.append(UInt8(val >> 16))
    out.append(UInt8(val >> 24))
}

public func fixedPack<T>(val: Float64, out: T) where T <: BytesWriter {
    unsafe { fixedPack(dtol(val), out) }
}

public func fixedPack<T>(val: Float32, out: T) where T <: BytesWriter {
    unsafe { fixedPack(ftoi(val), out) }
}

@overflowWrapping
public func fixed64Parse<T>(src: T) where T <: BytesReader {
    UInt64(src.read()) | (UInt64(src.read()) << 8) | (UInt64(src.read()) << 16) | (UInt64(src.read()) << 24) |
    (UInt64(src.read()) << 32) | (UInt64(src.read()) << 40) | (UInt64(src.read()) << 48) | (UInt64(src.read()) << 56)
}

@overflowWrapping
public func sfixed64Parse<T>(src: T) where T <: BytesReader {
    Int64(fixed64Parse<T>(src))
}

@overflowWrapping
public func fixed32Parse<T>(src: T) where T <: BytesReader {
    UInt32(src.read()) | (UInt32(src.read()) << 8) | (UInt32(src.read()) << 16) | (UInt32(src.read()) << 24)
}

@overflowWrapping
public func sfixed32Parse<T>(src: T) where T <: BytesReader {
    Int32(fixed32Parse<T>(src))
}

public func float64Parse<T>(src: T) where T <: BytesReader {
    unsafe { ltod(fixed64Parse(src)) }
}

public func float32Parse<T>(src: T) where T <: BytesReader {
    unsafe { itof(fixed32Parse(src)) }
}

@overflowWrapping
public func binSize(val: Bytes) {
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

public func binPack<T>(val: Bytes, out: T) where T <: BytesWriter {
    varintPack<T>(val.size, out)
    out.appendBytes(val)
}

public func binPack<T>(val: String, out: T) where T <: BytesWriter {
    let view = val.utf8View
    varintPack<T>(view.size, out)
    out.appendUtf8View(view)
}

public func sub<T>(src: T) where T <: BytesReader & SubReader<T> {
    src.read(int64Parse(src))
}

public func bytesParse<T>(src: T) where T <: BytesReader & SubReader<T> {
    src.read(int64Parse(src)).data().toArray()
}

public func stringParse<T>(src: T) where T <: BytesReader & SubReader<T> {
    String.fromUtf8(unsafe { src.read(int64Parse(src)).data().getRawArray() })
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