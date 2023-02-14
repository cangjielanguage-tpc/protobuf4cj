/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

package protobuf

from std import collection.*

public type Tag = UInt32
public type WireNum = UInt8
public type Bytes = Array<Byte>
public type BytesSlice = RoArray<Byte>

/* ffi, typecast by bits */
foreign func itof(v: UInt32): Float32
foreign func ltod(v: UInt64): Float64
foreign func ftoi(v: Float32): UInt32
foreign func dtol(v: Float64): UInt64

public let VARINT: WireNum = 0
public let BIT64: WireNum = 1
public let PREFIXED: WireNum = 2
public let BIT32: WireNum = 5

/* protobuf wire type define. */
public class WireType <: ToString {
    private WireType(public let value: WireNum, private let name: String) { }
    public func toString() { name }

    public static func parse(val: WireNum): WireType {
        match (val) {
            case 0 => VARINT
            case 1 => BIT64
            case 2 => PREFIXED
            case 5 => BIT32
            case v => throw ParseValueExecption("WireType")
        }
    }

    public static let VARINT = WireType(VARINT, "VARINT")
    public static let BIT64 = WireType(BIT64, "BIT64")
    public static let PREFIXED = WireType(PREFIXED, "PREFIXED")
    public static let BIT32 = WireType(BIT32, "BIT32")
}

/* packed size of tag. */
public func tagSize(tag: Tag) {
    if (tag < (1 << 4)) { return 1 }
    if (tag < (1 << 11)) { return 2 }
    if (tag < (1 << 18)) { return 3 }
    if (tag < (1 << 25)) { return 4 }
    return 5
}

/* packed size by varint encoding. */
public func varintSize(val: UInt64) {
    if (val < (1 << 7)) { return 1 }
    if (val < (1 << 14)) { return 2 }
    if (val < (1 << 21)) { return 3 }
    if (val < (1 << 28)) { return 4 }
    if (val < (1 << 35)) { return 5 }
    if (val < (1 << 42)) { return 6 }
    if (val < (1 << 49)) { return 7 }
    if (val < (1 << 56)) { return 8 }
    if (val < (1 << 63)) { return 9 }
    return 10
}

/* packed size by varint encoding. */
@overflowWrapping
public func varintSize(val: Int64) {
    if (val < 0) { return 10 }
    if (val < (1 << 7)) { return 1 }
    if (val < (1 << 14)) { return 2 }
    if (val < (1 << 21)) { return 3 }
    if (val < (1 << 28)) { return 4 }
    if (val < (1 << 35)) { return 5 }
    if (val < (1 << 42)) { return 6 }
    if (val < (1 << 49)) { return 7 }
    if (val < (1 << 56)) { return 8 }
    return 9
}

/* packed size by varint encoding. */
@overflowWrapping
public func varintSize(val: UInt32) {
    if (val < (1 << 7)) { return 1 }
    if (val < (1 << 14)) { return 2 }
    if (val < (1 << 21)) { return 3 }
    if (val < (1 << 28)) { return 4 }
	return 5
}

/* packed size by varint encoding. */
@overflowWrapping
public func varintSize(val: Int32) {
    if (val < 0) { return 10 }
    if (val < (1 << 7)) { return 1 }
    if (val < (1 << 14)) { return 2 }
    if (val < (1 << 21)) { return 3 }
    if (val < (1 << 28)) { return 4 }
    return 5
}

/* the zigzag-encoded 64-bit unsigned integer form of a 64-bit signed integer. */
@overflowWrapping
public func zigzag(val: Int64) {
    (UInt64(val) << 1) ^ UInt64(val >> 63)
}

/* the zigzag-encoded 32-bit unsigned integer form of a 32-bit signed integer. */
@overflowWrapping
public func zigzag(val: Int32) {
    (UInt32(val) << 1) ^ UInt32(val >> 31)
}

/* unzigzag a zigzag-encoded 64-bit unsigned integer to a 64-bit signed integer. */
@overflowWrapping
public func unzigzag(val: UInt64) {
    Int64((val >> 1) ^ -(val & 1))
}

/* unzigzag a zigzag-encoded 32-bit unsigned integer to a 32-bit signed integer. */
@overflowWrapping
public func unzigzag(val: UInt32) {
    Int32((val >> 1) ^ -(val & 1))
}

/* packed size of sint64. */
public func sintSize(val: Int64) {
    varintSize(zigzag(val))
}

/* packed size of sint32. */
public func sintSize(val: Int32) {
    varintSize(zigzag(val))
}

@overflowWrapping
public func binSize(val: BytesSlice) {
    let size = val.size
    varintSize(size) + size
}

@overflowWrapping
public func binSize(val: BytesString) {
    let size = val.size
    varintSize(size) + size
}

@overflowWrapping
public func binSize(val: String) {
    let size = val.utf8View.size
    varintSize(size) + size
}

@overflowWrapping
public func binSize<M>(val: M) where M <: Message {
    let size = val.size
    varintSize(size) + size
}

public interface Int32Enum <: ToString & ToJson {
    func value(): Int32
    func toJson(): Json { toString() }
}

public interface Enum<E> <: Int32Enum & Equatable<E> where E <: Enum<E> {
    operator func==(e: E): Bool
    operator func!=(e: E) { !(this == e) }

    static func parse(v: Int32): E
    static func parse(v: String): E
}

public interface Message <: ToString {
    prop let size: Int64
    func isEmpty(): Bool
    func clear(): Unit
    func clone(): Message

