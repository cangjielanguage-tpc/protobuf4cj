package protobuf

/* Field Flags */
public type Flags = UInt32
public let FLAG_PACKED: Flags = (1 << 0)
public let FLAG_DEFAULT_VALUE: Flags = (1 << 1)

public interface Enum <: ToString {
    func value(): Int32
    func valid(v: Int32): Bool  /* cannot be static */
    func parse(v: Int32): Enum  /* cannot be static */
    func repeat(): RepeatEnumIF /* cannot be static */
    static func default(): Enum
}

/**
 * Field wire types.
 *
 * \see [Message Structure] in the Protocol Buffers documentation.
 *
 * [Message Structure]:
 *      https://developers.google.com/protocol-buffers/docs/encoding#structure
 */
public enum WireType { VARINT | BIT64 | PREFIXED | BIT32 }

extend WireType <: Enum {
    public func value(): Int32 {
        match (this) {
            case VARINT => 0
            case BIT64 => 1
            case PREFIXED => 2
            case BIT32 => 5
        }
    }

    public func toString() {
        match (this) {
            case VARINT => "Varint"
            case BIT64 => "Bit64"
            case PREFIXED => "Prefixed"
            case BIT32 => "Bit32"
        }
    }

    public func valid(v: Int32) {
        match (v) {
            case 0 | 1 | 2 | 5 => true
            case _ => false
        }
    }

    public func parse(v: Int32): WireType {
        match (v) {
            case 0 => VARINT
            case 1 => BIT64
            case 2 => PREFIXED
            case 5 => BIT32
            case e => throw InvalidEnumValueException("WireType", e)
        }
    }

    public func repeat() { RepeatEnum<WireType>() }
    public static func default() { VARINT }
}

extend WireType <: Equatable<WireType> {
    public operator func ==(o: WireType) { this.value() == o.value() }
    public operator func !=(o: WireType) { this.value() != o.value() }
}

/**
 * Message field rules.
 *
 * \see [Defining A Message Type] in the Protocol Buffers documentation.
 *
 * [Defining A Message Type]:
 *      https://developers.google.com/protocol-buffers/docs/proto#simple
 */
public enum Label { NONE | REQUIRED | OPTIONAL | REPEATED }

extend Label <: Enum {
    public func value(): Int32 {
        match (this) {
            case NONE => 0
            case REQUIRED => 1
            case OPTIONAL => 2
            case REPEATED => 3
        }
    }

    public func toString() {
        match (this) {
            case NONE => "None"
            case REQUIRED => "Required"
            case OPTIONAL => "Optional"
            case REPEATED => "Repeated"
        }
    }

    public func valid(v: Int32) {
        match (v) {
            case 0 | 1 | 2 | 3 => true
            case _ => false
        }
    }

    public func parse(v: Int32) {
        match (v) {
            case 0 => NONE
            case 1 => REQUIRED
            case 2 => OPTIONAL
            case 3 => REPEATED
            case e => throw InvalidEnumValueException("Label", e)
        }
    }

    public func repeat() { RepeatEnum<Label>() }
    public static func default() { NONE }
}

extend Label <: Equatable<Label> {
    public operator func ==(o: Label) { this.value() == o.value() }
    public operator func !=(o: Label) { this.value() != o.value() }
}

public interface RepeatEnumIF <: ToString & Collection<Enum> & Iterator<Enum> { }

public interface RepeatMessageIF <: ToString & Collection<MessageLite> & Iterator<MessageLite> { }

public class RepeatMessage<T> <: RepeatMessageIF where T <: MessageLite {
    private var idx = 0
    public RepeatMessage(var buffer!: Buffer<T> = Buffer()) {}
    public func isEmpty() { buffer.isEmpty() }
    public func size() { buffer.size() }
    public func toString() { buffer.toString() }
    public func iterator() { RepeatMessage<T>(buffer: buffer) } /* <T> required */
    public func next(): ?MessageLite { if (idx >= buffer.size()) { None } else { buffer[idx] } }
}

public class RepeatEnum<T> <: RepeatEnumIF where T <: Enum {
    private var idx = 0
    public RepeatEnum(var buffer!: Buffer<T> = Buffer()) {}
    public func isEmpty() { buffer.isEmpty() }
    public func size() { buffer.size() }
    public func toString() { buffer.toString() }
    public func iterator() { RepeatEnum<T>(buffer: buffer) } /* <T> required */
    public func next(): ?Enum { if (idx >= buffer.size()) { None } else { buffer[idx] } }
}

