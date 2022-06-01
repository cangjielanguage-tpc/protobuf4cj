package protobuf

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
public interface Enum<E> <: ValuedEnum & ToString & Hashable & Equatable<E> where E <: Enum<E> {
    static func parse(v: Int32): E
    static func parse(v: String): E
    func hashCode() { value().hashCode() }
    operator func ==(right: E) { value() == right.value() }
    operator func !=(right: E) { value() != right.value() }
}

/* base of protobuf message */
public abstract class MessageLite <: ToString {
    protected func getAccessors(): HashMap<Tag, Accessor>
    protected func getNames(): HashMap<Tag, String> // 现阶段不完全确定哪些信息必须提供，故单独提供，后期再整合
    protected open func getDefaultValue(): ?HashMap<Tag, Any> { None } // proto3用不到, 故提供默认实现, proto2需覆盖此函数
    public func clone(): MessageLite // 由于需要具体的类型信息，只能交给子类具体实现

    public var unknownFields = Buffer<MessageUnknownField>()
    protected var m_fields = HashMap<Tag, Any>()
    protected open func m_proto2() { true } // 默认proto2

    /* oneof */
    protected static let UNSETCASE: Tag = 0xffffffff
    protected open func getOneofCase(): ?Array<Tag> { None }
    protected open func getOneofIndex(): ?HashMap<Tag, Int64> { None }

    protected func m_fieldsClone() {
        let result = HashMap<Tag, Any>()
        let accessors = getAccessors()
        for ((tag, val) in m_fields) {
            result[tag] = accessors[tag].clone(val)
        }
        result
    }

    /* 打包接口 */
    public func pack(out: Bytes) {
        let accessors = getAccessors()
        for ((tag, val) in m_fields) {
            accessors[tag].pack(tag, val, out)
        }
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
                m_fields[tag] = accessors[tag].unpack(tag, src)
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
        for ((tag, val) in m_fields) {
            if (dot) { sb.append(", ") } else { dot = true }
            sb.append("\"${names[tag]}\"").append(": ").append(accessors[tag].toString(val))
        }
        sb.append('}').toString()
    }

    /* 供子类获取指定field的值 */
    protected func get<T>(tag: Tag): T where T <: Default<T> {
        if (m_fields.contains(tag)) { return dynamic_cast(m_fields[tag]) }
        match (getOneofIndex()?.get(tag)) {
            /* oneof field, 且当前oneof组case不为该field */
            case Some(Some(index)) =>
                let c = getOneofCase().getOrThrow()[index]
                if (c != tag && c != UNSETCASE) { throw UnmatchedOneofCaseException(getNames()[tag], getNames()[c]) }
                else { () } // 偶现warning: Node thunk(id:24678) has type (Enum-Option<Enum-Option<Int64>>) -> Record-String but type (Enum-Option<Int64>) -> Record-String is expected.
            case _ => ()
        }
        let default = T.default()
        /* 引用类型保存到fields并返回 */
        if (reference(default)) { m_fields[tag] = default; return default }
        /* proto3直接返回类型的缺省值 */
        if (!m_proto2()) { return default }
        /* 如果是proto2, 有设置缺省值, 返回缺省值, 否则抛出异常 */
        match (getDefaultValue()?.get(tag)) {
            case Some(Some(v)) => return dynamic_cast(v)
            case _ => throw GetFieldValueException(getNames()[tag])
        }
    }

    /* 供子类设置指定field的值 */
    protected func set(tag: Tag, val: Any): Unit {
        // debug(val, "set(${getNames()[tag]})")
        /* proto2会保存设置的所有值, proto3不保存值类型的`0`值 */
        let cnew = if (m_proto2() || !zeroish(val)) { m_fields[tag] = val; tag } else { m_fields.remove(tag); UNSETCASE }
        match (getOneofIndex()?.get(tag)) {
            /* 若之前oneof为其它field, 需要清除它, 并设置case为当前tag */
            case Some(Some(index)) =>
                let c = getOneofCase().getOrThrow()[index]
                if (c != tag && c != UNSETCASE) { m_fields.remove(c) }
                if (c != cnew) { getOneofCase().getOrThrow()[index] = cnew }
            case _ => ()
        }
    }

    protected func has(tag: Tag): Bool {
        m_fields.contains(tag)
    }

    /* clean all the field's value */
    public func clear(): Unit {
        m_fields.clear()
        match (getOneofCase()) {
            case Some(a) => for (i in 0..a.size()) { a[i] = UNSETCASE }
            case _ => ()
        }
    }
}
