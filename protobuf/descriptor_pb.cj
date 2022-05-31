package google.protobuf

from std import collection.*
import protobuf.*

public class FileDescriptorSet <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, RepeatMessageAccessor<FileDescriptorProto>.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "file")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = FileDescriptorSet(); rv.m_fields = m_fieldsClone(); rv }

    public prop var file: Buffer<FileDescriptorProto> {
        get() { get<Buffer<FileDescriptorProto>>(1) }
        set(v) { set(1, v) }
    }
}

extend FileDescriptorSet <: Default<FileDescriptorSet> {
    public static func default() { FileDescriptorSet() }
}

public class FileDescriptorProto <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor.getInstance()), (2, StringAccessor.getInstance()), (3, RepeatStringAccessor.getInstance()),
        (10, RepeatInt32Accessor.getInstance()), (11, RepeatInt32Accessor.getInstance()),
        (4, RepeatMessageAccessor<DescriptorProto>.getInstance()),
        (5, RepeatMessageAccessor<EnumDescriptorProto>.getInstance()),
        (6, RepeatMessageAccessor<ServiceDescriptorProto>.getInstance()),
        (7, RepeatMessageAccessor<FieldDescriptorProto>.getInstance()), (8, MessageAccessor<FileOptions>.getInstance()),
        (9, MessageAccessor<SourceCodeInfo>.getInstance()), (12, StringAccessor.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "name"), (2, "package_"), (3, "dependency"), (10, "publicDependency"), (11, "weakDependency"),
        (4, "messageType"), (5, "enumType"), (6, "service"), (7, "extension"), (8, "options"), (9, "sourceCodeInfo"),
        (12, "syntax")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = FileDescriptorProto(); rv.m_fields = m_fieldsClone(); rv }

    public prop var name: String {
        get() { get<String>(1) }
        set(v) { set(1, v) }
    }

    public prop var package_: String {
        get() { get<String>(2) }
        set(v) { set(2, v) }
    }

    public prop var dependency: Buffer<String> {
        get() { get<Buffer<String>>(3) }
        set(v) { set(3, v) }
    }

    public prop var publicDependency: Buffer<Int32> {
        get() { get<Buffer<Int32>>(10) }
        set(v) { set(10, v) }
    }

    public prop var weakDependency: Buffer<Int32> {
        get() { get<Buffer<Int32>>(11) }
        set(v) { set(11, v) }
    }

    public prop var messageType: Buffer<DescriptorProto> {
        get() { get<Buffer<DescriptorProto>>(4) }
        set(v) { set(4, v) }
    }

    public prop var enumType: Buffer<EnumDescriptorProto> {
        get() { get<Buffer<EnumDescriptorProto>>(5) }
        set(v) { set(5, v) }
    }

    public prop var service: Buffer<ServiceDescriptorProto> {
        get() { get<Buffer<ServiceDescriptorProto>>(6) }
        set(v) { set(6, v) }
    }

    public prop var extension: Buffer<FieldDescriptorProto> {
        get() { get<Buffer<FieldDescriptorProto>>(7) }
        set(v) { set(7, v) }
    }

    public prop var options: FileOptions {
        get() { get<FileOptions>(8) }
        set(v) { set(8, v) }
    }

    public prop var sourceCodeInfo: SourceCodeInfo {
        get() { get<SourceCodeInfo>(9) }
        set(v) { set(9, v) }
    }

    public prop var syntax: String {
        get() { get<String>(12) }
        set(v) { set(12, v) }
    }
}

extend FileDescriptorProto <: Default<FileDescriptorProto> {
    public static func default() { FileDescriptorProto() }
}

public class DescriptorProto_ExtensionRange <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, Int32Accessor.getInstance()), (2, Int32Accessor.getInstance()),
        (3, MessageAccessor<ExtensionRangeOptions>.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "start"), (2, "end"), (3, "options")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = DescriptorProto_ExtensionRange(); rv.m_fields = m_fieldsClone(); rv }

    public prop var start: Int32 {
        get() { get<Int32>(1) }
        set(v) { set(1, v) }
    }

    public prop var end: Int32 {
        get() { get<Int32>(2) }
        set(v) { set(2, v) }
    }

    public prop var options: ExtensionRangeOptions {
        get() { get<ExtensionRangeOptions>(3) }
        set(v) { set(3, v) }
    }
}

extend DescriptorProto_ExtensionRange <: Default<DescriptorProto_ExtensionRange> {
    public static func default() { DescriptorProto_ExtensionRange() }
}

