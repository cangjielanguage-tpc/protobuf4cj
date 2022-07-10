/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file about: protobuf.
 */
package protobuf

/**
 * An unknown message field.
 * @author tutudo
 * @since 0.29.3
 */
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

    /**
     * The Function is toString
     *
     * @return Type of $
     * @since 0.29.3
     */
    public func toString() { "tag: ${tag}, wireType: ${wireType}, data: ${data}" }
}

/**
 * The interface is ValuedEnum
 * @author tutudo
 * @since 0.29.3
 */
public interface ValuedEnum {
    func value(): Int32
}

/**
 * base of protobuf enum
 * @author tutudo
 * @since 0.29.3
 */
public interface Enum<E> <: ValuedEnum & ToString & Hashable & Equatable<E> where E <: Enum<E> {
    static func parse(v: Int32): E
    static func parse(v: String): E
    func hashCode() { value().hashCode() }
    operator func ==(right: E) { value() == right.value() }
    operator func !=(right: E) { value() != right.value() }
}

/**
 * base of protobuf message
 * @author tutudo
 * @since 0.29.3
 */
public abstract class MessageLite <: ToString {
    protected func getAccessors(): HashMap<Tag, Accessor>
    protected func getNames(): HashMap<Tag, String>

    /**
     * The Function is clone
     * Because specific type information is required, it can only be given to subclass implementation
     *
     * @return Type of MessageLite
     * @since 0.29.3
     */
    public func clone(): MessageLite

    public var unknownFields = ArrayList<MessageUnknownField>()
    protected var m_fields = HashMap<Tag, Any>()

    /* default proto2*/
    protected open func m_proto2() { true }

    /* proto2 default value */
    protected open func getDefaultValue(): ?HashMap<Tag, Any> { None }

    /* proto2 required fields */
    protected open func getRequiredFields(): ?Array<Tag> { None }

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

    protected func m_requiredFieldsCheck() {
        if (!m_proto2()) { return () }
        for (tag in getRequiredFields() ?? []) {
            if (!m_fields.contains(tag) && getDefaultValue()?.contains(tag) != true) {
                throw RequiredFieldNotSetException(getNames()[tag])
            }
        }
    }

    /**
     * Packaging interface
     *
     * @param out of Bytes
     *
     * @since 0.29.3
     */
    public func pack(out: Bytes) {
        m_requiredFieldsCheck()
        let accessors = getAccessors()
        for ((tag, val) in m_fields) {
            accessors[tag].pack(tag, val, out)
        }
        for (field in unknownFields) {
            field.pack(out)
        }
    }

    /**
     * Unpacking interface
     *
     * @param src of SimpleReader
     *
     * @since 0.29.3
     */
    public func unpack(src: SimpleReader) {
        let accessors = getAccessors()
        while (!src.isEmpty()) {
            let (tag, wt) = tagParse(src)
            if (accessors.contains(tag)) {
                m_fields[tag] = accessors[tag].unpack(tag, src)
            } else {
                unknownFields.append(MessageUnknownField.unpack(tag, wt, src))
            }
        }
        this
    }

    /**
     * Unpacking interface
     *
     * @param src of Collection<Byte>
     *
     * @since 0.29.3
     */
    public func unpack(src: Collection<Byte>) {
        unpack(SimpleReader(
            match (src) {
                case arr: Array<UInt8> => arr
                case _ => Array(src)
            }
        ))
    }

    /**
     * Convert to JSON like string (enum, bytes are different from JSON)
     *
     * @param src of Collection<Byte>
     *
     * @since 0.29.3
     */
    public func toString() {
        m_requiredFieldsCheck()
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

    /* For subclasses to get the value of the specified field */
    protected func get<T>(tag: Tag): T where T <: Default<T> {
        if (m_fields.contains(tag)) { return dynamic_cast(m_fields[tag]) }
        match (getOneofIndex()?.get(tag)) {
            /* oneof field, and the current oneof group case is not this field */
            case Some(Some(index)) =>
                let c = getOneofCase().getOrThrow()[index]
                if (c != tag && c != UNSETCASE) { throw UnmatchedOneofCaseException(getNames()[tag], getNames()[c]) }
            case _ => ()
        }
        let default = T.default()

        /* Save the reference type to fields and return */
        if (reference(default)) { m_fields[tag] = default; return default }

        /* Proto3 directly returns the default value of the type */
        if (!m_proto2()) { return default }

        /* If it is proto2, the default value is set and returned; otherwise, an exception is thrown */
        match (getDefaultValue()?.get(tag)) {
            case Some(Some(v)) => return dynamic_cast(v)
            case _ => throw GetFieldValueException(getNames()[tag])
        }
    }

    /* The value of the specified field for subclass settings */
    protected func set(tag: Tag, val: Any): Unit {
        /* Proto2 will save all the set values, while proto3 will not save the '0' value of the value type */
        let cnew = if (m_proto2() || !zeroish(val)) { m_fields[tag] = val; tag } else { m_fields.remove(tag); UNSETCASE }
        match (getOneofIndex()?.get(tag)) {

            /* If the previous oneof is another field, you need to clear it and set the case to the current tag */
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

    /**
     * clean all the field's value
     *
     * @return Type of Unit
     * @since 0.29.3
     */
    public func clear(): Unit {
        m_fields.clear()
        match (getOneofCase()) {
            case Some(a) => for (i in 0..a.size()) { a[i] = UNSETCASE }
            case _ => ()
        }
    }
}
