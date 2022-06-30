/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file about: Use the accessors provided by the subclass messages to access (get set pack unpack, etc.) specific data (fields).
 */
package protobuf

/* throws */
func dynamic_cast<T>(v: Any): T {
    (v as T).getOrThrow()
}

func escape(s: String) {
    let sb = StringBuilder()
    for (c in s) {
        match (c) {
            case '"' => sb.append("\\\"")
            case '\\' => sb.append("\\\\")
            case '\b' => sb.append("\\b")
            case '\f' => sb.append("\\f")
            case '\t' => sb.append("\\t")
            case '\n' => sb.append("\\n")
            case '\r' => sb.append("\\r")
            case _ => sb.append(c)
        }
    }
    sb.toString()
}

/**
 * The interface is Accessor, access all the message fields
 * @author tutudo
 * @since 0.29.3
 */
public interface Accessor {
    func pack(tag: Tag, val: Any, out: Bytes): Unit
    func unpack(tag: Tag, src: SimpleReader): Any
    func clone(val: Any): Any { val }
    func toString(val: Any) { dynamic_cast<ToString>(val).toString() }
    static func getInstance(): Accessor
}

/**
 * The interface is RepeatAccessor<T> inherited from Accessor where T <: ToString
 * access all the repeated fields, override the default `clone` and `toString`
 * @author tutudo
 * @since 0.29.3
 */
public interface RepeatAccessor<T> <: Accessor where T <: ToString {
    func clone(val: Any): Any { dynamic_cast<ArrayList<T>>(val).clone() }
    func toString(val: Any) { dynamic_cast<ArrayList<T>>(val).toString() }
}

/**
 * The class is Int32Accessor inherited from Accessor
 * @author tutudo
 * @since 0.29.3
 */
public class Int32Accessor <: Accessor {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, VARINT, out)
        varintPack(UInt64(dynamic_cast<Int32>(val)), out)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @return Type of Any
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader): Any {
        Int32(varintParse(src))
    }
    private static let instance = Int32Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * The class is UInt32Accessor inherited from Accessor
 * @author tutudo
 * @since 0.29.3
 */
public class UInt32Accessor <: Accessor {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, VARINT, out)
        varintPack(UInt64(dynamic_cast<UInt32>(val)), out)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @return Type of Any
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader): Any {
        UInt32(varintParse(src))
    }
    private static let instance = UInt32Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * The class is Int64Accessor inherited from Accessor
 * @author tutudo
 * @since 0.29.3
 */
public class Int64Accessor <: Accessor {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, VARINT, out)
        varintPack(UInt64(dynamic_cast<Int64>(val)), out)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @return Type of Any
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader): Any {
        Int64(varintParse(src))
    }
    private static let instance = Int64Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * The class is UInt64Accessor inherited from Accessor
 * @author tutudo
 * @since 0.29.3
 */
public class UInt64Accessor <: Accessor {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, VARINT, out)
        varintPack(dynamic_cast(val), out)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @return Type of Any
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader): Any {
        varintParse(src)
    }
    private static let instance = UInt64Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * The class is EnumAccessor<E> inherited from Accessor where E <: Enum<E>,enum E
 * @author tutudo
 * @since 0.29.3
 */
public class EnumAccessor<E> <: Accessor where E <: Enum<E> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, VARINT, out)
        varintPack(UInt64(dynamic_cast<E>(val).value()), out)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @return Type of Any
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader): Any {
        E.parse(Int32(varintParse(src)))
    }

    /**
     * The Function is toString
     *
     * @param val of Any
     *
     * @since 0.29.3
     */
    public func toString(val: Any) { "\"${dynamic_cast<E>(val)}\"" }
    private static let instance = EnumAccessor<E>()
    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * zigzag-encoding 128-base int32
 * @author tutudo
 * @since 0.29.3
 */
public class SInt32Accessor <: Accessor {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, VARINT, out)
        varintPack(UInt64(zigzag(dynamic_cast<Int32>(val))), out)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @return Type of Any
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader): Any {
        unzigzag(UInt32(varintParse(src)))
    }
    private static let instance = SInt32Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * zigzag-encoding 128-base int64
 * @author tutudo
 * @since 0.29.3
 */