public class DescriptorProto_ReservedRange <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, Int32Accessor.getInstance()), (2, Int32Accessor.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "start"), (2, "end")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = DescriptorProto_ReservedRange(); rv.m_fields = m_fieldsClone(); rv }

    public prop var start: Int32 {
        get() { get<Int32>(1) }
        set(v) { set(1, v) }
    }

    public prop var end: Int32 {
        get() { get<Int32>(2) }
        set(v) { set(2, v) }
    }
}

extend DescriptorProto_ReservedRange <: Default<DescriptorProto_ReservedRange> {
    public static func default() { DescriptorProto_ReservedRange() }
}

public class DescriptorProto <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor.getInstance()), (2, RepeatMessageAccessor<FieldDescriptorProto>.getInstance()),
        (6, RepeatMessageAccessor<FieldDescriptorProto>.getInstance()),
        (3, RepeatMessageAccessor<DescriptorProto>.getInstance()),
        (4, RepeatMessageAccessor<EnumDescriptorProto>.getInstance()),
        (5, RepeatMessageAccessor<DescriptorProto_ExtensionRange>.getInstance()),
        (8, RepeatMessageAccessor<OneofDescriptorProto>.getInstance()),
        (7, MessageAccessor<MessageOptions>.getInstance()),
        (9, RepeatMessageAccessor<DescriptorProto_ReservedRange>.getInstance()),
        (10, RepeatStringAccessor.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "name"), (2, "field"), (6, "extension"), (3, "nestedType"), (4, "enumType"), (5, "extensionRange"),
        (8, "oneofDecl"), (7, "options"), (9, "reservedRange"), (10, "reservedName")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = DescriptorProto(); rv.m_fields = m_fieldsClone(); rv }

    public prop var name: String {
        get() { get<String>(1) }
        set(v) { set(1, v) }
    }

    public prop var field: Buffer<FieldDescriptorProto> {
        get() { get<Buffer<FieldDescriptorProto>>(2) }
        set(v) { set(2, v) }
    }

    public prop var extension: Buffer<FieldDescriptorProto> {
        get() { get<Buffer<FieldDescriptorProto>>(6) }
        set(v) { set(6, v) }
    }

    public prop var nestedType: Buffer<DescriptorProto> {
        get() { get<Buffer<DescriptorProto>>(3) }
        set(v) { set(3, v) }
    }

    public prop var enumType: Buffer<EnumDescriptorProto> {
        get() { get<Buffer<EnumDescriptorProto>>(4) }
        set(v) { set(4, v) }
    }

    public prop var extensionRange: Buffer<DescriptorProto_ExtensionRange> {
        get() { get<Buffer<DescriptorProto_ExtensionRange>>(5) }
        set(v) { set(5, v) }
    }

    public prop var oneofDecl: Buffer<OneofDescriptorProto> {
        get() { get<Buffer<OneofDescriptorProto>>(8) }
        set(v) { set(8, v) }
    }

    public prop var options: MessageOptions {
        get() { get<MessageOptions>(7) }
        set(v) { set(7, v) }
    }

    public prop var reservedRange: Buffer<DescriptorProto_ReservedRange> {
        get() { get<Buffer<DescriptorProto_ReservedRange>>(9) }
        set(v) { set(9, v) }
    }

    public prop var reservedName: Buffer<String> {
        get() { get<Buffer<String>>(10) }
        set(v) { set(10, v) }
    }
}

extend DescriptorProto <: Default<DescriptorProto> {
    public static func default() { DescriptorProto() }
}

public class ExtensionRangeOptions <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (999, RepeatMessageAccessor<UninterpretedOption>.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (999, "uninterpretedOption")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = ExtensionRangeOptions(); rv.m_fields = m_fieldsClone(); rv }

    public prop var uninterpretedOption: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend ExtensionRangeOptions <: Default<ExtensionRangeOptions> {
    public static func default() { ExtensionRangeOptions() }
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

    /* cangjie 0.28.4 bug, xxx should be implemented */
    public func hashCode() { value().hashCode() }
    public operator func ==(right: FieldDescriptorProto_Type) { value() == right.value() }
    public operator func !=(right: FieldDescriptorProto_Type) { value() != right.value() }
}

extend FieldDescriptorProto_Type <: Default<FieldDescriptorProto_Type> {
    public static func default() { TYPE_DOUBLE }
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

    /* cangjie 0.28.4 bug, xxx should be implemented */
    public func hashCode() { value().hashCode() }
    public operator func ==(right: FieldDescriptorProto_Label) { value() == right.value() }
    public operator func !=(right: FieldDescriptorProto_Label) { value() != right.value() }
}

extend FieldDescriptorProto_Label <: Default<FieldDescriptorProto_Label> {
    public static func default() { LABEL_OPTIONAL }
}

