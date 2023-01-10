/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file about: BytesReader
 */
package protobuf

/* public interface of reader. */
public interface BytesReader <: SubReader<BytesReader> {
    /* no data unread */
    func isEmpty(): Bool
    /* read and increase the offset */
    func read(): Byte
    /* read a sub reader with length of `len` and increase the offset */
    func read(len: Int64): BytesReader
    /* all the unread data */
    func data(): BytesSlice

    /* parse a tag(with wire-type) from  */
    @overflowWrapping
    func parseTag(): (Tag, WireNum) {
        var byte = read()
        if ((byte & 0xf8) == 0) {
            throw ParseValueExecption("tag", reason: "invalid tag value")
        }

        var tag = UInt32(byte & 0x7f) >> 3
        let wireType = byte & 7
        if (byte < 0x80) {
            return (tag, wireType)
        }

        var shift: UInt8 = 4
        while (shift <= 25) {
            byte = read()
            if (byte < 0x80) {
                tag |= UInt32(byte) << shift
                return (tag, wireType)
            }

            tag |= UInt32(byte & 0x7f) << shift
            shift += 7
        }

        throw ParseValueExecption("tag", reason: "invalid tag value")
    }

    /* get varint data from bytes reader */
    @overflowWrapping
    func parseVarintData() {
        var byte = read()
        if (byte < 0x80) {
            return [byte]
        }

        let data: Bytes = [byte, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        var i = 1
        while (i < 10) {
            byte = read()
            data[i] = byte
            if (byte < 0x80) {
                return data[.. i + 1]
            }
        }

        throw ParseValueExecption("varint", reason: "invalid value")
    }

    /* parse uint64 from varint encoded  */
    @overflowWrapping
    func parseUInt64() {
        var byte = read()
        var rv = UInt64(byte & 0x7f)
        if (byte < 0x80) {
            return rv
        }

        var shift: UInt8 = 7
        while (shift <= 63) {
            byte = read()
            if (byte < 0x80) {
                rv |= UInt64(byte) << shift
                return rv
            }
            rv |= UInt64(byte & 0x7f) << shift
            shift += 7
        }

        throw ParseValueExecption("varint", reason: "invalid value")
    }

    /* parse int64 from varint encoded  */
    @overflowWrapping
    func parseInt64() {
        Int64(parseUInt64())
    }

    /* parse uint32 from varint encoded  */
    @overflowWrapping
    func parseUInt32() {
        var byte = read()
        var rv = UInt32(byte & 0x7f)
        if (byte < 0x80) {
            return rv
        }

        byte = read()
        rv |= UInt32(byte & 0x7f) << 7
        if (byte < 0x80) {
            return rv
        }

        byte = read()
        rv |= UInt32(byte & 0x7f) << 14
        if (byte < 0x80) {
            return rv
        }

        byte = read()
        rv |= UInt32(byte & 0x7f) << 21
        if (byte < 0x80) {
            return rv
        }

        byte = read()
        rv |= UInt32(byte) << 28
        /* scan varint */
        if ((byte > 0x7f) && (read() > 0x7f) && (read() > 0x7f) && (read() > 0x7f) && (read() > 0x7f)) {
            read()
        }

        return rv
    }

    /* parse int32 from varint encoded  */
    @overflowWrapping
    func parseInt32() {
        Int32(parseUInt32())
    }

    func parseBool() {
        read() != 0
    }

    /* parse sint64. */
    @overflowWrapping
    func parseSInt64() {
        unzigzag((parseUInt64()))
    }

    /* parse sint32. */
    @overflowWrapping
    func parseSInt32() {
        unzigzag((parseUInt32()))
    }

    @overflowWrapping
    func parseFixed64() {
        UInt64(read()) | (UInt64(read()) << 8) | (UInt64(read()) << 16) | (UInt64(read()) << 24) |
        (UInt64(read()) << 32) | (UInt64(read()) << 40) | (UInt64(read()) << 48) | (UInt64(read()) << 56)
    }

    @overflowWrapping
    func parseSFixed64() {
        Int64(parseFixed64())
    }

    @overflowWrapping
    func parseFixed32() {
        UInt32(read()) | (UInt32(read()) << 8) | (UInt32(read()) << 16) | (UInt32(read()) << 24)
    }

    @overflowWrapping
    func parseSFixed32() {
        Int32(parseFixed32())
    }

    func parseFloat64() {
        unsafe { ltod(parseFixed64()) }
    }

    func parseFloat32() {
        unsafe { itof(parseFixed32()) }
    }

    func sub() {
        read(parseInt64())
    }

    func parseBytes() {
        read(parseInt64()).data().toArray()
    }

    func parseString() {
        String.fromUtf8(unsafe { read(parseInt64()).data().getRawArray() })
    }
}

/* typed sub reader. */
public interface SubReader<T> {
    func read(len: Int64): T
}

/**
 * SimpleReader
 */
public class SimpleReader <: BytesReader & SubReader<SimpleReader> {
    private var offset = 0       /* bytes offset */
    private let size: Int64       /* bytes size */

    public SimpleReader(let bytes: BytesSlice) {
        size = bytes.size
    }

    public init(data: Collection<Byte>, begin!: Int64 = 0, end!: Int64 = data.size) {
        this(BytesSlice(data)[begin .. end])
    }

    public init() {
        this(BytesSlice())
    }

    /** Returns true if this Reader contains no elements. */
    public func isEmpty() {
        return offset >= size
    }

    /** Return bytes slice. */
    @overflowWrapping
    public func data() {
        bytes[offset ..]
    }

    /** read a byte, increase the offset */
    @overflowWrapping
    public func read() {
        offset++
        bytes[offset - 1]
    }

    /** read length of `len` bytes, return its reader. */
    @overflowWrapping
    public func read(len: Int64) {
        offset += len
        SimpleReader(bytes.slice(offset - len, len))
    }
}