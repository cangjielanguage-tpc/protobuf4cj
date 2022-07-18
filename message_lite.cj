/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

package protobuf

from std import sync.*

public abstract class MessageLite <: MessageField & Json & ToString {
    /* init value of all kinds of collections in message_lite. */
    protected static let s_initHashMapTagUnpacker = HashMap<Tag, Unpacker>()
    protected static let s_initHashMapTagString = HashMap<Tag, String>()
    protected static let s_initHashMapTagMessageFile = HashMap<Tag, MessageField>()
    protected static let s_initHashMapTagInt64 = HashMap<Tag, Int64>()
    protected static let s_initHashMapStringTag = HashMap<String, Tag>()
    protected static let s_initArrayTag = Array<Tag>()

    protected var m_proto2 = true
    protected var m_unpacker = s_initHashMapTagUnpacker
    protected var m_names = s_initHashMapTagString
    protected var m_nameTags = s_initHashMapStringTag
    protected var m_defaultValue = s_initHashMapTagMessageFile
    protected var m_requiredFields = s_initArrayTag

    protected static let UNSETCASE: Tag = 0xffffffff
    protected var m_oneofIndex = s_initHashMapTagInt64  /* 与类绑定 */
    protected var m_oneofCase = s_initArrayTag /* 对象间独立 */

    public var unknownFields = ArrayList<MessageUnknownField>()
    protected let m_fields = HashMap<Tag, MessageField>()

    protected func m_fieldsClone(m: MessageLite) {
        if (!m_oneofCase.isEmpty()) {
            m_oneofCase = m.m_oneofCase.clone()
        }
        for ((tag, val) in m.m_fields) {
            m_fields[tag] = clone(val)
        }
        this
    }

    protected func m_requiredFieldsCheck() {
        if (!m_proto2 || m_requiredFields.isEmpty()) { return }
        for (tag in m_requiredFields) {
            if (!m_fields.contains(tag) && !m_defaultValue.contains(tag)) {
                throw RequiredFieldNotSetException(m_names[tag])
            }
        }
    }

    public func packSize(): Int64 {
        var ret = 0
        for ((tag, val) in m_fields) {
            if (!val.isEmpty()) {
                ret += tag.tagSize + packSize(val)
            }
        }
        for (val in unknownFields) {
            ret += val.packSize()
        }
        ret
    }

    public func pack(out: Writer<Byte>): Unit {
        m_requiredFieldsCheck()
        for ((tag, val) in m_fields) {
            if (!val.isEmpty()) {
                tag.tagPack(wireType(val), out)
                pack(val, out)
            }
        }
        for (val in unknownFields) {
            val.pack(out)
        }
    }

    public func unpack(src: Collection<Byte>) {
        unpack(SimpleReader(src))
    }

    public func unpack(src: BytesReader) {
        while (!src.isEmpty()) {
            let (tag, wt) = Tag.tagParse(src)
            match (m_unpacker.get(tag)) {
                case Some(unpacker) => set(tag, unpacker.unpack(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(tag, wt, src))
            }
        }
    }

    /* clone */
    public func clone(): MessageLite

    public func isEmpty() { m_fields.isEmpty() || packSize() == 0 }

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

    public func stringify(os: JsonSerializer): Unit {
        m_requiredFieldsCheck()
        var sep = false
        os.append("{")
        for ((tag, val) in m_fields) {
            if (sep) { os.append(", ") } else { sep = true }
            os.append("\"${m_names[tag]}\"")
            os.append(": ")
            stringify(val, os)
        }
        os.append("}")
    }

    protected func set(tag: Tag, val: MessageField): Unit {
        let cs = if (m_proto2 || !val.isEmpty()) { m_fields[tag] = val; tag } else { m_fields.remove(tag); UNSETCASE }
        if (let Some(idx) = m_oneofIndex.get(tag)) {
            let c = m_oneofCase[idx]
            if (c != tag && c != UNSETCASE) { m_fields.remove(c) }
            if (c != cs) { m_oneofCase[idx] = cs }
        }
    }

    private func get_(tag: Tag): MessageField {
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
            set(tag, default); return default
        }

        if (!m_proto2) {
            return default
        }

        // todo not support reference default value yet.
        if (let Some(v) = m_defaultValue.get(tag)) {
            return v
        }

        throw GetFieldValueException(m_names[tag])
    }

    /* get typeof `T` value from message field */
    protected func get<T>(tag: Tag): T {
        match (get_(tag)) {
            case val: ValuedMessageField => (val.value() as T).getOrThrow()
            case val => (val as T).getOrThrow()
        }
    }
}

public interface MessageParser<M> where M <: MessageLite & MessageParser<M> {
    static func fromJson(src: JsonReader): M
    static func fromBytes(src: BytesReader): M
    static func fromBytes(src: Collection<Byte>): M { M.fromBytes(SimpleReader(src)) }
}

public class Once {
    var e = false
    let m = sync.ReentrantMutex()

    public func once(f: ()-> Unit) {
        if (e) { return }
        m.lock()
        if (!e) {
            e = true
            f()
        }
        m.unlock()
    }
}