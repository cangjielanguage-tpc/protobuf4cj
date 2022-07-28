/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

package protobuf

public interface Unpacker {
    /* unpack a special message field from bytes reader */
    func unpack(src: BytesReader): MessageField
    /* the dafault value of the special message field's type */
    func default(): MessageField
}

/* unpacker for native types */
public interface TypedUnpacker<T> <: Unpacker where T <: MessageField {
    func unpack(src: BytesReader): T
    func default(): T
}

/* unpacker for proxy types, such as sint64, sint32, sfixed64... */
public interface ProxyUnpacker<T, P> <: Unpacker where T <: MessageField, P <: Proxy<T> {
    func unpack(src: BytesReader): P
    func default(): P
}

public class UInt64Unpacker <: TypedUnpacker<UInt64> {
    public static let instance = UInt64Unpacker()
    public static let packedInstance = RepeatUnpacker<UInt64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<UInt64>(tag, instance) }
    public static let unbox = UnBox<UInt64>(fieldPass<UInt64>, instance)
    public func unpack(src: BytesReader) { UInt64.parse(src) }
    public func default() { UInt64(0) }
}

public class Int64Unpacker <: TypedUnpacker<Int64> {
    public static let instance = Int64Unpacker()
    public static let packedInstance = RepeatUnpacker<Int64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Int64>(tag, instance) }
    public static let unbox = UnBox<Int64>(fieldPass<Int64>, instance)
    public func unpack(src: BytesReader) { Int64.parse(src) }
    public func default() { 0 }
}

public class UInt32Unpacker <: TypedUnpacker<UInt32> {
    public static let instance = UInt32Unpacker()
    public static let packedInstance = RepeatUnpacker<UInt32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<UInt32>(tag, instance) }
    public static let unbox = UnBox<UInt32>(fieldPass<UInt32>, instance)
    public func unpack(src: BytesReader) { UInt32.parse(src) }
    public func default() { UInt32(0) }
}

public class Int32Unpacker <: TypedUnpacker<Int32> {
    public static let instance = Int32Unpacker()
    public static let packedInstance = RepeatUnpacker<Int32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Int32>(tag, instance) }
    public static let unbox = UnBox<Int32>(fieldPass<Int32>, instance)
    public func unpack(src: BytesReader) { Int32.parse(src) }
    public func default() { Int32(0) }
}

public class BoolUnpacker <: TypedUnpacker<Bool> {
    public static let instance = BoolUnpacker()
    public static let packedInstance = RepeatUnpacker<Bool>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Bool>(tag, instance) }
    public static let unbox = UnBox<Bool>(fieldPass<Bool>, instance)
    public func unpack(src: BytesReader) { Bool.parse(src) }
    public func default() { false }
}

/* cangjie 0.30.4, error: no method 'fromBytes' match for generic member access function call when searching in upper bounds */
func parseInt32(src:BytesReader) {
    Int32.parse(src)
}
func parseInt64(src:BytesReader) {
    Int64.parse(src)
}

public class EnumUnpacker<E> <: TypedUnpacker<E> where E <: Enum<E> {
    public static let instance = EnumUnpacker<E>()
    public static let packedInstance = RepeatUnpacker<E>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<E>(tag, instance) }
    public static let unbox = UnBox<E>(fieldPass<E>, instance)
    public func unpack(src: BytesReader) { E.parse(parseInt32(src)) /* Int32.parse(src) will not be compiled successfully */ }
    public func default() { E.parse(0) }
}

public class MessageUnpacker<M> <: TypedUnpacker<M> where M <: MessageLite & MessageParser<M> {
    public static let instance = MessageUnpacker<M>()
    public static let packedInstance = RepeatUnpacker<M>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<M>(tag, instance) }
    public static let unbox = UnBox<M>(fieldPass<M>, instance)
    public func unpack(src: BytesReader) { M.fromBytes(src.read(parseInt64(src))) }
    public func default() { M.fromBytes([]) }
}

public class BytesUnpacker <: TypedUnpacker<Bytes> {
    public static let instance = BytesUnpacker()
    public static let packedInstance = RepeatUnpacker<Bytes>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Bytes>(tag, instance) }
    public static let unbox = UnBox<Bytes>(fieldPass<Bytes>, instance)
    public func unpack(src: BytesReader) { Bytes(src.read(Int64.parse(src)).data()) }
    public func default() { Bytes() }
}

public class StringUnpacker <: TypedUnpacker<String> {
    public static let instance = StringUnpacker()
    public static let packedInstance = RepeatUnpacker<String>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<String>(tag, instance) }
    public static let unbox = UnBox<String>(fieldPass<String>, instance)
    public func unpack(src: BytesReader) { String.parse(src) }
    public func default() { "" }
}

public class Float32Unpacker <: TypedUnpacker<Float32> {
    public static let instance = Float32Unpacker()
    public static let packedInstance = RepeatUnpacker<Float32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Float32>(tag, instance) }
    public static let unbox = UnBox<Float32>(fieldPass<Float32>, instance)
    public func unpack(src: BytesReader) { Float32.fixedParse(src) }
    public func default() { Float32(.0) }
}

public class Float64Unpacker <: TypedUnpacker<Float64> {
    public static let instance = Float64Unpacker()
    public static let packedInstance = RepeatUnpacker<Float64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Float64>(tag, instance) }
    public static let unbox = UnBox<Float64>(fieldPass<Float64>, instance)
    public func unpack(src: BytesReader) { Float64.fixedParse(src) }
    public func default() { .0 }
}

