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
    private var offset: Int64       /* raw data offset */

    public SimpleReader(let bytes: RoArray<Byte>, let begin!: Int64 = 0, let end!: Int64 = bytes.size) {
        if (begin < 0 || end < begin || end > bytes.size) {
            throw IllegalArgumentException("Arguments out of range.")
        }
        offset = begin
    }

    public init(data: BytesSlice) {
        this(data.rawData, begin: data.start, end: data.start + data.size)
    }

    public init(data: Collection<Byte>, begin!: Int64 = 0, end!: Int64 = data.size) {
        this(RoArray(data), begin: begin, end: end)
    }

    /** Returns true if this Reader contains no elements. */
    @fastCall
    public func isEmpty() {
        return offset >= end
    }

    /** Return bytes slice. */
    @fastCall
    @overflowWrapping
    public func data() {
        bytes.slice(offset, end - offset)
    }

    /** read a byte, increase the offset */
    @fastCall
    @overflowWrapping
    public func read() {
        offset++
        bytes[offset - 1]
    }

    /** read length of `len` bytes, return its reader. */
    @fastCall
    @overflowWrapping
    public func read(len: Int64) {
        offset += len
        SimpleReader(bytes, begin: offset - len, end: offset)
    }
}