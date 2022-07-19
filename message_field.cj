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

public interface ValuedEnum <: MessageField & ToString {
    func value(): Int32
    func packSize() { UInt64(value()).varintSize }
    func pack(out: BytesWriter) { UInt64(value()).varintPack(out) }
    func isEmpty() { value() == 0 }
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
extend ArrayList<T> <: MessageField where T <: Byte { /* cannot extend ArrayList<Byte> to Reference yet. */
    public func packSize() { size().packSize() + size() }
    public func pack(out: BytesWriter) { size().pack(out); out.appendAll((this as Bytes).getOrThrow()) }
}

/* 返回 field 真实的数据 */
public interface ValuedMessageField <: MessageField {
    func value(): Any
}

/* `box` trans `T` to `Proxy<T>` */
public interface Proxy<T> <: ValuedMessageField where T <: MessageField {
    static func box(v: T): Proxy<T>
}

public struct SInt64 <: Proxy<Int64> & Varint {
    public SInt64(let val: Int64) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { val.zigzag().packSize() }
    public func pack(out: BytesWriter) { val.zigzag().pack(out) }
    public func toString() { val.toString() }
    public static func box(val: Int64): Proxy<Int64> { SInt64(val) }
}

public struct SInt32 <: Proxy<Int32> & Varint {
    public SInt32(let val: Int32) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { val.zigzag().packSize() }
    public func pack(out: BytesWriter) { val.zigzag().pack(out) }
    public func toString() { val.toString() }
    public static func box(val: Int32): Proxy<Int32> { SInt32(val) }
}

public struct SFixed64 <: Proxy<Int64> & Bit64 {
    public SFixed64(let val: Int64) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { 8 }
    public func pack(out: BytesWriter) { val.fixedPack(out) }
    public func toString() { val.toString() }
    public static func box(val: Int64): Proxy<Int64> { SFixed64(val) }
}

public struct SFixed32 <: Proxy<Int32> & Bit32 {
    public SFixed32(let val: Int32) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { 4 }
    public func pack(out: BytesWriter) { val.fixedPack(out) }
    public func toString() { val.toString() }
    public static func box(val: Int32): Proxy<Int32> { SFixed32(val) }
}

public struct Fixed64 <: Proxy<UInt64> & Bit64 {
    public Fixed64(let val: UInt64) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { 8 }
    public func pack(out: BytesWriter) { val.fixedPack(out) }
    public func toString() { val.toString() }
    public static func box(val: UInt64): Proxy<UInt64> { Fixed64(val) }
}

public struct Fixed32 <: Proxy<UInt32> & Bit32 {
    public Fixed32(let val: UInt32) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { 4 }
    public func pack(out: BytesWriter) { val.fixedPack(out) }
    public func toString() { val.toString() }
    public static func box(val: UInt32): Proxy<UInt32> { Fixed32(val) }
}

/* all repeated fields comm isEmpty, toString, stringify */
public abstract class RepeatFieldComm<T> <: ValuedMessageField & Stringify & Reference where T <: MessageField {
    RepeatFieldComm(let val: ArrayList<T>) { }
    public func value() { val }
    public func isEmpty() { val.isEmpty() }

    public func toString() {
        let sb = StringBuilder("[")
        var sep = false
        for (v in val) {
            if (sep) { sb.append(", ") } else { sep = true }
            match (v) {
                case str: JsonString => str.stringify(sb)
                case _ => sb.append(v.toString())
            }
        }
        sb.append(']').toString()
    }

    public func stringify(os: JsonSerializer): Unit {
        var sep = false
        os.append("[")
        for (v in val) {
            if (sep) { os.append(", ") } else { sep = true }
            stringify(v, os)
        }
        os.append("]")
    }
}

/* repeated fileds with `packed` flag for int64,uint64,int32,uint32,bool,enum,float64,float32 */
public class PackedField<T> <: RepeatFieldComm<T> where T <: MessageField {
    public PackedField(val: ArrayList<T>) { super(val) }
    public func clone() { PackedField<T>(val.clone()) }

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
    let tag: Tag
    public init(tag: Tag, val: ArrayList<T>) { super(val); this.tag = tag }

    public func clone() {
        if (val.isEmpty() || !reference(val[0]) ) {
            return RepeatField<T>(tag, val.clone())
        }
        RepeatField<T>(tag, ArrayList<T>(val.size(), { i => (clone(val[i]) as T).getOrThrow() }))
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
public class PackedProxyField<T, P> <: RepeatFieldComm<T> where T <: MessageField, P <: Proxy<T> {
    public PackedProxyField(val: ArrayList<T>) { super(val) }
    public func clone() { PackedProxyField<T, P>(val.clone()) }

    func itemSize() {
        var len = 0
        for (v in val) {
            len += P.box(v).packSize()
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
            P.box(v).pack(out)
        }
    }
}

/* repeated fields for sint64,sint32,sfixed64,sfixed32,fixed64,fixed32 */
public class RepeatProxyField<T, P> <: RepeatFieldComm<T> where T <: MessageField, P <: Proxy<T> {
    let tag: Tag
    public init(tag: Tag, val: ArrayList<T>) { super(val); this.tag = tag }
    public func clone() { RepeatProxyField<T, P>(tag, val.clone()) }

    public func packSize() {
        var len = tag.tagSize * (val.size() - 1)
        for (v in val) {
            len += P.box(v).packSize()
        }
        len
    }

    public func pack(out: BytesWriter) {
        P.box(val[0]).pack(out)
        let wt = wireType(P.box(val[0]))
        for (i in 1..val.size()) {
            tag.tagPack(wt, out)
            P.box(val[i]).pack(out)
        }
    }
}

public type PackedSInt64 = PackedProxyField<Int64, SInt64>
public type PackedSInt32 = PackedProxyField<Int32, SInt32>
public type PackedSFixed64 = PackedProxyField<Int64, SFixed64>
public type PackedSFixed32 = PackedProxyField<Int32, SFixed32>
public type PackedFixed64 = PackedProxyField<UInt64, Fixed64>
public type PackedFixed32 = PackedProxyField<UInt32, Fixed32>

public type RepeatSInt64 = RepeatProxyField<Int64, SInt64>
public type RepeatSInt32 = RepeatProxyField<Int32, SInt32>
public type RepeatSFixed64 = RepeatProxyField<Int64, SFixed64>
public type RepeatSFixed32 = RepeatProxyField<Int32, SFixed32>
public type RepeatFixed64 = RepeatProxyField<UInt64, Fixed64>
public type RepeatFixed32 = RepeatProxyField<UInt32, Fixed32>

public abstract class MapFieldComm<K, V> <: ValuedMessageField & Reference & Stringify where K <: Hashable & Equatable<K> & MessageField, V <: MessageField {
    MapFieldComm(let tag: Tag, let val: HashMap<K, V>) { }
    public func value() { val }
    public func isEmpty() { val.isEmpty() }
    public func clone(): MapFieldComm<K, V>

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

/* todo ValuedField K, V not support yet */
public class MapField<K, V> <: MapFieldComm<K, V> where K <: Hashable & Equatable<K> & MessageField, V <: MessageField {
    public MapField(tag: Tag, val: HashMap<K, V>) { super(tag, val)}

    public func clone(): MapField<K, V> {
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
        case _: ArrayList<Byte> => true
        case _ => false
    }
}

func clone(val: MessageField): MessageField {
    match (val) {
        case c: Reference => c.clone()
        case c: MessageLite => c.clone()
        case c: ArrayList<Byte> => c.clone()
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
        case c: ValuedEnum => os.append("\"${c.toString()}\"")
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