public class Fixed32Unpacker <: ProxyUnpacker<UInt32, Fixed32> {
    public static let instance = Fixed32Unpacker()
    public static let packedInstance = RepeatProxyUnpacker<UInt32, Fixed32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatProxyUnpacker<UInt32, Fixed32>(tag, instance) }
    public static let unbox = UnBox<UInt32>(Fixed32.box, instance)
    public func unpack(src: BytesReader) { Fixed32(UInt32.fixedParse(src)) }
    public func default() { Fixed32(0) }
}

public class Fixed64Unpacker <: ProxyUnpacker<UInt64, Fixed64> {
    public static let instance = Fixed64Unpacker()
    public static let packedInstance = RepeatProxyUnpacker<UInt64, Fixed64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatProxyUnpacker<UInt64, Fixed64>(tag, instance) }
    public static let unbox = UnBox<UInt64>(Fixed64.box, instance)
    public func unpack(src: BytesReader) { Fixed64(UInt64.fixedParse(src)) }
    public func default() { Fixed64(0) }
}

public class SFixed32Unpacker <: ProxyUnpacker<Int32, SFixed32> {
    public static let instance = SFixed32Unpacker()
    public static let packedInstance = RepeatProxyUnpacker<Int32, SFixed32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatProxyUnpacker<Int32, SFixed32>(tag, instance) }
    public static let unbox = UnBox<Int32>(SFixed32.box, instance)
    public func unpack(src: BytesReader) { SFixed32(Int32.fixedParse(src)) }
    public func default() { SFixed32(0) }
}

public class SFixed64Unpacker <: ProxyUnpacker<Int64, SFixed64> {
    public static let instance = SFixed64Unpacker()
    public static let packedInstance = RepeatProxyUnpacker<Int64, SFixed64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatProxyUnpacker<Int64, SFixed64>(tag, instance) }
    public static let unbox = UnBox<Int64>(SFixed64.box, instance)
    public func unpack(src: BytesReader) { SFixed64(Int64.fixedParse(src)) }
    public func default() { SFixed64(0) }
}

public class SInt64Unpacker <: ProxyUnpacker<Int64, SInt64> {
    public static let instance = SInt64Unpacker()
    public static let packedInstance = RepeatProxyUnpacker<Int64, SInt64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatProxyUnpacker<Int64, SInt64>(tag, instance) }
    public static let unbox = UnBox<Int64>(SInt64.box, instance)
    public func unpack(src: BytesReader) { SInt64(UInt64.parse(src).unzigzag()) }
    public func default() { SInt64(0) }
}

public class SInt32Unpacker <: ProxyUnpacker<Int32, SInt32> {
    public static let instance = SInt32Unpacker()
    public static let packedInstance = RepeatProxyUnpacker<Int32, SInt32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatProxyUnpacker<Int32, SInt32>(tag, instance) }
    public static let unbox = UnBox<Int32>(SInt32.box, instance)
    public func unpack(src: BytesReader) { SInt32(UInt32.parse(src).unzigzag()) }
    public func default() { SInt32(0) }
}

/* unpacker for repeated for native types */
public class RepeatUnpacker<T> <: Unpacker where T <: MessageField {
    public RepeatUnpacker(let tag: Tag, let unpacker: TypedUnpacker<T>) {}
    public init(packed: TypedUnpacker<T>) { unpacker = packed; tag = 0 }

    private func packedUnpack(src: BytesReader) {
        let arr = ArrayList<T>()
        let sub = src.read(parseInt64(src))
        while (!sub.isEmpty()) {
            arr.append(unpacker.unpack(sub))
        }
        PackedField<T>(arr)
    }

    private func repeatUnpack(src: BytesReader) {
        let arr = ArrayList<T>()
        while (true) {
            arr.append(unpacker.unpack(src))

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

    public func default(): RepeatFieldComm<T> {
        if (tag == 0) {
            return PackedField<T>(ArrayList<T>())
        }
        RepeatField<T>(tag, ArrayList<T>())
    }
}

/* unpacker for repeated for proxy types */
public class RepeatProxyUnpacker<T, P> <: Unpacker where T <: MessageField, P <: Proxy<T> {
    public RepeatProxyUnpacker(let tag: Tag, let unpacker: ProxyUnpacker<T, P>) {}
    public init(packed: ProxyUnpacker<T, P>) { unpacker = packed; tag = 0 }

    private func packedUnpack(src: BytesReader) {
        let arr = ArrayList<T>()
        let sub = src.read(parseInt64(src))
        while (!sub.isEmpty()) {
            arr.append(unpacker.unpack(sub).value())
        }
        PackedProxyField<T, P>(arr)
    }

    private func repeatUnpack(src: BytesReader) {
        let arr = ArrayList<T>()
        while (true) {
            arr.append(unpacker.unpack(src).value())

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
    public func default() { MapField<K, V>(tag, HashMap(), kb: ku.box, vb: vu.box) }

    public func unpack(src: BytesReader) {
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

            map[match (key) {
                case k: Value<K> => k.value()
                case _ => (key as K).getOrThrow()
            }] = match (val) {
                case v: Value<V> => v.value()
                case _ => (val as V).getOrThrow()
            }
        }
        MapField<K, V>(tag, map, kb: ku.box, vb: vu.box)
    }
}