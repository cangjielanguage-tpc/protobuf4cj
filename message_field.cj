/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

package protobuf

from json import json.*
public from json import json.JsonReader, json.JsonSerializer

public interface MessageField {
    /* the pack size of the field, exclude `the first tag` */
    func packSize(): Int64
    /* pack out the field, exclude `the first tag` */
    func pack(out: BytesWriter): Unit
    func toString(): String
    func isEmpty(): Bool
}

extend UInt64 <: MessageField & Varint {
    public func packSize() { this.varintSize }
    public func pack(out: BytesWriter) { this.varintPack(out) }
    public func isEmpty() { this == 0 }
}

extend Int64 <: MessageField & Varint {
    public func packSize() { UInt64(this).varintSize }
    public func pack(out: BytesWriter) { UInt64(this).varintPack(out) }
    public func isEmpty() { this == 0 }
}

extend UInt32 <: MessageField & Varint {
    public func packSize() { UInt64(this).varintSize }
    public func pack(out: BytesWriter) { UInt64(this).varintPack(out) }
    public func isEmpty() { this == 0 }
}

extend Int32 <: MessageField & Varint {
    public func packSize() { UInt64(this).varintSize }
    public func pack(out: BytesWriter) { UInt64(this).varintPack(out) }
    public func isEmpty() { this == 0 }
}

extend Bool <: MessageField & Varint {
    public func packSize() { 1 }
    public func pack(out: BytesWriter) { UInt64(if (this) { 1 } else { 0 }).varintPack(out) }
    public func isEmpty() { !this }
}

public interface ValuedEnum <: MessageField & Stringify {
    func value(): Int32
    func packSize() { UInt64(value()).varintSize }
    func pack(out: BytesWriter) { UInt64(value()).varintPack(out) }
    func isEmpty() { value() == 0 }
    func stringify(os: JsonSerializer) { os.append(value().toString()); () }
}

public interface Enum<E> <: ValuedEnum where E <: Enum<E> {
    static func parse(v: Int32): E
    static func parse(v: String): E
}

extend Float32 <: MessageField & Bit32 & Stringify {
    public func isEmpty() { this == .0 }
    public func packSize() { 4 }
    public func pack(out: BytesWriter) { fixedPack(out) }
    public func stringify(os: JsonSerializer) { Float64(this).stringify(os) }
}

extend Float64 <: MessageField & Bit64 & Stringify {
    public func isEmpty() { this == .0 }
    public func packSize() { 8 }
    public func pack(out: BytesWriter) { fixedPack(out) }
}

extend String <: MessageField & Stringify {
    public func packSize() { let len = this.utf8View.size(); len.packSize() + len }
    public func pack(out: BytesWriter) { let arr = this.toUtf8Array(); arr.size().pack(out); out.appendAll(arr) }
}

/* bytes */
extend ArrayList<T> <: MessageField where T <: UInt8 {
    public func packSize() { size().packSize() + size() }
    public func pack(out: BytesWriter) { size().pack(out); out.appendAll((this as Bytes).getOrThrow()) }
}

/* 返回 field 真实的数据 */
public interface ValuedMessageField <: MessageField {
    func value(): Any
}

public struct SInt64 <: ValuedMessageField & Varint {
    SInt64(let val: Int64) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { val.zigzag().packSize() }
    public func pack(out: BytesWriter) { val.zigzag().pack(out) }
    public func toString() { val.toString() }
}

public struct SInt32 <: ValuedMessageField & Varint {
    SInt32(let val: Int32) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { val.zigzag().packSize() }
    public func pack(out: BytesWriter) { val.zigzag().pack(out) }
    public func toString() { val.toString() }
}

public struct SFixed64 <: ValuedMessageField & Bit64 {
    SFixed64(let val: Int64) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { 8 }
    public func pack(out: BytesWriter) { val.fixedPack(out) }
    public func toString() { val.toString() }
}

