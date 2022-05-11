package protobuf

/* throws */
func dynamic_cast<T>(v: Any): T {
    match (v) {
        case a: Self<T> => a.self()
        case _ => (v as T).getOrThrow()
    }
}

/* access all the message fields */
public interface Accessor {
    func pack(tag: Tag, val: Any, out: Bytes): Unit
    func unpack(tag: Tag, src: SimpleReader): Any
    func clone(val: Any): Any { val }
    func toString(val: Any) { dynamic_cast<ToString>(val).toString() }
    static func getInstance(): Accessor
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
    private static let instance = Int32Accessor()
    public static func getInstance() { instance }
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
    private static let instance = UInt32Accessor()
    public static func getInstance() { instance }
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
    private static let instance = Int64Accessor()
    public static func getInstance() { instance }
}

public class UInt64Accessor <: Accessor {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, VARINT, out)
        varintPack(dynamic_cast(val), out)
    }
    public func unpack(tag: Tag, src: SimpleReader): Any {
        varintParse(src)
    }
    private static let instance = UInt64Accessor()
    public static func getInstance() { instance }
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
    public func toString(val: Any) { "\"${dynamic_cast<E>(val)}\"" }
    private static let instance = EnumAccessor<E>()
    public static func getInstance() { instance }
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
    private static let instance = SInt32Accessor()
    public static func getInstance() { instance }
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
    private static let instance = SInt64Accessor()
    public static func getInstance() { instance }
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
    private static let instance = BoolAccessor()
    public static func getInstance() { instance }
}

/* length fixed 4-bytes signed int32 */
public class SFixed32Accessor <: Accessor {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        tagPack(tag, BIT32, out)
        fixedPack(dynamic_cast<Int32>(val), out)
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader): Any {
        Int32(fixed32Parse(src))
    }
    private static let instance = SFixed32Accessor()
    public static func getInstance() { instance }
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
    private static let instance = Fixed32Accessor()
    public static func getInstance() { instance }
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
    private static let instance = FloatAccessor()
    public static func getInstance() { instance }
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
    private static let instance = SFixed64Accessor()
    public static func getInstance() { instance }
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
    private static let instance = Fixed64Accessor()
    public static func getInstance() { instance }
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
    private static let instance = DoubleAccessor()
    public static func getInstance() { instance }
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
    private static let instance = StringAccessor()
    public static func getInstance() { instance }
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
    private static let instance = BytesAccessor()
    public static func getInstance() { instance }
}

/* message M */
public class MessageAccessor<M> <: Accessor where M <: MessageLite & Default<M> {
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
    public func unpack(tag: Tag, src: SimpleReader): Any {
        M.default().unpack(binParse(src)) // unpack return MessageLite, if M needed, use dynamic_cast<M>
    }
    public func clone(val: Any) {
        dynamic_cast<M>(val).clone()
    }
    private static let instance = MessageAccessor<M>()
    public static func getInstance() { instance }
}

/* repeated int32 without `packed` flag */
public class RepeatInt32Accessor <: RepeatAccessor<Int32> {
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Int32>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, VARINT, out)
            varintPack(UInt64(v), out)
        }
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Int32>()
        while (true) {
            rv.append(Int32(varintParse(src)))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatInt32Accessor()
    public static func getInstance() { instance }
}

/* repeated int32 with `packed` flag */
public class PackedInt32Accessor <: RepeatAccessor<Int32> {
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Int32>>(val)
        if (val.isEmpty()) { return }
        let tmp = Bytes()
        for (v in val) { varintPack(UInt64(v), tmp) }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(tmp.size()), out)
        out.appendAll(tmp)
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Int32>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(Int32(varintParse(tmp))) }
        rv
    }
    private static let instance = PackedInt32Accessor()
    public static func getInstance() { instance }
}

/* repeated uint32 without `packed` flag */
public class RepeatUInt32Accessor <: RepeatAccessor<UInt32> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<UInt32>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, VARINT, out)
            varintPack(UInt64(v), out)
        }
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<UInt32>()
        while (true) {
            rv.append(UInt32(varintParse(src)))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatUInt32Accessor()
    public static func getInstance() { instance }
}

/* repeated uint32 with `packed` flag */
public class PackedUInt32Accessor <: RepeatAccessor<UInt32> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<UInt32>>(val)
        if (val.isEmpty()) { return }
        let tmp = Bytes()
        for (v in val) { varintPack(UInt64(v), tmp) }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(tmp.size()), out)
        out.appendAll(tmp)
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<UInt32>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(UInt32(varintParse(tmp))) }
        rv
    }
    private static let instance = PackedUInt32Accessor()
    public static func getInstance() { instance }
}