public class FieldDescriptorProto <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor.getInstance()), (3, Int32Accessor.getInstance()),
        (4, EnumAccessor<FieldDescriptorProto_Label>.getInstance()),
        (5, EnumAccessor<FieldDescriptorProto_Type>.getInstance()), (6, StringAccessor.getInstance()),
        (2, StringAccessor.getInstance()), (7, StringAccessor.getInstance()), (9, Int32Accessor.getInstance()),
        (10, StringAccessor.getInstance()), (8, MessageAccessor<FieldOptions>.getInstance()),
        (17, BoolAccessor.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "name"), (3, "number"), (4, "label"), (5, "type_"), (6, "typeName"), (2, "extendee"), (7, "defaultValue"),
        (9, "oneofIndex"), (10, "jsonName"), (8, "options"), (17, "proto3Optional")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = FieldDescriptorProto(); rv.m_fields = m_fieldsClone(); rv }

    public prop var name: String {
        get() { get<String>(1) }
        set(v) { set(1, v) }
    }

    public prop var number: Int32 {
        get() { get<Int32>(3) }
        set(v) { set(3, v) }
    }

    public prop var label: FieldDescriptorProto_Label {
        get() { get<FieldDescriptorProto_Label>(4) }
        set(v) { set(4, v) }
    }

    public prop var type_: FieldDescriptorProto_Type {
        get() { get<FieldDescriptorProto_Type>(5) }
        set(v) { set(5, v) }
    }

    public prop var typeName: String {
        get() { get<String>(6) }
        set(v) { set(6, v) }
    }

    public prop var extendee: String {
        get() { get<String>(2) }
        set(v) { set(2, v) }
    }

    public prop var defaultValue: String {
        get() { get<String>(7) }
        set(v) { set(7, v) }
    }

    public prop var oneofIndex: Int32 {
        get() { get<Int32>(9) }
        set(v) { set(9, v) }
    }

    public prop var jsonName: String {
        get() { get<String>(10) }
        set(v) { set(10, v) }
    }

    public prop var options: FieldOptions {
        get() { get<FieldOptions>(8) }
        set(v) { set(8, v) }
    }

    public prop var proto3Optional: Bool {
        get() { get<Bool>(17) }
        set(v) { set(17, v) }
    }
}

extend FieldDescriptorProto <: Default<FieldDescriptorProto> {
    public static func default() { FieldDescriptorProto() }
}

public class OneofDescriptorProto <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor.getInstance()), (2, MessageAccessor<OneofOptions>.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "name"), (2, "options")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = OneofDescriptorProto(); rv.m_fields = m_fieldsClone(); rv }

    public prop var name: String {
        get() { get<String>(1) }
        set(v) { set(1, v) }
    }

    public prop var options: OneofOptions {
        get() { get<OneofOptions>(2) }
        set(v) { set(2, v) }
    }
}

extend OneofDescriptorProto <: Default<OneofDescriptorProto> {
    public static func default() { OneofDescriptorProto() }
}

public class EnumDescriptorProto_EnumReservedRange <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, Int32Accessor.getInstance()), (2, Int32Accessor.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "start"), (2, "end")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = EnumDescriptorProto_EnumReservedRange(); rv.m_fields = m_fieldsClone(); rv }

    public prop var start: Int32 {
        get() { get<Int32>(1) }
        set(v) { set(1, v) }
    }

    public prop var end: Int32 {
        get() { get<Int32>(2) }
        set(v) { set(2, v) }
    }
}

extend EnumDescriptorProto_EnumReservedRange <: Default<EnumDescriptorProto_EnumReservedRange> {
    public static func default() { EnumDescriptorProto_EnumReservedRange() }
}

public class EnumDescriptorProto <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor.getInstance()), (2, RepeatMessageAccessor<EnumValueDescriptorProto>.getInstance()),
        (3, MessageAccessor<EnumOptions>.getInstance()),
        (4, RepeatMessageAccessor<EnumDescriptorProto_EnumReservedRange>.getInstance()),
        (5, RepeatStringAccessor.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "name"), (2, "value"), (3, "options"), (4, "reservedRange"), (5, "reservedName")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = EnumDescriptorProto(); rv.m_fields = m_fieldsClone(); rv }

    public prop var name: String {
        get() { get<String>(1) }
        set(v) { set(1, v) }
    }

    public prop var value: Buffer<EnumValueDescriptorProto> {
        get() { get<Buffer<EnumValueDescriptorProto>>(2) }
        set(v) { set(2, v) }
    }

    public prop var options: EnumOptions {
        get() { get<EnumOptions>(3) }
        set(v) { set(3, v) }
    }

    public prop var reservedRange: Buffer<EnumDescriptorProto_EnumReservedRange> {
        get() { get<Buffer<EnumDescriptorProto_EnumReservedRange>>(4) }
        set(v) { set(4, v) }
    }

    public prop var reservedName: Buffer<String> {
        get() { get<Buffer<String>>(5) }
        set(v) { set(5, v) }
    }
}

