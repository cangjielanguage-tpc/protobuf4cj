package protoc

import protobuf.*
import collection.*

public class FileDescriptorSet <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, RepeatMessageAccessor<FileDescriptorProto>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "file")
    ])
    protected func getNames() { names }

    public func clone() { let rv = FileDescriptorSet(); rv.fields = fieldsClone(); rv }

    public prop var file: Buffer<FileDescriptorProto> {
        get() { get<Buffer<FileDescriptorProto>>(1) }
        set(v) { set(1, v) }
    }
}

extend FileDescriptorSet <: Default<FileDescriptorSet> {
    public static func default() { FileDescriptorSet() }
}

public class FileDescriptorProto <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor()),
        (2, StringAccessor()),
        (3, RepeatStringAccessor()),
        (10, RepeatInt32Accessor()),
        (11, RepeatInt32Accessor()),
        (4, RepeatMessageAccessor<DescriptorProto>()),
        (5, RepeatMessageAccessor<EnumDescriptorProto>()),
        (6, RepeatMessageAccessor<ServiceDescriptorProto>()),
        (7, RepeatMessageAccessor<FieldDescriptorProto>()),
        (8, MessageAccessor<FileOptions>()),
        (9, MessageAccessor<SourceCodeInfo>()),
        (12, StringAccessor())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "name"),
        (2, "package"),
        (3, "dependency"),
        (10, "public_dependency"),
        (11, "weak_dependency"),
        (4, "message_type"),
        (5, "enum_type"),
        (6, "service"),
        (7, "extension"),
        (8, "options"),
        (9, "source_code_info"),
        (12, "syntax")
    ])
    protected func getNames() { names }

    public func clone() { let rv = FileDescriptorProto(); rv.fields = fieldsClone(); rv }

    public prop var name: String {
        get() { get<String>(1) }
        set(v) { set(1, v) }
    }

    public prop var package: String {
        get() { get<String>(2) }
        set(v) { set(2, v) }
    }

    public prop var dependency: Buffer<String> {
        get() { get<Buffer<String>>(3) }
        set(v) { set(3, v) }
    }

    public prop var public_dependency: Buffer<Int32> {
        get() { get<Buffer<Int32>>(10) }
        set(v) { set(10, v) }
    }

    public prop var weak_dependency: Buffer<Int32> {
        get() { get<Buffer<Int32>>(11) }
        set(v) { set(11, v) }
    }

    public prop var message_type: Buffer<DescriptorProto> {
        get() { get<Buffer<DescriptorProto>>(4) }
        set(v) { set(4, v) }
    }

    public prop var enum_type: Buffer<EnumDescriptorProto> {
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

    public prop var source_code_info: SourceCodeInfo {
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

public class ExtensionRange <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, Int32Accessor()),
        (2, Int32Accessor()),
        (3, MessageAccessor<ExtensionRangeOptions>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "start"),
        (2, "end"),
        (3, "options")
    ])
    protected func getNames() { names }

    public func clone() { let rv = ExtensionRange(); rv.fields = fieldsClone(); rv }

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

extend ExtensionRange <: Default<ExtensionRange> {
    public static func default() { ExtensionRange() }
}

public class ReservedRange <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, Int32Accessor()),
        (2, Int32Accessor())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "start"),
        (2, "end")
    ])
    protected func getNames() { names }

    public func clone() { let rv = ReservedRange(); rv.fields = fieldsClone(); rv }

    public prop var start: Int32 {
        get() { get<Int32>(1) }
        set(v) { set(1, v) }
    }

    public prop var end: Int32 {
        get() { get<Int32>(2) }
        set(v) { set(2, v) }
    }
}

extend ReservedRange <: Default<ReservedRange> {
    public static func default() { ReservedRange() }
}

