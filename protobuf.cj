package protobuf

/**
 * Field wire types.
 *
 * \see [Message Structure] in the Protocol Buffers documentation.
 *
 * [Message Structure]:
 *      https://developers.google.com/protocol-buffers/docs/encoding#structure
 */
public enum WireType { VARINT | BIT64 | PREFIXED | BIT32 }

extend WireType <: Enum<WireType> {
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

    public static func parse(v: Int32): WireType {
        match (v) {
            case 0 => VARINT
            case 1 => BIT64
            case 2 => PREFIXED
            case 5 => BIT32
            case e => throw InvalidEnumValueException("WireType", e)
        }
    }
}

extend WireType <: Default<WireType> {
    public static func default(): WireType { VARINT }
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

extend Label <: Enum<Label> {
    public func value(): Int32 {
        match (this) {
            case NONE => 0
            case REQUIRED => 1
            case OPTIONAL => 2
            case REPEATED => 3
        }
    }

    public func toString(): String {
        match (this) {
            case NONE => "None"
            case REQUIRED => "Required"
            case OPTIONAL => "Optional"
            case REPEATED => "Repeated"
        }
    }

    public static func parse(v: Int32): Label {
        match (v) {
            case 0 => NONE
            case 1 => REQUIRED
            case 2 => OPTIONAL
            case 3 => REPEATED
            case e => throw InvalidEnumValueException("Label", e)
        }
    }
}

extend Label <: Default<Label> {
    public static func default(): Label { NONE }
}

extend Label <: Equatable<Label> {
    public operator func ==(o: Label) { this.value() == o.value() }
    public operator func !=(o: Label) { this.value() != o.value() }
}

/* An unknown message field. */
public class MessageUnknownField <: ToString {
    public MessageUnknownField(
        /** The tag number. */
        let tag: Tag,
        /** The wire type of the field. */
        let wireType: WireType,
        /** Field data. */
        let data: Array<UInt8>
    ) {}

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
            case VARINT => len = varintSize(varintParse(src)); src.seek(-len)
            case PREFIXED => let p = varintParse(src); let v = varintSize(p); len = Int64(p) + v; src.seek(-v)
        }
        MessageUnknownField(tag, wt, src.read(len).data())
    }

    public func toString() { "tag: ${tag}, wireType: ${wireType}, data: ${data}" }
}

public interface ValuedEnum {
    func value(): Int32
}

/* base of protobuf enum */
public interface Enum<E> <: ValuedEnum & ToString {
    static func parse(v: Int32): E
}

/* base of protobuf message */
public abstract class MessageLite <: ToString {
    protected func getAccessors(): HashMap<Tag, Accessor>
    protected func getNames(): HashMap<Tag, String> // 现阶段不完全确定哪些信息必须提供，故单独提供，后期再整合
    protected open func getDefaultValue(): HashMap<Tag, Any> { HashMap() } // proto3用不到, 故提供默认实现, proto2需覆盖此函数
    public func clone(): MessageLite // 由于需要具体的类型信息，只能交给子类具体实现

    public var unknownFields = Buffer<MessageUnknownField>()
    protected var fields = HashMap<Tag, Any>()
    protected var proto2 = true // 默认proto2

    protected func fieldsClone() {
        let result = HashMap<Tag, Any>()
        let accessors = getAccessors()
        let iter = fields.iterator()
        while (true) {
            match (iter.next()) {
                case Some((tag, val: Any)) => result[tag] = accessors[tag].clone(val)
                case _ => break
            }
        }
        result
    }

    /* 打包接口 */
    public func pack(out: Bytes) {
        let accessors = getAccessors()
        let iter = fields.iterator()
        while (true) {
            match (iter.next()) {
                // todo: 引用类型bytes, message, 为`空`时, proto3不打包, proto2打包
                case Some((tag, val: Any)) => accessors[tag].pack(tag, val, out)
                case _ => break
            }
        }
        // // cangjie 0.28.4 bug, 不能使用for in进行遍历
        // for ((tag, val) in fields) {
        //     accessors[tag].pack(tag, val, out)
        // }
        for (field in unknownFields) {
            field.pack(out)
        }
    }

    /* 解包接口 */
    public func unpack(src: SimpleReader) {
        let accessors = getAccessors()
        while (!src.isEmpty()) {
            let (tag, wt) = tagParse(src)
            if (accessors.contains(tag)) {
                fields[tag] = accessors[tag].unpack(tag, src)
            } else {
                unknownFields.add(MessageUnknownField.unpack(tag, wt, src))
            }
        }
        this
    }

    /* 解包接口 */
    public func unpack(src: Collection<Byte>) {
        unpack(SimpleReader(Array<UInt8>(src)))
    }

    /* 转成类似JSON的字符串(enum, bytes与JSON存在差异) */
    public func toString() {
        let sb = StringBuilder("{")
        var dot = false
        let names = getNames()
        let accessors = getAccessors()
        /* cangjie 0.28.4 bug, 此处不支持for in */
        let iter = fields.iterator()
        while (true) {
            match (iter.next()) {
                case Some((tag, val: Any)) =>
                    // debug(val, "toString(${names[tag]})")
                    if (dot) { sb.append(", ") } else { dot = true }
                    sb.append("\"${names[tag]}\"").append(": ").append(accessors[tag].toString(val))
                case _ => break
            }
        }
        sb.append('}').toString()
    }

    /* 供子类获取指定field的值 */
    protected func get<T>(tag: Tag): T where T <: Default<T> {
        if (fields.contains(tag)) { return dynamic_cast(fields[tag]) }
        let default = T.default()
        /* 引用类型保存到fields并返回 */
        if (reference(default)) { fields[tag] = default; return default }
        /* proto3直接返回类型的缺省值 */
        if (!proto2) { default }
        /* 如果是proto2, 有设置缺省值, 返回缺省值, 否则抛出异常 */
        match (getDefaultValue().get(tag)) {
            case Some(v) => return dynamic_cast(v)
            case _ => throw GetFieldValueException(getNames()[tag])
        }
    }

    /* 供子类设置指定field的值 */
    protected func set(tag: Tag, val: Any): Unit {
        // debug(val, "set(${getNames()[tag]})")
        /* proto2会保存设置的所有值, proto3不保存值类型的`0`值 */
        if (proto2 || !zeroish(val)) { return fields[tag] = val }
        fields.remove(tag); ()
    }

    protected func has(tag: Tag): Bool {
        fields.contains(tag)
    }

    /* clean all the field's value */
    public func clear(): Unit {
        fields.clear()
    }
}
