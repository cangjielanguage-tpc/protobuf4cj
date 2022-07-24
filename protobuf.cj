/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

package protobuf

from std import collection.*

public type Tag = UInt32
public type Bytes = ArrayList<Byte>

public class WireType <: ToString {
    private WireType(public let value: UInt8, private let name: String) { }
    public func toString() { name }

    public static func parse(val: UInt8): WireType {
        match (val) {
            case 0 => VARINT
            case 1 => BIT64
            case 2 => PREFIXED
            case 5 => BIT32
            case v => throw Exception()
        }
    }

    public static let VARINT = WireType(0, "VARINT")
    public static let BIT64 = WireType(1, "BIT64")
    public static let PREFIXED = WireType(2, "PREFIXED")
    public static let BIT32 = WireType(5, "BIT32")
}

extend Tag {
    /*
    * the number of bytes required to store the tag for the field. Includes
    * 3 bits for the wire-type, and a single bit that denotes the end-of-tag.
    */
    public prop let tagSize: Int64 {
        get() {
            if (this < (1 << 4)) { return 1 }
            if (this < (1 << 11)) { return 2 }
            if (this < (1 << 18)) { return 3 }
            if (this < (1 << 25)) { return 4 }
            5
        }
    }

    /* pack a tag(with wire-type) out. */
    public func tagPack(w: WireType, out: BytesWriter) {
        (this << 3 | UInt32(w.value)).pack(out)
    }

    public static func tagParse(src: BytesReader): (Tag, WireType) {
        if (src.isEmpty()) {
            throw ParseValueExecption("tag", reason: "empty buffer")
        }

        var byte = src.read()
        if ((byte & 0xf8) == 0) {
            throw ParseValueExecption("tag", reason: "invalid tag value")
        }

        var tag = UInt32(byte & 0x7f) >> 3
        let wireType = WireType.parse(byte & 7)
        if ((byte & 0x80) == 0) {
            return (tag, wireType)
        }

        var shift: UInt8 = 4
        for (i in 1..5) {
            if (src.isEmpty()) {
                throw ParseValueExecption("tag", reason: "incomplete buffer")
            }

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

    /* try to read the same tag from the bytes reader */
    func tagGetNext(src: BytesReader) {
        if (src.isEmpty()) {
            return false
        }

        let n = UInt64.peek(src)
        if (UInt64(this) == (n >> 3)) {
            src.read(n.varintSize)
            return true
        }

        false
    }
}

// ffi
foreign func itof(v: UInt32): Float32
foreign func ltod(v: UInt64): Float64
foreign func ftoi(v: Float32): UInt32
foreign func dtol(v: Float64): UInt64

extend UInt64 {
    prop let varintSize: Int64 {
        get() {
            if (this > 0x7fff_ffff_ffff_ffff) { return 10 }
            if (this < (1 << 7)) { return 1 } 
            if (this < (1 << 14)) { return 2 }
            if (this < (1 << 21)) { return 3 }
            if (this < (1 << 28)) { return 4 }
            if (this < (1 << 35)) { return 5 }
            if (this < (1 << 42)) { return 6 }
            if (this < (1 << 49)) { return 7 }
            if (this < (1 << 56)) { return 8 }
            9
        }
    }

    @overflowWrapping
    public /* cangjie 0.30.4 bug */
    func varintPack(out: BytesWriter) {
        var v = this
        while (v >= 0x80) {
            out.append(UInt8(v | 0x80))
            v >>= 7
        }
        out.append(UInt8(v))
    }

    @overflowWrapping
    public /* cangjie 0.30.4 bug */
    func unzigzag() {
        Int64((this >> 1) ^ -(this & 1))
    }

    @overflowWrapping
    public /* cangjie 0.30.4 bug */
    func fixedPack(out: BytesWriter) {
        out.append(UInt8(this))
        out.append(UInt8(this >> 8))
        out.append(UInt8(this >> 16))
        out.append(UInt8(this >> 24))
        out.append(UInt8(this >> 32))
        out.append(UInt8(this >> 40))
        out.append(UInt8(this >> 48))
        out.append(UInt8(this >> 56))
    }

    static func fixedParse(src: BytesReader) {
        if (src.size() < 8) {
            throw ParseValueExecption("fixed64", reason: "incomplete buffer")
        }

        UInt64(src.read()) | (UInt64(src.read()) << 8) | (UInt64(src.read()) << 16) | (UInt64(src.read()) << 24) |
        (UInt64(src.read()) << 32) | (UInt64(src.read()) << 40) | (UInt64(src.read()) << 48) | (UInt64(src.read()) << 56)
    }

    static func parse(src: BytesReader) {
        if (src.isEmpty()) {
            throw ParseValueExecption("varint", reason: "empty buffer")
        }

        var byte = src.read()
        var rv = UInt64(byte & 0x7f)
        if ((byte & 0x80) == 0) {
            return rv
        }

        var shift: UInt8 = 7
        for (i in 1..10) {
            if (src.isEmpty()) {
                throw ParseValueExecption("varint", reason: "incomplete buffer")
            }

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

    /* peek a varint from bytes reader */
    static func peek(src: BytesReader) {
        var byte = src.peek(0)
        var rv = UInt64(byte & 0x7f)
        if ((byte & 0x80) == 0) {
            return rv
        }

        var shift: UInt8 = 7
        for (i in 1..10) {
            byte = src.peek(i)
            if ((byte & 0x80) == 0) {
                rv |= UInt64(byte) << shift
                return rv
            }
            rv |= UInt64(byte & 0x7f) << shift
            shift += 7
        }

        throw ParseValueExecption("varint", reason: "invalid value")
    }
}

extend Int64 {
    /* the ZigZag-encoded 64-bit unsigned integer form of a 64-bit signed integer. */
    @overflowWrapping
    public /* cangjie 0.30.4 bug */
    func zigzag() {
        (UInt64(this) << 1) ^ UInt64(this >> 63)
    }

    @overflowWrapping
    public /* cangjie 0.30.4 bug */
    func fixedPack(out: BytesWriter) {
        out.append(UInt8(this))
        out.append(UInt8(this >> 8))
        out.append(UInt8(this >> 16))
        out.append(UInt8(this >> 24))
        out.append(UInt8(this >> 32))
        out.append(UInt8(this >> 40))
        out.append(UInt8(this >> 48))
        out.append(UInt8(this >> 56))
    }

    @overflowWrapping
    static func parse(src: BytesReader) {
        Int64(UInt64.parse(src))
    }

    @overflowWrapping
    static func fixedParse(src: BytesReader) {
        Int64(UInt64.fixedParse(src))
    }
}

extend UInt32 {
    /* Unzigzag a ZigZag-decoded 32-bit unsigned integer to a 32-bit signed integer. */
    @overflowWrapping
    public /* cangjie 0.30.4 bug */
    func unzigzag() {
        Int32((this >> 1) ^ -(this & 1))
    }

    @overflowWrapping
    public /* cangjie 0.30.4 bug */
    func fixedPack(out: BytesWriter) {
        out.append(UInt8(this))
        out.append(UInt8(this >> 8))
        out.append(UInt8(this >> 16))
        out.append(UInt8(this >> 24))
    }

    static func fixedParse(src: BytesReader) {
        if (src.size() < 4) {
            throw ParseValueExecption("fixed32", reason: "incomplete buffer")
        }

        UInt32(src.read()) | (UInt32(src.read()) << 8) | (UInt32(src.read()) << 16) | (UInt32(src.read()) << 24)
    }

    @overflowWrapping
    static func parse(src: BytesReader) {
        UInt32(UInt64.parse(src))
    }
}

extend Int32 {
    @overflowWrapping
    public /* cangjie 0.30.4 bug */
    func zigzag() {
        (UInt32(this) << 1) ^ UInt32(this >> 31)
    }

    @overflowWrapping
    public /* cangjie 0.30.4 bug */
    func fixedPack(out: BytesWriter) {
        out.append(UInt8(this))
        out.append(UInt8(this >> 8))
        out.append(UInt8(this >> 16))
        out.append(UInt8(this >> 24))
    }

    @overflowWrapping
    static func parse(src: BytesReader) {
        Int32(UInt64.parse(src))
    }

    @overflowWrapping
    static func fixedParse(src: BytesReader) {
        Int32(UInt32.fixedParse(src))
    }
}

extend Bool {
    static func parse(src: BytesReader) {
        UInt64.parse(src) != 0
    }
}

extend Float64 {
    public /* cangjie 0.30.4 bug */
    func fixedPack(out: BytesWriter) {
        unsafe { dtol(this).fixedPack(out) }
    }

    static func fixedParse(src: BytesReader) {
       unsafe { ltod(UInt64.fixedParse(src)) }
    }
}

extend Float32 {
    public /* cangjie 0.30.4 bug */
    func fixedPack(out: BytesWriter) {
        unsafe { ftoi(this).fixedPack(out) }
    }

    static func fixedParse(src: BytesReader) {
        unsafe { itof(UInt32.fixedParse(src)) }
    }
}

extend String {
    static func parse(src: BytesReader) {
        String.fromUtf8(src.read(Int64.parse(src)).data())
    }
}

public interface AddMessage<M> {
    func add(): M
}

extend ArrayList<M> <: AddMessage<M> where M <: MessageLite & MessageParser<M> {
    public func add(): M { let m = M.fromBytes([]); this.append(m); m }
}
