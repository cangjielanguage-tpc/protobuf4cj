package protobuf

/* throws */
func dynamic_cast<T>(v: Any): T { (v as T).getOrThrow() }

// todo getInstance()
/* access all the message fields */
public interface Accessor {
    func pack(tag: Tag, val: Any, out: Bytes): Unit
    func unpack(tag: Tag, src: SimpleReader): Any
    func clone(val: Any): Any { val }
    func toString(val: Any) { dynamic_cast<ToString>(val).toString() }
}

/* access all the repeated fields, override the default `clone` and `toString` */
public interface RepeatAccessor<T> <: Accessor where T <: ToString {
    func clone(val: Any): Any { dynamic_cast<Buffer<T>>(val).clone() }
    func toString(val: Any) { dynamic_cast<Buffer<T>>(val).toString() }
}

public class Int32Accessor <: Accessor {
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, VARINT, out)
        varintPack(UInt64(dynamic_cast<Int32>(val)), out)
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader): Any {
        Int32(varintParse(src))
    }
}

public class UInt32Accessor <: Accessor {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, VARINT, out)
        varintPack(UInt64(dynamic_cast<UInt32>(val)), out)
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader): Any {
        UInt32(varintParse(src))
    }
}

public class Int64Accessor <: Accessor {
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, VARINT, out)
        varintPack(UInt64(dynamic_cast<Int64>(val)), out)
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader): Any {
        Int64(varintParse(src))
    }
}

public class UInt64Accessor <: Accessor {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, VARINT, out)
        varintPack(dynamic_cast(val), out)
    }
    public func unpack(tag: Tag, src: SimpleReader): Any {
        varintParse(src)
    }
}

/* enum E */
public class EnumAccessor<E> <: Accessor where E <: Enum<E> {
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, VARINT, out)
        varintPack(UInt64(dynamic_cast<E>(val).value()), out)
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader): Any {
        E.parse(Int32(varintParse(src)))
    }
}

/* zigzag-encoding 128-base int32 */
public class SInt32Accessor <: Accessor {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, VARINT, out)
        varintPack(UInt64(zigzag(dynamic_cast<Int32>(val))), out)
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader): Any {
        unzigzag(UInt32(varintParse(src)))
    }
}

/* zigzag-encoding 128-base int64 */
public class SInt64Accessor <: Accessor {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, VARINT, out)
        varintPack(zigzag(dynamic_cast<Int64>(val)), out)
    }
    public func unpack(tag: Tag, src: SimpleReader): Any {
        unzigzag(varintParse(src))
    }
}

/* bool, varint 0 or 1 */
public class BoolAccessor <: Accessor {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, VARINT, out)
        varintPack(if (dynamic_cast(val)) { 1 } else { 0 }, out)
    }
    public func unpack(tag: Tag, src: SimpleReader): Any {
        varintParse(src) != 0
    }
}

/* length fixed 4-bytes signed int32 */
public class SFiexd32Accessor <: Accessor {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, BIT32, out)
        fixedPack(dynamic_cast<Int32>(val), out)
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader): Any {
        Int32(fixed32Parse(src))
    }
}

/* length fixed 4-bytes unsigned uint32 */
public class Fixed32Accessor <: Accessor {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, BIT32, out)
        fixedPack(dynamic_cast<UInt32>(val), out)
    }
    public func unpack(tag: Tag, src: SimpleReader): Any {
        fixed32Parse(src)
    }
}

/* length fixed 4-bytes float32 */
public class FloatAccessor <: Accessor {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, BIT32, out)
        fixedPack(dynamic_cast<Float32>(val), out)
    }
    public func unpack(tag: Tag, src: SimpleReader): Any {
        floatBits(fixed32Parse(src))
    }
}

/* length fixed 8-bytes signed int64 */
public class SFixed64Accessor <: Accessor {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, BIT64, out)
        fixedPack(dynamic_cast<Int64>(val), out)
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader): Any {
        Int64(fixed64Parse(src))
    }
}

/* length fixed 8-bytes unsigned uint64 */
public class Fixed64Accessor <: Accessor {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, BIT64, out)
        fixedPack(dynamic_cast<UInt64>(val), out)
    }
    public func unpack(tag: Tag, src: SimpleReader): Any {
        fixed64Parse(src)
    }
}

/* length fixed 8-bytes float64 */
public class DoubleAccessor <: Accessor {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, BIT64, out)
        fixedPack(dynamic_cast<Float64>(val), out)
    }
    public func unpack(tag: Tag, src: SimpleReader): Any {
        floatBits(fixed64Parse(src))
    }
}

/* string */
public class StringAccessor <: Accessor {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, PREFIXED, out)
        strPack(dynamic_cast(val), out)
    }
    public func unpack(tag: Tag, src: SimpleReader): Any {
        strParse(src)
    }
    public func toString(val: Any) { "\"${dynamic_cast<String>(val)}\"" }
}

/* bytes */
public class BytesAccessor <: RepeatAccessor<UInt8> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Bytes>(val)
        let len = UInt64(val.size())
        if (len > 0) {
            tagPack(tag, PREFIXED, out)
            varintPack(len, out)
            out.appendAll(val)
        }
    }
    public func unpack(tag: Tag, src: SimpleReader): Any {
        Bytes(binParse(src).data())
    }
}

/* message M */
public class MessageAccessor<M> <: Accessor where M <: MessageLite & Default<M> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let tmp = ArrayList<UInt8>()
        dynamic_cast<M>(val).pack(tmp)
        let len = UInt64(tmp.size())
        if (len > 0) {
            tagPack(tag, PREFIXED, out)
            varintPack(len, out)
            out.appendAll(tmp)
        }
    }
    public func unpack(tag: Tag, src: SimpleReader): Any {
        M.default().unpack(binParse(src))
    }
    public func clone(val: Any) {
        dynamic_cast<M>(val).clone()
    }
}

// todo repeated