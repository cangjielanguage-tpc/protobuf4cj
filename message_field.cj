/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

package protobuf

from json import json.{ Json, ToJson, JsonString, JsonArray, JsonNumber }
public from json import json.{ JsonReader, JsonStringReader, JsonObject }

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
    @overflowWrapping
    public func packSize() { UInt64(this).varintSize }
    @overflowWrapping
    public func pack(out: BytesWriter) { UInt64(this).varintPack(out) }
    public func isEmpty() { this == 0 }
}

extend UInt32 <: MessageField & Varint {
    public func packSize() { UInt64(this).varintSize }
    public func pack(out: BytesWriter) { UInt64(this).varintPack(out) }
    public func isEmpty() { this == 0 }
}

extend Int32 <: MessageField & Varint {
    @overflowWrapping
    public func packSize() { UInt64(this).varintSize }
    @overflowWrapping
    public func pack(out: BytesWriter) { UInt64(this).varintPack(out) }
    public func isEmpty() { this == 0 }
}

extend Bool <: MessageField & Varint {
    public func packSize() { 1 }
    public func pack(out: BytesWriter) { UInt64(if (this) { 1 } else { 0 }).varintPack(out) }
    public func isEmpty() { !this }
}

public interface ValuedEnum <: MessageField & ToString & ToJson {
    func value(): Int32
    func packSize() { value().packSize() } /* cangjie 0.31.4 bug, varintSize undefined */
    func pack(out: BytesWriter) { value().pack(out) } /* cangjie 0.31.4 bug, varintPack undefined */
    func isEmpty() { value() == 0 }
    func toJson(): Json { toString() }
}

public interface Enum<E> <: ValuedEnum & Equatable<E> where E <: Enum<E> {
    static func parse(v: Int32): E
    static func parse(v: String): E
    operator func==(e: E) { value() == e.value() }
    operator func!=(e: E) { value() != e.value() }
}

extend Float32 <: MessageField & Bit32 {
    public func isEmpty() { this == .0 }
    public func packSize() { 4 }
    public func pack(out: BytesWriter) { fixedPack(out) }
}

extend Float64 <: MessageField & Bit64 {
    public func isEmpty() { this == .0 }
    public func packSize() { 8 }
    public func pack(out: BytesWriter) { fixedPack(out) }
}

extend String <: MessageField {
    public func packSize() { let len = this.utf8View.size; len.packSize() + len }
    public func pack(out: BytesWriter) { let arr = this.toUtf8Array(); arr.size.pack(out); out.appendAll(arr) }
}

/* bytes */
extend ArrayList<T> <: MessageField where T <: Byte { /* cannot extend ArrayList<Byte> to Reference yet. */
    public func packSize() { size.packSize() + size }
    public func pack(out: BytesWriter) { size.pack(out); out.appendAll((this as Bytes).getOrThrow()) }
}

/* get origin value from field by `value` */
public interface Value<T> <: MessageField {
    func value(): T
}

/* `box` trans `T` to `Proxy<T>` */
public interface Proxy<T> <: Value<T> & ToJson where T <: MessageField {
    static func box(v: T): Proxy<T>
}

public struct SInt64 <: Proxy<Int64> & Varint {
    public SInt64(let val: Int64) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { val.zigzag().packSize() }
    public func pack(out: BytesWriter) { val.zigzag().pack(out) }
    public func toString() { val.toString() }
    public func toJson(): Json { Float64(val) }
    public static func box(val: Int64): Proxy<Int64> { SInt64(val) }
}

public struct SInt32 <: Proxy<Int32> & Varint {
    public SInt32(let val: Int32) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { val.zigzag().packSize() }
    public func pack(out: BytesWriter) { val.zigzag().pack(out) }
    public func toString() { val.toString() }
    public func toJson(): Json { Float64(val) }
    public static func box(val: Int32): Proxy<Int32> { SInt32(val) }
}

public struct SFixed64 <: Proxy<Int64> & Bit64 {
    public SFixed64(let val: Int64) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { 8 }
    public func pack(out: BytesWriter) { val.fixedPack(out) }
    public func toString() { val.toString() }
    public func toJson(): Json { Float64(val) }
    public static func box(val: Int64): Proxy<Int64> { SFixed64(val) }
}

public struct SFixed32 <: Proxy<Int32> & Bit32 {
    public SFixed32(let val: Int32) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { 4 }
    public func pack(out: BytesWriter) { val.fixedPack(out) }
    public func toString() { val.toString() }
    public func toJson(): Json { Float64(val) }
    public static func box(val: Int32): Proxy<Int32> { SFixed32(val) }
}

public struct Fixed64 <: Proxy<UInt64> & Bit64 {
    public Fixed64(let val: UInt64) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { 8 }
    public func pack(out: BytesWriter) { val.fixedPack(out) }
    public func toString() { val.toString() }
    public func toJson(): Json { Float64(val) }
    public static func box(val: UInt64): Proxy<UInt64> { Fixed64(val) }
}

