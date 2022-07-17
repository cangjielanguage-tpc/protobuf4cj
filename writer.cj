/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

package protobuf

/* Bytes Reader. */
public type BytesWriter = Writer<Byte>

/* public interface of `generic-T` writer. */
public interface Writer<T> {
    /* append `v` to writer */
    func append(v: T): Unit
    /* append all the `a` to writer */
    func appendAll(a: Collection<T>): Unit
}

/* ArrayList is already Writer */
extend ArrayList<T> <: Writer<T>  { }