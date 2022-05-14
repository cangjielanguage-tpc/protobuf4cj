package google.protobuf.compiler

from std import collection.*
import protobuf.*
import google.protobuf.*

public class Version <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, Int32Accessor()),
        (2, Int32Accessor()),
        (3, Int32Accessor()),
        (4, StringAccessor())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "major"),
        (2, "minor"),
        (3, "patch"),
        (4, "suffix")
    ])
    protected func getNames() { names }

    public func clone() { let rv = Version(); rv.fields = fieldsClone(); rv }

    public prop var major: Int32 {
        get() { get<Int32>(1) }
        set(v) { set(1, v) }
    }

    public prop var minor: Int32 {
        get() { get<Int32>(2) }
        set(v) { set(2, v) }
    }

    public prop var patch: Int32 {
        get() { get<Int32>(3) }
        set(v) { set(3, v) }
    }

    public prop var suffix: String {
        get() { get<String>(4) }
        set(v) { set(4, v) }
    }
}

extend Version <: Default<Version> {
    public static func default() { Version() }
}

public class CodeGeneratorRequest <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, RepeatStringAccessor()),
        (2, StringAccessor()),
        (15, RepeatMessageAccessor<google.protobuf.FileDescriptorProto>()),
        (3, MessageAccessor<Version>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "fileToGenerate"),
        (2, "parameter"),
        (15, "protoFile"),
        (3, "compilerVersion")
    ])
    protected func getNames() { names }

    public func clone() { let rv = CodeGeneratorRequest(); rv.fields = fieldsClone(); rv }

    public prop var fileToGenerate: Buffer<String> {
        get() { get<Buffer<String>>(1) }
        set(v) { set(1, v) }
    }

    public prop var parameter: String {
        get() { get<String>(2) }
        set(v) { set(2, v) }
    }

    public prop var protoFile: Buffer<google.protobuf.FileDescriptorProto> {
        get() { get<Buffer<google.protobuf.FileDescriptorProto>>(15) }
        set(v) { set(15, v) }
    }

    public prop var compilerVersion: Version {
        get() { get<Version>(3) }
        set(v) { set(3, v) }
    }
}

extend CodeGeneratorRequest <: Default<CodeGeneratorRequest> {
    public static func default() { CodeGeneratorRequest() }
}

public class CodeGeneratorResponse <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor()),
        (2, UInt64Accessor()),
        (15, RepeatMessageAccessor<CodeGeneratorResponse_File>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "error"),
        (2, "supportedFeatures"),
        (15, "file")
    ])
    protected func getNames() { names }

    public func clone() { let rv = CodeGeneratorResponse(); rv.fields = fieldsClone(); rv }

    public prop var error: String {
        get() { get<String>(1) }
        set(v) { set(1, v) }
    }

    public prop var supportedFeatures: UInt64 {
        get() { get<UInt64>(2) }
        set(v) { set(2, v) }
    }

    public prop var file: Buffer<CodeGeneratorResponse_File> {
        get() { get<Buffer<CodeGeneratorResponse_File>>(15) }
        set(v) { set(15, v) }
    }
}

extend CodeGeneratorResponse <: Default<CodeGeneratorResponse> {
    public static func default() { CodeGeneratorResponse() }
}

public class CodeGeneratorResponse_File <: MessageLite {
    static let accessors = HashMap<Tag, Accessor>([
        (1, StringAccessor()),
        (2, StringAccessor()),
        (15, StringAccessor()),
        (16, MessageAccessor<google.protobuf.GeneratedCodeInfo>())
    ])
    protected func getAccessors() { accessors }

    static let names = HashMap<Tag, String>([
        (1, "name"),
        (2, "insertionPoint"),
        (15, "content"),
        (16, "generatedCodeInfo")
    ])
    protected func getNames() { names }

    public func clone() { let rv = CodeGeneratorResponse_File(); rv.fields = fieldsClone(); rv }

    public prop var name: String {
        get() { get<String>(1) }
        set(v) { set(1, v) }
    }

    public prop var insertionPoint: String {
        get() { get<String>(2) }
        set(v) { set(2, v) }
    }

    public prop var content: String {
        get() { get<String>(15) }
        set(v) { set(15, v) }
    }

    public prop var generatedCodeInfo: google.protobuf.GeneratedCodeInfo {
        get() { get<google.protobuf.GeneratedCodeInfo>(16) }
        set(v) { set(16, v) }
    }
}

extend CodeGeneratorResponse_File <: Default<CodeGeneratorResponse_File> {
    public static func default() { CodeGeneratorResponse_File() }
}

public enum CodeGeneratorResponse_Feature { FEATURE_NONE | FEATURE_PROTO3_OPTIONAL }

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

    /* cangjie 0.28.4 bug, xxx should be implemented */
    public func hashCode() { value().hashCode() }
    public operator func ==(right: CodeGeneratorResponse_Feature) { value() == right.value() }
    public operator func !=(right: CodeGeneratorResponse_Feature) { value() != right.value() }
}

extend CodeGeneratorResponse_Feature <: Default<CodeGeneratorResponse_Feature> {
    public static func default() { FEATURE_NONE }
}
