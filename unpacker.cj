/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

package protobuf

public interface Unpacker {
    /* unpack a special message field from bytes reader */
    func unpack(src: BytesReader): MessageField
    /* unpack a special message field from Json */
    func unpack(src: Json): MessageField
    /* the dafault value of the special message field's type */
    func default(): MessageField
}

/* cangjie 0.30.4 bug, `TypedUnpacker<T> <: Unpacker` will aborted when unpacking. */
public class UInt64Unpacker <: Unpacker {
    public static let instance = UInt64Unpacker()
    public static let packedInstance = RepeatUnpacker<UInt64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<UInt64>(tag, instance) }
    public static let unbox = UnBox<UInt64>(fieldPass<UInt64>, instance)
    public func unpack(src: BytesReader): MessageField { UInt64.parse(src) }
    public func unpack(src: Json): MessageField { UInt64.parse(src) }
    public func default(): MessageField { UInt64(0) }
}

public class Int64Unpacker <: Unpacker {
    public static let instance = Int64Unpacker()
    public static let packedInstance = RepeatUnpacker<Int64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Int64>(tag, instance) }
    public static let unbox = UnBox<Int64>(fieldPass<Int64>, instance)
    public func unpack(src: BytesReader): MessageField { Int64.parse(src) }
    public func unpack(src: Json): MessageField { Int64.parse(src) }
    public func default(): MessageField { 0 }
}

public class UInt32Unpacker <: Unpacker {
    public static let instance = UInt32Unpacker()
    public static let packedInstance = RepeatUnpacker<UInt32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<UInt32>(tag, instance) }
    public static let unbox = UnBox<UInt32>(fieldPass<UInt32>, instance)
    public func unpack(src: BytesReader): MessageField { UInt32.parse(src) }
    public func unpack(src: Json): MessageField { UInt32.parse(src) }
    public func default(): MessageField { UInt32(0) }
}

public class Int32Unpacker <: Unpacker {
    public static let instance = Int32Unpacker()
    public static let packedInstance = RepeatUnpacker<Int32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Int32>(tag, instance) }
    public static let unbox = UnBox<Int32>(fieldPass<Int32>, instance)
    public func unpack(src: BytesReader): MessageField { Int32.parse(src) }
    public func unpack(src: Json): MessageField { Int32.parse(src) }
    public func default(): MessageField { Int32(0) }
}

public class BoolUnpacker <: Unpacker {
    public static let instance = BoolUnpacker()
    public static let packedInstance = RepeatUnpacker<Bool>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Bool>(tag, instance) }
    public static let unbox = UnBox<Bool>(fieldPass<Bool>, instance)
    public func unpack(src: BytesReader): MessageField { Bool.parse(src) }
    public func unpack(src: Json): MessageField { src.asBoolean() }
    public func default(): MessageField { false }
}

/* cangjie 0.30.4, error: no method 'fromBytes' match for generic member access function call when searching in upper bounds */
func parseInt32(src:BytesReader) {
    Int32.parse(src)
}
func parseInt64(src:BytesReader) {
    Int64.parse(src)
}

/* cangjie 0.31.4, error: static default implement in interface cannot call other static non implement */
func parseEnum<E>(src: Json) where E <: Enum<E> {
    match (src) {
        case c: JsonString => E.parse(c)
        case c: JsonNumber => E.parse(Int32(c))
        case _ => throw Exception()
    }
}

public class EnumUnpacker<E> <: Unpacker where E <: Enum<E> {
    public static let instance = EnumUnpacker<E>()
    public static let packedInstance = RepeatUnpacker<E>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<E>(tag, instance) }
    public static let unbox = UnBox<E>(fieldPass<E>, instance)
    public func unpack(src: BytesReader): MessageField { E.parse(parseInt32(src)) /* Int32.parse(src) will not be compiled successfully */ }
    public func unpack(src: Json): MessageField { parseEnum<E>(src) }
    public func default(): MessageField { E.parse(0) }
}