/* repeated int64 without `packed` flag */
public class RepeatInt64Accessor <: RepeatAccessor<Int64> {
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Int64>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, VARINT, out)
            varintPack(UInt64(v), out)
        }
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Int64>()
        while (true) {
            rv.append(Int64(varintParse(src)))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatInt64Accessor()
    public static func getInstance() { instance }
}

/* repeated int64 with `packed` flag */
public class PackedInt64Accessor <: RepeatAccessor<Int64> {
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Int64>>(val)
        if (val.isEmpty()) { return }
        let tmp = Bytes()
        for (v in val) { varintPack(UInt64(v), tmp) }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(tmp.size()), out)
        out.appendAll(tmp)
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Int64>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(Int64(varintParse(tmp))) }
        rv
    }
    private static let instance = PackedInt64Accessor()
    public static func getInstance() { instance }
}

/* repeated uint64 without `packed` flag */
public class RepeatUInt64Accessor <: RepeatAccessor<UInt64> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<UInt64>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, VARINT, out)
            varintPack(v, out)
        }
    }
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<UInt64>()
        while (true) {
            rv.append(varintParse(src))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatUInt64Accessor()
    public static func getInstance() { instance }
}

/* repeated uint64 with `packed` flag */
public class PackedUInt64Accessor <: RepeatAccessor<UInt64> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<UInt64>>(val)
        if (val.isEmpty()) { return }
        let tmp = Bytes()
        for (v in val) { varintPack(v, tmp) }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(tmp.size()), out)
        out.appendAll(tmp)
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<UInt64>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(varintParse(tmp)) }
        rv
    }
    private static let instance = PackedUInt64Accessor()
    public static func getInstance() { instance }
}

/* repeated enum without `packed` flag */
public class RepeatEnumAccessor<E> <: RepeatAccessor<E> where E <: Enum<E> {
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<E>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, VARINT, out)
            varintPack(UInt64(v.value()), out)
        }
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<E>()
        while (true) {
            rv.append(E.parse(Int32(varintParse(src))))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    public func toString(val: Any) {
        let sb = StringBuilder("[")
        var dot = false
        let ss = dynamic_cast<Buffer<E>>(val)
        for (s in ss) {
            if (dot) { sb.append(", ") } else { dot = true }
            sb.append('"').append(s).append('"')
        }
        sb.append(']').toString()
    }
    private static let instance = RepeatEnumAccessor<E>()
    public static func getInstance() { instance }
}

/* repeated enum with `packed` flag */
public class PackedEnumAccessor<E> <: RepeatAccessor<E> where E <: Enum<E> {
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<E>>(val)
        if (val.isEmpty()) { return }
        let tmp = Bytes()
        for (v in val) { varintPack(UInt64(v.value()), tmp) }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(tmp.size()), out)
        out.appendAll(tmp)
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<E>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(E.parse(Int32(varintParse(tmp)))) }
        rv
    }
    public func toString(val: Any) {
        let sb = StringBuilder("[")
        var dot = false
        let ss = dynamic_cast<Buffer<E>>(val)
        for (s in ss) {
            if (dot) { sb.append(", ") } else { dot = true }
            sb.append('"').append(s).append('"')
        }
        sb.append(']').toString()
    }
    private static let instance = PackedEnumAccessor<E>()
    public static func getInstance() { instance }
}

/* repeated sint32 without `packed` flag */
public class RepeatSInt32Accessor <: RepeatAccessor<Int32> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Int32>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, VARINT, out)
            varintPack(UInt64(zigzag(v)), out)
        }
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Int32>()
        while (true) {
            rv.append(unzigzag(UInt32(varintParse(src))))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatSInt32Accessor()
    public static func getInstance() { instance }
}

/* repeated sint32 with `packed` flag */
public class PackedSInt32Accessor <: RepeatAccessor<Int32> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Int32>>(val)
        if (val.isEmpty()) { return }
        let tmp = Bytes()
        for (v in val) { varintPack(UInt64(zigzag(v)), tmp) }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(tmp.size()), out)
        out.appendAll(tmp)
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Int32>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(unzigzag(UInt32(varintParse(tmp)))) }
        rv
    }
    private static let instance = PackedSInt32Accessor()
    public static func getInstance() { instance }
}

/* repeated sint64 without `packed` flag */
public class RepeatSInt64Accessor <: RepeatAccessor<Int64> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Int64>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, VARINT, out)
            varintPack(zigzag(v), out)
        }
    }
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Int64>()
        while (true) {
            rv.append(unzigzag(varintParse(src)))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatSInt64Accessor()
    public static func getInstance() { instance }
}

