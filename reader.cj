/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file about: ReaderSeekBase
 */
package protobuf

public enum ReaderSeekBase { SET | CUR | END }

/**
 * The class is SimpleReader
 * @author tutudo
 * @since 0.29.3
 */
public class SimpleReader {
    public SimpleReader (
        private let buffer: Array<UInt8>,
        private let begin!: Int64 = 0,
        private let end!: Int64 = buffer.size(),
        private var offset!: Int64 = begin
    ) {
        if (begin < 0 || end > buffer.size()) {
            debug()
            throw IllegalArgumentException("SimpleReader Arguments out of range.")
        }
    }

    /**
     * unread bytes size
     *
     * @since 0.29.3
     */
    public func size() {
        end - offset
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
     * seek the offset
     *
     * @param offset of Int64
     * @param base of ReaderSeekBase, and the Default value is CUR
     *
     * @since 0.29.3
     */
    public func seek(offset: Int64, base!: ReaderSeekBase = CUR) {
        match(base) {
            case SET => this.offset = begin + offset
            case CUR => this.offset += offset
            case END => this.offset = end - offset
        }
        this.offset
    }

    /**
     * peek a byte
     *
     * @param i of Int64
     *
     * @since 0.29.3
     */
    public func peek(i: Int64) { 
        buffer[offset + i]
    }

    /**
     * all data
     *
     * @since 0.29.3
     */
    public func data() { 
        if (offset >= end) {
            return Array<UInt8>()
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
        let v = buffer[offset]
        offset++
        v
    }

    /**
     * read length of `s` bytes, return its reader.
     *
     * @param s of Int64
     *
     * @since 0.29.3
     */
    public func read(s: Int64) {
        let v = SimpleReader(buffer, begin: offset, end: offset + s)
        offset += s
        v
    }

    /**
     * read `v`, if succeed, increase the offset
     *
     * @param v of UInt8
     *
     * @since 0.29.3
     */
    public func read(v: UInt8) {
        if (offset < begin || offset >= end || buffer[offset] != v) {
            return false
        }
        offset++
        true
    }

    /**
     * read `a`, if succeed, increase the offset
     *
     * @param a of Collection<UInt8>
     *
     * @since 0.29.3
     */
    public func read(a: Collection<UInt8>) {
        if (offset < begin || offset + a.size() > end) {
            return false
        }

        var s = offset
        for (u in a) {
            if (buffer[s] != u) {
                return false
            }
            s++
        }

        offset = s
        true
    }

    /**
     * The Function is debug
     *
     * @since 0.29.3
     */
    public func debug() {
        println("begin: ${begin}, end: ${end}, offset: ${offset}")
    }
}