extend EnumDescriptorProto <: Default<EnumDescriptorProto> {
    public static func default() { EnumDescriptorProto() }
}

public class EnumValueDescriptorProto <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor.getInstance()), (2, Int32Accessor.getInstance()),
        (3, MessageAccessor<EnumValueOptions>.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "name"), (2, "number"), (3, "options")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = EnumValueDescriptorProto(); rv.m_fields = m_fieldsClone(); rv }

    public prop var name: String {
        get() { get<String>(1) }
        set(v) { set(1, v) }
    }

    public prop var number: Int32 {
        get() { get<Int32>(2) }
        set(v) { set(2, v) }
    }

    public prop var options: EnumValueOptions {
        get() { get<EnumValueOptions>(3) }
        set(v) { set(3, v) }
    }
}

extend EnumValueDescriptorProto <: Default<EnumValueDescriptorProto> {
    public static func default() { EnumValueDescriptorProto() }
}

public class ServiceDescriptorProto <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor.getInstance()), (2, RepeatMessageAccessor<MethodDescriptorProto>.getInstance()),
        (3, MessageAccessor<ServiceOptions>.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "name"), (2, "method"), (3, "options")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = ServiceDescriptorProto(); rv.m_fields = m_fieldsClone(); rv }

    public prop var name: String {
        get() { get<String>(1) }
        set(v) { set(1, v) }
    }

    public prop var method: Buffer<MethodDescriptorProto> {
        get() { get<Buffer<MethodDescriptorProto>>(2) }
        set(v) { set(2, v) }
    }

    public prop var options: ServiceOptions {
        get() { get<ServiceOptions>(3) }
        set(v) { set(3, v) }
    }
}

extend ServiceDescriptorProto <: Default<ServiceDescriptorProto> {
    public static func default() { ServiceDescriptorProto() }
}

public class MethodDescriptorProto <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor.getInstance()), (2, StringAccessor.getInstance()), (3, StringAccessor.getInstance()),
        (4, MessageAccessor<MethodOptions>.getInstance()), (5, BoolAccessor.getInstance()),
        (6, BoolAccessor.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "name"), (2, "inputType"), (3, "outputType"), (4, "options"), (5, "clientStreaming"),
        (6, "serverStreaming")
    ])
    protected func getNames() { m_names }

    private static let m_dv = HashMap<Tag, Any>([
        (5, false), (6, false)
    ])
    protected override func getDefaultValue(): ?HashMap<Tag, Any> { m_dv }

    public func clone() { let rv = MethodDescriptorProto(); rv.m_fields = m_fieldsClone(); rv }

    public prop var name: String {
        get() { get<String>(1) }
        set(v) { set(1, v) }
    }

    public prop var inputType: String {
        get() { get<String>(2) }
        set(v) { set(2, v) }
    }

    public prop var outputType: String {
        get() { get<String>(3) }
        set(v) { set(3, v) }
    }

    public prop var options: MethodOptions {
        get() { get<MethodOptions>(4) }
        set(v) { set(4, v) }
    }

    public prop var clientStreaming: Bool {
        get() { get<Bool>(5) }
        set(v) { set(5, v) }
    }

    public prop var serverStreaming: Bool {
        get() { get<Bool>(6) }
        set(v) { set(6, v) }
    }
}

extend MethodDescriptorProto <: Default<MethodDescriptorProto> {
    public static func default() { MethodDescriptorProto() }
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

    /* cangjie 0.28.4 bug, xxx should be implemented */
    public func hashCode() { value().hashCode() }
    public operator func ==(right: FileOptions_OptimizeMode) { value() == right.value() }
    public operator func !=(right: FileOptions_OptimizeMode) { value() != right.value() }
}

extend FileOptions_OptimizeMode <: Default<FileOptions_OptimizeMode> {
    public static func default() { SPEED }
}