public enum UniqueField {
    | INT32     (Int32)         /**< int32 */
	| SINT32    (Int32)         /**< signed int32 */
	| SFIXED32  (Int32)         /**< signed int32 (4 bytes) */
	| INT64     (Int64)         /**< int64 */
	| SINT64    (Int64)         /**< signed int64 */
	| SFIXED64  (Int64)         /**< signed int64 (8 bytes) */
	| UINT32    (UInt32)        /**< unsigned int32 */
	| FIXED32   (UInt32)        /**< unsigned int32 (4 bytes) */
	| UINT64    (UInt64)        /**< unsigned int64 */
	| FIXED64   (UInt64)        /**< unsigned int64 (8 bytes) */
	| FLOAT     (Float32)       /**< float */
	| DOUBLE    (Float64)       /**< double */
	| BOOL      (Bool)          /**< boolean */
	| ENUM      (Enum)          /**< enumerated type */
	| STRING    (String)        /**< UTF-8 or ASCII string */
	| BYTES     (Bytes)         /**< arbitrary byte sequence */
	| MESSAGE   (MessageLite)   /**< nested message */
}

public enum RepeatField {
    | INT32     (Buffer<Int32>)     /**< int32 */
    | SINT32    (Buffer<Int32>)     /**< signed int32 */
    | SFIXED32  (Buffer<Int32>)     /**< signed int32 (4 bytes) */
    | INT64     (Buffer<Int64>)     /**< int64 */
    | SINT64    (Buffer<Int64>)     /**< signed int64 */
    | SFIXED64  (Buffer<Int64>)     /**< signed int64 (8 bytes) */
    | UINT32    (Buffer<UInt32>)    /**< unsigned int32 */
    | FIXED32   (Buffer<UInt32>)    /**< unsigned int32 (4 bytes) */
    | UINT64    (Buffer<UInt64>)    /**< unsigned int64 */
    | FIXED64   (Buffer<UInt64>)    /**< unsigned int64 (8 bytes) */
    | FLOAT     (Buffer<Float32>)   /**< float */
    | DOUBLE    (Buffer<Float64>)   /**< double */
    | BOOL      (Buffer<Bool>)      /**< boolean */
    | ENUM      (RepeatEnumIF)        /**< enumerated type */
    | STRING    (Buffer<String>)    /**< UTF-8 or ASCII string */
    | BYTES     (Buffer<Bytes>)     /**< arbitrary byte sequence */
    | MESSAGE   (RepeatMessageIF)     /**< nested message */
}

public enum MessageField <: ToString {
    | UNIQUE    (UniqueField)
    | REPEAT    (RepeatField)