public struct Fixed32 <: Proxy<UInt32> & Bit32 {
    public Fixed32(let val: UInt32) { }
    public func value() { val }
    public func isEmpty() { val == 0 }
    public func packSize() { 4 }
    public func pack(out: BytesWriter) { val.fixedPack(out) }
    public func toString() { val.toString() }
    public func toJson(): Json { Float64(val) }
    public static func box(val: UInt32): Proxy<UInt32> { Fixed32(val) }
}

/* all repeated fields comm isEmpty, toString, toJson */
public abstract class RepeatFieldComm<T> <: Value<ArrayList<T>> & ToJson & Reference where T <: MessageField {
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

    public func toJson(): Json {
        JsonArray(val.size, { i => toJson(val[i]) })
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
        RepeatField<T>(tag, ArrayList<T>(val.size, { i => (clone(val[i]) as T).getOrThrow() }))
    }

    public func packSize() {
        var len = tag.tagSize * (val.size - 1)
        for (v in val) {
            len += packSize(v)
        }
        len
    }

    public func pack(out: BytesWriter) {
        pack(val[0], out)
        let wt = wireType(val[0])
        for (i in 1..val.size) {
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
        var len = tag.tagSize * (val.size - 1)
        for (v in val) {
            len += P.box(v).packSize()
        }
        len
    }

    public func pack(out: BytesWriter) {
        P.box(val[0]).pack(out)
        let wt = wireType(P.box(val[0]))
        for (i in 1..val.size) {
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

/* trans native type value to message field */
public func fieldPass<T>(val: T): MessageField where T <: MessageField { val }

/*
 * map<k, v> fields, set parameter `kb` or `kv` when `k` or `v` is proxy type
 * for example, creating a map<sint32, string> field by `MapField<Int32, String>(1, HashMap(), kb: SInt32.box)`
 */
public class MapField<K, V> <: Value<HashMap<K, V>> & Reference & ToJson where K <: Hashable & Equatable<K> & MessageField, V <: MessageField {
    static func kPass(k: K): MessageField { k }
    static func vPass(v: V): MessageField { v }

    public MapField(let tag: Tag, let val: HashMap<K, V>,
        let kb!: (K) -> MessageField = fieldPass<K>,   /* box function of key */
        let vb!: (V) -> MessageField = fieldPass<V>    /* box function of value */
    ) { }

    public func value() { val }
    public func isEmpty() { val.isEmpty() }

    public func clone(): MapField<K, V> {
        let map = val.clone()
        for ((k, v) in map) {
            /* deep copy all the reference fields */
            if (!reference(v)) {
                break
            }
            /* `v` is a value with native type */
            map[k] = (clone(v) as V).getOrThrow()
        }

        MapField<K, V>(tag, map, kb: kb, vb: vb)
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

    public func toJson(): Json {
        let obj = JsonObject()
        for ((k, v) in val) {
            obj[k.toString()] = toJson(v)
        }
        obj
    }

    /* map will not pack any empty fields */
    public func packSize() {
        var len = tag.tagSize * (val.size - 1)
        for ((k, v) in val) {
            /* length of key-value */
            var sub = 0
            /* kb isEmpty when and only when b isEmpty */
            if (!k.isEmpty()) {
                /* k will never be message, so kb(k).packSize() rather than packSize(kb(k)) */
                sub += 1 + kb(k).packSize()
            }
            if (!v.isEmpty()) {
                sub += 1 + packSize(vb(v))
            }
            len += sub.packSize() + sub
        }
        len
    }

    public func pack(out: BytesWriter) {
        /* tag pack flag, this first tag has packed before */
        var flag = false
        /* boxed key, value */
        var kBox: MessageField
        var vBox: MessageField
        for ((k, v) in val) {
            if (flag) {
                tag.tagPack(WireType.PREFIXED, out)
            } else {
                flag = true
            }

            /* length of sub entry */
            var sub = 0
            kBox = kb(k)
            vBox = vb(v)
            if (!k.isEmpty()) {
                sub += 1 + kBox.packSize()
            }
            if (!v.isEmpty()) {
                sub += 1 + packSize(vBox)
            }
            sub.pack(out)

            if (!k.isEmpty()) {
                UInt32(1).tagPack(wireType(kBox), out)
                kBox.pack(out)
            }
            if (!v.isEmpty()) {
                UInt32(2).tagPack(wireType(vBox), out)
                /* `vBox` should be packed out byte `pack` rather than `vBox.pack` */
                pack(vBox, out)
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

func toJson(val: MessageField) {
    match (val) {
        case c: ToJson => c.toJson()
        case c: ArrayList<Byte> => JsonArray(c.size, { i => Float64(c[i])})
        case _ => throw Exception()
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

func typeCast<T>(val: MessageField): T {
    match (val) {
        case c: Value<T> => c.value()
        case _ => (val as T).getOrThrow()
    }
}