public class MessageUnpacker<M> <: Unpacker where M <: MessageLite & MessageParser<M> {
    public static let instance = MessageUnpacker<M>()
    public static let packedInstance = RepeatUnpacker<M>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<M>(tag, instance) }
    public static let unbox = UnBox<M>(fieldPass<M>, instance)
    public func unpack(src: BytesReader): MessageField { M.fromBytes(src.read(parseInt64(src))) }
    public func unpack(src: Json): MessageField { M.fromJson(src.asObject()) }
    public func default(): MessageField { M.fromBytes(SimpleReader([])) }
}

/* parse bytes from json, at present, bytes only supports to parse/stringify as uint8 array. */
func parseBytes(src: Json) {
    let arr = Bytes()
    /* parse as uint8 array */
    for (v in src.asArray()) {
        arr.append(UInt8(v.asNumber()))
    }
    arr
}

public class BytesUnpacker <: Unpacker {
    public static let instance = BytesUnpacker()
    public static let packedInstance = RepeatUnpacker<Bytes>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Bytes>(tag, instance) }
    public static let unbox = UnBox<Bytes>(fieldPass<Bytes>, instance)
    public func unpack(src: BytesReader): MessageField { Bytes(src.read(Int64.parse(src)).data()) }
    public func unpack(src: Json): MessageField { parseBytes(src) }
    public func default(): MessageField { Bytes() }
}

public class StringUnpacker <: Unpacker {
    public static let instance = StringUnpacker()
    public static let packedInstance = RepeatUnpacker<String>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<String>(tag, instance) }
    public static let unbox = UnBox<String>(fieldPass<String>, instance)
    public func unpack(src: BytesReader): MessageField { String.parse(src) }
    public func unpack(src: Json): MessageField { src.asString() }
    public func default(): MessageField { "" }
}

public class Float32Unpacker <: Unpacker {
    public static let instance = Float32Unpacker()
    public static let packedInstance = RepeatUnpacker<Float32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Float32>(tag, instance) }
    public static let unbox = UnBox<Float32>(fieldPass<Float32>, instance)
    public func unpack(src: BytesReader): MessageField { Float32.fixedParse(src) }
    public func unpack(src: Json): MessageField { Float32(src.asNumber()) }
    public func default(): MessageField { Float32(.0) }
}

public class Float64Unpacker <: Unpacker {
    public static let instance = Float64Unpacker()
    public static let packedInstance = RepeatUnpacker<Float64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Float64>(tag, instance) }
    public static let unbox = UnBox<Float64>(fieldPass<Float64>, instance)
    public func unpack(src: BytesReader): MessageField { Float64.fixedParse(src) }
    public func unpack(src: Json): MessageField { Float64(src.asNumber()) }
    public func default(): MessageField { .0 }
}

public class Fixed32Unpacker <: Unpacker {
    public static let instance = Fixed32Unpacker()
    public static let packedInstance = RepeatProxyUnpacker<UInt32, Fixed32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatProxyUnpacker<UInt32, Fixed32>(tag, instance) }
    public static let unbox = UnBox<UInt32>(Fixed32.box, instance)
    public func unpack(src: BytesReader): MessageField { Fixed32(UInt32.fixedParse(src)) }
    public func unpack(src: Json): MessageField { Fixed32(UInt32.parse(src)) }
    public func default(): MessageField { Fixed32(0) }
}

public class Fixed64Unpacker <: Unpacker {
    public static let instance = Fixed64Unpacker()
    public static let packedInstance = RepeatProxyUnpacker<UInt64, Fixed64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatProxyUnpacker<UInt64, Fixed64>(tag, instance) }
    public static let unbox = UnBox<UInt64>(Fixed64.box, instance)
    public func unpack(src: BytesReader): MessageField { Fixed64(UInt64.fixedParse(src)) }
    public func unpack(src: Json): MessageField { Fixed64(UInt64.parse(src)) }
    public func default(): MessageField { Fixed64(0) }
}