    @overflowWrapping
    func packedSize(fd: FieldDescriptor): Int64 { /* Int64 Required */
        if (zeroish(fd)) {
            return 0
        }

        var rv = 0
        var tc = 1

        match (this) {
            case UNIQUE(INT32(v))       => rv = varintSize(UInt64(v))
            case UNIQUE(UINT32(v))      => rv = varintSize(UInt64(v))
            case UNIQUE(INT64(v))       => rv = varintSize(UInt64(v))
            case UNIQUE(UINT64(v))      => rv = varintSize(v)
            case UNIQUE(ENUM(v))        => rv = varintSize(UInt64(v.value()))
            case UNIQUE(SINT32(v))      => rv = varintSize(UInt64(zigzag(v)))
            case UNIQUE(SINT64(v))      => rv = varintSize(zigzag(v))
            case UNIQUE(BOOL(_))        => rv = 1
            case UNIQUE(SFIXED32(_) | FIXED32(_) | FLOAT(_))    => rv = 4
            case UNIQUE(SFIXED64(_) | FIXED64(_) | DOUBLE(_))   => rv = 8
            case UNIQUE(STRING(v))      => rv = strSize(v)
            case UNIQUE(BYTES(v))       => rv = binSize(v)
            case UNIQUE(MESSAGE(v))     => rv = msgSize(v)
            case REPEAT(INT32(a))       => tc = a.size(); for (v in a) { rv += varintSize(UInt64(v)) }; ()
            case REPEAT(UINT32(a))      => tc = a.size(); for (v in a) { rv += varintSize(UInt64(v)) }; ()
            case REPEAT(INT64(a))       => tc = a.size(); for (v in a) { rv += varintSize(UInt64(v)) }; ()
            case REPEAT(UINT64(a))      => tc = a.size(); for (v in a) { rv += varintSize(v) }; ()
            case REPEAT(ENUM(a))        => tc = a.size(); for (v in a) { rv += varintSize(UInt64(v.value())) }; ()
            case REPEAT(SINT32(a))      => tc = a.size(); for (v in a) { rv += varintSize(UInt64(zigzag(v))) }; ()
            case REPEAT(SINT64(a))      => tc = a.size(); for (v in a) { rv += varintSize(zigzag(v)) }; ()
            case REPEAT(BOOL(a))        => tc = a.size(); rv = 1 * a.size()
            case REPEAT(SFIXED32(a))    => tc = a.size(); rv = 4 * a.size()
            case REPEAT(FIXED32(a))     => tc = a.size(); rv = 4 * a.size()
            case REPEAT(FLOAT(a))       => tc = a.size(); rv = 4 * a.size()
            case REPEAT(SFIXED64(a))    => tc = a.size(); rv = 8 * a.size()
            case REPEAT(FIXED64(a))     => tc = a.size(); rv = 8 * a.size()
            case REPEAT(DOUBLE(a))      => tc = a.size(); rv = 8 * a.size()
            case REPEAT(STRING(a))      => tc = a.size(); for (v in a) { rv += strSize(v) }; ()
            case REPEAT(BYTES(a))       => tc = a.size(); for (v in a) { rv += binSize(v) }; ()
            case REPEAT(MESSAGE(a))     => tc = a.size(); for (v in a) { rv += msgSize(v) }; ()
        }

        if ((fd.flags & FLAG_PACKED) != 0) {
            tagSize(fd.tag) + varintSize(UInt64(rv)) + rv
        } else {
            tagSize(fd.tag) * tc + rv
        }
    }

    @overflowWrapping
    func pack(fd: FieldDescriptor, out: Bytes): Unit { /* Unit Required */
        if (zeroish(fd)) {
            return
        }
        match (this) {
            case UNIQUE(INT32(v))       => tagPack(fd.tag, VARINT, out); varintPack(UInt64(v), out)
            case UNIQUE(UINT32(v))      => tagPack(fd.tag, VARINT, out); varintPack(UInt64(v), out)
            case UNIQUE(INT64(v))       => tagPack(fd.tag, VARINT, out); varintPack(UInt64(v), out)
            case UNIQUE(UINT64(v))      => tagPack(fd.tag, VARINT, out); varintPack(v, out)
            case UNIQUE(ENUM(v))        => tagPack(fd.tag, VARINT, out); varintPack(UInt64(v.value()), out)
            case UNIQUE(SINT32(v))      => tagPack(fd.tag, VARINT, out); varintPack(UInt64(zigzag(v)), out)
            case UNIQUE(SINT64(v))      => tagPack(fd.tag, VARINT, out); varintPack(zigzag(v), out)
            case UNIQUE(BOOL(v))        => tagPack(fd.tag, VARINT, out); varintPack(if (v) { 1 } else { 0 }, out)
            case UNIQUE(SFIXED32(v))    => tagPack(fd.tag, BIT32, out); fixedPack(v, out)
            case UNIQUE(FIXED32(v))     => tagPack(fd.tag, BIT32, out); fixedPack(v, out)
            case UNIQUE(FLOAT(v))       => tagPack(fd.tag, BIT32, out); fixedPack(v, out)
            case UNIQUE(SFIXED64(v))    => tagPack(fd.tag, BIT64, out); fixedPack(v, out)
            case UNIQUE(FIXED64(v))     => tagPack(fd.tag, BIT64, out); fixedPack(v, out)
            case UNIQUE(DOUBLE(v))      => tagPack(fd.tag, BIT64, out); fixedPack(v, out)
            case UNIQUE(STRING(v))      => tagPack(fd.tag, PREFIXED, out); strPack(v, out)
            case UNIQUE(BYTES(v))       => tagPack(fd.tag, PREFIXED, out); binPack(v, out)
            case UNIQUE(MESSAGE(v))     => tagPack(fd.tag, PREFIXED, out); msgPack(v, out)
            case _ => return // todo
        }
    }