public class FileOptions <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor.getInstance()), (8, StringAccessor.getInstance()), (10, BoolAccessor.getInstance()),
        (20, BoolAccessor.getInstance()), (27, BoolAccessor.getInstance()),
        (9, EnumAccessor<FileOptions_OptimizeMode>.getInstance()), (11, StringAccessor.getInstance()),
        (16, BoolAccessor.getInstance()), (17, BoolAccessor.getInstance()), (18, BoolAccessor.getInstance()),
        (42, BoolAccessor.getInstance()), (23, BoolAccessor.getInstance()), (31, BoolAccessor.getInstance()),
        (36, StringAccessor.getInstance()), (37, StringAccessor.getInstance()), (39, StringAccessor.getInstance()),
        (40, StringAccessor.getInstance()), (41, StringAccessor.getInstance()), (44, StringAccessor.getInstance()),
        (45, StringAccessor.getInstance()), (999, RepeatMessageAccessor<UninterpretedOption>.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "javaPackage"), (8, "javaOuterClassname"), (10, "javaMultipleFiles"), (20, "javaGenerateEqualsAndHash"),
        (27, "javaStringCheckUtf8"), (9, "optimizeFor"), (11, "goPackage"), (16, "ccGenericServices"),
        (17, "javaGenericServices"), (18, "pyGenericServices"), (42, "phpGenericServices"), (23, "deprecated"),
        (31, "ccEnableArenas"), (36, "objcClassPrefix"), (37, "csharpNamespace"), (39, "swiftPrefix"),
        (40, "phpClassPrefix"), (41, "phpNamespace"), (44, "phpMetadataNamespace"), (45, "rubyPackage"),
        (999, "uninterpretedOption")
    ])
    protected func getNames() { m_names }

    private static let m_dv = HashMap<Tag, Any>([
        (10, false), (27, false), (9, FileOptions_OptimizeMode.SPEED), (16, false), (17, false), (18, false),
        (42, false), (23, false), (31, true)
    ])
    protected override func getDefaultValue(): ?HashMap<Tag, Any> { m_dv }

    public func clone() { let rv = FileOptions(); rv.m_fields = m_fieldsClone(); rv }

    public prop var javaPackage: String {
        get() { get<String>(1) }
        set(v) { set(1, v) }
    }

    public prop var javaOuterClassname: String {
        get() { get<String>(8) }
        set(v) { set(8, v) }
    }

    public prop var javaMultipleFiles: Bool {
        get() { get<Bool>(10) }
        set(v) { set(10, v) }
    }

    public prop var javaGenerateEqualsAndHash: Bool {
        get() { get<Bool>(20) }
        set(v) { set(20, v) }
    }

    public prop var javaStringCheckUtf8: Bool {
        get() { get<Bool>(27) }
        set(v) { set(27, v) }
    }

    public prop var optimizeFor: FileOptions_OptimizeMode {
        get() { get<FileOptions_OptimizeMode>(9) }
        set(v) { set(9, v) }
    }

    public prop var goPackage: String {
        get() { get<String>(11) }
        set(v) { set(11, v) }
    }

    public prop var ccGenericServices: Bool {
        get() { get<Bool>(16) }
        set(v) { set(16, v) }
    }

    public prop var javaGenericServices: Bool {
        get() { get<Bool>(17) }
        set(v) { set(17, v) }
    }

    public prop var pyGenericServices: Bool {
        get() { get<Bool>(18) }
        set(v) { set(18, v) }
    }

    public prop var phpGenericServices: Bool {
        get() { get<Bool>(42) }
        set(v) { set(42, v) }
    }

    public prop var deprecated: Bool {
        get() { get<Bool>(23) }
        set(v) { set(23, v) }
    }

    public prop var ccEnableArenas: Bool {
        get() { get<Bool>(31) }
        set(v) { set(31, v) }
    }

    public prop var objcClassPrefix: String {
        get() { get<String>(36) }
        set(v) { set(36, v) }
    }

    public prop var csharpNamespace: String {
        get() { get<String>(37) }
        set(v) { set(37, v) }
    }

    public prop var swiftPrefix: String {
        get() { get<String>(39) }
        set(v) { set(39, v) }
    }

    public prop var phpClassPrefix: String {
        get() { get<String>(40) }
        set(v) { set(40, v) }
    }

    public prop var phpNamespace: String {
        get() { get<String>(41) }
        set(v) { set(41, v) }
    }

    public prop var phpMetadataNamespace: String {
        get() { get<String>(44) }
        set(v) { set(44, v) }
    }

    public prop var rubyPackage: String {
        get() { get<String>(45) }
        set(v) { set(45, v) }
    }

    public prop var uninterpretedOption: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend FileOptions <: Default<FileOptions> {
    public static func default() { FileOptions() }
}