public class SInt64Accessor <: Accessor {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, VARINT, out)
        varintPack(zigzag(dynamic_cast<Int64>(val)), out)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @return Type of Any
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader): Any {
        unzigzag(varintParse(src))
    }
    private static let instance = SInt64Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * bool, varint 0 or 1
 * @author tutudo
 * @since 0.29.3
 */
public class BoolAccessor <: Accessor {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, VARINT, out)
        varintPack(if (dynamic_cast(val)) { 1 } else { 0 }, out)
    }
    
    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @return Type of Any
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader): Any {
        varintParse(src) != 0
    }
    private static let instance = BoolAccessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/* length fixed 4-bytes signed int32 */

/**
 * The class is SFixed32Accessor inherited from Accessor
 * @author tutudo
 * @since 0.29.3
 */
public class SFixed32Accessor <: Accessor {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, BIT32, out)
        fixedPack(dynamic_cast<Int32>(val), out)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @return Type of Any
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader): Any {
        Int32(fixed32Parse(src))
    }
    private static let instance = SFixed32Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/* length fixed 4-bytes unsigned uint32 */

/**
 * The class is Fixed32Accessor inherited from Accessor
 * @author tutudo
 * @since 0.29.3
 */
public class Fixed32Accessor <: Accessor {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, BIT32, out)
        fixedPack(dynamic_cast<UInt32>(val), out)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @return Type of Any
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader): Any {
        fixed32Parse(src)
    }
    private static let instance = Fixed32Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * length fixed 4-bytes float32
 * @author tutudo
 * @since 0.29.3
 */
public class FloatAccessor <: Accessor {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, BIT32, out)
        fixedPack(dynamic_cast<Float32>(val), out)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @return Type of Any
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader): Any {
        floatBits(fixed32Parse(src))
    }
    private static let instance = FloatAccessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * length fixed 8-bytes signed int64
 * @author tutudo
 * @since 0.29.3
 */
public class SFixed64Accessor <: Accessor {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, BIT64, out)
        fixedPack(dynamic_cast<Int64>(val), out)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @return Type of Any
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader): Any {
        Int64(fixed64Parse(src))
    }

    private static let instance = SFixed64Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * length fixed 8-bytes unsigned uint64
 * @author tutudo
 * @since 0.29.3
 */
public class Fixed64Accessor <: Accessor {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, BIT64, out)
        fixedPack(dynamic_cast<UInt64>(val), out)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @return Type of Any
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader): Any {
        fixed64Parse(src)
    }

    private static let instance = Fixed64Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * Length fixed 8-bytes float64
 * @author tutudo
 * @since 0.29.3
 */
public class DoubleAccessor <: Accessor {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, BIT64, out)
        fixedPack(dynamic_cast<Float64>(val), out)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @return Type of Any
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader): Any {
        floatBits(fixed64Parse(src))
    }
    private static let instance = DoubleAccessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * string
 * @author tutudo
 * @since 0.29.3
 */
public class StringAccessor <: Accessor {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, PREFIXED, out)
        strPack(dynamic_cast(val), out)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @return Type of Any
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader): Any {
        String.fromUtf8(binParse(src).data())
    }

    /**
     * The Function is toString
     *
     * @param val of Any
     *
     * @since 0.29.3
     */
    public func toString(val: Any) { "\"${escape(dynamic_cast<String>(val))}\"" }
    private static let instance = StringAccessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * Bytes
 * @author tutudo
 * @since 0.29.3
 */
public class BytesAccessor <: RepeatAccessor<UInt8> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Bytes>(val)
        let len = UInt64(val.size())
        if (len > 0) {
            tagPack(tag, PREFIXED, out)
            varintPack(len, out)
            out.appendAll(val)
        }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @return Type of Any
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader): Any {
        Bytes(binParse(src).data())
    }
    private static let instance = BytesAccessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * message M 
 * @author tutudo
 * @since 0.29.3
 */