    @overflowWrapping
    func unpack(fd: FieldDescriptor, src: SimpleReader): MessageField {
        match (this) {
            case UNIQUE(INT32(v))       => UNIQUE(INT32(Int32(varintParse(src))))
            case UNIQUE(UINT32(v))      => UNIQUE(UINT32(UInt32(varintParse(src))))
            case UNIQUE(INT64(v))       => UNIQUE(INT64(Int64(varintParse(src))))
            case UNIQUE(UINT64(v))      => UNIQUE(UINT64(varintParse(src)))
            case UNIQUE(ENUM(v))        => UNIQUE(ENUM(v.parse(Int32(varintParse(src)))))
            case UNIQUE(SINT32(v))      => UNIQUE(SINT32(unzigzag(UInt32(varintParse(src)))))
            case UNIQUE(SINT64(v))      => UNIQUE(SINT64(unzigzag(varintParse(src))))
            case UNIQUE(BOOL(v))        => UNIQUE(BOOL(varintParse(src) != 0))
            case UNIQUE(SFIXED32(v))    => UNIQUE(SFIXED32(Int32(fixed32Parse(src))))
            case UNIQUE(FIXED32(v))     => UNIQUE(FIXED32(fixed32Parse(src)))
            case UNIQUE(FLOAT(v))       => UNIQUE(FLOAT(floatBits(fixed32Parse(src))))
            case UNIQUE(SFIXED64(v))    => UNIQUE(SFIXED64(Int64(fixed64Parse(src))))
            case UNIQUE(FIXED64(v))     => UNIQUE(FIXED64(fixed64Parse(src)))
            case UNIQUE(DOUBLE(v))      => UNIQUE(DOUBLE(floatBits(fixed64Parse(src))))
            case UNIQUE(STRING(v))      => UNIQUE(STRING(strParse(src)))
            case UNIQUE(BYTES(v))       => UNIQUE(BYTES(Bytes(binParse(src).data())))
            case UNIQUE(MESSAGE(v))     => UNIQUE(MESSAGE(v.unpack(binParse(src))))
            case _ => REPEAT(STRING(Buffer()))  // todo
        }
    }

    func zeroish(fd: FieldDescriptor): Bool {
        if (fd.label != NONE && fd.label != REPEATED) {
            return false
        }

        match (this) {
            case UNIQUE(INT32(v))       => v == 0
            case UNIQUE(SINT32(v))      => v == 0
            case UNIQUE(SFIXED32(v))    => v == 0
            case UNIQUE(INT64(v))       => v == 0
            case UNIQUE(SINT64(v))      => v == 0
            case UNIQUE(SFIXED64(v))    => v == 0
            case UNIQUE(UINT32(v))      => v == 0
            case UNIQUE(FIXED32(v))     => v == 0
            case UNIQUE(UINT64(v))      => v == 0
            case UNIQUE(FIXED64(v))     => v == 0
            case UNIQUE(FLOAT(v))       => v == .0
            case UNIQUE(DOUBLE(v))      => v == .0
            case UNIQUE(BOOL(v))        => v == false
            case UNIQUE(ENUM(v))        => v.value() == 0
            case UNIQUE(STRING(v))      => v.isEmpty()
            case UNIQUE(BYTES(v))       => v.isEmpty()
            case UNIQUE(MESSAGE(v))     => v.packedSize() == 0
            case REPEAT(INT32(v))       => v.isEmpty()
            case REPEAT(SINT32(v))      => v.isEmpty()
            case REPEAT(SFIXED32(v))    => v.isEmpty()
            case REPEAT(INT64(v))       => v.isEmpty()
            case REPEAT(SINT64(v))      => v.isEmpty()
            case REPEAT(SFIXED64(v))    => v.isEmpty()
            case REPEAT(UINT32(v))      => v.isEmpty()
            case REPEAT(FIXED32(v))     => v.isEmpty()
            case REPEAT(UINT64(v))      => v.isEmpty()
            case REPEAT(FIXED64(v))     => v.isEmpty()
            case REPEAT(FLOAT(v))       => v.isEmpty()
            case REPEAT(DOUBLE(v))      => v.isEmpty()
            case REPEAT(BOOL(v))        => v.isEmpty()
            case REPEAT(ENUM(v))        => v.isEmpty()
            case REPEAT(STRING(v))      => v.isEmpty()
            case REPEAT(BYTES(v))       => v.isEmpty()
            case REPEAT(MESSAGE(v))     => v.isEmpty()
        }
    }