public class MessageOptions <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, BoolAccessor.getInstance()), (2, BoolAccessor.getInstance()), (3, BoolAccessor.getInstance()),
        (7, BoolAccessor.getInstance()), (999, RepeatMessageAccessor<UninterpretedOption>.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "messageSetWireFormat"), (2, "noStandardDescriptorAccessor"), (3, "deprecated"), (7, "mapEntry"),
        (999, "uninterpretedOption")
    ])
    protected func getNames() { m_names }

    private static let m_dv = HashMap<Tag, Any>([
        (1, false), (2, false), (3, false)
    ])
    protected override func getDefaultValue(): ?HashMap<Tag, Any> { m_dv }

    public func clone() { let rv = MessageOptions(); rv.m_fields = m_fieldsClone(); rv }

    public prop var messageSetWireFormat: Bool {
        get() { get<Bool>(1) }
        set(v) { set(1, v) }
    }

    public prop var noStandardDescriptorAccessor: Bool {
        get() { get<Bool>(2) }
        set(v) { set(2, v) }
    }

    public prop var deprecated: Bool {
        get() { get<Bool>(3) }
        set(v) { set(3, v) }
    }

    public prop var mapEntry: Bool {
        get() { get<Bool>(7) }
        set(v) { set(7, v) }
    }

    public prop var uninterpretedOption: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend MessageOptions <: Default<MessageOptions> {
    public static func default() { MessageOptions() }
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

    /* cangjie 0.28.4 bug, xxx should be implemented */
    public func hashCode() { value().hashCode() }
    public operator func ==(right: FieldOptions_CType) { value() == right.value() }
    public operator func !=(right: FieldOptions_CType) { value() != right.value() }
}

extend FieldOptions_CType <: Default<FieldOptions_CType> {
    public static func default() { STRING }
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

    /* cangjie 0.28.4 bug, xxx should be implemented */
    public func hashCode() { value().hashCode() }
    public operator func ==(right: FieldOptions_JSType) { value() == right.value() }
    public operator func !=(right: FieldOptions_JSType) { value() != right.value() }
}

extend FieldOptions_JSType <: Default<FieldOptions_JSType> {
    public static func default() { JS_NORMAL }
}

public class FieldOptions <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, EnumAccessor<FieldOptions_CType>.getInstance()), (2, BoolAccessor.getInstance()),
        (6, EnumAccessor<FieldOptions_JSType>.getInstance()), (5, BoolAccessor.getInstance()),
        (15, BoolAccessor.getInstance()), (3, BoolAccessor.getInstance()), (10, BoolAccessor.getInstance()),
        (999, RepeatMessageAccessor<UninterpretedOption>.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "ctype"), (2, "packed"), (6, "jstype"), (5, "lazy"), (15, "unverifiedLazy"), (3, "deprecated"),
        (10, "weak"), (999, "uninterpretedOption")
    ])
    protected func getNames() { m_names }

    private static let m_dv = HashMap<Tag, Any>([
        (1, FieldOptions_CType.STRING), (6, FieldOptions_JSType.JS_NORMAL), (5, false), (15, false), (3, false),
        (10, false)
    ])
    protected override func getDefaultValue(): ?HashMap<Tag, Any> { m_dv }

    public func clone() { let rv = FieldOptions(); rv.m_fields = m_fieldsClone(); rv }

    public prop var ctype: FieldOptions_CType {
        get() { get<FieldOptions_CType>(1) }
        set(v) { set(1, v) }
    }

    public prop var packed: Bool {
        get() { get<Bool>(2) }
        set(v) { set(2, v) }
    }

    public prop var jstype: FieldOptions_JSType {
        get() { get<FieldOptions_JSType>(6) }
        set(v) { set(6, v) }
    }

    public prop var lazy: Bool {
        get() { get<Bool>(5) }
        set(v) { set(5, v) }
    }

    public prop var unverifiedLazy: Bool {
        get() { get<Bool>(15) }
        set(v) { set(15, v) }
    }

    public prop var deprecated: Bool {
        get() { get<Bool>(3) }
        set(v) { set(3, v) }
    }

    public prop var weak: Bool {
        get() { get<Bool>(10) }
        set(v) { set(10, v) }
    }

    public prop var uninterpretedOption: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend FieldOptions <: Default<FieldOptions> {
    public static func default() { FieldOptions() }
}

public class OneofOptions <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (999, RepeatMessageAccessor<UninterpretedOption>.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (999, "uninterpretedOption")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = OneofOptions(); rv.m_fields = m_fieldsClone(); rv }

    public prop var uninterpretedOption: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend OneofOptions <: Default<OneofOptions> {
    public static func default() { OneofOptions() }
}

public class EnumOptions <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (2, BoolAccessor.getInstance()), (3, BoolAccessor.getInstance()),
        (999, RepeatMessageAccessor<UninterpretedOption>.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (2, "allowAlias"), (3, "deprecated"), (999, "uninterpretedOption")
    ])
    protected func getNames() { m_names }

    private static let m_dv = HashMap<Tag, Any>([
        (3, false)
    ])
    protected override func getDefaultValue(): ?HashMap<Tag, Any> { m_dv }

    public func clone() { let rv = EnumOptions(); rv.m_fields = m_fieldsClone(); rv }

    public prop var allowAlias: Bool {
        get() { get<Bool>(2) }
        set(v) { set(2, v) }
    }

    public prop var deprecated: Bool {
        get() { get<Bool>(3) }
        set(v) { set(3, v) }
    }

    public prop var uninterpretedOption: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend EnumOptions <: Default<EnumOptions> {
    public static func default() { EnumOptions() }
}