public class MessageAccessor<M> <: Accessor where M <: MessageLite & Default<M> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let tmp = Bytes()
        dynamic_cast<M>(val).pack(tmp)
        let len = UInt64(tmp.size())
        if (len > 0) {
            tagPack(tag, PREFIXED, out)
            varintPack(len, out)
            out.appendAll(tmp)
        }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @return Type of Any
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader): Any {
        M.default().unpack(binParse(src)) // unpack return MessageLite, if M needed, use dynamic_cast<M>
    }

    /**
     * The Function is clone
     *
     * @param val of Any
     *
     * @since 0.29.3
     */
    public func clone(val: Any) {
        dynamic_cast<M>(val).clone()
    }

    private static let instance = MessageAccessor<M>()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated int32 without `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class RepeatInt32Accessor <: RepeatAccessor<Int32> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Int32>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, VARINT, out)
            varintPack(UInt64(v), out)
        }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Int32>()
        while (true) {
            rv.append(Int32(varintParse(src)))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatInt32Accessor()
    
    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated int32 with `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class PackedInt32Accessor <: RepeatAccessor<Int32> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Int32>>(val)
        if (val.isEmpty()) { return }
        let tmp = Bytes()
        for (v in val) { varintPack(UInt64(v), tmp) }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(tmp.size()), out)
        out.appendAll(tmp)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Int32>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(Int32(varintParse(tmp))) }
        rv
    }
    private static let instance = PackedInt32Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated uint32 without `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class RepeatUInt32Accessor <: RepeatAccessor<UInt32> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<UInt32>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, VARINT, out)
            varintPack(UInt64(v), out)
        }
    }
    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<UInt32>()
        while (true) {
            rv.append(UInt32(varintParse(src)))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatUInt32Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated uint32 with `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class PackedUInt32Accessor <: RepeatAccessor<UInt32> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<UInt32>>(val)
        if (val.isEmpty()) { return }
        let tmp = Bytes()
        for (v in val) { varintPack(UInt64(v), tmp) }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(tmp.size()), out)
        out.appendAll(tmp)
    }
    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<UInt32>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(UInt32(varintParse(tmp))) }
        rv
    }
    private static let instance = PackedUInt32Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated int64 without `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class RepeatInt64Accessor <: RepeatAccessor<Int64> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Int64>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, VARINT, out)
            varintPack(UInt64(v), out)
        }
    }
    
    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Int64>()
        while (true) {
            rv.append(Int64(varintParse(src)))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatInt64Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}


/**
 * repeated int64 with `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class PackedInt64Accessor <: RepeatAccessor<Int64> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Int64>>(val)
        if (val.isEmpty()) { return }
        let tmp = Bytes()
        for (v in val) { varintPack(UInt64(v), tmp) }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(tmp.size()), out)
        out.appendAll(tmp)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Int64>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(Int64(varintParse(tmp))) }
        rv
    }
    private static let instance = PackedInt64Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated uint64 without `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class RepeatUInt64Accessor <: RepeatAccessor<UInt64> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<UInt64>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, VARINT, out)
            varintPack(v, out)
        }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<UInt64>()
        while (true) {
            rv.append(varintParse(src))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatUInt64Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated uint64 with `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class PackedUInt64Accessor <: RepeatAccessor<UInt64> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<UInt64>>(val)
        if (val.isEmpty()) { return }
        let tmp = Bytes()
        for (v in val) { varintPack(v, tmp) }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(tmp.size()), out)
        out.appendAll(tmp)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<UInt64>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(varintParse(tmp)) }
        rv
    }
    private static let instance = PackedUInt64Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated enum without `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class RepeatEnumAccessor<E> <: RepeatAccessor<E> where E <: Enum<E> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<E>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, VARINT, out)
            varintPack(UInt64(v.value()), out)
        }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<E>()
        while (true) {
            rv.append(E.parse(Int32(varintParse(src))))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }

    /**
     * The Function is toString
     *
     * @param val of Any
     *
     * @since 0.29.3
     */
    public func toString(val: Any) {
        let sb = StringBuilder("[")
        var dot = false
        let ss = dynamic_cast<ArrayList<E>>(val)
        for (s in ss) {
            if (dot) { sb.append(", ") } else { dot = true }
            sb.append('"').append(s).append('"')
        }
        sb.append(']').toString()
    }
    private static let instance = RepeatEnumAccessor<E>()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated enum with `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class PackedEnumAccessor<E> <: RepeatAccessor<E> where E <: Enum<E> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<E>>(val)
        if (val.isEmpty()) { return }
        let tmp = Bytes()
        for (v in val) { varintPack(UInt64(v.value()), tmp) }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(tmp.size()), out)
        out.appendAll(tmp)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<E>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(E.parse(Int32(varintParse(tmp)))) }
        rv
    }

    /**
     * The Function is toString
     *
     * @param val of Any
     *
     * @since 0.29.3
     */
    public func toString(val: Any) {
        let sb = StringBuilder("[")
        var dot = false
        let ss = dynamic_cast<ArrayList<E>>(val)
        for (s in ss) {
            if (dot) { sb.append(", ") } else { dot = true }
            sb.append('"').append(s).append('"')
        }
        sb.append(']').toString()
    }
    private static let instance = PackedEnumAccessor<E>()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated sint32 without `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class RepeatSInt32Accessor <: RepeatAccessor<Int32> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Int32>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, VARINT, out)
            varintPack(UInt64(zigzag(v)), out)
        }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Int32>()
        while (true) {
            rv.append(unzigzag(UInt32(varintParse(src))))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatSInt32Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated sint32 with `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class PackedSInt32Accessor <: RepeatAccessor<Int32> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Int32>>(val)
        if (val.isEmpty()) { return }
        let tmp = Bytes()
        for (v in val) { varintPack(UInt64(zigzag(v)), tmp) }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(tmp.size()), out)
        out.appendAll(tmp)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Int32>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(unzigzag(UInt32(varintParse(tmp)))) }
        rv
    }
    private static let instance = PackedSInt32Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated sint64 without `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class RepeatSInt64Accessor <: RepeatAccessor<Int64> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Int64>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, VARINT, out)
            varintPack(zigzag(v), out)
        }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Int64>()
        while (true) {
            rv.append(unzigzag(varintParse(src)))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatSInt64Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated sint64 with `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class PackedSInt64Accessor <: RepeatAccessor<Int64> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Int64>>(val)
        if (val.isEmpty()) { return }
        let tmp = Bytes()
        for (v in val) { varintPack(zigzag(v), tmp) }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(tmp.size()), out)
        out.appendAll(tmp)
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Int64>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(unzigzag(varintParse(tmp))) }
        rv
    }
    private static let instance = PackedSInt64Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated bool without `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class RepeatBoolAccessor <: RepeatAccessor<Bool> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Bool>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, VARINT, out)
            varintPack(if (v) { 1 } else { 0 }, out)
        }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Bool>()
        while (true) {
            rv.append(varintParse(src) != 0)
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }

    private static let instance = RepeatBoolAccessor()
    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated bool with `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class PackedBoolAccessor <: RepeatAccessor<Bool> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Bool>>(val)
        if (val.isEmpty()) { return }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(val.size()), out)
        for (v in val) { varintPack(if (v) { 1 } else { 0 }, out) }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Bool>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(varintParse(tmp) != 0) }
        rv
    }
    private static let instance = PackedBoolAccessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated 4-bytes int32 without `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class RepeatSFixed32Accessor <: RepeatAccessor<Int32> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Int32>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, BIT32, out)
            fixedPack(v, out)
        }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Int32>()
        while (true) {
            rv.append(Int32(fixed32Parse(src)))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatSFixed32Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated 4-bytes int32 with `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class PackedSFixed32Accessor <: RepeatAccessor<Int32> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Int32>>(val)
        if (val.isEmpty()) { return }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(val.size()) * 4, out)
        for (v in val) { fixedPack(v, out) }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Int32>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(Int32(fixed32Parse(tmp))) }
        rv
    }
    private static let instance = PackedSFixed32Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated 4-bytes uint32 without `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class RepeatFixed32Accessor <: RepeatAccessor<UInt32> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<UInt32>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, BIT32, out)
            fixedPack(v, out)
        }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<UInt32>()
        while (true) {
            rv.append(fixed32Parse(src))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatFixed32Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/* repeated 4-bytes uint32 with `packed` flag */

/**
 * The class is PackedFixed32Accessor inherited from RepeatAccessor<UInt32>
 * @author tutudo
 * @since 0.29.3
 */
public class PackedFixed32Accessor <: RepeatAccessor<UInt32> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<UInt32>>(val)
        if (val.isEmpty()) { return }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(val.size()) * 4, out)
        for (v in val) { fixedPack(v, out) }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<UInt32>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(fixed32Parse(tmp)) }
        rv
    }
    private static let instance = PackedFixed32Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated 4-bytes float32 without `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class RepeatFloatAccessor <: RepeatAccessor<Float32> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Float32>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, BIT32, out)
            fixedPack(v, out)
        }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Float32>()
        while (true) {
            rv.append(floatBits(fixed32Parse(src)))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatFloatAccessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated 4-bytes float32 with `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class PackedFloatAccessor <: RepeatAccessor<Float32> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Float32>>(val)
        if (val.isEmpty()) { return }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(val.size()) * 4, out)
        for (v in val) { fixedPack(v, out) }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Float32>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(floatBits(fixed32Parse(tmp))) }
        rv
    }
    private static let instance = PackedFloatAccessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated 8-bytes int64 without `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class RepeatSFixed64Accessor <: RepeatAccessor<Int64> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Int64>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, BIT64, out)
            fixedPack(v, out)
        }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Int64>()
        while (true) {
            rv.append(Int64(fixed64Parse(src)))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatSFixed64Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated 8-bytes int64 with `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class PackedSFixed64Accessor <: RepeatAccessor<Int64> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Int64>>(val)
        if (val.isEmpty()) { return }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(val.size()) * 8, out)
        for (v in val) { fixedPack(v, out) }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Int64>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(Int64(fixed32Parse(tmp))) }
        rv
    }
    private static let instance = PackedSFixed64Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated 8-bytes uint64 without `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class RepeatFixed64Accessor <: RepeatAccessor<UInt64> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<UInt64>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, BIT64, out)
            fixedPack(v, out)
        }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<UInt64>()
        while (true) {
            rv.append(fixed64Parse(src))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatFixed64Accessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated 8-bytes uint64 with `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class PackedFixed64Accessor <: RepeatAccessor<UInt64> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<UInt64>>(val)
        if (val.isEmpty()) { return }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(val.size()) * 8, out)
        for (v in val) { fixedPack(v, out) }
    }
    
    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<UInt64>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(fixed64Parse(tmp)) }
        rv
    }
    private static let instance = PackedFixed64Accessor()
    
    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated 8-bytes float64 without `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class RepeatDoubleAccessor <: RepeatAccessor<Float64> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Float64>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, BIT64, out)
            fixedPack(v, out)
        }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Float64>()
        while (true) {
            rv.append(floatBits(fixed64Parse(src)))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatDoubleAccessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated 8-bytes float64 with `packed` flag
 * @author tutudo
 * @since 0.29.3
 */
public class PackedDoubleAccessor <: RepeatAccessor<Float64> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Float64>>(val)
        if (val.isEmpty()) { return }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(val.size()) * 8, out)
        for (v in val) { fixedPack(v, out) }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Float64>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(floatBits(fixed64Parse(tmp))) }
        rv
    }
    private static let instance = PackedDoubleAccessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated string
 * @author tutudo
 * @since 0.29.3
 */