public struct SFixed32 <: ValuedMessageField & Bit32 {
    SFixed32(let val: Int32) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { 4 }
    public func pack(out: BytesWriter) { val.fixedPack(out) }
    public func toString() { val.toString() }
}

public struct Fixed64 <: ValuedMessageField & Bit64 {
    Fixed64(let val: UInt64) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { 8 }
    public func pack(out: BytesWriter) { val.fixedPack(out) }
    public func toString() { val.toString() }
}

public struct Fixed32 <: ValuedMessageField & Bit32 {
    Fixed32(let val: UInt32) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { 4 }
    public func pack(out: BytesWriter) { val.fixedPack(out) }
    public func toString() { val.toString() }
}

public interface RepeatFieldComm<T> <: ValuedMessageField & Stringify & Reference where T <: MessageField {
    func value(): ArrayList<T>
    func isEmpty() { value().isEmpty() }

    func toString() {
        let sb = StringBuilder("[")
        var sep = false
        for (v in value()) {
            if (sep) { sb.append(", ") } else { sep = true }
            match (v) {
                case str: JsonString => str.stringify(sb)
                case _ => sb.append(v.toString())
            }
        }
        sb.append(']').toString()
    }

    func stringify(os: JsonSerializer): Unit {
        var sep = false
        os.append("[")
        for (v in value()) {
            if (sep) { os.append(", ") } else { sep = true }
            stringify(v, os)
        }
        os.append("]")
    }
}

/* repeated fileds with `packed` flag for int64,uint64,int32,uint32,bool,enum,float64,float32 */
public class PackedField<T> <: RepeatFieldComm<T> where T <: MessageField {
    public PackedField(let val: ArrayList<T>) { }
    public func value() { val }
    public func clone() { PackedField(val.clone()) }

    /* pack size of array items, exclude `length prefixed`. */
    func itemSize() {
        var len = 0
        for (v in val) {
            len += v.packSize()
        }
        len
    }

    public func packSize() {
        var len = itemSize()
        len.packSize() + len
    }

    public func pack(out: BytesWriter) {
        itemSize().pack(out)
        for (v in val) {
            v.pack(out)
        }
    }
}

/* repeated fields for int64,uint64,int32,uint32,bool,enum,float64,float32,bytes,string,message */
public class RepeatField<T> <: RepeatFieldComm<T> where T <: MessageField {
    public RepeatField(let tag: Tag, let val: ArrayList<T>) { }
    public func value() { val }

    public func clone() {
        if (val.isEmpty() || !reference(val[0]) ) {
            return RepeatField(tag, val.clone())
        }
        RepeatField(tag, ArrayList<T>(val.size(), { i => (clone(val[i]) as T).getOrThrow() }))
    }

    public func packSize() {
        var len = tag.tagSize * (val.size() - 1)
        for (v in val) {
            len += packSize(v)
        }
        len
    }

    public func pack(out: BytesWriter) {
        pack(val[0], out)
        let wt = wireType(val[0])
        for (i in 1..val.size()) {
            tag.tagPack(wt, out)
            pack(val[i], out)
        }
    }
}

/* repeated fileds with `packed` flag for sint64,sint32,sfixed64,sfixed32,fixed64,fixed32 */
public abstract class ValuedPackedField<T> <: RepeatFieldComm<T> where T <: MessageField {
    ValuedPackedField(let val: ArrayList<T>) {}
    public func value() { val }
    public func clone(): ValuedPackedField<T>
    protected func proxy(v: T): MessageField

    /* pack size of array items, exclude `length prefixed`. */
    func itemSize() {
        var len = 0
        for (v in val) {
            len += proxy(v).packSize()
        }
        len
    }

    public func packSize() {
        var len = itemSize()
        len.packSize() + len
    }

    public func pack(out: BytesWriter) {
        itemSize().pack(out)
        for (v in val) {
            proxy(v).pack(out)
        }
    }
}

public class PackedSInt64 <: ValuedPackedField<Int64> {
    public init(val: ArrayList<Int64>) { super(val) }
    public func clone() { PackedSInt64(val.clone()) }
    protected func proxy(v: Int64): MessageField { SInt64(v) }
}

