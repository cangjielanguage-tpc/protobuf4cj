/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

package protobuf

from std import sync.*

public abstract class MessageLite2 <: MessageLite {
    /* special fields info of proto2 */
    protected var m_defaultValue = s_initHashMapTagMessageFile
    protected var m_requiredFields = s_initArrayTag

    /* check required fields */
    protected func m_requiredFieldsCheck() {
        for (tag in m_requiredFields) {
            if (!m_fields.contains(tag) && !m_defaultValue.contains(tag)) {
                throw RequiredFieldNotSetException(m_names[tag])
            }
        }
    }

    /* check if field should be packed */
    protected func m_packCheck(val: MessageField): Bool {
        match (val) {
            case _: Reference => !val.isEmpty()
            case _ => true
        }
    }

    /* set proto2 message field's value */
    protected func set(tag: Tag, val: MessageField): Unit {
        m_fields[tag] = val

        if (let Some(idx) = m_oneofIndex.get(tag)) {
            let c = m_oneofCase[idx]
            if (c != tag) {
                m_oneofCase[idx] = tag
            } else if (c != UNSETCASE) {
                m_fields.remove(c)
            }
        }
    }

    /* get proto2 message field's value by tag */
    protected func get_(tag: Tag): MessageField {
        if (let Some(v) = m_fields.get(tag)) {
            return v
        }

        if (let Some(idx) = m_oneofIndex.get(tag)) {
            let c = m_oneofCase[idx]
            if (c != UNSETCASE) {
                throw UnmatchedOneofCaseException(m_names[tag], m_names[c])
            }
        }

        /* proto2 default value */
        if (let Some(v) = m_defaultValue.get(tag)) {
            return v
        }

        /* proto2, value must be set before reading */
        let default = m_unpacker[tag].default()
        match (default) {
            case _: Reference => set(tag, default); return default
            case _ => throw GetFieldValueException(m_names[tag])
        }
    }
}

public abstract class MessageLite <: MessageField & ToJson & ToString {
    /* init value of all kinds of collections in message_lite. */
    protected static let s_initHashMapTagUnpacker = HashMap<Tag, Unpacker>()
    protected static let s_initHashMapTagString = HashMap<Tag, String>()
    protected static let s_initHashMapTagMessageFile = HashMap<Tag, MessageField>()
    protected static let s_initHashMapTagInt64 = HashMap<Tag, Int64>()
    protected static let s_initHashMapStringTag = HashMap<String, Tag>()
    protected static let s_initArrayTag = Array<Tag>()

    /* once mutex of messages */
    private static let s_onceMutex = sync.ReentrantMutex()
    protected static func s_newOnce() {
        Once(s_onceMutex)
    }

    /* message_lite fields info table */
    protected var m_unpacker = s_initHashMapTagUnpacker
    protected var m_names = s_initHashMapTagString
    protected var m_nameTags = s_initHashMapStringTag

    protected static let UNSETCASE: Tag = 0xffffffff
    protected var m_oneofIndex = s_initHashMapTagInt64  /* group index of oneof sub fields */
    protected var m_oneofCase = s_initArrayTag /* case of oneof group */

    /* unknown fields */
    public var unknownFields = ArrayList<MessageUnknownField>()
    protected let m_fields = HashMap<Tag, MessageField>()

    /* clone all fields */
    protected func m_fieldsClone(m: MessageLite) {
        if (!m_oneofCase.isEmpty()) {
            m_oneofCase = m.m_oneofCase.clone()
        }
        for ((tag, val) in m.m_fields) {
            m_fields[tag] = clone(val)
        }
    }

    /* check required fields, proto3 has no required fields */
    protected open func m_requiredFieldsCheck() { return }

    /* check if field should be pack, proto3 will not pack any empty field */
    protected open func m_packCheck(val: MessageField): Bool {
        match (val) {
            case c: Bytes => !c.isEmpty()
            case c: MessageLite => !c.isEmpty()
            case _: Reference => !val.isEmpty()
            case _ => true
        }
    }

    /* return the size of packing required. */
    public func packSize(): Int64 {
        var ret = 0
        for ((tag, val) in m_fields) {
            if (m_packCheck(val)) {
                ret += tag.tagSize + packSize(val)
            }
        }
        for (val in unknownFields) {
            ret += val.packSize()
        }
        ret
    }