public class RepeatStringAccessor <: RepeatAccessor<String> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<String>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, PREFIXED, out)
            strPack(v, out)
        }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<String>()
        while (true) {
            rv.append(String.fromUtf8(binParse(src).data()))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    public func toString(val: Any) {
        let sb = StringBuilder("[")
        var dot = false
        let ss = dynamic_cast<ArrayList<String>>(val)
        for (s in ss) {
            if (dot) { sb.append(", ") } else { dot = true }
            sb.append('"').append(escape(s)).append('"')
        }
        sb.append(']').toString()
    }
    private static let instance = RepeatStringAccessor()
    /**
     * The Function is getInstance
     *
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated bytes
 * @author tutudo
 * @since 0.29.3
 */
public class RepeatBytesAccessor <: RepeatAccessor<Bytes> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<Bytes>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, PREFIXED, out)
            binPack(v, out)
        }
    }

    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<Bytes>()
        while (true) {
            rv.append(Bytes(binParse(src).data()))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }

    /**
     * The Function is clone
     *
     * @param val of Any
     *
     * @since 0.29.3
     */
    public func clone(val: Any) {
        let val = dynamic_cast<ArrayList<Bytes>>(val)
        ArrayList<Bytes>(val.size(), { i => val[i].clone() })
    }
    private static let instance = RepeatBytesAccessor()

    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/**
 * repeated message
 * @author tutudo
 * @since 0.29.3
 */