public class SFixed32Unpacker <: Unpacker {
    public static let instance = SFixed32Unpacker()
    public static let packedInstance = RepeatProxyUnpacker<Int32, SFixed32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatProxyUnpacker<Int32, SFixed32>(tag, instance) }
    public static let unbox = UnBox<Int32>(SFixed32.box, instance)
    public func unpack(src: BytesReader): MessageField { SFixed32(Int32.fixedParse(src)) }
    public func unpack(src: Json): MessageField { SFixed32(Int32.parse(src)) }
    public func default(): MessageField { SFixed32(0) }
}

public class SFixed64Unpacker <: Unpacker {
    public static let instance = SFixed64Unpacker()
    public static let packedInstance = RepeatProxyUnpacker<Int64, SFixed64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatProxyUnpacker<Int64, SFixed64>(tag, instance) }
    public static let unbox = UnBox<Int64>(SFixed64.box, instance)
    public func unpack(src: BytesReader): MessageField { SFixed64(Int64.fixedParse(src)) }
    public func unpack(src: Json): MessageField { SFixed64(Int64.parse(src)) }
    public func default(): MessageField { SFixed64(0) }
}

public class SInt64Unpacker <: Unpacker {
    public static let instance = SInt64Unpacker()
    public static let packedInstance = RepeatProxyUnpacker<Int64, SInt64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatProxyUnpacker<Int64, SInt64>(tag, instance) }
    public static let unbox = UnBox<Int64>(SInt64.box, instance)
    public func unpack(src: BytesReader): MessageField { SInt64(UInt64.parse(src).unzigzag()) }
    public func unpack(src: Json): MessageField { SInt64(Int64.parse(src)) }
    public func default(): MessageField { SInt64(0) }
}

public class SInt32Unpacker <: Unpacker {
    public static let instance = SInt32Unpacker()
    public static let packedInstance = RepeatProxyUnpacker<Int32, SInt32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatProxyUnpacker<Int32, SInt32>(tag, instance) }
    public static let unbox = UnBox<Int32>(SInt32.box, instance)
    public func unpack(src: BytesReader): MessageField { SInt32(UInt32.parse(src).unzigzag()) }
    public func unpack(src: Json): MessageField { SInt32(Int32.parse(src)) }
    public func default(): MessageField { SInt32(0) }
}

/* parse array from json */
func parseArray<T>(src: Json, unpack: (Json) -> MessageField) where T <: MessageField {
    let arr = ArrayList<T>()
    for (v in src.asArray()) {
        arr.append(typeCast(unpack(v)))
    }
    arr
}

/* unpacker for repeated for native types */
public class RepeatUnpacker<T> <: Unpacker where T <: MessageField {
    public RepeatUnpacker(let tag: Tag, let unpacker: Unpacker) {}
    public init(packed: Unpacker) { unpacker = packed; tag = 0 }

    private func packedUnpack(src: BytesReader) {
        let arr = ArrayList<T>()
        let sub = src.read(parseInt64(src))
        while (!sub.isEmpty()) {
            arr.append(typeCast(unpacker.unpack(sub)))
        }
        PackedField<T>(arr)
    }

    private func repeatUnpack(src: BytesReader) {
        let arr = ArrayList<T>()
        while (true) {
            arr.append(typeCast(unpacker.unpack(src)))

            /* try to get the next tag, break if not equlas to `tag`. */
            if (!tag.tagGetNext(src)) {
                break
            }
        }
        RepeatField<T>(tag, arr)
    }

    public func unpack(src: BytesReader): RepeatFieldComm<T> {
        if (tag == 0) {
            return packedUnpack(src)
        }
        repeatUnpack(src)
    }