public class PackedSInt32 <: ValuedPackedField<Int32> {
    public init(val: ArrayList<Int32>) { super(val) }
    public func clone() { PackedSInt32(val.clone()) }
    protected func proxy(v: Int32): MessageField { SInt32(v) }
}

public class PackedSFixed64 <: ValuedPackedField<Int64> {
    public init(val: ArrayList<Int64>) { super(val) }
    public func clone() { PackedSFixed64(val.clone()) }
    protected func proxy(v: Int64): MessageField { SFixed64(v) }
}

public class PackedSFixed32 <: ValuedPackedField<Int32> {
    public init(val: ArrayList<Int32>) { super(val) }
    public func clone() { PackedSFixed32(val.clone()) }
    protected func proxy(v: Int32): MessageField { SFixed32(v) }
}

public class PackedFixed64 <: ValuedPackedField<UInt64> {
    public init(val: ArrayList<UInt64>) { super(val) }
    public func clone() { PackedFixed64(val.clone()) }
    protected func proxy(v: UInt64): MessageField { Fixed64(v) }
}

public class PackedFixed32 <: ValuedPackedField<UInt32> {
    public init(val: ArrayList<UInt32>) { super(val) }
    public func clone() { PackedFixed32(val.clone()) }
    protected func proxy(v: UInt32): MessageField { Fixed32(v) }
}

/* repeated fields for sint64,sint32,sfixed64,sfixed32,fixed64,fixed32 */
public abstract class ValuedRepeatField<T> <: RepeatFieldComm<T> where T <: MessageField {
    ValuedRepeatField(let tag: Tag, let val: ArrayList<T>) { }
    public func value() { val }
    public func clone(): ValuedRepeatField<T>
    protected func proxy(v: T): MessageField

    public func packSize() {
        var len = tag.tagSize * (val.size() - 1)
        for (v in val) {
            len += packSize(proxy(v))
        }
        len
    }

    public func pack(out: BytesWriter) {
        pack(proxy(val[0]), out)
        let wt = wireType(proxy(val[0]))
        for (i in 1..val.size()) {
            tag.tagPack(wt, out)
            pack(proxy(val[i]), out)
        }
    }
}

public class RepeatSInt64 <: ValuedRepeatField<Int64> {
    public init(tag: Tag, val: ArrayList<Int64>) { super(tag, val) }
    public func clone() { RepeatSInt64(tag, val.clone()) }
    protected func proxy(v: Int64): MessageField { SInt64(v) }
}

public class RepeatSInt32 <: ValuedRepeatField<Int32> {
    public init(tag: Tag, val: ArrayList<Int32>) { super(tag, val) }
    public func clone() { RepeatSInt32(tag, val.clone()) }
    protected func proxy(v: Int32): MessageField { SInt32(v) }
}

public class RepeatSFixed64 <: ValuedRepeatField<Int64> {
    public init(tag: Tag, val: ArrayList<Int64>) { super(tag, val) }
    public func clone() { RepeatSFixed64(tag, val.clone()) }
    protected func proxy(v: Int64): MessageField { SFixed64(v) }
}

public class RepeatSFixed32 <: ValuedRepeatField<Int32> {
    public init(tag: Tag, val: ArrayList<Int32>) { super(tag, val) }
    public func clone() { RepeatSFixed32(tag, val.clone()) }
    protected func proxy(v: Int32): MessageField { SFixed32(v) }
}

public class RepeatFixed64 <: ValuedRepeatField<UInt64> {
    public init(tag: Tag, val: ArrayList<UInt64>) { super(tag, val) }
    public func clone() { RepeatFixed64(tag, val.clone()) }
    protected func proxy(v: UInt64): MessageField { Fixed64(v) }
}