    public func toString() {
        match (this) {
            case UNIQUE(STRING(v))      => "\"${v}\""
            case REPEAT(STRING(v))      =>
                var sb = StringBuilder("["); var dot = false
                for (s in v) { if (dot) { sb.append(", "); () } else { dot = true }; sb.append(v.toString()) }
                sb.append(']').toString()
            case UNIQUE(INT32(v))       => v.toString()
            case UNIQUE(SINT32(v))      => v.toString()
            case UNIQUE(SFIXED32(v))    => v.toString()
            case UNIQUE(INT64(v))       => v.toString()
            case UNIQUE(SINT64(v))      => v.toString()
            case UNIQUE(SFIXED64(v))    => v.toString()
            case UNIQUE(UINT32(v))      => v.toString()
            case UNIQUE(FIXED32(v))     => v.toString()
            case UNIQUE(UINT64(v))      => v.toString()
            case UNIQUE(FIXED64(v))     => v.toString()
            case UNIQUE(FLOAT(v))       => v.toString()
            case UNIQUE(DOUBLE(v))      => v.toString()
            case UNIQUE(BOOL(v))        => v.toString()
            case UNIQUE(ENUM(v))        => v.toString()
            case UNIQUE(BYTES(v))       => v.toString()
            case UNIQUE(MESSAGE(v))     => v.toString()
            case REPEAT(INT32(v))       => v.toString()
            case REPEAT(SINT32(v))      => v.toString()
            case REPEAT(SFIXED32(v))    => v.toString()
            case REPEAT(INT64(v))       => v.toString()
            case REPEAT(SINT64(v))      => v.toString()
            case REPEAT(SFIXED64(v))    => v.toString()
            case REPEAT(UINT32(v))      => v.toString()
            case REPEAT(FIXED32(v))     => v.toString()
            case REPEAT(UINT64(v))      => v.toString()
            case REPEAT(FIXED64(v))     => v.toString()
            case REPEAT(FLOAT(v))       => v.toString()
            case REPEAT(DOUBLE(v))      => v.toString()
            case REPEAT(BOOL(v))        => v.toString()
            case REPEAT(ENUM(v))        => v.toString()
            case REPEAT(BYTES(v))       => v.toString()
            case REPEAT(MESSAGE(v))     => v.toString()
        }
    }
}

/**
 * Describes a single field in a message.
 */
public class FieldDescriptor {
    public FieldDescriptor(
        /** Name of the field as given in the .proto file. */
        let name: String,
        /** Tag value of the field as given in the .proto file. */
        let tag: Tag,
        /** Whether the field is `REQUIRED`, `OPTIONAL`, `REPEATED` or `NONE` . */
        let label: Label,
        /** The template for this field */
        let templ: UniqueField,
        /** A flag word. Zero or more of the bits defined in the Field Flags may be set. */
        let flags: Flags
    ) {}

    @overflowWrapping
    func unpack(src: SimpleReader): MessageField {
        match (templ) {
            case INT32(v)       => UNIQUE(INT32(Int32(varintParse(src))))
            case UINT32(v)      => UNIQUE(UINT32(UInt32(varintParse(src))))
            case INT64(v)       => UNIQUE(INT64(Int64(varintParse(src))))
            case UINT64(v)      => UNIQUE(UINT64(varintParse(src)))
            case ENUM(v)        => UNIQUE(ENUM(v.parse(Int32(varintParse(src)))))
            case SINT32(v)      => UNIQUE(SINT32(unzigzag(UInt32(varintParse(src)))))
            case SINT64(v)      => UNIQUE(SINT64(unzigzag(varintParse(src))))
            case BOOL(v)        => UNIQUE(BOOL(varintParse(src) != 0))
            case SFIXED32(v)    => UNIQUE(SFIXED32(Int32(fixed32Parse(src))))
            case FIXED32(v)     => UNIQUE(FIXED32(fixed32Parse(src)))
            case FLOAT(v)       => UNIQUE(FLOAT(floatBits(fixed32Parse(src))))
            case SFIXED64(v)    => UNIQUE(SFIXED64(Int64(fixed64Parse(src))))
            case FIXED64(v)     => UNIQUE(FIXED64(fixed64Parse(src)))
            case DOUBLE(v)      => UNIQUE(DOUBLE(floatBits(fixed64Parse(src))))
            case STRING(v)      => UNIQUE(STRING(strParse(src)))
            case BYTES(v)       => UNIQUE(BYTES(Bytes(binParse(src).data())))
            case MESSAGE(v)     => UNIQUE(MESSAGE(v.unpack(binParse(src))))
        }
        // todo repeated
    }