    public func unpack(src: Json): RepeatFieldComm<T> {
        let arr = parseArray<T>(src, unpacker.unpack)
        if (tag == 0) {
            return PackedField<T>(arr)
        }
        RepeatField<T>(tag, arr)
    }

    public func default(): RepeatFieldComm<T> {
        if (tag == 0) {
            return PackedField<T>(ArrayList())
        }
        RepeatField<T>(tag, ArrayList())
    }
}

/* unpacker for repeated for proxy types */
public class RepeatProxyUnpacker<T, P> <: Unpacker where T <: MessageField, P <: Proxy<T> {
    public RepeatProxyUnpacker(let tag: Tag, let unpacker: Unpacker) {}
    public init(packed: Unpacker) { unpacker = packed; tag = 0 }

    private func packedUnpack(src: BytesReader) {
        let arr = ArrayList<T>()
        let sub = src.read(parseInt64(src))
        while (!sub.isEmpty()) {
            arr.append(typeCast(unpacker.unpack(sub)))
        }
        PackedProxyField<T, P>(arr)
    }

    private func repeatUnpack(src: BytesReader) {
        let arr = ArrayList<T>()
        while (true) {
            arr.append(typeCast(unpacker.unpack(src)))

            /* try to get the next tag, break if not equlas to `tag`. */
            if (!tag.tagGetNext(src)) {
                break
            }
        }
        RepeatProxyField<T, P>(tag, arr)
    }

    public func unpack(src: BytesReader): RepeatFieldComm<T> {
        if (tag == 0) {
            return packedUnpack(src)
        }
        repeatUnpack(src)
    }

    public func unpack(src: Json): RepeatFieldComm<T> {
        let arr = parseArray<T>(src, unpacker.unpack)
        if (tag == 0) {
            return PackedProxyField<T, P>(arr)
        }
        RepeatProxyField<T, P>(tag, arr)
    }

    public func default(): RepeatFieldComm<T> {
        if (tag == 0) {
            return PackedProxyField<T, P>(ArrayList())
        }
        RepeatProxyField<T, P>(tag, ArrayList())
    }
}

/* group of unpacker and proxy's box */
public class UnBox<T> where T <: MessageField {
    UnBox(
        let box: (T) -> MessageField,   /* box function used in map field */
        let unpacker: Unpacker          /* unpack functions used in map unpacker */
    ) { }
}

/* unpacker for maps */
public class MapUnpacker<K, V> <: Unpacker where K <: Hashable & Equatable<K> & MessageField, V <: MessageField {
    public MapUnpacker(let tag: Tag, let ku: UnBox<K>, let vu: UnBox<V>) { }
    public func default(): MessageField { MapField<K, V>(tag, HashMap(), kb: ku.box, vb: vu.box) }

    public func unpack(src: BytesReader): MessageField {
        let map = HashMap<K, V>()
        var key: MessageField
        var val: MessageField

        while (true) {
            key = ku.unpacker.default()
            val = vu.unpacker.default()

            let sub = src.read(parseInt64(src))
            while (!sub.isEmpty()) {
                match (Tag.tagParse(sub)[0]) {
                    case 1 => key = ku.unpacker.unpack(sub)
                    case 2 => val = vu.unpacker.unpack(sub)
                    case e => throw Exception() // todo
                }
            }

            map[typeCast(key)] = typeCast(val)

            /* try to get the next tag, break if not equlas to `tag`. */
            if (!tag.tagGetNext(src)) {
                break
            }
        }
        MapField<K, V>(tag, map, kb: ku.box, vb: vu.box)
    }

    public func unpack(src: Json): MessageField {
        let map = HashMap<K, V>()
        for ((k, v) in src.asObject()) {
            map[typeCast(ku.unpacker.unpack(k))] = typeCast(vu.unpacker.unpack(v))
        }
        MapField<K, V>(tag, map, kb: ku.box, vb: vu.box)
    }
}