public class DescriptorProto <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor()),
        (2, RepeatMessageAccessor<FieldDescriptorProto>()),
        (6, RepeatMessageAccessor<FieldDescriptorProto>()),
        (3, RepeatMessageAccessor<DescriptorProto>()),
        (4, RepeatMessageAccessor<EnumDescriptorProto>()),
        (5, RepeatMessageAccessor<ExtensionRange>()),
        (8, RepeatMessageAccessor<OneofDescriptorProto>()),
        (7, MessageAccessor<MessageOptions>()),
        (9, RepeatMessageAccessor<ReservedRange>()),
        (10, RepeatStringAccessor())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "name"),
        (2, "field"),
        (6, "extension"),
        (3, "nested_type"),
        (4, "enum_type"),
        (5, "extension_range"),
        (8, "oneof_decl"),
        (7, "options"),
        (9, "reserved_range"),
        (10, "reserved_name")
    ])
    protected func getNames() { names }

    public func clone() { let rv = DescriptorProto(); rv.fields = fieldsClone(); rv }

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

    public prop var nested_type: Buffer<DescriptorProto> {
        get() { get<Buffer<DescriptorProto>>(3) }
        set(v) { set(3, v) }
    }

    public prop var enum_type: Buffer<EnumDescriptorProto> {
        get() { get<Buffer<EnumDescriptorProto>>(4) }
        set(v) { set(4, v) }
    }

    public prop var extension_range: Buffer<ExtensionRange> {
        get() { get<Buffer<ExtensionRange>>(5) }
        set(v) { set(5, v) }
    }

    public prop var oneof_decl: Buffer<OneofDescriptorProto> {
        get() { get<Buffer<OneofDescriptorProto>>(8) }
        set(v) { set(8, v) }
    }

    public prop var options: MessageOptions {
        get() { get<MessageOptions>(7) }
        set(v) { set(7, v) }
    }

    public prop var reserved_range: Buffer<ReservedRange> {
        get() { get<Buffer<ReservedRange>>(9) }
        set(v) { set(9, v) }
    }

    public prop var reserved_name: Buffer<String> {
        get() { get<Buffer<String>>(10) }
        set(v) { set(10, v) }
    }
}

extend DescriptorProto <: Default<DescriptorProto> {
    public static func default() { DescriptorProto() }
}

public class ExtensionRangeOptions <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (999, RepeatMessageAccessor<UninterpretedOption>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (999, "uninterpreted_option")
    ])
    protected func getNames() { names }

    public func clone() { let rv = ExtensionRangeOptions(); rv.fields = fieldsClone(); rv }

    public prop var uninterpreted_option: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend ExtensionRangeOptions <: Default<ExtensionRangeOptions> {
    public static func default() { ExtensionRangeOptions() }
}

public class FieldDescriptorProto <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor()),
        (3, Int32Accessor()),
        (4, MessageAccessor<Label>()),
        (5, MessageAccessor<Type>()),
        (6, StringAccessor()),
        (2, StringAccessor()),
        (7, StringAccessor()),
        (9, Int32Accessor()),
        (10, StringAccessor()),
        (8, MessageAccessor<FieldOptions>()),
        (17, BoolAccessor())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "name"),
        (3, "number"),
        (4, "label"),
        (5, "type"),
        (6, "type_name"),
        (2, "extendee"),
        (7, "default_value"),
        (9, "oneof_index"),
        (10, "json_name"),
        (8, "options"),
        (17, "proto3_optional")
    ])
    protected func getNames() { names }

    public func clone() { let rv = FieldDescriptorProto(); rv.fields = fieldsClone(); rv }

    public prop var name: String {
        get() { get<String>(1) }
        set(v) { set(1, v) }
    }

    public prop var number: Int32 {
        get() { get<Int32>(3) }
        set(v) { set(3, v) }
    }

    public prop var label: Label {
        get() { get<Label>(4) }
        set(v) { set(4, v) }
    }

    public prop var type: Type {
        get() { get<Type>(5) }
        set(v) { set(5, v) }
    }

    public prop var type_name: String {
        get() { get<String>(6) }
        set(v) { set(6, v) }
    }

    public prop var extendee: String {
        get() { get<String>(2) }
        set(v) { set(2, v) }
    }

    public prop var default_value: String {
        get() { get<String>(7) }
        set(v) { set(7, v) }
    }

    public prop var oneof_index: Int32 {
        get() { get<Int32>(9) }
        set(v) { set(9, v) }
    }

    public prop var json_name: String {
        get() { get<String>(10) }
        set(v) { set(10, v) }
    }

    public prop var options: FieldOptions {
        get() { get<FieldOptions>(8) }
        set(v) { set(8, v) }
    }

    public prop var proto3_optional: Bool {
        get() { get<Bool>(17) }
        set(v) { set(17, v) }
    }
}