    /**
     * pack the message to the bytes writer.
     * for example, `ArrayList<Byte>` is a commonly used bytes writer.
     */
    public func pack(out: BytesWriter): Unit {
        m_requiredFieldsCheck()
        for ((tag, val) in m_fields) {
            if (m_packCheck(val)) {
                tag.tagPack(wireType(val), out)
                pack(val, out)
            }
        }
        for (val in unknownFields) {
            val.pack(out)
        }
    }

    /* return packing result, `Bytes` is the alias of `ArrayList<Byte>`. */
    public func pack(): Bytes {
        let ret = Bytes()
        pack(ret)
        ret
    }

    /* unpack from a readonly bytes collection. */
    public func unpack(src: Collection<Byte>) {
        unpack(SimpleReader(src))
    }

    /* unpack from a bytes reader. */
    public func unpack(src: BytesReader) {
        while (!src.isEmpty()) {
            let (tag, wt) = Tag.tagParse(src)
            match (m_unpacker.get(tag)) {
                case Some(unpacker) => set(tag, unpacker.unpack(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(tag, wt, src))
            }
        }
    }

    /* unpack from JSON object */
    public func unpack(src: JsonObject) {
        for ((k, v) in src) {
            let tag = m_nameTags[k]
            set(tag, m_unpacker[tag].unpack(v))
        }
    }

    /* clone */
    public func clone(): MessageLite

    /* clear */
    public func clear() {
        for (i in 0..m_oneofCase.size) {
            m_oneofCase[i] = UNSETCASE
        }
        m_fields.clear()
        unknownFields.clear()
    }

    /* whether if the message is empty: has no fields set or all the fields is empty. */
    public func isEmpty() {
        for ((_, val) in m_fields) {
            if (m_packCheck(val)) {
                return false
            }
        }
        return unknownFields.isEmpty()
    }

    /* to string */
    public func toString() {
        m_requiredFieldsCheck()
        let sb = StringBuilder("{")
        var sep = false
        for ((tag, val) in m_fields) {
            if (sep) { sb.append(", ") } else { sep = true }
            sb.append(m_names[tag]).append(": ")
            match (val) {
                case str: JsonString => str.stringify(sb)
                case _ => sb.append(val.toString())
            }
        }
        sb.append('}').toString()
    }

    /* to Json */
    public func toJson(): Json /* JsonObject */ {
        let obj = JsonObject()
        for ((tag, val) in m_fields) {
            obj[m_names[tag]] = toJson(val)
        }
        obj
    }

    /* set message field's value */
    protected open func set(tag: Tag, val: MessageField): Unit {
        let cs = if (reference(val) || !val.isEmpty()) {
            m_fields[tag] = val; tag
        } else {
            m_fields.remove(tag); UNSETCASE
        }

        if (let Some(idx) = m_oneofIndex.get(tag)) {
            let c = m_oneofCase[idx]
            if (c != tag && c != UNSETCASE) { m_fields.remove(c) }
            if (c != cs) { m_oneofCase[idx] = cs }
        }
    }

    /* get message field's value by tag */
    protected open func get_(tag: Tag): MessageField {
        if (let Some(v) = m_fields.get(tag)) {
            return v
        }

        if (let Some(idx) = m_oneofIndex.get(tag)) {
            let c = m_oneofCase[idx]
            if (c != UNSETCASE) {
                throw UnmatchedOneofCaseException(m_names[tag], m_names[c])
            }
        }

        let default = m_unpacker[tag].default()
        if (reference(default)) {
            set(tag, default)
        }

        return default
    }

    /* get typeof `T` value from message field */
    protected func get<T>(tag: Tag): T {
        typeCast(get_(tag))
    }
}

/* cangjie 0.32.5, static default implementation in interface is forbidden now */
public interface MessageParser<M> where M <: MessageLite & MessageParser<M> {
    static func fromJson(src: JsonReader): M
    static func fromJson(src: String): M
    static func fromBytes(src: Collection<Byte>): M
    /* do not delete!
    static func fromJson(src: JsonReader): M { M.fromJson(src.readObject()) }
    static func fromJson(src: String): M { M.fromJson(JsonParse(src).asObject()) }
    static func fromBytes(src: Collection<Byte>): M { M.fromBytes(SimpleReader(src)) }
    */
    static func fromBytes(src: BytesReader): M
    static func fromJson(src: JsonObject): M
}

public struct Once {
    public Once(
        private let m: sync.ReentrantMutex
    ) { }

    public init() {
        m = sync.ReentrantMutex()
    }

    private let e = sync.AtomicBool(false)

    public func once(f: ()-> Unit) {
        if (e.load()) { return }
        m.lock()
        if (!e.load()) {
            f()
            e.store(true)
        }
        m.unlock()
    }
}