/* repeated sint64 with `packed` flag */
public class PackedSInt64Accessor <: RepeatAccessor<Int64> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Int64>>(val)
        if (val.isEmpty()) { return }
        let tmp = Bytes()
        for (v in val) { varintPack(zigzag(v), tmp) }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(tmp.size()), out)
        out.appendAll(tmp)
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Int64>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(unzigzag(varintParse(tmp))) }
        rv
    }
    private static let instance = PackedSInt64Accessor()
    public static func getInstance() { instance }
}

/* repeated bool without `packed` flag */
public class RepeatBoolAccessor <: RepeatAccessor<Bool> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Bool>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, VARINT, out)
            varintPack(if (v) { 1 } else { 0 }, out)
        }
    }
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Bool>()
        while (true) {
            rv.append(varintParse(src) != 0)
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatBoolAccessor()
    public static func getInstance() { instance }
}

/* repeated bool with `packed` flag */
public class PackedBoolAccessor <: RepeatAccessor<Bool> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Bool>>(val)
        if (val.isEmpty()) { return }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(val.size()), out)
        for (v in val) { varintPack(if (v) { 1 } else { 0 }, out) }
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Bool>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(varintParse(tmp) != 0) }
        rv
    }
    private static let instance = PackedBoolAccessor()
    public static func getInstance() { instance }
}

/* repeated 4-bytes int32 without `packed` flag */
public class RepeatSFixed32Accessor <: RepeatAccessor<Int32> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Int32>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, BIT32, out)
            fixedPack(v, out)
        }
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Int32>()
        while (true) {
            rv.append(Int32(fixed32Parse(src)))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatSFixed32Accessor()
    public static func getInstance() { instance }
}

/* repeated 4-bytes int32 with `packed` flag */
public class PackedSFixed32Accessor <: RepeatAccessor<Int32> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Int32>>(val)
        if (val.isEmpty()) { return }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(val.size()) * 4, out)
        for (v in val) { fixedPack(v, out) }
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Int32>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(Int32(fixed32Parse(tmp))) }
        rv
    }
    private static let instance = PackedSFixed32Accessor()
    public static func getInstance() { instance }
}

/* repeated 4-bytes uint32 without `packed` flag */
public class RepeatFixed32Accessor <: RepeatAccessor<UInt32> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<UInt32>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, BIT32, out)
            fixedPack(v, out)
        }
    }
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<UInt32>()
        while (true) {
            rv.append(fixed32Parse(src))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatFixed32Accessor()
    public static func getInstance() { instance }
}

/* repeated 4-bytes uint32 with `packed` flag */
public class PackedFixed32Accessor <: RepeatAccessor<UInt32> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<UInt32>>(val)
        if (val.isEmpty()) { return }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(val.size()) * 4, out)
        for (v in val) { fixedPack(v, out) }
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<UInt32>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(fixed32Parse(tmp)) }
        rv
    }
    private static let instance = PackedFixed32Accessor()
    public static func getInstance() { instance }
}

/* repeated 4-bytes float32 without `packed` flag */
public class RepeatFloatAccessor <: RepeatAccessor<Float32> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Float32>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, BIT32, out)
            fixedPack(v, out)
        }
    }
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Float32>()
        while (true) {
            rv.append(floatBits(fixed32Parse(src)))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatFloatAccessor()
    public static func getInstance() { instance }
}

/* repeated 4-bytes float32 with `packed` flag */
public class PackedFloatAccessor <: RepeatAccessor<Float32> {
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Float32>>(val)
        if (val.isEmpty()) { return }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(val.size()) * 4, out)
        for (v in val) { fixedPack(v, out) }
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Float32>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(floatBits(fixed32Parse(tmp))) }
        rv
    }
    private static let instance = PackedFloatAccessor()
    public static func getInstance() { instance }
}

/* repeated 8-bytes int64 without `packed` flag */
public class RepeatSFixed64Accessor <: RepeatAccessor<Int64> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Int64>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, BIT64, out)
            fixedPack(v, out)
        }
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Int64>()
        while (true) {
            rv.append(Int64(fixed64Parse(src)))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatSFixed64Accessor()
    public static func getInstance() { instance }
}

/* repeated 8-bytes int64 with `packed` flag */
public class PackedSFixed64Accessor <: RepeatAccessor<Int64> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Int64>>(val)
        if (val.isEmpty()) { return }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(val.size()) * 8, out)
        for (v in val) { fixedPack(v, out) }
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Int64>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(Int64(fixed32Parse(tmp))) }
        rv
    }
    private static let instance = PackedSFixed64Accessor()
    public static func getInstance() { instance }
}