extend FieldDescriptorProto <: Default<FieldDescriptorProto> {
    public static func default() { FieldDescriptorProto() }
}

public class OneofDescriptorProto <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor()),
        (2, MessageAccessor<OneofOptions>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "name"),
        (2, "options")
    ])
    protected func getNames() { names }

    public func clone() { let rv = OneofDescriptorProto(); rv.fields = fieldsClone(); rv }

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

public class EnumReservedRange <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, Int32Accessor()),
        (2, Int32Accessor())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "start"),
        (2, "end")
    ])
    protected func getNames() { names }

    public func clone() { let rv = EnumReservedRange(); rv.fields = fieldsClone(); rv }

    public prop var start: Int32 {
        get() { get<Int32>(1) }
        set(v) { set(1, v) }
    }

    public prop var end: Int32 {
        get() { get<Int32>(2) }
        set(v) { set(2, v) }
    }
}

extend EnumReservedRange <: Default<EnumReservedRange> {
    public static func default() { EnumReservedRange() }
}

public class EnumDescriptorProto <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor()),
        (2, RepeatMessageAccessor<EnumValueDescriptorProto>()),
        (3, MessageAccessor<EnumOptions>()),
        (4, RepeatMessageAccessor<EnumReservedRange>()),
        (5, RepeatStringAccessor())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "name"),
        (2, "value"),
        (3, "options"),
        (4, "reserved_range"),
        (5, "reserved_name")
    ])
    protected func getNames() { names }

    public func clone() { let rv = EnumDescriptorProto(); rv.fields = fieldsClone(); rv }

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

    public prop var reserved_range: Buffer<EnumReservedRange> {
        get() { get<Buffer<EnumReservedRange>>(4) }
        set(v) { set(4, v) }
    }

    public prop var reserved_name: Buffer<String> {
        get() { get<Buffer<String>>(5) }
        set(v) { set(5, v) }
    }
}

extend EnumDescriptorProto <: Default<EnumDescriptorProto> {
    public static func default() { EnumDescriptorProto() }
}

public class EnumValueDescriptorProto <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor()),
        (2, Int32Accessor()),
        (3, MessageAccessor<EnumValueOptions>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "name"),
        (2, "number"),
        (3, "options")
    ])
    protected func getNames() { names }

    public func clone() { let rv = EnumValueDescriptorProto(); rv.fields = fieldsClone(); rv }

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
    static let accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor()),
        (2, RepeatMessageAccessor<MethodDescriptorProto>()),
        (3, MessageAccessor<ServiceOptions>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "name"),
        (2, "method"),
        (3, "options")
    ])
    protected func getNames() { names }

    public func clone() { let rv = ServiceDescriptorProto(); rv.fields = fieldsClone(); rv }

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
    static let accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor()),
        (2, StringAccessor()),
        (3, StringAccessor()),
        (4, MessageAccessor<MethodOptions>()),
        (5, BoolAccessor()),
        (6, BoolAccessor())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "name"),
        (2, "input_type"),
        (3, "output_type"),
        (4, "options"),
        (5, "client_streaming"),
        (6, "server_streaming")
    ])
    protected func getNames() { names }

    public func clone() { let rv = MethodDescriptorProto(); rv.fields = fieldsClone(); rv }

    public prop var name: String {
        get() { get<String>(1) }
        set(v) { set(1, v) }
    }

    public prop var input_type: String {
        get() { get<String>(2) }
        set(v) { set(2, v) }
    }

    public prop var output_type: String {
        get() { get<String>(3) }
        set(v) { set(3, v) }
    }

    public prop var options: MethodOptions {
        get() { get<MethodOptions>(4) }
        set(v) { set(4, v) }
    }

    public prop var client_streaming: Bool {
        get() { get<Bool>(5) }
        set(v) { set(5, v) }
    }

    public prop var server_streaming: Bool {
        get() { get<Bool>(6) }
        set(v) { set(6, v) }
    }
}

