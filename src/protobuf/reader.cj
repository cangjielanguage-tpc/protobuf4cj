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