public class RepeatFixed32 <: ValuedRepeatField<UInt32> {
    public init(tag: Tag, val: ArrayList<UInt32>) { super(tag, val) }
    public func clone() { RepeatFixed32(tag, val.clone()) }
    protected func proxy(v: UInt32): MessageField { Fixed32(v) }
}

/* todo ValuedField K, V not support yet */
public class MapField<K, V> <: ValuedMessageField & Reference & Stringify where K <: Hashable & Equatable<K> & MessageField, V <: MessageField {
    public MapField(let tag: Tag, let val: HashMap<K, V>) { }
    public func value() { val }
    public func isEmpty() { val.isEmpty() }

    public func clone(): MessageField {
        let map = HashMap<K, V>()
        let ret = MapField<K, V>(tag, map)
        for ((k, v) in val) {
            map[k] = (clone(v) as V).getOrThrow()
        }
        ret
    }

    public func packSize() {
        var len = tag.tagSize * (val.size() - 1)
        for ((k, v) in val) {
            var sub = 0
            if (!k.isEmpty()) {
                sub += 1 + k.packSize()
            }
            if (!v.isEmpty()) {
                sub += 1 + packSize(v)
            }
            len += sub.packSize() + sub
        }
        len
    }

    public func pack(out: BytesWriter) {
        var flag = false
        for ((k, v) in val) {
            if (flag) {
                tag.tagPack(WireType.PREFIXED, out)
            } else {
                flag = true
            }

            /* length of sub entry */
            var len = 0
            if (!k.isEmpty()) {
                len += 1 + k.packSize()
            }
            if (!v.isEmpty()) {
                len += 1 + packSize(v)
            }

            len.pack(out)

            if (!k.isEmpty()) {
                UInt32(1).tagPack(wireType(k), out)
                k.pack(out)
            }
            if (!v.isEmpty()) {
                UInt32(2).tagPack(wireType(v), out)
                v.pack(out)
            }
        }
    }

    public func toString() {
        let sb = StringBuilder("{")
        var sep = false
        for ((k, v) in val) {
            if (sep) { sb.append(", ") } else { sep = true }
            sb.append(k.toString()).append(": ")
            match (v) {
                case str: JsonString => str.stringify(sb)
                case _ => sb.append(v.toString())
            }
        }
        sb.append('}').toString()
    }

    public func stringify(os: JsonSerializer): Unit {
        var sep = false
        for ((k, v) in val) {
            if (sep) { os.append(", ") } else { sep = true }
            k.toString().stringify(os)
            os.append(": ")
            stringify(v, os)
        }
        os.append("}")
    }
}

/**
 * special internal processing for Enum and MessageLite,
 * avoid exporting too many unnecessary interfaces.
 */
public interface Varint { }
public interface Bit64 { }
public interface Bit32 { }

func wireType(val: MessageField) {
    match (val) {
        case _: Varint => WireType.VARINT
        case _: ValuedEnum => WireType.VARINT
        case _: Bit64 => WireType.BIT64
        case _: Bit32 => WireType.BIT32
        case _ => WireType.PREFIXED
    }
}

public interface Reference {
    func clone(): MessageField
}

func reference(val: MessageField) {
    match (val) {
        case _: Reference => true
        case _: MessageLite => true
        case _ => false
    }
}

func clone(val: MessageField) {
    match (val) {
        case c: Reference => c.clone()
        case c: MessageLite => c.clone()
        case _ => val
    }
}

public interface Stringify {
    func stringify(os: JsonSerializer): Unit
}

func stringify(val: MessageField, os: JsonSerializer) {
    match (val) {
        case c: MessageLite => c.stringify(os)
        case c: Stringify => c.stringify(os)
        case _ => os.append(val.toString())
    }
}

func packSize(val: MessageField) {
    match (val) {
        case c: MessageLite => let len = c.packSize(); len.packSize() + len
        case _ => val.packSize()
    }
}

func pack(val: MessageField, out: BytesWriter): Unit {
    match (val) {
        case c: MessageLite => c.packSize().pack(out); c.pack(out)
        case _ => val.pack(out)
    }
}