extend MethodDescriptorProto <: Default<MethodDescriptorProto> {
    public static func default() { MethodDescriptorProto() }
}

public class FileOptions <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor()),
        (8, StringAccessor()),
        (10, BoolAccessor()),
        (20, BoolAccessor()),
        (27, BoolAccessor()),
        (9, MessageAccessor<OptimizeMode>()),
        (11, StringAccessor()),
        (16, BoolAccessor()),
        (17, BoolAccessor()),
        (18, BoolAccessor()),
        (42, BoolAccessor()),
        (23, BoolAccessor()),
        (31, BoolAccessor()),
        (36, StringAccessor()),
        (37, StringAccessor()),
        (39, StringAccessor()),
        (40, StringAccessor()),
        (41, StringAccessor()),
        (44, StringAccessor()),
        (45, StringAccessor()),
        (999, RepeatMessageAccessor<UninterpretedOption>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "java_package"),
        (8, "java_outer_classname"),
        (10, "java_multiple_files"),
        (20, "java_generate_equals_and_hash"),
        (27, "java_string_check_utf8"),
        (9, "optimize_for"),
        (11, "go_package"),
        (16, "cc_generic_services"),
        (17, "java_generic_services"),
        (18, "py_generic_services"),
        (42, "php_generic_services"),
        (23, "deprecated"),
        (31, "cc_enable_arenas"),
        (36, "objc_class_prefix"),
        (37, "csharp_namespace"),
        (39, "swift_prefix"),
        (40, "php_class_prefix"),
        (41, "php_namespace"),
        (44, "php_metadata_namespace"),
        (45, "ruby_package"),
        (999, "uninterpreted_option")
    ])
    protected func getNames() { names }

    public func clone() { let rv = FileOptions(); rv.fields = fieldsClone(); rv }

    public prop var java_package: String {
        get() { get<String>(1) }
        set(v) { set(1, v) }
    }

    public prop var java_outer_classname: String {
        get() { get<String>(8) }
        set(v) { set(8, v) }
    }

    public prop var java_multiple_files: Bool {
        get() { get<Bool>(10) }
        set(v) { set(10, v) }
    }

    public prop var java_generate_equals_and_hash: Bool {
        get() { get<Bool>(20) }
        set(v) { set(20, v) }
    }

    public prop var java_string_check_utf8: Bool {
        get() { get<Bool>(27) }
        set(v) { set(27, v) }
    }

    public prop var optimize_for: OptimizeMode {
        get() { get<OptimizeMode>(9) }
        set(v) { set(9, v) }
    }

    public prop var go_package: String {
        get() { get<String>(11) }
        set(v) { set(11, v) }
    }

    public prop var cc_generic_services: Bool {
        get() { get<Bool>(16) }
        set(v) { set(16, v) }
    }

    public prop var java_generic_services: Bool {
        get() { get<Bool>(17) }
        set(v) { set(17, v) }
    }

    public prop var py_generic_services: Bool {
        get() { get<Bool>(18) }
        set(v) { set(18, v) }
    }

    public prop var php_generic_services: Bool {
        get() { get<Bool>(42) }
        set(v) { set(42, v) }
    }

    public prop var deprecated: Bool {
        get() { get<Bool>(23) }
        set(v) { set(23, v) }
    }

    public prop var cc_enable_arenas: Bool {
        get() { get<Bool>(31) }
        set(v) { set(31, v) }
    }

    public prop var objc_class_prefix: String {
        get() { get<String>(36) }
        set(v) { set(36, v) }
    }

    public prop var csharp_namespace: String {
        get() { get<String>(37) }
        set(v) { set(37, v) }
    }

    public prop var swift_prefix: String {
        get() { get<String>(39) }
        set(v) { set(39, v) }
    }

    public prop var php_class_prefix: String {
        get() { get<String>(40) }
        set(v) { set(40, v) }
    }

    public prop var php_namespace: String {
        get() { get<String>(41) }
        set(v) { set(41, v) }
    }

    public prop var php_metadata_namespace: String {
        get() { get<String>(44) }
        set(v) { set(44, v) }
    }

    public prop var ruby_package: String {
        get() { get<String>(45) }
        set(v) { set(45, v) }
    }

    public prop var uninterpreted_option: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend FileOptions <: Default<FileOptions> {
    public static func default() { FileOptions() }
}