    func default(): Bool*MessageField {
        if (label != REPEATED) {
            match (templ) {
                case BYTES(_)   => (true, UNIQUE(BYTES(Buffer())))
                case MESSAGE(v) => (true, UNIQUE(MESSAGE(v.clone())))
                case _          => (false, UNIQUE(templ))
            }
        }
        (true, match (templ) {
            case INT32(v)       => REPEAT(INT32(Buffer()))
            case SINT32(v)      => REPEAT(SINT32(Buffer()))
            case SFIXED32(v)    => REPEAT(SFIXED32(Buffer()))
            case INT64(v)       => REPEAT(INT64(Buffer()))
            case SINT64(v)      => REPEAT(SINT64(Buffer()))
            case SFIXED64(v)    => REPEAT(SFIXED64(Buffer()))
            case UINT32(v)      => REPEAT(UINT32(Buffer()))
            case FIXED32(v)     => REPEAT(FIXED32(Buffer()))
            case UINT64(v)      => REPEAT(UINT64(Buffer()))
            case FIXED64(v)     => REPEAT(FIXED64(Buffer()))
            case FLOAT(v)       => REPEAT(FLOAT(Buffer()))
            case DOUBLE(v)      => REPEAT(DOUBLE(Buffer()))
            case BOOL(v)        => REPEAT(BOOL(Buffer()))
            case ENUM(v)        => REPEAT(ENUM(v.repeat())) /* for abstract elements */
            case STRING(v)      => REPEAT(STRING(Buffer()))
            case BYTES(v)       => REPEAT(BYTES(Buffer<Bytes>()))
            case MESSAGE(v)     => REPEAT(MESSAGE(v.repeat())) /* for abstract elements */
        })
    }
}

/**
 * Describes a message.
 */
public class MessageDescriptor {
    public MessageDescriptor(
        /** The qualified name (e.g., "namespace.Type"). */
        let name: String,
        /** The unqualified name as given in the .proto file (e.g., "Type"). */
        let shortName: String,
        /** Identifier used in generated CangJie code. */
        let cangjieName: String,
        /** The dot-separated namespace. */
        let packageName: String,
        /** The protobuf syntax */
        let syntax: String
    ) {}
}

/**
 * An unknown message field.
 */
public class MessageUnknownField {
    public MessageUnknownField(
        /** The tag number. */
        let tag: Tag,
        /** The wire type of the field. */
        let wireType: WireType,
        /** Field data. */
        let data: List<UInt8>
    ) {}

    /** Calculate the serialized size of the unknown field with tag. */
    func packedSize() {
        tagSize(tag) + binSize(data)
    }

    /* Pack out the unknown field with tag. */
    func pack(out: Bytes) {
        tagPack(tag, wireType, out)
        binPack(data, out)
    }

    static func unpack(tag: Tag, wt: WireType, src: SimpleReader) {
        let len: Int64
        match (wt) {
            case BIT32 => len = 4
            case BIT64 => len = 8
            case VARINT => len = varintSize(varintParse(src.read(min(src.size(), 10))))
            case PREFIXED => let p = varintParse(src.read(min(src.size(), 10))); len = Int64(p) + varintSize(p)
        }
        MessageUnknownField(tag, wt, src.read(len).data())
    }
}

public abstract class MessageLite <: ToString {
    /** The descriptor for this message type. */
    protected func getMessageDescriptor(): MessageDescriptor
    protected func getFieldDescriptor(): HashMap<Tag ,FieldDescriptor>
    public func clone(): MessageLite
    public func repeat(): RepeatMessageIF

    /* protobuf syntax version */
    protected var proto2 = true

    /* The fields this message belongs to */
    protected var fields = HashMap<Tag, MessageField>()

    /** The fields that weren't recognized by the parser. */
    protected var unknownFields = Buffer<MessageUnknownField>()
    public func getUnknownFields() { unknownFields }

    /* Calculate the serialized size of the message. */
    public open func packedSize() {
        check()
        var rv = 0
        let fds = getFieldDescriptor()
        for ((tag, field) in fields) {
            rv += field.packedSize(fds[tag])
        }
        for (field in getUnknownFields()) {
            rv += field.packedSize()
        }
        rv
    }