public class RepeatMessageAccessor<M> <: RepeatAccessor<M> where M <: MessageLite & Default<M> {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<ArrayList<M>>(val)
        if (val.isEmpty()) { return }
        let tmp = Bytes()
        for (v in val) {
            tagPack(tag, PREFIXED, out)
            tmp.clear()
            v.pack(tmp)
            varintPack(UInt64(tmp.size()), out)
            out.appendAll(tmp)
        }
    }
    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = ArrayList<M>()
        while (true) {
            rv.append(dynamic_cast<M>(M.default().unpack(binParse(src))))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    /**
     * The Function is clone
     *
     * @param val of Any
     *
     * @since 0.29.3
     */
    public func clone(val: Any) {
        let val = dynamic_cast<ArrayList<M>>(val)
        ArrayList<M>(val.size(), { i => dynamic_cast<M>(val[i].clone()) })
    }
    private static let instance = RepeatMessageAccessor<M>()
    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}

/* map<K, V>, similar to repeated MapEntry */

/**
 * The class is MapAccessor<K, V, KA, VA> inherited from Accessor where K <: Hashable & Equatable<K> & ToString & Default<K>, V <: Default<V>, KA <: Accessor, VA <: Accessor
 * @author tutudo
 * @since 0.29.3
 */
public class MapAccessor<K, V, KA, VA> <: Accessor where K <: Hashable & Equatable<K> & ToString & Default<K>, V <: Default<V>, KA <: Accessor, VA <: Accessor {
    /**
     * The Function is pack
     *
     * @param tag of Tag
     * @param val of Any
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<HashMap<K, V>>(val)
        if (val.isEmpty()) { return }
        let ka = KA.getInstance()
        let va = VA.getInstance()
        let tmp = Bytes()
        for ((k, v) in val) {
            tagPack(tag, PREFIXED, out)
            tmp.clear()
            if (!zeroish(k)) { ka.pack(1, k, tmp) }
            if (!zeroish(v)) { va.pack(2, v, tmp) }
            varintPack(UInt64(tmp.size()), out)
            out.appendAll(tmp)
        }
    }
    /**
     * The Function is unpack
     *
     * @param tag of Tag
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = HashMap<K, V>()
        let ka = KA.getInstance()
        let va = VA.getInstance()
        var k: K
        var v: V
        var tmp: SimpleReader
        while (true) {
            tmp = binParse(src)
            k = K.default()
            v = V.default()
            while (!tmp.isEmpty()) {
                match (tagParse(tmp)) {
                    case (1, _) => k = dynamic_cast<K>(ka.unpack(1, tmp))
                    case (2, _) => v = dynamic_cast<V>(va.unpack(2, tmp))
                    case _ => throw Exception() // todo
                }
            }
            rv[k] = v
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    /**
     * The Function is clone
     *
     * @param val of Any
     *
     * @since 0.29.3
     */
    public func clone(val: Any) {
        let rv = HashMap<K, V>()
        let va = VA.getInstance()
        for ((k, v) in dynamic_cast<HashMap<K, V>>(val)) { rv[k] = dynamic_cast<V>(va.clone(v)) }
        rv
    }
    public func toString(val: Any) {
        let va = VA.getInstance()
        let sb = StringBuilder("{")
        var dot = false
        for ((k, v) in dynamic_cast<HashMap<K, V>>(val)) {
            if (dot) { sb.append(", ") } else { dot = true }
            sb.append("\"${k}\"").append(": ").append(va.toString(v))
        }
        sb.append('}').toString()
    }
    private static let instance = MapAccessor<K, V, KA, VA>()
    /**
     * The Function is getInstance
     *
     * @since 0.29.3
     */
    public static func getInstance() { instance }
}