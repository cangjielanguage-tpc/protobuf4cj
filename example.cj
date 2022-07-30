/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

package protobuf

/*
message M_example {
    uint64 num = 1;
    string name = 2;
    sint32 sval = 3;
    repeated string ss = 4;
    repeated int64 nums = 5 [packed = true];
    map<sint64, string> mm = 6;
}

message M1 {
    repeated M_example msgs = 1;
}
 */

public class M_example <: MessageLite {
    static let m_once = Once()
    static var s_unpackers = s_initHashMapTagUnpacker
    static var s_names = s_initHashMapTagString
    static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, UInt64Unpacker.instance), (2, StringUnpacker.instance), (3, SInt32Unpacker.instance),
            (4, StringUnpacker.repeatInstance(4)), (5, Int64Unpacker.packedInstance),
            (6, MapUnpacker<Int64, String>(6, SInt64Unpacker.unbox, StringUnpacker.unbox))
        ])

        s_names = HashMap<Tag, String>([
            (1, "num"), (2, "name"), (3, "sval"), (4, "ss"), (5, "nums"), (6, "mm")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("num", 1), ("name", 2), ("sval", 3), ("ss", 4), ("nums", 5), ("mm", 6)
        ])
        // has no dafault value
        // has no required fields
        // has no oneof fields
    }

    public init() {
        // proto3
        m_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
        // has no dafault value
        // has no required fields
        // has no oneof fields
    }

    public func clone() {
        M_example().m_fieldsClone(this)
    }

    public prop var num: UInt64 {
        get() { get(1) }
        set(v) { set(1, v) }
    }

    public prop var name: String {
        get() { get(2) }
        set(v) { set(2, v) }
    }

    public prop var sval: Int32 {
        get() { get(3) }
        set(v) { set(3, SInt32(v)) }
    }

    public prop var ss: ArrayList<String> {
        get() { get(4) }
        set(v) { set(4, RepeatField<String>(4, v)) }
    }

    public prop var nums: ArrayList<Int64> {
        get() { get(5) }
        set(v) { set(5, PackedField<Int64>(v)) }
    }

    public prop var mm: HashMap<Int64, String> {
        get() { get(6) }
        set(v) { set(6, MapField<Int64, String>(6, v, kb: SInt64.box)) }
    }
}

extend M_example <: MessageParser<M_example> {
    public static func fromJson(src: JsonObject) {
        let m = M_example()
        m.parse(src)
        m
    }

    public static func fromBytes(src: BytesReader) {
        let m = M_example()
        m.unpack(src)
        m
    }
}

public class M1 <: MessageLite {
    static let m_once = Once()
    static var s_unpackers = s_initHashMapTagUnpacker
    static var s_names = s_initHashMapTagString
    static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, MessageUnpacker<M_example>.repeatInstance(1))
        ])

        s_names = HashMap<Tag, String>([
            (1, "msgs")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("msgs", 1)
        ])
        // has no dafault value
        // has no required fields
        // has no oneof fields
    }

    public init() {
        // proto3
        m_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
        // has no dafault value
        // has no required fields
        // has no oneof fields
    }

    public func clone() {
        M1().m_fieldsClone(this)
    }

    public prop var msgs: ArrayList<M_example> {
        get() { get(1) }
        set(v) { set(1, RepeatField<M_example>(1, v)) }
    }
}

extend M1 <: MessageParser<M1> {
    public static func fromJson(src: JsonObject) { let m = M1(); m.parse(src); m }
    public static func fromBytes(src: BytesReader) { let m = M1(); m.unpack(src); m }
}