    /* Pack out the message. */
    public open func pack(out: Bytes): Unit { /* Unit Required */
        let fds = getFieldDescriptor()
        for ((tag, field) in fields) {
            field.pack(fds[tag], out)
        }
        for (field in getUnknownFields()) {
            field.pack(out)
        }
    }

    public open func unpack(src: Collection<Byte>) {
        let reader = SimpleReader(List(src))
        unpack(reader)
    }

    public open func unpack(src: SimpleReader): MessageLite {
        let fds = getFieldDescriptor()
        var fields = fields
        while (src.isEmpty() == false) {
            let (tag, wt) = tagParse(src)
            if (fds.contains(tag) == false) {
                unknownFields.add(MessageUnknownField.unpack(tag, wt, src))
            } else {
                fields[tag] = fds[tag].unpack(src)
            }
        }
        check()
        this
    }

    public func toString() {
        let fds = getFieldDescriptor()
        let sb = StringBuilder("{")
        var dot = false
        for ((tag, field) in fields) {
            if (dot) { sb.append(", "); () } else { dot = true }
            sb.append(fds[tag].name).append(": ").append(field)
        }
        sb.append('}').toString()
    }

    protected func check(): Unit { /* Unit Required */
        let fields = fields
        for ((tag, fd) in getFieldDescriptor()) {
            if (fd.label == REQUIRED && (fd.flags & FLAG_DEFAULT_VALUE) == 0 && !fields.contains(tag)) {
                throw RequiredFieldNotSetException(fd.name)
            }
        }
    }

    protected func getField(tag: Tag) {
        let fields = fields
        if (fields.contains(tag)) {
            fields[tag]
        }

        let fd = getFieldDescriptor()[tag]
        if (proto2) {
            if ((fd.flags & FLAG_DEFAULT_VALUE) == 0) {
                throw GetFieldValueException(fd.name)
            }
            UNIQUE(fd.templ)
        }

        /* proto3 */
        let (ref, iv) = fd.default()
        if (ref) {
            fields[tag] = iv
        }
        iv
    }

    protected func getInt32(tag: Tag): Int32 {
        match (getField(tag)) {
            case UNIQUE(INT32(v)) => return v
            case _ => throw ValueTypeUnmatchException(getFieldDescriptor()[tag].name, "int32")
        }
    }

    protected func setInt32(tag: Tag, v: Int32) {
        fields[tag] = UNIQUE(INT32(v))
    }

    protected func getInt64(tag: Tag): Int64 {
        match (getField(tag)) {
            case UNIQUE(INT64(v)) => return v
            case _ => throw ValueTypeUnmatchException(getFieldDescriptor()[tag].name, "int64")
        }
    }

    protected func setInt64(tag: Tag, v: Int64) {
        fields[tag] = UNIQUE(INT64(v))
    }

    protected func getUInt32(tag: Tag): UInt32 {
        match (getField(tag)) {
            case UNIQUE(UINT32(v)) => return v
            case _ => throw ValueTypeUnmatchException(getFieldDescriptor()[tag].name, "uint32")
        }
    }

    protected func setUInt32(tag: Tag, v: UInt32) {
        fields[tag] = UNIQUE(UINT32(v))
    }

    protected func getUInt64(tag: Tag): UInt64 {
        match (getField(tag)) {
            case UNIQUE(UINT64(v)) => return v
            case _ => throw ValueTypeUnmatchException(getFieldDescriptor()[tag].name, "uint64")
        }
    }

    protected func setUInt64(tag: Tag, v: UInt64) {
        fields[tag] = UNIQUE(UINT64(v))
    }

    protected func getSInt32(tag: Tag): Int32 {
        match (getField(tag)) {
            case UNIQUE(SINT32(v)) => return v
            case _ => throw ValueTypeUnmatchException(getFieldDescriptor()[tag].name, "sint32")
        }
    }

    protected func setSInt32(tag: Tag, v: Int32) {
        fields[tag] = UNIQUE(SINT32(v))
    }

    protected func getSInt64(tag: Tag): Int64 {
        match (getField(tag)) {
            case UNIQUE(SINT64(v)) => return v
            case _ => throw ValueTypeUnmatchException(getFieldDescriptor()[tag].name, "sint64")
        }
    }

    protected func setSInt64(tag: Tag, v: Int64) {
        fields[tag] = UNIQUE(SINT64(v))
    }