    /* abstract generic function is not allowed in interface */
    /* func unpack<T>(src: T): Unit where T <: BytesReader */
    /* func pack<T>(out: T): Unit where T <: BytesWriter */

    func unpacki(src: BytesReader): Unit
    func packi(out: BytesWriter): Unit

    /* unpack from collection. */
    func unpack(src: Collection<Byte>): Unit {
        unpacki(SimpleReader(src))
    }

    /* unpack from bytes slice */
    func unpack(src: BytesSlice): Unit {
        unpacki(SimpleReader(src))
    }

    /* pack message to bytes */
    func pack(): Bytes {
        let out = SimpleWriter(size)
        packi(out)
        out.data
    }
}

public interface TypedMessage<M> where M <: Message {
    func clone(): M
    static func empty(): M
    static func fromBytes(src: Collection<Byte>): M
    static func fromBytes(src: BytesReader): M
}

public interface AddMessage<M> {
    func add(): M
}

extend ArrayList<M> <: AddMessage<M> where M <: TypedMessage<M> {
    public func add(): M { let m = M.empty(); this.append(m); m }
}

public interface Parent {
    func markDirty(): Unit
}

class ParentNode {
    var next: ?ParentNode = None
    ParentNode(let data: AbstractMessage) { }
}

struct Parents {
    var header: ?ParentNode = None

    public func markDirty(): Unit {
        var node = header
        while (true) { match (node) {
            case Some(n) => n.data.markDirty(); node = n.next
            case _ => return
        } }
    }

    mut func insert(v: AbstractMessage) {
        var node = header ?? return header = ParentNode(v)
        while (true) { match (node.next) {
            case Some(n) => node = n
            case _ => return node.next = ParentNode(v)
        } }
    }

    mut func remove(v: AbstractMessage) {
        var node = header ?? return ()
        if (refEq(node.data, v)) {
            return header = node.next
        }
        while (true) { match (node.next) {
            case Some(n) => if (refEq(n.data, v)) { return node.next = n.next } else { node = n }
            case _ => return
        } }
    }
}

public abstract class AbstractMessage <: Message & Parent {
    var m_parents = Parents()

    protected var m_cachedSize = -1
    protected var m_cachedHash = -1 /* [TODO] */
    public func markDirty(): Unit {
        if (m_cachedSize != -1 /* || m_cachedHash != -1 */) {   /* any cached */
            m_cachedSize = -1
            /* m_cachedHash = -1 */

            m_parents.markDirty()
        }
    }

    /* mark message is empty() */
    protected func m_markEmpty() { m_cachedSize = 0; return true }

    /* unknownFields */
    public let unknownFields = RepeatedField<MessageUnknownField>()

    /* unpack unknownFields */
    protected func m_unknown<R>(src: R, tag: (Tag, WireNum)) where R <: BytesReader {
        unknownFields.appendDirty(MessageUnknownField.unpack(tag[0], tag[1], src))
    }

    /* pack unknownFields */
    protected func m_unknown<W>(out: W) where W <: BytesWriter {
        for (field in unknownFields) { field.pack(out) }
    }

    /* unpack to repeated fields */
    protected static func s_add<T>(fields: RepeatedField<T>, val: T) { fields.appendDirty(val) }
    protected static func s_add<R>(fields: RepeatedString, src: R) where R <: BytesReader { fields.appendDirty(src.parseBytesSlice()) }
    protected static func s_add<T, R>(fields: RepeatedMessage<T>, src: R) where T <: AbstractMessage & TypedMessage<T>, R <: BytesReader { fields.appendDirty(T.fromBytes(subReader(src))) }

    /* pack repeated string */
    protected static func s_pack<W>(tag: Tag, fields: RepeatedString, out: W) where W <: BytesWriter {
        if (fields.isEmpty()) { return }
        
        let app: UInt8 = if (tag <= 15) { UInt8(tag) << 3 | PREFIXED } else { 0 }

        for (s in fields.getRawData()) {
            if (app > 0) { out.append(app) } else { out.packTag(tag, PREFIXED) }
            out.packBin(s)
        }
    }

    /* pack string */
    protected static func s_pack<W>(tag: Tag, field: Pb3String, out: W) where W <: BytesWriter {
        if (field.isEmpty()) { return }

        if (tag <= 15) { out.append(UInt8(tag) << 3 | PREFIXED) } else { out.packTag(tag, PREFIXED) }

        out.packBin(field)
    }

    /* pack string */
    protected static func s_pack<W>(tag: Tag, field: Pb2String, out: W) where W <: BytesWriter {
        if (let Some(str) = field.data) {
            if (tag <= 15) { out.append(UInt8(tag) << 3 | PREFIXED) } else { out.packTag(tag, PREFIXED) }

            out.packBin(field)
        }
    }

    /* set member field's parent */
    protected func m_member(rf: AbstractMessage) { rf.m_parents.insert(this) }
    protected func m_member(rf: RepeatedString) { rf.setParent(this) }
    protected func m_member<T>(rf: RepeatedField<T>) { rf.setParent(this) }
    protected func m_member<T>(rf: RepeatedMessage<T>) where T <: AbstractMessage & TypedMessage<T> { rf.setParent(this) }

    /* assign member old to new, reset their parent */
    protected func m_assign(old: AbstractMessage, new: AbstractMessage) { old.m_parents.remove(this); new.m_parents.insert(this) }
}