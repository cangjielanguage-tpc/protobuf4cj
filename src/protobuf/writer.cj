/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

package protobuf

/* public interface of bytes writer. */
public interface BytesWriter {
    /* append a byte writer */
    func append(val: Byte): Unit
    /* append bytes to writer */
    func appendBytes(val: Bytes): Unit

    /* pack a tag(with wire-type) out. */
    @overflowWrapping
    func packTag(tag: Tag, wt: WireType) {
        packVarint(tag << 3 | UInt32(wt.value))
    }

    /* pack a tag(with wire-type) out. */
    @overflowWrapping
    func packTag(tag: Tag, wn: WireNum) {
        packVarint(tag << 3 | UInt32(wn))
    }

    /* pack out by varint encoding. */
    @overflowWrapping
    func packVarint(val: UInt64) {
        var v = val
        while (v >= 0x80) {
            append(UInt8(v | 0x80))
            v >>= 7
        }
        append(UInt8(v))
    }

    /* pack out by varint encoding. */
    @overflowWrapping
    func packVarint(val: Int64) {
        packVarint(UInt64(val))
    }

    /* pack out by varint encoding. */
    @overflowWrapping
    func packVarint(val: UInt32) {
        var value = val
        if (value >= 0x80) {
            append(UInt8(value | 0x80))
            value >>= 7
            if (value >= 0x80) {
                append(UInt8(value | 0x80))
                value >>= 7
                if (value >= 0x80) {
                    append(UInt8(value | 0x80))
                    value >>= 7
                    if (value >= 0x80) {
                        append(UInt8(value | 0x80))
                        value >>= 7
                    }
                }
            }
        }

        /* assert: value < 128 */
        append(UInt8(value))
    }

    /* pack out by varint encoding. */
    @overflowWrapping
    func packVarint(val: Int32) {
        if (val >= 0) {
            return packVarint(UInt32(val))
        }

        append(UInt8(val | 0x80))
        append(UInt8((val >> 7) | 0x80))
        append(UInt8((val >> 14) | 0x80))
        append(UInt8((val >> 21) | 0x80))
        append(UInt8((val >> 28) | 0x80))
        append(0xff)
        append(0xff)
        append(0xff)
        append(0xff)
        append(0x01)
    }

    /* pack out bool */
    func packBool(val: Bool) {
        append(if (val) { 1 } else { 0 })
    }

    /* pack out sint64. */
    func packSInt(val: Int64) {
        packVarint(zigzag(val))
    }

    /* pack out sint32. */
    func packSInt(val: Int32) {
        packVarint(zigzag(val))
    }

    @overflowWrapping
    func packFixed(val: UInt64) {
        append(UInt8(val))
        append(UInt8(val >> 8))
        append(UInt8(val >> 16))
        append(UInt8(val >> 24))
        append(UInt8(val >> 32))
        append(UInt8(val >> 40))
        append(UInt8(val >> 48))
        append(UInt8(val >> 56))
    }

    @overflowWrapping
    func packFixed(val: Int64) {
        append(UInt8(val))
        append(UInt8(val >> 8))
        append(UInt8(val >> 16))
        append(UInt8(val >> 24))
        append(UInt8(val >> 32))
        append(UInt8(val >> 40))
        append(UInt8(val >> 48))
        append(UInt8(val >> 56))
    }

    @overflowWrapping
    func packFixed(val: UInt32) {
        append(UInt8(val))
        append(UInt8(val >> 8))
        append(UInt8(val >> 16))
        append(UInt8(val >> 24))
    }

    @overflowWrapping
    func packFixed(val: Int32) {
        append(UInt8(val))
        append(UInt8(val >> 8))
        append(UInt8(val >> 16))
        append(UInt8(val >> 24))
    }

    func packFixed(val: Float64) {
        unsafe { packFixed(dtol(val)) }
    }

    func packFixed(val: Float32) {
        unsafe { packFixed(ftoi(val)) }
    }

    func packBin(val: BytesSlice) {
        packVarint(val.size)
        appendBytes(unsafe { val.getRawArray() })
    }

    func packBin(val: BytesString) {
        let bytes = unsafe { val.getRawBytes() }
        packVarint(bytes.size)
        appendBytes(bytes)
    }

    func packBin(val: String) {
        let view = val.utf8View
        packVarint(view.size)
        appendBytes(unsafe { view.getRawBytes() })
    }
}

public class SimpleWriter <: BytesWriter {
    public var offset = 0               /* curren write position */

    public SimpleWriter(
        public let data: Bytes          /* data's buffer */
    ) { }

    public init() {
        this(Bytes())
    }

    public init(size: Int64) {
        this(Bytes(size, item: 0))
    }

    /* reset offset to `0` */
    public func clear() { offset = 0 }
    public func isFull() { offset >= data.size }

    @overflowWrapping
    public func append(val: Byte) {
        data[offset] = val
        offset++
    }

    @overflowWrapping
    public func appendBytes(val: Bytes) {
        val.copyTo(data, 0, offset, val.size)
        offset += val.size
    }
}