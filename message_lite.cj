/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

package protobuf

from std import sync.*

public abstract class MessageLite <: MessageField & ToJson & ToString {
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
        if (!m_proto2) {
            return
        }

        if (m_requiredFields.isEmpty()) {
            return
        }

        for (tag in m_requiredFields) {
            if (!m_fields.contains(tag) && !m_defaultValue.contains(tag)) {
                throw RequiredFieldNotSetException(m_names[tag])
            }
        }
    }

    /* 
     * proto3 will not pack any empty field
     * proto2 will not pack any empty array or map, but pack empty bytes and message.
     */
    private func packCheck(val: MessageField): Bool {
        match (val) {
            case c: Bytes => m_proto2 || !c.isEmpty()
            case c: MessageLite => if (m_proto2) { true } else { !c.isEmpty() }
            case _: Reference => !val.isEmpty()
            case _ => true
        }
    }

    /* return the size of packing required. */
    public func packSize(): Int64 {
        var ret = 0
        for ((tag, val) in m_fields) {
            if (packCheck(val)) {
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
            if (packCheck(val)) {
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

    /* whether if the message is empty: has no fields set or all the fields is empty. */
    public func isEmpty() {
        if (m_fields.isEmpty()) {
            return true
        }
        packSize() == 0
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

    protected func set(tag: Tag, val: MessageField): Unit {
        let cs = if (m_proto2 || reference(val) || !val.isEmpty()) {
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

        if (let Some(v) = m_defaultValue.get(tag)) {
            return v
        }

        throw GetFieldValueException(m_names[tag])
    }

    /* get typeof `T` value from message field */
    protected func get<T>(tag: Tag): T {
        typeCast(get_(tag))
    }
}

/* cangjie 0.31.4 bug, fromBytes cannot call the another one fromBytes. */
public interface MessageParserTmp<M> where M <: MessageLite {
    static func fromBytes(src: BytesReader): M
    static func fromJson(src: JsonObject): M
}

public interface MessageParser<M> <: MessageParserTmp<M> where M <: MessageLite & MessageParser<M> {
    static func fromJson(src: JsonReader): M { src.skipWhitespace(); M.fromJson(src.readObject()) }
    static func fromJson(src: String): M { M.fromJson(JsonParse(src).asObject()) }
    static func fromBytes(src: Collection<Byte>): M { M.fromBytes(SimpleReader(src)) }
}

public class Once {
    var e = sync.AtomicBool(false)
    let m = sync.ReentrantMutex()

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