public class EnumValueOptions <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, BoolAccessor.getInstance()), (999, RepeatMessageAccessor<UninterpretedOption>.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "deprecated"), (999, "uninterpretedOption")
    ])
    protected func getNames() { m_names }

    private static let m_dv = HashMap<Tag, Any>([
        (1, false)
    ])
    protected override func getDefaultValue(): ?HashMap<Tag, Any> { m_dv }

    public func clone() { let rv = EnumValueOptions(); rv.m_fields = m_fieldsClone(); rv }

    public prop var deprecated: Bool {
        get() { get<Bool>(1) }
        set(v) { set(1, v) }
    }

    public prop var uninterpretedOption: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend EnumValueOptions <: Default<EnumValueOptions> {
    public static func default() { EnumValueOptions() }
}

public class ServiceOptions <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (33, BoolAccessor.getInstance()), (999, RepeatMessageAccessor<UninterpretedOption>.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (33, "deprecated"), (999, "uninterpretedOption")
    ])
    protected func getNames() { m_names }

    private static let m_dv = HashMap<Tag, Any>([
        (33, false)
    ])
    protected override func getDefaultValue(): ?HashMap<Tag, Any> { m_dv }

    public func clone() { let rv = ServiceOptions(); rv.m_fields = m_fieldsClone(); rv }

    public prop var deprecated: Bool {
        get() { get<Bool>(33) }
        set(v) { set(33, v) }
    }

    public prop var uninterpretedOption: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend ServiceOptions <: Default<ServiceOptions> {
    public static func default() { ServiceOptions() }
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

    /* cangjie 0.28.4 bug, xxx should be implemented */
    public func hashCode() { value().hashCode() }
    public operator func ==(right: MethodOptions_IdempotencyLevel) { value() == right.value() }
    public operator func !=(right: MethodOptions_IdempotencyLevel) { value() != right.value() }
}

extend MethodOptions_IdempotencyLevel <: Default<MethodOptions_IdempotencyLevel> {
    public static func default() { IDEMPOTENCY_UNKNOWN }
}

public class MethodOptions <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (33, BoolAccessor.getInstance()), (34, EnumAccessor<MethodOptions_IdempotencyLevel>.getInstance()),
        (999, RepeatMessageAccessor<UninterpretedOption>.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (33, "deprecated"), (34, "idempotencyLevel"), (999, "uninterpretedOption")
    ])
    protected func getNames() { m_names }

    private static let m_dv = HashMap<Tag, Any>([
        (33, false), (34, MethodOptions_IdempotencyLevel.IDEMPOTENCY_UNKNOWN)
    ])
    protected override func getDefaultValue(): ?HashMap<Tag, Any> { m_dv }

    public func clone() { let rv = MethodOptions(); rv.m_fields = m_fieldsClone(); rv }

    public prop var deprecated: Bool {
        get() { get<Bool>(33) }
        set(v) { set(33, v) }
    }

    public prop var idempotencyLevel: MethodOptions_IdempotencyLevel {
        get() { get<MethodOptions_IdempotencyLevel>(34) }
        set(v) { set(34, v) }
    }

    public prop var uninterpretedOption: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend MethodOptions <: Default<MethodOptions> {
    public static func default() { MethodOptions() }
}

public class UninterpretedOption_NamePart <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor.getInstance()), (2, BoolAccessor.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "namePart"), (2, "isExtension")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = UninterpretedOption_NamePart(); rv.m_fields = m_fieldsClone(); rv }

    public prop var namePart: String {
        get() { get<String>(1) }
        set(v) { set(1, v) }
    }

    public prop var isExtension: Bool {
        get() { get<Bool>(2) }
        set(v) { set(2, v) }
    }
}

extend UninterpretedOption_NamePart <: Default<UninterpretedOption_NamePart> {
    public static func default() { UninterpretedOption_NamePart() }
}

