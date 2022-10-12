package google.protobuf

from std import collection.*
from protobuf import protobuf.*

public class FileDescriptorSet <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, MessageUnpacker<FileDescriptorProto>.repeatInstance(1))
        ])

        s_names = HashMap<Tag, String>([
            (1, "file")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("file", 1)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): FileDescriptorSet { let m = FileDescriptorSet(); m.m_fieldsClone(this); m }

    public prop var file: ArrayList<FileDescriptorProto> {
        get( ) { get(1) }
        set(v) { set(1, RepeatField<FileDescriptorProto>(1, v)) }
    }
}

extend FileDescriptorSet <: MessageParser<FileDescriptorSet> {
    public static func fromJson(src: JsonObject) { let m = FileDescriptorSet(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = FileDescriptorSet(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class FileDescriptorProto <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, StringUnpacker.instance), (2, StringUnpacker.instance), (3, StringUnpacker.repeatInstance(3)),
            (10, Int32Unpacker.repeatInstance(10)), (11, Int32Unpacker.repeatInstance(11)),
            (4, MessageUnpacker<DescriptorProto>.repeatInstance(4)),
            (5, MessageUnpacker<EnumDescriptorProto>.repeatInstance(5)),
            (6, MessageUnpacker<ServiceDescriptorProto>.repeatInstance(6)),
            (7, MessageUnpacker<FieldDescriptorProto>.repeatInstance(7)), (8, MessageUnpacker<FileOptions>.instance),
            (9, MessageUnpacker<SourceCodeInfo>.instance), (12, StringUnpacker.instance)
        ])

        /* cangjie 0.32.5 bug, 1 is not exists in s_unpackers */
        s_unpackers[1] = StringUnpacker.instance

        s_names = HashMap<Tag, String>([
            (1, "name"), (2, "package"), (3, "dependency"), (10, "publicDependency"), (11, "weakDependency"),
            (4, "messageType"), (5, "enumType"), (6, "service"), (7, "extension"), (8, "options"),
            (9, "sourceCodeInfo"), (12, "syntax")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("name", 1), ("package", 2), ("dependency", 3), ("publicDependency", 10), ("weakDependency", 11),
            ("messageType", 4), ("enumType", 5), ("service", 6), ("extension", 7), ("options", 8),
            ("sourceCodeInfo", 9), ("syntax", 12)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): FileDescriptorProto { let m = FileDescriptorProto(); m.m_fieldsClone(this); m }

    public prop var name: String {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var package_: String {
        get( ) { get(2) }
        set(v) { set(2, v) }
    }

    public prop var dependency: ArrayList<String> {
        get( ) { get(3) }
        set(v) { set(3, RepeatField<String>(3, v)) }
    }

    public prop var publicDependency: ArrayList<Int32> {
        get( ) { get(10) }
        set(v) { set(10, RepeatField<Int32>(10, v)) }
    }

    public prop var weakDependency: ArrayList<Int32> {
        get( ) { get(11) }
        set(v) { set(11, RepeatField<Int32>(11, v)) }
    }

    public prop var messageType: ArrayList<DescriptorProto> {
        get( ) { get(4) }
        set(v) { set(4, RepeatField<DescriptorProto>(4, v)) }
    }

    public prop var enumType: ArrayList<EnumDescriptorProto> {
        get( ) { get(5) }
        set(v) { set(5, RepeatField<EnumDescriptorProto>(5, v)) }
    }

    public prop var service: ArrayList<ServiceDescriptorProto> {
        get( ) { get(6) }
        set(v) { set(6, RepeatField<ServiceDescriptorProto>(6, v)) }
    }

    public prop var extension: ArrayList<FieldDescriptorProto> {
        get( ) { get(7) }
        set(v) { set(7, RepeatField<FieldDescriptorProto>(7, v)) }
    }

    public prop var options: FileOptions {
        get( ) { get(8) }
        set(v) { set(8, v) }
    }

    public prop var sourceCodeInfo: SourceCodeInfo {
        get( ) { get(9) }
        set(v) { set(9, v) }
    }

    public prop var syntax: String {
        get( ) { get(12) }
        set(v) { set(12, v) }
    }

    public prop let hasName: Bool { get() { m_fields.contains(1) } }
    public prop let hasPackage: Bool { get() { m_fields.contains(2) } }
    public prop let hasOptions: Bool { get() { m_fields.contains(8) } }
    public prop let hasSourceCodeInfo: Bool { get() { m_fields.contains(9) } }
    public prop let hasSyntax: Bool { get() { m_fields.contains(12) } }
}

extend FileDescriptorProto <: MessageParser<FileDescriptorProto> {
    public static func fromJson(src: JsonObject) { let m = FileDescriptorProto(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = FileDescriptorProto(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class DescriptorProto_ExtensionRange <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, Int32Unpacker.instance), (2, Int32Unpacker.instance),
            (3, MessageUnpacker<ExtensionRangeOptions>.instance)
        ])

        s_names = HashMap<Tag, String>([
            (1, "start"), (2, "end"), (3, "options")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("start", 1), ("end", 2), ("options", 3)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): DescriptorProto_ExtensionRange { let m = DescriptorProto_ExtensionRange(); m.m_fieldsClone(this); m }

    public prop var start: Int32 {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var end: Int32 {
        get( ) { get(2) }
        set(v) { set(2, v) }
    }

    public prop var options: ExtensionRangeOptions {
        get( ) { get(3) }
        set(v) { set(3, v) }
    }

    public prop let hasStart: Bool { get() { m_fields.contains(1) } }
    public prop let hasEnd: Bool { get() { m_fields.contains(2) } }
    public prop let hasOptions: Bool { get() { m_fields.contains(3) } }
}

extend DescriptorProto_ExtensionRange <: MessageParser<DescriptorProto_ExtensionRange> {
    public static func fromJson(src: JsonObject) { let m = DescriptorProto_ExtensionRange(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = DescriptorProto_ExtensionRange(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class DescriptorProto_ReservedRange <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, Int32Unpacker.instance), (2, Int32Unpacker.instance)
        ])

        s_names = HashMap<Tag, String>([
            (1, "start"), (2, "end")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("start", 1), ("end", 2)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): DescriptorProto_ReservedRange { let m = DescriptorProto_ReservedRange(); m.m_fieldsClone(this); m }

    public prop var start: Int32 {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var end: Int32 {
        get( ) { get(2) }
        set(v) { set(2, v) }
    }

    public prop let hasStart: Bool { get() { m_fields.contains(1) } }
    public prop let hasEnd: Bool { get() { m_fields.contains(2) } }
}

extend DescriptorProto_ReservedRange <: MessageParser<DescriptorProto_ReservedRange> {
    public static func fromJson(src: JsonObject) { let m = DescriptorProto_ReservedRange(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = DescriptorProto_ReservedRange(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class DescriptorProto <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, StringUnpacker.instance), (2, MessageUnpacker<FieldDescriptorProto>.repeatInstance(2)),
            (6, MessageUnpacker<FieldDescriptorProto>.repeatInstance(6)),
            (3, MessageUnpacker<DescriptorProto>.repeatInstance(3)),
            (4, MessageUnpacker<EnumDescriptorProto>.repeatInstance(4)),
            (5, MessageUnpacker<DescriptorProto_ExtensionRange>.repeatInstance(5)),
            (8, MessageUnpacker<OneofDescriptorProto>.repeatInstance(8)), (7, MessageUnpacker<MessageOptions>.instance),
            (9, MessageUnpacker<DescriptorProto_ReservedRange>.repeatInstance(9)),
            (10, StringUnpacker.repeatInstance(10))
        ])

        s_names = HashMap<Tag, String>([
            (1, "name"), (2, "field"), (6, "extension"), (3, "nestedType"), (4, "enumType"), (5, "extensionRange"),
            (8, "oneofDecl"), (7, "options"), (9, "reservedRange"), (10, "reservedName")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("name", 1), ("field", 2), ("extension", 6), ("nestedType", 3), ("enumType", 4), ("extensionRange", 5),
            ("oneofDecl", 8), ("options", 7), ("reservedRange", 9), ("reservedName", 10)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): DescriptorProto { let m = DescriptorProto(); m.m_fieldsClone(this); m }

    public prop var name: String {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var field: ArrayList<FieldDescriptorProto> {
        get( ) { get(2) }
        set(v) { set(2, RepeatField<FieldDescriptorProto>(2, v)) }
    }

    public prop var extension: ArrayList<FieldDescriptorProto> {
        get( ) { get(6) }
        set(v) { set(6, RepeatField<FieldDescriptorProto>(6, v)) }
    }

    public prop var nestedType: ArrayList<DescriptorProto> {
        get( ) { get(3) }
        set(v) { set(3, RepeatField<DescriptorProto>(3, v)) }
    }

    public prop var enumType: ArrayList<EnumDescriptorProto> {
        get( ) { get(4) }
        set(v) { set(4, RepeatField<EnumDescriptorProto>(4, v)) }
    }

    public prop var extensionRange: ArrayList<DescriptorProto_ExtensionRange> {
        get( ) { get(5) }
        set(v) { set(5, RepeatField<DescriptorProto_ExtensionRange>(5, v)) }
    }

    public prop var oneofDecl: ArrayList<OneofDescriptorProto> {
        get( ) { get(8) }
        set(v) { set(8, RepeatField<OneofDescriptorProto>(8, v)) }
    }

    public prop var options: MessageOptions {
        get( ) { get(7) }
        set(v) { set(7, v) }
    }

    public prop var reservedRange: ArrayList<DescriptorProto_ReservedRange> {
        get( ) { get(9) }
        set(v) { set(9, RepeatField<DescriptorProto_ReservedRange>(9, v)) }
    }

    public prop var reservedName: ArrayList<String> {
        get( ) { get(10) }
        set(v) { set(10, RepeatField<String>(10, v)) }
    }

    public prop let hasName: Bool { get() { m_fields.contains(1) } }
    public prop let hasOptions: Bool { get() { m_fields.contains(7) } }
}

extend DescriptorProto <: MessageParser<DescriptorProto> {
    public static func fromJson(src: JsonObject) { let m = DescriptorProto(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = DescriptorProto(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class ExtensionRangeOptions <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (999, MessageUnpacker<UninterpretedOption>.repeatInstance(999))
        ])

        s_names = HashMap<Tag, String>([
            (999, "uninterpretedOption")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("uninterpretedOption", 999)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): ExtensionRangeOptions { let m = ExtensionRangeOptions(); m.m_fieldsClone(this); m }

    public prop var uninterpretedOption: ArrayList<UninterpretedOption> {
        get( ) { get(999) }
        set(v) { set(999, RepeatField<UninterpretedOption>(999, v)) }
    }
}

extend ExtensionRangeOptions <: MessageParser<ExtensionRangeOptions> {
    public static func fromJson(src: JsonObject) { let m = ExtensionRangeOptions(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = ExtensionRangeOptions(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public enum FieldDescriptorProto_Type {
    | TYPE_DOUBLE | TYPE_FLOAT | TYPE_INT64 | TYPE_UINT64 | TYPE_INT32 | TYPE_FIXED64 | TYPE_FIXED32 | TYPE_BOOL
    | TYPE_STRING | TYPE_GROUP | TYPE_MESSAGE | TYPE_BYTES | TYPE_UINT32 | TYPE_ENUM | TYPE_SFIXED32 | TYPE_SFIXED64
    | TYPE_SINT32 | TYPE_SINT64
}

extend FieldDescriptorProto_Type <: Enum<FieldDescriptorProto_Type> {
    public func value(): Int32 {
        match(this) {
            case TYPE_DOUBLE => 1
            case TYPE_FLOAT => 2
            case TYPE_INT64 => 3
            case TYPE_UINT64 => 4
            case TYPE_INT32 => 5
            case TYPE_FIXED64 => 6
            case TYPE_FIXED32 => 7
            case TYPE_BOOL => 8
            case TYPE_STRING => 9
            case TYPE_GROUP => 10
            case TYPE_MESSAGE => 11
            case TYPE_BYTES => 12
            case TYPE_UINT32 => 13
            case TYPE_ENUM => 14
            case TYPE_SFIXED32 => 15
            case TYPE_SFIXED64 => 16
            case TYPE_SINT32 => 17
            case TYPE_SINT64 => 18
        }
    }

    public func toString(): String {
        match(this) {
            case TYPE_DOUBLE => "TYPE_DOUBLE"
            case TYPE_FLOAT => "TYPE_FLOAT"
            case TYPE_INT64 => "TYPE_INT64"
            case TYPE_UINT64 => "TYPE_UINT64"
            case TYPE_INT32 => "TYPE_INT32"
            case TYPE_FIXED64 => "TYPE_FIXED64"
            case TYPE_FIXED32 => "TYPE_FIXED32"
            case TYPE_BOOL => "TYPE_BOOL"
            case TYPE_STRING => "TYPE_STRING"
            case TYPE_GROUP => "TYPE_GROUP"
            case TYPE_MESSAGE => "TYPE_MESSAGE"
            case TYPE_BYTES => "TYPE_BYTES"
            case TYPE_UINT32 => "TYPE_UINT32"
            case TYPE_ENUM => "TYPE_ENUM"
            case TYPE_SFIXED32 => "TYPE_SFIXED32"
            case TYPE_SFIXED64 => "TYPE_SFIXED64"
            case TYPE_SINT32 => "TYPE_SINT32"
            case TYPE_SINT64 => "TYPE_SINT64"
        }
    }

    public static func parse(value: Int32): FieldDescriptorProto_Type {
        match(value) {
            case 1 => TYPE_DOUBLE
            case 2 => TYPE_FLOAT
            case 3 => TYPE_INT64
            case 4 => TYPE_UINT64
            case 5 => TYPE_INT32
            case 6 => TYPE_FIXED64
            case 7 => TYPE_FIXED32
            case 8 => TYPE_BOOL
            case 9 => TYPE_STRING
            case 10 => TYPE_GROUP
            case 11 => TYPE_MESSAGE
            case 12 => TYPE_BYTES
            case 13 => TYPE_UINT32
            case 14 => TYPE_ENUM
            case 15 => TYPE_SFIXED32
            case 16 => TYPE_SFIXED64
            case 17 => TYPE_SINT32
            case 18 => TYPE_SINT64
            case e => throw InvalidEnumValueException("FieldDescriptorProto_Type", e)
        }
    }

    public static func parse(value: String): FieldDescriptorProto_Type {
        match(value) {
            case "TYPE_DOUBLE" => TYPE_DOUBLE
            case "TYPE_FLOAT" => TYPE_FLOAT
            case "TYPE_INT64" => TYPE_INT64
            case "TYPE_UINT64" => TYPE_UINT64
            case "TYPE_INT32" => TYPE_INT32
            case "TYPE_FIXED64" => TYPE_FIXED64
            case "TYPE_FIXED32" => TYPE_FIXED32
            case "TYPE_BOOL" => TYPE_BOOL
            case "TYPE_STRING" => TYPE_STRING
            case "TYPE_GROUP" => TYPE_GROUP
            case "TYPE_MESSAGE" => TYPE_MESSAGE
            case "TYPE_BYTES" => TYPE_BYTES
            case "TYPE_UINT32" => TYPE_UINT32
            case "TYPE_ENUM" => TYPE_ENUM
            case "TYPE_SFIXED32" => TYPE_SFIXED32
            case "TYPE_SFIXED64" => TYPE_SFIXED64
            case "TYPE_SINT32" => TYPE_SINT32
            case "TYPE_SINT64" => TYPE_SINT64
            case e => throw UnmatchedEnumStringException("FieldDescriptorProto_Type", e)
        }
    }
}

public enum FieldDescriptorProto_Label {
    | LABEL_OPTIONAL | LABEL_REQUIRED | LABEL_REPEATED
}

extend FieldDescriptorProto_Label <: Enum<FieldDescriptorProto_Label> {
    public func value(): Int32 {
        match(this) {
            case LABEL_OPTIONAL => 1
            case LABEL_REQUIRED => 2
            case LABEL_REPEATED => 3
        }
    }

    public func toString(): String {
        match(this) {
            case LABEL_OPTIONAL => "LABEL_OPTIONAL"
            case LABEL_REQUIRED => "LABEL_REQUIRED"
            case LABEL_REPEATED => "LABEL_REPEATED"
        }
    }

    public static func parse(value: Int32): FieldDescriptorProto_Label {
        match(value) {
            case 1 => LABEL_OPTIONAL
            case 2 => LABEL_REQUIRED
            case 3 => LABEL_REPEATED
            case e => throw InvalidEnumValueException("FieldDescriptorProto_Label", e)
        }
    }

    public static func parse(value: String): FieldDescriptorProto_Label {
        match(value) {
            case "LABEL_OPTIONAL" => LABEL_OPTIONAL
            case "LABEL_REQUIRED" => LABEL_REQUIRED
            case "LABEL_REPEATED" => LABEL_REPEATED
            case e => throw UnmatchedEnumStringException("FieldDescriptorProto_Label", e)
        }
    }
}

public class FieldDescriptorProto <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, StringUnpacker.instance), (3, Int32Unpacker.instance),
            (4, EnumUnpacker<FieldDescriptorProto_Label>.instance),
            (5, EnumUnpacker<FieldDescriptorProto_Type>.instance), (6, StringUnpacker.instance),
            (2, StringUnpacker.instance), (7, StringUnpacker.instance), (9, Int32Unpacker.instance),
            (10, StringUnpacker.instance), (8, MessageUnpacker<FieldOptions>.instance), (17, BoolUnpacker.instance)
        ])

        s_names = HashMap<Tag, String>([
            (1, "name"), (3, "number"), (4, "label"), (5, "type"), (6, "typeName"), (2, "extendee"),
            (7, "defaultValue"), (9, "oneofIndex"), (10, "jsonName"), (8, "options"), (17, "proto3Optional")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("name", 1), ("number", 3), ("label", 4), ("type", 5), ("typeName", 6), ("extendee", 2),
            ("defaultValue", 7), ("oneofIndex", 9), ("jsonName", 10), ("options", 8), ("proto3Optional", 17)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): FieldDescriptorProto { let m = FieldDescriptorProto(); m.m_fieldsClone(this); m }

    public prop var name: String {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var number: Int32 {
        get( ) { get(3) }
        set(v) { set(3, v) }
    }

    public prop var label: FieldDescriptorProto_Label {
        get( ) { get(4) }
        set(v) { set(4, v) }
    }

    public prop var type_: FieldDescriptorProto_Type {
        get( ) { get(5) }
        set(v) { set(5, v) }
    }

    public prop var typeName: String {
        get( ) { get(6) }
        set(v) { set(6, v) }
    }

    public prop var extendee: String {
        get( ) { get(2) }
        set(v) { set(2, v) }
    }

    public prop var defaultValue: String {
        get( ) { get(7) }
        set(v) { set(7, v) }
    }

    public prop var oneofIndex: Int32 {
        get( ) { get(9) }
        set(v) { set(9, v) }
    }

    public prop var jsonName: String {
        get( ) { get(10) }
        set(v) { set(10, v) }
    }

    public prop var options: FieldOptions {
        get( ) { get(8) }
        set(v) { set(8, v) }
    }

    public prop var proto3Optional: Bool {
        get( ) { get(17) }
        set(v) { set(17, v) }
    }

    public prop let hasName: Bool { get() { m_fields.contains(1) } }
    public prop let hasNumber: Bool { get() { m_fields.contains(3) } }
    public prop let hasLabel: Bool { get() { m_fields.contains(4) } }
    public prop let hasType: Bool { get() { m_fields.contains(5) } }
    public prop let hasTypeName: Bool { get() { m_fields.contains(6) } }
    public prop let hasExtendee: Bool { get() { m_fields.contains(2) } }
    public prop let hasDefaultValue: Bool { get() { m_fields.contains(7) } }
    public prop let hasOneofIndex: Bool { get() { m_fields.contains(9) } }
    public prop let hasJsonName: Bool { get() { m_fields.contains(10) } }
    public prop let hasOptions: Bool { get() { m_fields.contains(8) } }
    public prop let hasProto3Optional: Bool { get() { m_fields.contains(17) } }
}

extend FieldDescriptorProto <: MessageParser<FieldDescriptorProto> {
    public static func fromJson(src: JsonObject) { let m = FieldDescriptorProto(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = FieldDescriptorProto(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class OneofDescriptorProto <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, StringUnpacker.instance), (2, MessageUnpacker<OneofOptions>.instance)
        ])

        s_names = HashMap<Tag, String>([
            (1, "name"), (2, "options")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("name", 1), ("options", 2)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): OneofDescriptorProto { let m = OneofDescriptorProto(); m.m_fieldsClone(this); m }

    public prop var name: String {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var options: OneofOptions {
        get( ) { get(2) }
        set(v) { set(2, v) }
    }

    public prop let hasName: Bool { get() { m_fields.contains(1) } }
    public prop let hasOptions: Bool { get() { m_fields.contains(2) } }
}

extend OneofDescriptorProto <: MessageParser<OneofDescriptorProto> {
    public static func fromJson(src: JsonObject) { let m = OneofDescriptorProto(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = OneofDescriptorProto(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class EnumDescriptorProto_EnumReservedRange <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, Int32Unpacker.instance), (2, Int32Unpacker.instance)
        ])

        s_names = HashMap<Tag, String>([
            (1, "start"), (2, "end")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("start", 1), ("end", 2)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): EnumDescriptorProto_EnumReservedRange { let m = EnumDescriptorProto_EnumReservedRange(); m.m_fieldsClone(this); m }

    public prop var start: Int32 {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var end: Int32 {
        get( ) { get(2) }
        set(v) { set(2, v) }
    }

    public prop let hasStart: Bool { get() { m_fields.contains(1) } }
    public prop let hasEnd: Bool { get() { m_fields.contains(2) } }
}

extend EnumDescriptorProto_EnumReservedRange <: MessageParser<EnumDescriptorProto_EnumReservedRange> {
    public static func fromJson(src: JsonObject) { let m = EnumDescriptorProto_EnumReservedRange(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = EnumDescriptorProto_EnumReservedRange(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class EnumDescriptorProto <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, StringUnpacker.instance), (2, MessageUnpacker<EnumValueDescriptorProto>.repeatInstance(2)),
            (3, MessageUnpacker<EnumOptions>.instance),
            (4, MessageUnpacker<EnumDescriptorProto_EnumReservedRange>.repeatInstance(4)),
            (5, StringUnpacker.repeatInstance(5))
        ])

        s_names = HashMap<Tag, String>([
            (1, "name"), (2, "value"), (3, "options"), (4, "reservedRange"), (5, "reservedName")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("name", 1), ("value", 2), ("options", 3), ("reservedRange", 4), ("reservedName", 5)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): EnumDescriptorProto { let m = EnumDescriptorProto(); m.m_fieldsClone(this); m }

    public prop var name: String {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var value: ArrayList<EnumValueDescriptorProto> {
        get( ) { get(2) }
        set(v) { set(2, RepeatField<EnumValueDescriptorProto>(2, v)) }
    }

    public prop var options: EnumOptions {
        get( ) { get(3) }
        set(v) { set(3, v) }
    }

    public prop var reservedRange: ArrayList<EnumDescriptorProto_EnumReservedRange> {
        get( ) { get(4) }
        set(v) { set(4, RepeatField<EnumDescriptorProto_EnumReservedRange>(4, v)) }
    }

    public prop var reservedName: ArrayList<String> {
        get( ) { get(5) }
        set(v) { set(5, RepeatField<String>(5, v)) }
    }

    public prop let hasName: Bool { get() { m_fields.contains(1) } }
    public prop let hasOptions: Bool { get() { m_fields.contains(3) } }
}

extend EnumDescriptorProto <: MessageParser<EnumDescriptorProto> {
    public static func fromJson(src: JsonObject) { let m = EnumDescriptorProto(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = EnumDescriptorProto(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class EnumValueDescriptorProto <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, StringUnpacker.instance), (2, Int32Unpacker.instance), (3, MessageUnpacker<EnumValueOptions>.instance)
        ])

        s_names = HashMap<Tag, String>([
            (1, "name"), (2, "number"), (3, "options")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("name", 1), ("number", 2), ("options", 3)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): EnumValueDescriptorProto { let m = EnumValueDescriptorProto(); m.m_fieldsClone(this); m }

    public prop var name: String {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var number: Int32 {
        get( ) { get(2) }
        set(v) { set(2, v) }
    }

    public prop var options: EnumValueOptions {
        get( ) { get(3) }
        set(v) { set(3, v) }
    }

    public prop let hasName: Bool { get() { m_fields.contains(1) } }
    public prop let hasNumber: Bool { get() { m_fields.contains(2) } }
    public prop let hasOptions: Bool { get() { m_fields.contains(3) } }
}

extend EnumValueDescriptorProto <: MessageParser<EnumValueDescriptorProto> {
    public static func fromJson(src: JsonObject) { let m = EnumValueDescriptorProto(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = EnumValueDescriptorProto(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class ServiceDescriptorProto <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, StringUnpacker.instance), (2, MessageUnpacker<MethodDescriptorProto>.repeatInstance(2)),
            (3, MessageUnpacker<ServiceOptions>.instance)
        ])

        s_names = HashMap<Tag, String>([
            (1, "name"), (2, "method"), (3, "options")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("name", 1), ("method", 2), ("options", 3)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): ServiceDescriptorProto { let m = ServiceDescriptorProto(); m.m_fieldsClone(this); m }

    public prop var name: String {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var method: ArrayList<MethodDescriptorProto> {
        get( ) { get(2) }
        set(v) { set(2, RepeatField<MethodDescriptorProto>(2, v)) }
    }

    public prop var options: ServiceOptions {
        get( ) { get(3) }
        set(v) { set(3, v) }
    }

    public prop let hasName: Bool { get() { m_fields.contains(1) } }
    public prop let hasOptions: Bool { get() { m_fields.contains(3) } }
}

extend ServiceDescriptorProto <: MessageParser<ServiceDescriptorProto> {
    public static func fromJson(src: JsonObject) { let m = ServiceDescriptorProto(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = ServiceDescriptorProto(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class MethodDescriptorProto <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag
    static var s_defaultValue = s_initHashMapTagMessageFile

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, StringUnpacker.instance), (2, StringUnpacker.instance), (3, StringUnpacker.instance),
            (4, MessageUnpacker<MethodOptions>.instance), (5, BoolUnpacker.instance), (6, BoolUnpacker.instance),
            (15, StringUnpacker.instance)
        ])

        s_names = HashMap<Tag, String>([
            (1, "name"), (2, "inputType"), (3, "outputType"), (4, "options"), (5, "clientStreaming"),
            (6, "serverStreaming"), (15, "funcName")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("name", 1), ("inputType", 2), ("outputType", 3), ("options", 4), ("clientStreaming", 5),
            ("serverStreaming", 6), ("funcName", 15)
        ])

        s_defaultValue = HashMap<Tag, MessageField>([
            (5, false), (6, false)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
        m_defaultValue = s_defaultValue
    }

    public func clone(): MethodDescriptorProto { let m = MethodDescriptorProto(); m.m_fieldsClone(this); m }

    public prop var name: String {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var inputType: String {
        get( ) { get(2) }
        set(v) { set(2, v) }
    }

    public prop var outputType: String {
        get( ) { get(3) }
        set(v) { set(3, v) }
    }

    public prop var options: MethodOptions {
        get( ) { get(4) }
        set(v) { set(4, v) }
    }

    public prop var clientStreaming: Bool {
        get( ) { get(5) }
        set(v) { set(5, v) }
    }

    public prop var serverStreaming: Bool {
        get( ) { get(6) }
        set(v) { set(6, v) }
    }

    public prop var funcName: String {
        get( ) { get(15) }
        set(v) { set(15, v) }
    }

    public prop let hasName: Bool { get() { m_fields.contains(1) } }
    public prop let hasInputType: Bool { get() { m_fields.contains(2) } }
    public prop let hasOutputType: Bool { get() { m_fields.contains(3) } }
    public prop let hasOptions: Bool { get() { m_fields.contains(4) } }
    public prop let hasClientStreaming: Bool { get() { m_fields.contains(5) } }
    public prop let hasServerStreaming: Bool { get() { m_fields.contains(6) } }
    public prop let hasFuncName: Bool { get() { m_fields.contains(15) } }
}

extend MethodDescriptorProto <: MessageParser<MethodDescriptorProto> {
    public static func fromJson(src: JsonObject) { let m = MethodDescriptorProto(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = MethodDescriptorProto(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public enum FileOptions_OptimizeMode {
    | SPEED | CODE_SIZE | LITE_RUNTIME
}

extend FileOptions_OptimizeMode <: Enum<FileOptions_OptimizeMode> {
    public func value(): Int32 {
        match(this) {
            case SPEED => 1
            case CODE_SIZE => 2
            case LITE_RUNTIME => 3
        }
    }

    public func toString(): String {
        match(this) {
            case SPEED => "SPEED"
            case CODE_SIZE => "CODE_SIZE"
            case LITE_RUNTIME => "LITE_RUNTIME"
        }
    }

    public static func parse(value: Int32): FileOptions_OptimizeMode {
        match(value) {
            case 1 => SPEED
            case 2 => CODE_SIZE
            case 3 => LITE_RUNTIME
            case e => throw InvalidEnumValueException("FileOptions_OptimizeMode", e)
        }
    }

    public static func parse(value: String): FileOptions_OptimizeMode {
        match(value) {
            case "SPEED" => SPEED
            case "CODE_SIZE" => CODE_SIZE
            case "LITE_RUNTIME" => LITE_RUNTIME
            case e => throw UnmatchedEnumStringException("FileOptions_OptimizeMode", e)
        }
    }
}

public class FileOptions <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag
    static var s_defaultValue = s_initHashMapTagMessageFile

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, StringUnpacker.instance), (8, StringUnpacker.instance), (10, BoolUnpacker.instance),
            (20, BoolUnpacker.instance), (27, BoolUnpacker.instance),
            (9, EnumUnpacker<FileOptions_OptimizeMode>.instance), (11, StringUnpacker.instance),
            (16, BoolUnpacker.instance), (17, BoolUnpacker.instance), (18, BoolUnpacker.instance),
            (42, BoolUnpacker.instance), (23, BoolUnpacker.instance), (31, BoolUnpacker.instance),
            (36, StringUnpacker.instance), (37, StringUnpacker.instance), (39, StringUnpacker.instance),
            (40, StringUnpacker.instance), (41, StringUnpacker.instance), (44, StringUnpacker.instance),
            (45, StringUnpacker.instance), (999, MessageUnpacker<UninterpretedOption>.repeatInstance(999))
        ])

        s_names = HashMap<Tag, String>([
            (1, "javaPackage"), (8, "javaOuterClassname"), (10, "javaMultipleFiles"), (20, "javaGenerateEqualsAndHash"),
            (27, "javaStringCheckUtf8"), (9, "optimizeFor"), (11, "goPackage"), (16, "ccGenericServices"),
            (17, "javaGenericServices"), (18, "pyGenericServices"), (42, "phpGenericServices"), (23, "deprecated"),
            (31, "ccEnableArenas"), (36, "objcClassPrefix"), (37, "csharpNamespace"), (39, "swiftPrefix"),
            (40, "phpClassPrefix"), (41, "phpNamespace"), (44, "phpMetadataNamespace"), (45, "rubyPackage"),
            (999, "uninterpretedOption")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("javaPackage", 1), ("javaOuterClassname", 8), ("javaMultipleFiles", 10), ("javaGenerateEqualsAndHash", 20),
            ("javaStringCheckUtf8", 27), ("optimizeFor", 9), ("goPackage", 11), ("ccGenericServices", 16),
            ("javaGenericServices", 17), ("pyGenericServices", 18), ("phpGenericServices", 42), ("deprecated", 23),
            ("ccEnableArenas", 31), ("objcClassPrefix", 36), ("csharpNamespace", 37), ("swiftPrefix", 39),
            ("phpClassPrefix", 40), ("phpNamespace", 41), ("phpMetadataNamespace", 44), ("rubyPackage", 45),
            ("uninterpretedOption", 999)
        ])

        s_defaultValue = HashMap<Tag, MessageField>([
            (10, false), (27, false), (9, FileOptions_OptimizeMode.SPEED), (16, false), (17, false), (18, false),
            (42, false), (23, false), (31, true)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
        m_defaultValue = s_defaultValue
    }

    public func clone(): FileOptions { let m = FileOptions(); m.m_fieldsClone(this); m }

    public prop var javaPackage: String {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var javaOuterClassname: String {
        get( ) { get(8) }
        set(v) { set(8, v) }
    }

    public prop var javaMultipleFiles: Bool {
        get( ) { get(10) }
        set(v) { set(10, v) }
    }

    public prop var javaGenerateEqualsAndHash: Bool {
        get( ) { get(20) }
        set(v) { set(20, v) }
    }

    public prop var javaStringCheckUtf8: Bool {
        get( ) { get(27) }
        set(v) { set(27, v) }
    }

    public prop var optimizeFor: FileOptions_OptimizeMode {
        get( ) { get(9) }
        set(v) { set(9, v) }
    }

    public prop var goPackage: String {
        get( ) { get(11) }
        set(v) { set(11, v) }
    }

    public prop var ccGenericServices: Bool {
        get( ) { get(16) }
        set(v) { set(16, v) }
    }

    public prop var javaGenericServices: Bool {
        get( ) { get(17) }
        set(v) { set(17, v) }
    }

    public prop var pyGenericServices: Bool {
        get( ) { get(18) }
        set(v) { set(18, v) }
    }

    public prop var phpGenericServices: Bool {
        get( ) { get(42) }
        set(v) { set(42, v) }
    }

    public prop var deprecated: Bool {
        get( ) { get(23) }
        set(v) { set(23, v) }
    }

    public prop var ccEnableArenas: Bool {
        get( ) { get(31) }
        set(v) { set(31, v) }
    }

    public prop var objcClassPrefix: String {
        get( ) { get(36) }
        set(v) { set(36, v) }
    }

    public prop var csharpNamespace: String {
        get( ) { get(37) }
        set(v) { set(37, v) }
    }

    public prop var swiftPrefix: String {
        get( ) { get(39) }
        set(v) { set(39, v) }
    }

    public prop var phpClassPrefix: String {
        get( ) { get(40) }
        set(v) { set(40, v) }
    }

    public prop var phpNamespace: String {
        get( ) { get(41) }
        set(v) { set(41, v) }
    }

    public prop var phpMetadataNamespace: String {
        get( ) { get(44) }
        set(v) { set(44, v) }
    }

    public prop var rubyPackage: String {
        get( ) { get(45) }
        set(v) { set(45, v) }
    }

    public prop var uninterpretedOption: ArrayList<UninterpretedOption> {
        get( ) { get(999) }
        set(v) { set(999, RepeatField<UninterpretedOption>(999, v)) }
    }

    public prop let hasJavaPackage: Bool { get() { m_fields.contains(1) } }
    public prop let hasJavaOuterClassname: Bool { get() { m_fields.contains(8) } }
    public prop let hasJavaMultipleFiles: Bool { get() { m_fields.contains(10) } }
    public prop let hasJavaGenerateEqualsAndHash: Bool { get() { m_fields.contains(20) } }
    public prop let hasJavaStringCheckUtf8: Bool { get() { m_fields.contains(27) } }
    public prop let hasOptimizeFor: Bool { get() { m_fields.contains(9) } }
    public prop let hasGoPackage: Bool { get() { m_fields.contains(11) } }
    public prop let hasCcGenericServices: Bool { get() { m_fields.contains(16) } }
    public prop let hasJavaGenericServices: Bool { get() { m_fields.contains(17) } }
    public prop let hasPyGenericServices: Bool { get() { m_fields.contains(18) } }
    public prop let hasPhpGenericServices: Bool { get() { m_fields.contains(42) } }
    public prop let hasDeprecated: Bool { get() { m_fields.contains(23) } }
    public prop let hasCcEnableArenas: Bool { get() { m_fields.contains(31) } }
    public prop let hasObjcClassPrefix: Bool { get() { m_fields.contains(36) } }
    public prop let hasCsharpNamespace: Bool { get() { m_fields.contains(37) } }
    public prop let hasSwiftPrefix: Bool { get() { m_fields.contains(39) } }
    public prop let hasPhpClassPrefix: Bool { get() { m_fields.contains(40) } }
    public prop let hasPhpNamespace: Bool { get() { m_fields.contains(41) } }
    public prop let hasPhpMetadataNamespace: Bool { get() { m_fields.contains(44) } }
    public prop let hasRubyPackage: Bool { get() { m_fields.contains(45) } }
}

extend FileOptions <: MessageParser<FileOptions> {
    public static func fromJson(src: JsonObject) { let m = FileOptions(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = FileOptions(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class MessageOptions <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag
    static var s_defaultValue = s_initHashMapTagMessageFile

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, BoolUnpacker.instance), (2, BoolUnpacker.instance), (3, BoolUnpacker.instance),
            (7, BoolUnpacker.instance), (999, MessageUnpacker<UninterpretedOption>.repeatInstance(999))
        ])

        s_names = HashMap<Tag, String>([
            (1, "messageSetWireFormat"), (2, "noStandardDescriptorAccessor"), (3, "deprecated"), (7, "mapEntry"),
            (999, "uninterpretedOption")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("messageSetWireFormat", 1), ("noStandardDescriptorAccessor", 2), ("deprecated", 3), ("mapEntry", 7),
            ("uninterpretedOption", 999)
        ])

        s_defaultValue = HashMap<Tag, MessageField>([
            (1, false), (2, false), (3, false)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
        m_defaultValue = s_defaultValue
    }

    public func clone(): MessageOptions { let m = MessageOptions(); m.m_fieldsClone(this); m }

    public prop var messageSetWireFormat: Bool {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var noStandardDescriptorAccessor: Bool {
        get( ) { get(2) }
        set(v) { set(2, v) }
    }

    public prop var deprecated: Bool {
        get( ) { get(3) }
        set(v) { set(3, v) }
    }

    public prop var mapEntry: Bool {
        get( ) { get(7) }
        set(v) { set(7, v) }
    }

    public prop var uninterpretedOption: ArrayList<UninterpretedOption> {
        get( ) { get(999) }
        set(v) { set(999, RepeatField<UninterpretedOption>(999, v)) }
    }

    public prop let hasMessageSetWireFormat: Bool { get() { m_fields.contains(1) } }
    public prop let hasNoStandardDescriptorAccessor: Bool { get() { m_fields.contains(2) } }
    public prop let hasDeprecated: Bool { get() { m_fields.contains(3) } }
    public prop let hasMapEntry: Bool { get() { m_fields.contains(7) } }
}

extend MessageOptions <: MessageParser<MessageOptions> {
    public static func fromJson(src: JsonObject) { let m = MessageOptions(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = MessageOptions(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public enum FieldOptions_CType {
    | STRING | CORD | STRING_PIECE
}

extend FieldOptions_CType <: Enum<FieldOptions_CType> {
    public func value(): Int32 {
        match(this) {
            case STRING => 0
            case CORD => 1
            case STRING_PIECE => 2
        }
    }

    public func toString(): String {
        match(this) {
            case STRING => "STRING"
            case CORD => "CORD"
            case STRING_PIECE => "STRING_PIECE"
        }
    }

    public static func parse(value: Int32): FieldOptions_CType {
        match(value) {
            case 0 => STRING
            case 1 => CORD
            case 2 => STRING_PIECE
            case e => throw InvalidEnumValueException("FieldOptions_CType", e)
        }
    }

    public static func parse(value: String): FieldOptions_CType {
        match(value) {
            case "STRING" => STRING
            case "CORD" => CORD
            case "STRING_PIECE" => STRING_PIECE
            case e => throw UnmatchedEnumStringException("FieldOptions_CType", e)
        }
    }
}

public enum FieldOptions_JSType {
    | JS_NORMAL | JS_STRING | JS_NUMBER
}

extend FieldOptions_JSType <: Enum<FieldOptions_JSType> {
    public func value(): Int32 {
        match(this) {
            case JS_NORMAL => 0
            case JS_STRING => 1
            case JS_NUMBER => 2
        }
    }

    public func toString(): String {
        match(this) {
            case JS_NORMAL => "JS_NORMAL"
            case JS_STRING => "JS_STRING"
            case JS_NUMBER => "JS_NUMBER"
        }
    }

    public static func parse(value: Int32): FieldOptions_JSType {
        match(value) {
            case 0 => JS_NORMAL
            case 1 => JS_STRING
            case 2 => JS_NUMBER
            case e => throw InvalidEnumValueException("FieldOptions_JSType", e)
        }
    }

    public static func parse(value: String): FieldOptions_JSType {
        match(value) {
            case "JS_NORMAL" => JS_NORMAL
            case "JS_STRING" => JS_STRING
            case "JS_NUMBER" => JS_NUMBER
            case e => throw UnmatchedEnumStringException("FieldOptions_JSType", e)
        }
    }
}

public class FieldOptions <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag
    static var s_defaultValue = s_initHashMapTagMessageFile

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, EnumUnpacker<FieldOptions_CType>.instance), (2, BoolUnpacker.instance),
            (6, EnumUnpacker<FieldOptions_JSType>.instance), (5, BoolUnpacker.instance), (15, BoolUnpacker.instance),
            (3, BoolUnpacker.instance), (10, BoolUnpacker.instance),
            (999, MessageUnpacker<UninterpretedOption>.repeatInstance(999))
        ])

        /* cangjie 0.32.5 bug, 2 is not exists in s_unpackers */
        s_unpackers[2] = BoolUnpacker.instance

        s_names = HashMap<Tag, String>([
            (1, "ctype"), (2, "packed"), (6, "jstype"), (5, "lazy"), (15, "unverifiedLazy"), (3, "deprecated"),
            (10, "weak"), (999, "uninterpretedOption")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("ctype", 1), ("packed", 2), ("jstype", 6), ("lazy", 5), ("unverifiedLazy", 15), ("deprecated", 3),
            ("weak", 10), ("uninterpretedOption", 999)
        ])

        s_defaultValue = HashMap<Tag, MessageField>([
            (1, FieldOptions_CType.STRING), (6, FieldOptions_JSType.JS_NORMAL), (5, false), (15, false), (3, false),
            (10, false)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
        m_defaultValue = s_defaultValue
    }

    public func clone(): FieldOptions { let m = FieldOptions(); m.m_fieldsClone(this); m }

    public prop var ctype: FieldOptions_CType {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var packed: Bool {
        get( ) { get(2) }
        set(v) { set(2, v) }
    }

    public prop var jstype: FieldOptions_JSType {
        get( ) { get(6) }
        set(v) { set(6, v) }
    }

    public prop var lazy: Bool {
        get( ) { get(5) }
        set(v) { set(5, v) }
    }

    public prop var unverifiedLazy: Bool {
        get( ) { get(15) }
        set(v) { set(15, v) }
    }

    public prop var deprecated: Bool {
        get( ) { get(3) }
        set(v) { set(3, v) }
    }

    public prop var weak: Bool {
        get( ) { get(10) }
        set(v) { set(10, v) }
    }

    public prop var uninterpretedOption: ArrayList<UninterpretedOption> {
        get( ) { get(999) }
        set(v) { set(999, RepeatField<UninterpretedOption>(999, v)) }
    }

    public prop let hasCtype: Bool { get() { m_fields.contains(1) } }
    public prop let hasPacked: Bool { get() { m_fields.contains(2) } }
    public prop let hasJstype: Bool { get() { m_fields.contains(6) } }
    public prop let hasLazy: Bool { get() { m_fields.contains(5) } }
    public prop let hasUnverifiedLazy: Bool { get() { m_fields.contains(15) } }
    public prop let hasDeprecated: Bool { get() { m_fields.contains(3) } }
    public prop let hasWeak: Bool { get() { m_fields.contains(10) } }
}

extend FieldOptions <: MessageParser<FieldOptions> {
    public static func fromJson(src: JsonObject) { let m = FieldOptions(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = FieldOptions(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class OneofOptions <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (999, MessageUnpacker<UninterpretedOption>.repeatInstance(999))
        ])

        s_names = HashMap<Tag, String>([
            (999, "uninterpretedOption")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("uninterpretedOption", 999)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): OneofOptions { let m = OneofOptions(); m.m_fieldsClone(this); m }

    public prop var uninterpretedOption: ArrayList<UninterpretedOption> {
        get( ) { get(999) }
        set(v) { set(999, RepeatField<UninterpretedOption>(999, v)) }
    }
}

extend OneofOptions <: MessageParser<OneofOptions> {
    public static func fromJson(src: JsonObject) { let m = OneofOptions(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = OneofOptions(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class EnumOptions <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag
    static var s_defaultValue = s_initHashMapTagMessageFile

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (2, BoolUnpacker.instance), (3, BoolUnpacker.instance),
            (999, MessageUnpacker<UninterpretedOption>.repeatInstance(999))
        ])

        s_names = HashMap<Tag, String>([
            (2, "allowAlias"), (3, "deprecated"), (999, "uninterpretedOption")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("allowAlias", 2), ("deprecated", 3), ("uninterpretedOption", 999)
        ])

        s_defaultValue = HashMap<Tag, MessageField>([
            (3, false)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
        m_defaultValue = s_defaultValue
    }

    public func clone(): EnumOptions { let m = EnumOptions(); m.m_fieldsClone(this); m }

    public prop var allowAlias: Bool {
        get( ) { get(2) }
        set(v) { set(2, v) }
    }

    public prop var deprecated: Bool {
        get( ) { get(3) }
        set(v) { set(3, v) }
    }

    public prop var uninterpretedOption: ArrayList<UninterpretedOption> {
        get( ) { get(999) }
        set(v) { set(999, RepeatField<UninterpretedOption>(999, v)) }
    }

    public prop let hasAllowAlias: Bool { get() { m_fields.contains(2) } }
    public prop let hasDeprecated: Bool { get() { m_fields.contains(3) } }
}

extend EnumOptions <: MessageParser<EnumOptions> {
    public static func fromJson(src: JsonObject) { let m = EnumOptions(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = EnumOptions(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class EnumValueOptions <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag
    static var s_defaultValue = s_initHashMapTagMessageFile

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, BoolUnpacker.instance), (999, MessageUnpacker<UninterpretedOption>.repeatInstance(999))
        ])

        s_names = HashMap<Tag, String>([
            (1, "deprecated"), (999, "uninterpretedOption")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("deprecated", 1), ("uninterpretedOption", 999)
        ])

        s_defaultValue = HashMap<Tag, MessageField>([
            (1, false)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
        m_defaultValue = s_defaultValue
    }

    public func clone(): EnumValueOptions { let m = EnumValueOptions(); m.m_fieldsClone(this); m }

    public prop var deprecated: Bool {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var uninterpretedOption: ArrayList<UninterpretedOption> {
        get( ) { get(999) }
        set(v) { set(999, RepeatField<UninterpretedOption>(999, v)) }
    }

    public prop let hasDeprecated: Bool { get() { m_fields.contains(1) } }
}

extend EnumValueOptions <: MessageParser<EnumValueOptions> {
    public static func fromJson(src: JsonObject) { let m = EnumValueOptions(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = EnumValueOptions(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class ServiceOptions <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag
    static var s_defaultValue = s_initHashMapTagMessageFile

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (33, BoolUnpacker.instance), (999, MessageUnpacker<UninterpretedOption>.repeatInstance(999))
        ])

        s_names = HashMap<Tag, String>([
            (33, "deprecated"), (999, "uninterpretedOption")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("deprecated", 33), ("uninterpretedOption", 999)
        ])

        s_defaultValue = HashMap<Tag, MessageField>([
            (33, false)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
        m_defaultValue = s_defaultValue
    }

    public func clone(): ServiceOptions { let m = ServiceOptions(); m.m_fieldsClone(this); m }

    public prop var deprecated: Bool {
        get( ) { get(33) }
        set(v) { set(33, v) }
    }

    public prop var uninterpretedOption: ArrayList<UninterpretedOption> {
        get( ) { get(999) }
        set(v) { set(999, RepeatField<UninterpretedOption>(999, v)) }
    }

    public prop let hasDeprecated: Bool { get() { m_fields.contains(33) } }
}

extend ServiceOptions <: MessageParser<ServiceOptions> {
    public static func fromJson(src: JsonObject) { let m = ServiceOptions(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = ServiceOptions(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public enum MethodOptions_IdempotencyLevel {
    | IDEMPOTENCY_UNKNOWN | NO_SIDE_EFFECTS | IDEMPOTENT
}

extend MethodOptions_IdempotencyLevel <: Enum<MethodOptions_IdempotencyLevel> {
    public func value(): Int32 {
        match(this) {
            case IDEMPOTENCY_UNKNOWN => 0
            case NO_SIDE_EFFECTS => 1
            case IDEMPOTENT => 2
        }
    }

    public func toString(): String {
        match(this) {
            case IDEMPOTENCY_UNKNOWN => "IDEMPOTENCY_UNKNOWN"
            case NO_SIDE_EFFECTS => "NO_SIDE_EFFECTS"
            case IDEMPOTENT => "IDEMPOTENT"
        }
    }

    public static func parse(value: Int32): MethodOptions_IdempotencyLevel {
        match(value) {
            case 0 => IDEMPOTENCY_UNKNOWN
            case 1 => NO_SIDE_EFFECTS
            case 2 => IDEMPOTENT
            case e => throw InvalidEnumValueException("MethodOptions_IdempotencyLevel", e)
        }
    }

    public static func parse(value: String): MethodOptions_IdempotencyLevel {
        match(value) {
            case "IDEMPOTENCY_UNKNOWN" => IDEMPOTENCY_UNKNOWN
            case "NO_SIDE_EFFECTS" => NO_SIDE_EFFECTS
            case "IDEMPOTENT" => IDEMPOTENT
            case e => throw UnmatchedEnumStringException("MethodOptions_IdempotencyLevel", e)
        }
    }
}

public class MethodOptions <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag
    static var s_defaultValue = s_initHashMapTagMessageFile

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (33, BoolUnpacker.instance), (34, EnumUnpacker<MethodOptions_IdempotencyLevel>.instance),
            (999, MessageUnpacker<UninterpretedOption>.repeatInstance(999))
        ])

        s_names = HashMap<Tag, String>([
            (33, "deprecated"), (34, "idempotencyLevel"), (999, "uninterpretedOption")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("deprecated", 33), ("idempotencyLevel", 34), ("uninterpretedOption", 999)
        ])

        s_defaultValue = HashMap<Tag, MessageField>([
            (33, false), (34, MethodOptions_IdempotencyLevel.IDEMPOTENCY_UNKNOWN)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
        m_defaultValue = s_defaultValue
    }

    public func clone(): MethodOptions { let m = MethodOptions(); m.m_fieldsClone(this); m }

    public prop var deprecated: Bool {
        get( ) { get(33) }
        set(v) { set(33, v) }
    }

    public prop var idempotencyLevel: MethodOptions_IdempotencyLevel {
        get( ) { get(34) }
        set(v) { set(34, v) }
    }

    public prop var uninterpretedOption: ArrayList<UninterpretedOption> {
        get( ) { get(999) }
        set(v) { set(999, RepeatField<UninterpretedOption>(999, v)) }
    }

    public prop let hasDeprecated: Bool { get() { m_fields.contains(33) } }
    public prop let hasIdempotencyLevel: Bool { get() { m_fields.contains(34) } }
}

extend MethodOptions <: MessageParser<MethodOptions> {
    public static func fromJson(src: JsonObject) { let m = MethodOptions(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = MethodOptions(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class UninterpretedOption_NamePart <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag
    static var s_requiredFields = s_initArrayTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, StringUnpacker.instance), (2, BoolUnpacker.instance)
        ])

        s_names = HashMap<Tag, String>([
            (1, "namePart"), (2, "isExtension")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("namePart", 1), ("isExtension", 2)
        ])

        s_requiredFields = Array<Tag>([
            1, 2
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
        m_requiredFields = s_requiredFields
    }

    public func clone(): UninterpretedOption_NamePart { let m = UninterpretedOption_NamePart(); m.m_fieldsClone(this); m }

    public prop var namePart: String {
        get( ) { get(1) }
        set(v) { set(1, v) }
    }

    public prop var isExtension: Bool {
        get( ) { get(2) }
        set(v) { set(2, v) }
    }

    public prop let hasNamePart: Bool { get() { m_fields.contains(1) } }
    public prop let hasIsExtension: Bool { get() { m_fields.contains(2) } }
}

extend UninterpretedOption_NamePart <: MessageParser<UninterpretedOption_NamePart> {
    public static func fromJson(src: JsonObject) { let m = UninterpretedOption_NamePart(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = UninterpretedOption_NamePart(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class UninterpretedOption <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (2, MessageUnpacker<UninterpretedOption_NamePart>.repeatInstance(2)), (3, StringUnpacker.instance),
            (4, UInt64Unpacker.instance), (5, Int64Unpacker.instance), (6, Float64Unpacker.instance),
            (7, BytesUnpacker.instance), (8, StringUnpacker.instance)
        ])

        s_names = HashMap<Tag, String>([
            (2, "name"), (3, "identifierValue"), (4, "positiveIntValue"), (5, "negativeIntValue"), (6, "doubleValue"),
            (7, "stringValue"), (8, "aggregateValue")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("name", 2), ("identifierValue", 3), ("positiveIntValue", 4), ("negativeIntValue", 5), ("doubleValue", 6),
            ("stringValue", 7), ("aggregateValue", 8)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): UninterpretedOption { let m = UninterpretedOption(); m.m_fieldsClone(this); m }

    public prop var name: ArrayList<UninterpretedOption_NamePart> {
        get( ) { get(2) }
        set(v) { set(2, RepeatField<UninterpretedOption_NamePart>(2, v)) }
    }

    public prop var identifierValue: String {
        get( ) { get(3) }
        set(v) { set(3, v) }
    }

    public prop var positiveIntValue: UInt64 {
        get( ) { get(4) }
        set(v) { set(4, v) }
    }

    public prop var negativeIntValue: Int64 {
        get( ) { get(5) }
        set(v) { set(5, v) }
    }

    public prop var doubleValue: Float64 {
        get( ) { get(6) }
        set(v) { set(6, v) }
    }

    public prop var stringValue: Bytes {
        get( ) { get(7) }
        set(v) { set(7, v) }
    }

    public prop var aggregateValue: String {
        get( ) { get(8) }
        set(v) { set(8, v) }
    }

    public prop let hasIdentifierValue: Bool { get() { m_fields.contains(3) } }
    public prop let hasPositiveIntValue: Bool { get() { m_fields.contains(4) } }
    public prop let hasNegativeIntValue: Bool { get() { m_fields.contains(5) } }
    public prop let hasDoubleValue: Bool { get() { m_fields.contains(6) } }
    public prop let hasStringValue: Bool { get() { m_fields.contains(7) } }
    public prop let hasAggregateValue: Bool { get() { m_fields.contains(8) } }
}

extend UninterpretedOption <: MessageParser<UninterpretedOption> {
    public static func fromJson(src: JsonObject) { let m = UninterpretedOption(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = UninterpretedOption(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class SourceCodeInfo_Location <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, Int32Unpacker.packedInstance), (2, Int32Unpacker.packedInstance), (3, StringUnpacker.instance),
            (4, StringUnpacker.instance), (6, StringUnpacker.repeatInstance(6))
        ])

        s_names = HashMap<Tag, String>([
            (1, "path"), (2, "span"), (3, "leadingComments"), (4, "trailingComments"), (6, "leadingDetachedComments")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("path", 1), ("span", 2), ("leadingComments", 3), ("trailingComments", 4), ("leadingDetachedComments", 6)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): SourceCodeInfo_Location { let m = SourceCodeInfo_Location(); m.m_fieldsClone(this); m }

    public prop var path: ArrayList<Int32> {
        get( ) { get(1) }
        set(v) { set(1, PackedField<Int32>(v)) }
    }

    public prop var span: ArrayList<Int32> {
        get( ) { get(2) }
        set(v) { set(2, PackedField<Int32>(v)) }
    }

    public prop var leadingComments: String {
        get( ) { get(3) }
        set(v) { set(3, v) }
    }

    public prop var trailingComments: String {
        get( ) { get(4) }
        set(v) { set(4, v) }
    }

    public prop var leadingDetachedComments: ArrayList<String> {
        get( ) { get(6) }
        set(v) { set(6, RepeatField<String>(6, v)) }
    }

    public prop let hasLeadingComments: Bool { get() { m_fields.contains(3) } }
    public prop let hasTrailingComments: Bool { get() { m_fields.contains(4) } }
}

extend SourceCodeInfo_Location <: MessageParser<SourceCodeInfo_Location> {
    public static func fromJson(src: JsonObject) { let m = SourceCodeInfo_Location(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = SourceCodeInfo_Location(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class SourceCodeInfo <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, MessageUnpacker<SourceCodeInfo_Location>.repeatInstance(1))
        ])

        s_names = HashMap<Tag, String>([
            (1, "location")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("location", 1)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): SourceCodeInfo { let m = SourceCodeInfo(); m.m_fieldsClone(this); m }

    public prop var location: ArrayList<SourceCodeInfo_Location> {
        get( ) { get(1) }
        set(v) { set(1, RepeatField<SourceCodeInfo_Location>(1, v)) }
    }
}

extend SourceCodeInfo <: MessageParser<SourceCodeInfo> {
    public static func fromJson(src: JsonObject) { let m = SourceCodeInfo(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = SourceCodeInfo(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class GeneratedCodeInfo_Annotation <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, Int32Unpacker.packedInstance), (2, StringUnpacker.instance), (3, Int32Unpacker.instance),
            (4, Int32Unpacker.instance)
        ])

        s_names = HashMap<Tag, String>([
            (1, "path"), (2, "sourceFile"), (3, "begin"), (4, "end")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("path", 1), ("sourceFile", 2), ("begin", 3), ("end", 4)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): GeneratedCodeInfo_Annotation { let m = GeneratedCodeInfo_Annotation(); m.m_fieldsClone(this); m }

    public prop var path: ArrayList<Int32> {
        get( ) { get(1) }
        set(v) { set(1, PackedField<Int32>(v)) }
    }

    public prop var sourceFile: String {
        get( ) { get(2) }
        set(v) { set(2, v) }
    }

    public prop var begin: Int32 {
        get( ) { get(3) }
        set(v) { set(3, v) }
    }

    public prop var end: Int32 {
        get( ) { get(4) }
        set(v) { set(4, v) }
    }

    public prop let hasSourceFile: Bool { get() { m_fields.contains(2) } }
    public prop let hasBegin: Bool { get() { m_fields.contains(3) } }
    public prop let hasEnd: Bool { get() { m_fields.contains(4) } }
}

extend GeneratedCodeInfo_Annotation <: MessageParser<GeneratedCodeInfo_Annotation> {
    public static func fromJson(src: JsonObject) { let m = GeneratedCodeInfo_Annotation(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = GeneratedCodeInfo_Annotation(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}

public class GeneratedCodeInfo <: MessageLite2 {
    private static let s_once = s_newOnce()
    private static var s_unpackers = s_initHashMapTagUnpacker
    private static var s_names = s_initHashMapTagString
    private static var s_nameTags = s_initHashMapStringTag

    static func s_init() {
        s_unpackers = HashMap<Tag, Unpacker>([
            (1, MessageUnpacker<GeneratedCodeInfo_Annotation>.repeatInstance(1))
        ])

        s_names = HashMap<Tag, String>([
            (1, "annotation")
        ])

        s_nameTags = HashMap<String, Tag>([
            ("annotation", 1)
        ])
    }

    public init() {
        s_once.once(s_init)
        m_unpacker = s_unpackers
        m_names = s_names
        m_nameTags = s_nameTags
    }

    public func clone(): GeneratedCodeInfo { let m = GeneratedCodeInfo(); m.m_fieldsClone(this); m }

    public prop var annotation: ArrayList<GeneratedCodeInfo_Annotation> {
        get( ) { get(1) }
        set(v) { set(1, RepeatField<GeneratedCodeInfo_Annotation>(1, v)) }
    }
}

extend GeneratedCodeInfo <: MessageParser<GeneratedCodeInfo> {
    public static func fromJson(src: JsonObject) { let m = GeneratedCodeInfo(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = GeneratedCodeInfo(); m.unpack(src); m }
    public static func fromJson(src: JsonReader) { fromJson(src.readObject()) }
    public static func fromJson(src: String) { fromJson(JsonStringReader(src).readObject()) }
    public static func fromBytes(src: Collection<Byte>) { fromBytes(SimpleReader(src)) }
}