public class MessageOptions <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, BoolAccessor()),
        (2, BoolAccessor()),
        (3, BoolAccessor()),
        (7, BoolAccessor()),
        (999, RepeatMessageAccessor<UninterpretedOption>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "message_set_wire_format"),
        (2, "no_standard_descriptor_accessor"),
        (3, "deprecated"),
        (7, "map_entry"),
        (999, "uninterpreted_option")
    ])
    protected func getNames() { names }

    public func clone() { let rv = MessageOptions(); rv.fields = fieldsClone(); rv }

    public prop var message_set_wire_format: Bool {
        get() { get<Bool>(1) }
        set(v) { set(1, v) }
    }

    public prop var no_standard_descriptor_accessor: Bool {
        get() { get<Bool>(2) }
        set(v) { set(2, v) }
    }

    public prop var deprecated: Bool {
        get() { get<Bool>(3) }
        set(v) { set(3, v) }
    }

    public prop var map_entry: Bool {
        get() { get<Bool>(7) }
        set(v) { set(7, v) }
    }

    public prop var uninterpreted_option: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend MessageOptions <: Default<MessageOptions> {
    public static func default() { MessageOptions() }
}

public class FieldOptions <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, MessageAccessor<CType>()),
        (2, BoolAccessor()),
        (6, MessageAccessor<JSType>()),
        (5, BoolAccessor()),
        (15, BoolAccessor()),
        (3, BoolAccessor()),
        (10, BoolAccessor()),
        (999, RepeatMessageAccessor<UninterpretedOption>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "ctype"),
        (2, "packed"),
        (6, "jstype"),
        (5, "lazy"),
        (15, "unverified_lazy"),
        (3, "deprecated"),
        (10, "weak"),
        (999, "uninterpreted_option")
    ])
    protected func getNames() { names }

    public func clone() { let rv = FieldOptions(); rv.fields = fieldsClone(); rv }

    public prop var ctype: CType {
        get() { get<CType>(1) }
        set(v) { set(1, v) }
    }

    public prop var packed: Bool {
        get() { get<Bool>(2) }
        set(v) { set(2, v) }
    }

    public prop var jstype: JSType {
        get() { get<JSType>(6) }
        set(v) { set(6, v) }
    }

    public prop var lazy: Bool {
        get() { get<Bool>(5) }
        set(v) { set(5, v) }
    }

    public prop var unverified_lazy: Bool {
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

    public prop var uninterpreted_option: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend FieldOptions <: Default<FieldOptions> {
    public static func default() { FieldOptions() }
}

public class OneofOptions <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (999, RepeatMessageAccessor<UninterpretedOption>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (999, "uninterpreted_option")
    ])
    protected func getNames() { names }

    public func clone() { let rv = OneofOptions(); rv.fields = fieldsClone(); rv }

    public prop var uninterpreted_option: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend OneofOptions <: Default<OneofOptions> {
    public static func default() { OneofOptions() }
}