public class UninterpretedOption <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (2, RepeatMessageAccessor<UninterpretedOption_NamePart>.getInstance()), (3, StringAccessor.getInstance()),
        (4, UInt64Accessor.getInstance()), (5, Int64Accessor.getInstance()), (6, DoubleAccessor.getInstance()),
        (7, BytesAccessor.getInstance()), (8, StringAccessor.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (2, "name"), (3, "identifierValue"), (4, "positiveIntValue"), (5, "negativeIntValue"), (6, "doubleValue"),
        (7, "stringValue"), (8, "aggregateValue")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = UninterpretedOption(); rv.m_fields = m_fieldsClone(); rv }

    public prop var name: Buffer<UninterpretedOption_NamePart> {
        get() { get<Buffer<UninterpretedOption_NamePart>>(2) }
        set(v) { set(2, v) }
    }

    public prop var identifierValue: String {
        get() { get<String>(3) }
        set(v) { set(3, v) }
    }

    public prop var positiveIntValue: UInt64 {
        get() { get<UInt64>(4) }
        set(v) { set(4, v) }
    }

    public prop var negativeIntValue: Int64 {
        get() { get<Int64>(5) }
        set(v) { set(5, v) }
    }

    public prop var doubleValue: Float64 {
        get() { get<Float64>(6) }
        set(v) { set(6, v) }
    }

    public prop var stringValue: Bytes {
        get() { get<Bytes>(7) }
        set(v) { set(7, v) }
    }

    public prop var aggregateValue: String {
        get() { get<String>(8) }
        set(v) { set(8, v) }
    }
}

extend UninterpretedOption <: Default<UninterpretedOption> {
    public static func default() { UninterpretedOption() }
}

public class SourceCodeInfo_Location <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, PackedInt32Accessor.getInstance()), (2, PackedInt32Accessor.getInstance()),
        (3, StringAccessor.getInstance()), (4, StringAccessor.getInstance()), (6, RepeatStringAccessor.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "path"), (2, "span"), (3, "leadingComments"), (4, "trailingComments"), (6, "leadingDetachedComments")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = SourceCodeInfo_Location(); rv.m_fields = m_fieldsClone(); rv }

    public prop var path: Buffer<Int32> {
        get() { get<Buffer<Int32>>(1) }
        set(v) { set(1, v) }
    }

    public prop var span: Buffer<Int32> {
        get() { get<Buffer<Int32>>(2) }
        set(v) { set(2, v) }
    }

    public prop var leadingComments: String {
        get() { get<String>(3) }
        set(v) { set(3, v) }
    }

    public prop var trailingComments: String {
        get() { get<String>(4) }
        set(v) { set(4, v) }
    }

    public prop var leadingDetachedComments: Buffer<String> {
        get() { get<Buffer<String>>(6) }
        set(v) { set(6, v) }
    }
}

extend SourceCodeInfo_Location <: Default<SourceCodeInfo_Location> {
    public static func default() { SourceCodeInfo_Location() }
}

public class SourceCodeInfo <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, RepeatMessageAccessor<SourceCodeInfo_Location>.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "location")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = SourceCodeInfo(); rv.m_fields = m_fieldsClone(); rv }

    public prop var location: Buffer<SourceCodeInfo_Location> {
        get() { get<Buffer<SourceCodeInfo_Location>>(1) }
        set(v) { set(1, v) }
    }
}

extend SourceCodeInfo <: Default<SourceCodeInfo> {
    public static func default() { SourceCodeInfo() }
}

public class GeneratedCodeInfo_Annotation <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, PackedInt32Accessor.getInstance()), (2, StringAccessor.getInstance()), (3, Int32Accessor.getInstance()),
        (4, Int32Accessor.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "path"), (2, "sourceFile"), (3, "begin"), (4, "end")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = GeneratedCodeInfo_Annotation(); rv.m_fields = m_fieldsClone(); rv }

    public prop var path: Buffer<Int32> {
        get() { get<Buffer<Int32>>(1) }
        set(v) { set(1, v) }
    }

    public prop var sourceFile: String {
        get() { get<String>(2) }
        set(v) { set(2, v) }
    }

    public prop var begin: Int32 {
        get() { get<Int32>(3) }
        set(v) { set(3, v) }
    }

    public prop var end: Int32 {
        get() { get<Int32>(4) }
        set(v) { set(4, v) }
    }
}

extend GeneratedCodeInfo_Annotation <: Default<GeneratedCodeInfo_Annotation> {
    public static func default() { GeneratedCodeInfo_Annotation() }
}

public class GeneratedCodeInfo <: MessageLite {
    private static let m_accessors = HashMap<Tag, Accessor>([
        (1, RepeatMessageAccessor<GeneratedCodeInfo_Annotation>.getInstance())
    ])
    protected func getAccessors() { m_accessors }

    private static let m_names = HashMap<Tag, String>([
        (1, "annotation")
    ])
    protected func getNames() { m_names }

    public func clone() { let rv = GeneratedCodeInfo(); rv.m_fields = m_fieldsClone(); rv }

    public prop var annotation: Buffer<GeneratedCodeInfo_Annotation> {
        get() { get<Buffer<GeneratedCodeInfo_Annotation>>(1) }
        set(v) { set(1, v) }
    }
}

extend GeneratedCodeInfo <: Default<GeneratedCodeInfo> {
    public static func default() { GeneratedCodeInfo() }
}
