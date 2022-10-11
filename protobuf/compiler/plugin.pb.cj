package google.protobuf.compiler

from std import collection.*
from protobuf import protobuf.*
import google.protobuf.*

public class Version <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, Int32Unpacker.instance), (2, Int32Unpacker.instance), (3, Int32Unpacker.instance),
            (4, StringUnpacker.instance)
        ])

        s_names = HashMap<Tag, String>([
            (1, "major"), (2, "minor"), (3, "patch"), (4, "suffix")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("major", 1), ("minor", 2), ("patch", 3), ("suffix", 4)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): Version { let m = Version(); m.m_fieldsClone(this); m }

    public prop var major: Int32 {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var minor: Int32 {
        get( ) { get(2) }
        set(v) { set(2, v) }
    }

    public prop var patch: Int32 {
        get( ) { get(3) }
        set(v) { set(3, v) }
    }

    public prop var suffix: String {
        get( ) { get(4) }
        set(v) { set(4, v) }
    }
}

extend Version <: MessageParser<Version> {
    public static func fromJson(src: JsonObject) { let m = Version(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = Version(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class CodeGeneratorRequest <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, StringUnpacker.repeatInstance(1)), (2, StringUnpacker.instance),
            (15, MessageUnpacker<google.protobuf.FileDescriptorProto>.repeatInstance(15)),
            (3, MessageUnpacker<Version>.instance)
        ])

        s_names = HashMap<Tag, String>([
            (1, "fileToGenerate"), (2, "parameter"), (15, "protoFile"), (3, "compilerVersion")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("fileToGenerate", 1), ("parameter", 2), ("protoFile", 15), ("compilerVersion", 3)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): CodeGeneratorRequest { let m = CodeGeneratorRequest(); m.m_fieldsClone(this); m }

    public prop var fileToGenerate: ArrayList<String> {
        get( ) { get(1) }
        set(v) { set(1, RepeatField<String>(1, v)) }
    }

    public prop var parameter: String {
        get( ) { get(2) }
        set(v) { set(2, v) }
    }

    public prop var protoFile: ArrayList<google.protobuf.FileDescriptorProto> {
        get( ) { get(15) }
        set(v) { set(15, RepeatField<google.protobuf.FileDescriptorProto>(15, v)) }
    }

    public prop var compilerVersion: Version {
        get( ) { get(3) }
        set(v) { set(3, v) }
    }
}

extend CodeGeneratorRequest <: MessageParser<CodeGeneratorRequest> {
    public static func fromJson(src: JsonObject) { let m = CodeGeneratorRequest(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = CodeGeneratorRequest(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class CodeGeneratorResponse_File <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, StringUnpacker.instance), (2, StringUnpacker.instance), (15, StringUnpacker.instance),
            (16, MessageUnpacker<google.protobuf.GeneratedCodeInfo>.instance)
        ])

        s_names = HashMap<Tag, String>([
            (1, "name"), (2, "insertionPoint"), (15, "content"), (16, "generatedCodeInfo")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("name", 1), ("insertionPoint", 2), ("content", 15), ("generatedCodeInfo", 16)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): CodeGeneratorResponse_File { let m = CodeGeneratorResponse_File(); m.m_fieldsClone(this); m }

    public prop var name: String {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var insertionPoint: String {
        get( ) { get(2) }
        set(v) { set(2, v) }
    }

    public prop var content: String {
        get( ) { get(15) }
        set(v) { set(15, v) }
    }

    public prop var generatedCodeInfo: google.protobuf.GeneratedCodeInfo {
        get( ) { get(16) }
        set(v) { set(16, v) }
    }
}

extend CodeGeneratorResponse_File <: MessageParser<CodeGeneratorResponse_File> {
    public static func fromJson(src: JsonObject) { let m = CodeGeneratorResponse_File(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = CodeGeneratorResponse_File(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public enum CodeGeneratorResponse_Feature {
    | FEATURE_NONE | FEATURE_PROTO3_OPTIONAL
}

extend CodeGeneratorResponse_Feature <: Enum<CodeGeneratorResponse_Feature> {
    public func value(): Int32 {
        match(this) {
            case FEATURE_NONE => 0
            case FEATURE_PROTO3_OPTIONAL => 1
        }
    }

    public func toString(): String {
        match(this) {
            case FEATURE_NONE => "FEATURE_NONE"
            case FEATURE_PROTO3_OPTIONAL => "FEATURE_PROTO3_OPTIONAL"
        }
    }

    public static func parse(value: Int32): CodeGeneratorResponse_Feature {
        match(value) {
            case 0 => FEATURE_NONE
            case 1 => FEATURE_PROTO3_OPTIONAL
            case e => throw InvalidEnumValueException("CodeGeneratorResponse_Feature", e)
        }
    }

    public static func parse(value: String): CodeGeneratorResponse_Feature {
        match(value) {
            case "FEATURE_NONE" => FEATURE_NONE
            case "FEATURE_PROTO3_OPTIONAL" => FEATURE_PROTO3_OPTIONAL
            case e => throw UnmatchedEnumStringException("CodeGeneratorResponse_Feature", e)
        }
    }
}

public class CodeGeneratorResponse <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, StringUnpacker.instance), (2, UInt64Unpacker.instance),
            (15, MessageUnpacker<CodeGeneratorResponse_File>.repeatInstance(15))
        ])

        s_names = HashMap<Tag, String>([
            (1, "error"), (2, "supportedFeatures"), (15, "file")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("error", 1), ("supportedFeatures", 2), ("file", 15)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): CodeGeneratorResponse { let m = CodeGeneratorResponse(); m.m_fieldsClone(this); m }

    public prop var error: String {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var supportedFeatures: UInt64 {
        get( ) { get(2) }
        set(v) { set(2, v) }
    }

    public prop var file: ArrayList<CodeGeneratorResponse_File> {
        get( ) { get(15) }
        set(v) { set(15, RepeatField<CodeGeneratorResponse_File>(15, v)) }
    }
}

extend CodeGeneratorResponse <: MessageParser<CodeGeneratorResponse> {
    public static func fromJson(src: JsonObject) { let m = CodeGeneratorResponse(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = CodeGeneratorResponse(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}