public class EnumOptions <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (2, BoolAccessor()),
        (3, BoolAccessor()),
        (999, RepeatMessageAccessor<UninterpretedOption>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (2, "allow_alias"),
        (3, "deprecated"),
        (999, "uninterpreted_option")
    ])
    protected func getNames() { names }

    public func clone() { let rv = EnumOptions(); rv.fields = fieldsClone(); rv }

    public prop var allow_alias: Bool {
        get() { get<Bool>(2) }
        set(v) { set(2, v) }
    }

    public prop var deprecated: Bool {
        get() { get<Bool>(3) }
        set(v) { set(3, v) }
    }

    public prop var uninterpreted_option: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend EnumOptions <: Default<EnumOptions> {
    public static func default() { EnumOptions() }
}

public class EnumValueOptions <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, BoolAccessor()),
        (999, RepeatMessageAccessor<UninterpretedOption>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "deprecated"),
        (999, "uninterpreted_option")
    ])
    protected func getNames() { names }

    public func clone() { let rv = EnumValueOptions(); rv.fields = fieldsClone(); rv }

    public prop var deprecated: Bool {
        get() { get<Bool>(1) }
        set(v) { set(1, v) }
    }

    public prop var uninterpreted_option: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend EnumValueOptions <: Default<EnumValueOptions> {
    public static func default() { EnumValueOptions() }
}

public class ServiceOptions <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (33, BoolAccessor()),
        (999, RepeatMessageAccessor<UninterpretedOption>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (33, "deprecated"),
        (999, "uninterpreted_option")
    ])
    protected func getNames() { names }

    public func clone() { let rv = ServiceOptions(); rv.fields = fieldsClone(); rv }

    public prop var deprecated: Bool {
        get() { get<Bool>(33) }
        set(v) { set(33, v) }
    }

    public prop var uninterpreted_option: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend ServiceOptions <: Default<ServiceOptions> {
    public static func default() { ServiceOptions() }
}

public class MethodOptions <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (33, BoolAccessor()),
        (34, MessageAccessor<IdempotencyLevel>()),
        (999, RepeatMessageAccessor<UninterpretedOption>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (33, "deprecated"),
        (34, "idempotency_level"),
        (999, "uninterpreted_option")
    ])
    protected func getNames() { names }

    public func clone() { let rv = MethodOptions(); rv.fields = fieldsClone(); rv }

    public prop var deprecated: Bool {
        get() { get<Bool>(33) }
        set(v) { set(33, v) }
    }

    public prop var idempotency_level: IdempotencyLevel {
        get() { get<IdempotencyLevel>(34) }
        set(v) { set(34, v) }
    }

    public prop var uninterpreted_option: Buffer<UninterpretedOption> {
        get() { get<Buffer<UninterpretedOption>>(999) }
        set(v) { set(999, v) }
    }
}

extend MethodOptions <: Default<MethodOptions> {
    public static func default() { MethodOptions() }
}

public class NamePart <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor()),
        (2, BoolAccessor())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "name_part"),
        (2, "is_extension")
    ])
    protected func getNames() { names }

    public func clone() { let rv = NamePart(); rv.fields = fieldsClone(); rv }

    public prop var name_part: String {
        get() { get<String>(1) }
        set(v) { set(1, v) }
    }

    public prop var is_extension: Bool {
        get() { get<Bool>(2) }
        set(v) { set(2, v) }
    }
}

extend NamePart <: Default<NamePart> {
    public static func default() { NamePart() }
}

