/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file about: BytesReader
 */
package protobuf

/* Bytes Reader. */
public type BytesReader = Reader<Byte>

/* public interface of `generic-T` reader. */
public interface Reader<T> <: SubReader<Reader<T>> {
    /* no data unread */
    func isEmpty(): Bool
    /* read and increase the offset */
    func read(): T
    /* read a sub reader with length of `len` and increase the offset */
    func read(len: Int64): Reader<T>
    /* all the unread data */
    func data(): Array<T>
}

/* typed sub reader. */
public interface SubReader<T> {
    func read(len: Int64): T
}

/**
 * The class is SimpleReader
 * @author tutudo
 * @since 0.29.3
 */
public class SimpleReader <: BytesReader & SubReader<SimpleReader> {
    private let buffer: Array<UInt8>
    public SimpleReader (
        buffer: Collection<UInt8>,
        private let begin!: Int64 = 0,
        private let end!: Int64 = buffer.size,
        private var offset!: Int64 = begin
    ) {
        if (begin < 0 || end > buffer.size) {
            throw IllegalArgumentException("SimpleReader Arguments out of range.")
        }

        this.buffer = match (buffer) {
            case arr: Bytes => arr
            case _ => Array(buffer)
        }
    }

    /**
     * any data unread
     *
     * @since 0.29.3
     */
    public func isEmpty() {
        return offset >= end
    }

    /**
     * all data
     *
     * @since 0.29.3
     */
    public func data() {
        if (offset >= end) {
            return Bytes()
        }
        buffer[offset..end]
    }

    /**
     * read a byte, increase the offset
     *
     *
     * @since 0.29.3
     */
    public func read() {
        offset++
        buffer[offset - 1]
    }

    /**
     * read length of `s` bytes, return its reader.
     *
     * @param s of Int64
     *
     * @since 0.29.3
     */
    public func read(s: Int64) {
        offset += s
        SimpleReader(buffer, begin: offset - s, end: offset)
    }
}