/* repeated 8-bytes uint64 without `packed` flag */
public class RepeatFixed64Accessor <: RepeatAccessor<UInt64> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<UInt64>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, BIT64, out)
            fixedPack(v, out)
        }
    }
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<UInt64>()
        while (true) {
            rv.append(fixed64Parse(src))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatFixed64Accessor()
    public static func getInstance() { instance }
}

/* repeated 8-bytes uint64 with `packed` flag */
public class PackedFixed64Accessor <: RepeatAccessor<UInt64> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<UInt64>>(val)
        if (val.isEmpty()) { return }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(val.size()) * 8, out)
        for (v in val) { fixedPack(v, out) }
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<UInt64>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(fixed64Parse(tmp)) }
        rv
    }
    private static let instance = PackedFixed64Accessor()
    public static func getInstance() { instance }
}

/* repeated 8-bytes float64 without `packed` flag */
public class RepeatDoubleAccessor <: RepeatAccessor<Float64> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Float64>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, BIT64, out)
            fixedPack(v, out)
        }
    }
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Float64>()
        while (true) {
            rv.append(floatBits(fixed64Parse(src)))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    private static let instance = RepeatDoubleAccessor()
    public static func getInstance() { instance }
}

/* repeated 8-bytes float64 with `packed` flag */
public class PackedDoubleAccessor <: RepeatAccessor<Float64> {
    @overflowWrapping
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Float64>>(val)
        if (val.isEmpty()) { return }
        tagPack(tag, PREFIXED, out)
        varintPack(UInt64(val.size()) * 8, out)
        for (v in val) { fixedPack(v, out) }
    }
    @overflowWrapping
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Float64>()
        let tmp = src.read(Int64(varintParse(src)))
        while (!tmp.isEmpty()) { rv.append(floatBits(fixed64Parse(tmp))) }
        rv
    }
    private static let instance = PackedDoubleAccessor()
    public static func getInstance() { instance }
}

/* repeated string */
public class RepeatStringAccessor <: RepeatAccessor<String> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<String>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, PREFIXED, out)
            strPack(v, out)
        }
    }
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<String>()
        while (true) {
            rv.append(strParse(src))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    public func toString(val: Any) {
        let sb = StringBuilder("[")
        var dot = false
        let ss = dynamic_cast<Buffer<String>>(val)
        for (s in ss) {
            if (dot) { sb.append(", ") } else { dot = true }
            sb.append('"').append(s).append('"')
        }
        sb.append(']').toString()
    }
    private static let instance = RepeatStringAccessor()
    public static func getInstance() { instance }
}

/* repeated bytes */
public class RepeatBytesAccessor <: RepeatAccessor<Bytes> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<Bytes>>(val)
        if (val.isEmpty()) { return }
        for (v in val) {
            tagPack(tag, PREFIXED, out)
            binPack(v, out)
        }
    }
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<Bytes>()
        while (true) {
            rv.append(Bytes(binParse(src).data()))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    public func clone(val: Any) {
        let val = dynamic_cast<Buffer<Bytes>>(val)
        Buffer<Bytes>(val.size(), { i => val[i].clone() })
    }
    private static let instance = RepeatBytesAccessor()
    public static func getInstance() { instance }
}
/* repeated message */
public class RepeatMessageAccessor<M> <: RepeatAccessor<M> where M <: MessageLite & Default<M> {
    public func pack(tag: Tag, val: Any, out: Bytes) {
        let val = dynamic_cast<Buffer<M>>(val)
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
    public func unpack(tag: Tag, src: SimpleReader) {
        let rv = Buffer<M>()
        while (true) {
            rv.append(dynamic_cast<M>(M.default().unpack(binParse(src))))
            if (src.isEmpty()) { break }
            let (next, _) = tagParse(src)
            if (next != tag) { src.seek(-tagSize(next)); break }
        }
        rv
    }
    public func clone(val: Any) {
        let val = dynamic_cast<Buffer<M>>(val)
        Buffer<M>(val.size(), { i => dynamic_cast<M>(val[i].clone()) })
    }
    private static let instance = RepeatMessageAccessor<M>()
    public static func getInstance() { instance }
}

/* map<K, V>, similar to repeated MapEntry */
public class MapAccessor<K, V, KA, VA> <: Accessor where K <: Hashable & Equatable<K> & ToString & Default<K>, V <: Default<V>, KA <: Accessor, VA <: Accessor {
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
    public static func getInstance() { instance }
}