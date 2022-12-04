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
    /* append string utf8 view to writer */
    func appendUtf8View(val: Utf8View): Unit
    /* append slice to writer */
    func appendSlice(val: BytesSlice): Unit
}

public class BytesBuffer <: BytesWriter {
    public BytesBuffer(
        public let data: Bytes,         /* data's buffer */
        public var offset!: Int64 = 0   /* curren write position */
    ) { }

    public init(size: Int64) {
        this(Bytes(size, item: 0))
    }

    @fastCall
    @overflowWrapping
    public func append(val: Byte) {
        data[offset] = val
        offset++
    }

    @fastCall
    @overflowWrapping
    public func appendBytes(val: Bytes) {
        val.copyTo(data, 0, offset, val.size)
        offset += val.size
    }

    @fastCall
    @overflowWrapping
    public func appendUtf8View(val: Utf8View) {
        val.copyTo(data, offset)
        offset += val.size
    }

    @fastCall
    @overflowWrapping
    public func appendSlice(val: BytesSlice) {
        val.copyTo(data, offset)
        offset += val.size
    }
}