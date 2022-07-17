/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

package protobuf

public interface Unpacker {
    func unpack(src: BytesReader): MessageField
    func default(): MessageField
}

public class UInt64Unpacker <: Unpacker {
    public static let instance = UInt64Unpacker()
    public static let packedInstance = RepeatUnpacker<UInt64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<UInt64>(tag, instance) }
    public func unpack(src: BytesReader): MessageField { UInt64.parse(src) }
    public func default(): MessageField { UInt64(0) }
}

public class Int64Unpacker <: Unpacker {
    public static let instance = Int64Unpacker()
    public static let packedInstance = RepeatUnpacker<Int64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Int64>(tag, instance) }
    public func unpack(src: BytesReader): MessageField { Int64.parse(src) }
    public func default(): MessageField { 0 }
}

public class UInt32Unpacker <: Unpacker {
    public static let instance = UInt32Unpacker()
    public static let packedInstance = RepeatUnpacker<UInt32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<UInt32>(tag, instance) }
    public func unpack(src: BytesReader): MessageField { UInt32.parse(src) }
    public func default(): MessageField { UInt32(0) }
}

public class Int32Unpacker <: Unpacker {
    public static let instance = Int32Unpacker()
    public static let packedInstance = RepeatUnpacker<Int32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Int32>(tag, instance) }
    public func unpack(src: BytesReader): MessageField { Int32.parse(src) }
    public func default(): MessageField { Int32(0) }
}

public class BoolUnpacker <: Unpacker {
    public static let instance = BoolUnpacker()
    public static let packedInstance = RepeatUnpacker<Bool>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Bool>(tag, instance) }
    public func unpack(src: BytesReader): MessageField { Bool.parse(src) }
    public func default(): MessageField { false }
}

public class EnumUnpacker<E> <: Unpacker where E <: Enum<E> {
    public static let instance = EnumUnpacker<E>()
    public static let packedInstance = RepeatUnpacker<E>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<E>(tag, instance) }
    public func unpack(src: BytesReader): MessageField { E.parse(Int32.parse(src)) }
    public func default(): MessageField { E.parse(0) }
}

public class MessageUnpacker<M> <: Unpacker where M <: MessageLite & MessageParser<M> {
    public static let instance = MessageUnpacker<M>()
    public static let packedInstance = RepeatUnpacker<M>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<M>(tag, instance) }
    public func unpack(src: BytesReader): MessageField { M.fromBytes(src.read(Int64.parse(src))) }
    public func default(): MessageField { M.fromBytes([]) }
}

public class BytesUnpacker <: Unpacker {
    public static let instance = BytesUnpacker()
    public static let packedInstance = RepeatUnpacker<Bytes>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Bytes>(tag, instance) }
    public func unpack(src: BytesReader): MessageField { Bytes(src.read(Int64.parse(src)).data()) }
    public func default(): MessageField { Bytes() }
}

public class StringUnpacker <: Unpacker {
    public static let instance = StringUnpacker()
    public static let packedInstance = RepeatUnpacker<String>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<String>(tag, instance) }
    public func unpack(src: BytesReader): MessageField { String.parse(src) }
    public func default(): MessageField { "" }
}

public class Float32Unpacker <: Unpacker {
    public static let instance = Float32Unpacker()
    public static let packedInstance = RepeatUnpacker<Float32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Float32>(tag, instance) }
    public func unpack(src: BytesReader): MessageField { Float32.fixedParse(src) }
    public func default(): MessageField { Float32(.0) }
}

public class Float64Unpacker <: Unpacker {
    public static let instance = Float64Unpacker()
    public static let packedInstance = RepeatUnpacker<Float64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Float64>(tag, instance) }
    public func unpack(src: BytesReader): MessageField { Float64.fixedParse(src) }
    public func default(): MessageField { .0 }
}

public class Fixed32Unpacker <: Unpacker {
    public static let instance = Fixed32Unpacker()
    public static let packedInstance = RepeatUnpacker<UInt32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<UInt32>(tag, instance) }
    public func unpack(src: BytesReader): MessageField { Fixed32(UInt32.fixedParse(src)) }
    public func default(): MessageField { Fixed32(0) }
}

public class Fixed64Unpacker <: Unpacker {
    public static let instance = Fixed64Unpacker()
    public static let packedInstance = RepeatUnpacker<UInt64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<UInt64>(tag, instance) }
    public func unpack(src: BytesReader): MessageField { Fixed64(UInt64.fixedParse(src)) }
    public func default(): MessageField { Fixed64(0) }
}

public class SFixed32Unpacker <: Unpacker {
    public static let instance = SFixed32Unpacker()
    public static let packedInstance = RepeatUnpacker<Int32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Int32>(tag, instance) }
    public func unpack(src: BytesReader): MessageField { SFixed32(Int32.fixedParse(src)) }
    public func default(): MessageField { SFixed32(0) }
}

public class SFixed64Unpacker <: Unpacker {
    public static let instance = SFixed64Unpacker()
    public static let packedInstance = RepeatUnpacker<Int64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Int64>(tag, instance) }
    public func unpack(src: BytesReader): MessageField { SFixed64(Int64.fixedParse(src)) }
    public func default(): MessageField { SFixed64(0) }
}

public class SInt64Unpacker <: Unpacker {
    public static let instance = SInt64Unpacker()
    public static let packedInstance = RepeatUnpacker<Int64>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Int64>(tag, instance) }
    public func unpack(src: BytesReader): MessageField { SInt64(UInt64.parse(src).unzigzag()) }
    public func default(): MessageField { SInt64(0) }
}

public class SInt32Unpacker <: Unpacker {
    public static let instance = SInt32Unpacker()
    public static let packedInstance = RepeatUnpacker<Int32>(instance)
    public static func repeatInstance(tag: Tag) { RepeatUnpacker<Int32>(tag, instance) }
    public func unpack(src: BytesReader): MessageField { SInt32(UInt32.parse(src).unzigzag()) }
    public func default(): MessageField { SInt32(0) }
}

public class RepeatUnpacker<T> <: Unpacker where T <: MessageField {
    public RepeatUnpacker(let tag: Tag, let unpacker: Unpacker) {}
    public init(packed: Unpacker) { unpacker = packed; tag = 0 }

    private func packedUnpack(src: BytesReader): PackedField<T> {
        let arr = ArrayList<T>()
        let ret = PackedField<T>(arr)
        let sub = src.read(Int64.parse(src))
        while (!sub.isEmpty()) {
            arr.append(match (unpacker.unpack(sub)) {
                case val: ValuedMessageField => (val.value() as T).getOrThrow()
                case val => (val as T).getOrThrow()
            })
        }
        ret
    }

    private func repeatUnpack(src: BytesReader): RepeatField<T> {
        let arr = ArrayList<T>()
        let ret = RepeatField<T>(tag, arr)
        while (true) {
            arr.append(match (unpacker.unpack(src)) {
                case val: ValuedMessageField => (val.value() as T).getOrThrow()
                case val => (val as T).getOrThrow()
            })

            if (src.isEmpty()) {
                break
            }

            /* parse the next tag, break if not equlas to `tag`. */
            let (t, _) = Tag.tagParse(src)
            if (t != tag) {
                src.seek(-t.tagSize, CurPos)
                break
            }
        }
        ret
    }

    public func unpack(src: BytesReader): MessageField {
        if (tag == 0) {
            return packedUnpack(src)
        }
        repeatUnpack(src)
    }

    public func default(): MessageField {
        if (tag == 0) {
            return PackedField<T>(ArrayList<T>())
        }
        RepeatField<T>(tag, ArrayList<T>())
    }
}