public class UninterpretedOption <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (2, RepeatMessageAccessor<NamePart>()),
        (3, StringAccessor()),
        (4, UInt64Accessor()),
        (5, Int64Accessor()),
        (6, Float64Accessor()),
        (7, BytesAccessor()),
        (8, StringAccessor())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (2, "name"),
        (3, "identifier_value"),
        (4, "positive_int_value"),
        (5, "negative_int_value"),
        (6, "double_value"),
        (7, "string_value"),
        (8, "aggregate_value")
    ])
    protected func getNames() { names }

    public func clone() { let rv = UninterpretedOption(); rv.fields = fieldsClone(); rv }

    public prop var name: Buffer<NamePart> {
        get() { get<Buffer<NamePart>>(2) }
        set(v) { set(2, v) }
    }

    public prop var identifier_value: String {
        get() { get<String>(3) }
        set(v) { set(3, v) }
    }

    public prop var positive_int_value: UInt64 {
        get() { get<UInt64>(4) }
        set(v) { set(4, v) }
    }

    public prop var negative_int_value: Int64 {
        get() { get<Int64>(5) }
        set(v) { set(5, v) }
    }

    public prop var double_value: Float64 {
        get() { get<Float64>(6) }
        set(v) { set(6, v) }
    }

    public prop var string_value: Bytes {
        get() { get<Bytes>(7) }
        set(v) { set(7, v) }
    }

    public prop var aggregate_value: String {
        get() { get<String>(8) }
        set(v) { set(8, v) }
    }
}

extend UninterpretedOption <: Default<UninterpretedOption> {
    public static func default() { UninterpretedOption() }
}

public class Location <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, RepeatInt32Accessor()),
        (2, RepeatInt32Accessor()),
        (3, StringAccessor()),
        (4, StringAccessor()),
        (6, RepeatStringAccessor())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "path"),
        (2, "span"),
        (3, "leading_comments"),
        (4, "trailing_comments"),
        (6, "leading_detached_comments")
    ])
    protected func getNames() { names }

    public func clone() { let rv = Location(); rv.fields = fieldsClone(); rv }

    public prop var path: Buffer<Int32> {
        get() { get<Buffer<Int32>>(1) }
        set(v) { set(1, v) }
    }

    public prop var span: Buffer<Int32> {
        get() { get<Buffer<Int32>>(2) }
        set(v) { set(2, v) }
    }

    public prop var leading_comments: String {
        get() { get<String>(3) }
        set(v) { set(3, v) }
    }

    public prop var trailing_comments: String {
        get() { get<String>(4) }
        set(v) { set(4, v) }
    }

    public prop var leading_detached_comments: Buffer<String> {
        get() { get<Buffer<String>>(6) }
        set(v) { set(6, v) }
    }
}

extend Location <: Default<Location> {
    public static func default() { Location() }
}

public class SourceCodeInfo <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, RepeatMessageAccessor<Location>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "location")
    ])
    protected func getNames() { names }

    public func clone() { let rv = SourceCodeInfo(); rv.fields = fieldsClone(); rv }

    public prop var location: Buffer<Location> {
        get() { get<Buffer<Location>>(1) }
        set(v) { set(1, v) }
    }
}

extend SourceCodeInfo <: Default<SourceCodeInfo> {
    public static func default() { SourceCodeInfo() }
}

public class Annotation <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, RepeatInt32Accessor()),
        (2, StringAccessor()),
        (3, Int32Accessor()),
        (4, Int32Accessor())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "path"),
        (2, "source_file"),
        (3, "begin"),
        (4, "end")
    ])
    protected func getNames() { names }

    public func clone() { let rv = Annotation(); rv.fields = fieldsClone(); rv }

    public prop var path: Buffer<Int32> {
        get() { get<Buffer<Int32>>(1) }
        set(v) { set(1, v) }
    }

    public prop var source_file: String {
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

extend Annotation <: Default<Annotation> {
    public static func default() { Annotation() }
}

public class GeneratedCodeInfo <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, RepeatMessageAccessor<Annotation>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "annotation")
    ])
    protected func getNames() { names }

    public func clone() { let rv = GeneratedCodeInfo(); rv.fields = fieldsClone(); rv }

    public prop var annotation: Buffer<Annotation> {
        get() { get<Buffer<Annotation>>(1) }
        set(v) { set(1, v) }
    }
}

extend GeneratedCodeInfo <: Default<GeneratedCodeInfo> {
    public static func default() { GeneratedCodeInfo() }
}