    protected func getSFixed32(tag: Tag): Int32 {
        match (getField(tag)) {
            case UNIQUE(SFIXED32(v)) => return v
            case _ => throw ValueTypeUnmatchException(getFieldDescriptor()[tag].name, "sfixed32")
        }
    }

    protected func setSFixed32(tag: Tag, v: Int32) {
        fields[tag] = UNIQUE(SFIXED32(v))
    }

    protected func getSFixed64(tag: Tag): Int64 {
        match (getField(tag)) {
            case UNIQUE(SFIXED64(v)) => return v
            case _ => throw ValueTypeUnmatchException(getFieldDescriptor()[tag].name, "sfixed64")
        }
    }

    protected func setSFixed64(tag: Tag, v: Int64) {
        fields[tag] = UNIQUE(SFIXED64(v))
    }

    protected func getFixed32(tag: Tag): UInt32 {
        match (getField(tag)) {
            case UNIQUE(FIXED32(v)) => return v
            case _ => throw ValueTypeUnmatchException(getFieldDescriptor()[tag].name, "fixed32")
        }
    }

    protected func setFixed32(tag: Tag, v: UInt32) {
        fields[tag] = UNIQUE(FIXED32(v))
    }

    protected func getFixed64(tag: Tag): UInt64 {
        match (getField(tag)) {
            case UNIQUE(FIXED64(v)) => return v
            case _ => throw ValueTypeUnmatchException(getFieldDescriptor()[tag].name, "fixed64")
        }
    }

    protected func setFixed64(tag: Tag, v: UInt64) {
        fields[tag] = UNIQUE(FIXED64(v))
    }

    protected func getFloat(tag: Tag): Float32 {
        match (getField(tag)) {
            case UNIQUE(FLOAT(v)) => return v
            case _ => throw ValueTypeUnmatchException(getFieldDescriptor()[tag].name, "float")
        }
    }

    protected func setFloat(tag: Tag, v: Float32) {
        fields[tag] = UNIQUE(FLOAT(v))
    }

    protected func getDouble(tag: Tag): Float64 {
        match (getField(tag)) {
            case UNIQUE(DOUBLE(v)) => return v
            case _ => throw ValueTypeUnmatchException(getFieldDescriptor()[tag].name, "double")
        }
    }

    protected func setDouble(tag: Tag, v: Float64) {
        fields[tag] = UNIQUE(DOUBLE(v))
    }

    protected func getBool(tag: Tag): Bool {
        match (getField(tag)) {
            case UNIQUE(BOOL(v)) => return v
            case _ => throw ValueTypeUnmatchException(getFieldDescriptor()[tag].name, "bool")
        }
    }

    protected func setBool(tag: Tag, v: Bool) {
        fields[tag] = UNIQUE(BOOL(v))
    }

    protected func getString(tag: Tag): String {
        match (getField(tag)) {
            case UNIQUE(STRING(v)) => return v
            case _ => throw ValueTypeUnmatchException(getFieldDescriptor()[tag].name, "string")
        }
    }

    protected func setString(tag: Tag, v: String) {
        fields[tag] = UNIQUE(STRING(v))
    }

    protected func getBytes(tag: Tag): Bytes {
        match (getField(tag)) {
            case UNIQUE(BYTES(v)) => return v
            case _ => throw ValueTypeUnmatchException(getFieldDescriptor()[tag].name, "bytes")
        }
    }

    protected func setBytes(tag: Tag, v: Collection<UInt8>) {
        fields[tag] = UNIQUE(BYTES(Bytes(v)))
    }

    protected func getMessage(tag: Tag): MessageLite {
        match (getField(tag)) {
            case UNIQUE(MESSAGE(v)) => return v
            case _ => throw ValueTypeUnmatchException(getFieldDescriptor()[tag].name, "message")
        }
    }

    protected func setMessage(tag: Tag, v: MessageLite) {
        fields[tag] = UNIQUE(MESSAGE(v))
    }

    protected func getEnum(tag: Tag): Enum {
        match (getField(tag)) {
            case UNIQUE(ENUM(v)) => return v
            case _ => throw ValueTypeUnmatchException(getFieldDescriptor()[tag].name, "enum")
        }
    }

    protected func setEnum(tag: Tag, v: Enum) {
        fields[tag] = UNIQUE(ENUM(v))
    }
}
