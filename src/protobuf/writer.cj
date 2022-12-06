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

    @overflowWrapping
    public func appendUtf8View(val: Utf8View) {
        val.copyTo(data, offset)
        offset += val.size
    }

    @overflowWrapping
    public func appendSlice(val: BytesSlice) {
        val.copyTo(data, offset)
        offset += val.size
    }
}