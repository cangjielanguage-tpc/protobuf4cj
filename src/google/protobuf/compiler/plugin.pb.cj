package google.protobuf.compiler

from std import collection.*
from protobuf import protobuf.*
import google.protobuf.*

public class Version <: MessageLite & TypedMessage<Version> {
    private var p_major: ?Int32
    private var p_minor: ?Int32
    private var p_patch: ?Int32
    private var p_suffix: Pb2String

    public init(
        major!: ?Int32 = None,
        minor!: ?Int32 = None,
        patch!: ?Int32 = None,
        suffix!: ?String = None
    ) {
        this.p_major = major
        this.p_minor = minor
        this.p_patch = patch
        this.p_suffix = Pb2String(suffix)
        m_init()
    }

    public init(src: Version__Builder) {
        this.p_major = src.major
        this.p_minor = src.minor
        this.p_patch = src.patch
        this.p_suffix = Pb2String(src.suffix)
        m_init()
    }

    private func m_init() {
        m_innerInit()
    }

    public func clearMajor() { p_major = None; markDirty() }
    public prop hasMajor: Bool { get() { isPresent(p_major) } }
    public mut prop major: Int32 { get() { p_major.getOrThrow() } set(_x) { p_major = _x; markDirty() } }

    public func clearMinor() { p_minor = None; markDirty() }
    public prop hasMinor: Bool { get() { isPresent(p_minor) } }
    public mut prop minor: Int32 { get() { p_minor.getOrThrow() } set(_x) { p_minor = _x; markDirty() } }

    public func clearPatch() { p_patch = None; markDirty() }
    public prop hasPatch: Bool { get() { isPresent(p_patch) } }
    public mut prop patch: Int32 { get() { p_patch.getOrThrow() } set(_x) { p_patch = _x; markDirty() } }

    public func clearSuffix() { p_suffix.clear(); markDirty() }
    public prop hasSuffix: Bool { get() { isPresent(p_suffix.data) } }
    public mut prop suffix: String { get() { p_suffix.get() } set(_v) { p_suffix.set(_v); markDirty() } }

    protected func m_size(): Int64 {
        var _x = 0
        if (let Some(_v) = p_major) { _x += 1 + varintSize(_v) }
        if (let Some(_v) = p_minor) { _x += 1 + varintSize(_v) }
        if (let Some(_v) = p_patch) { _x += 1 + varintSize(_v) }
        if (let Some(_v) = p_suffix.data) { _x += 1 + binSize(_v) }
        return _x
    }

    protected func m_hashCode(): Int64 {
        var _x = DefaultHasher()
        if (let Some(_v) = p_major) { _x.write(_v) }
        if (let Some(_v) = p_minor) { _x.write(_v) }
        if (let Some(_v) = p_patch) { _x.write(_v) }
        if (let Some(_v) = p_suffix.data) { _x.write(_v.hashCode()) }
        return _x.finish()
    }

    protected func m_isEmpty(): Bool {
        isNone(p_major) && isNone(p_minor) && isNone(p_patch) && isNone(p_suffix.data)
    }

    protected func m_clear(): Unit {
        p_major = None
        p_minor = None
        p_patch = None
        p_suffix.clear()
    }

    public operator func !=(src: Version): Bool { !(this == src) }
    public operator func ==(src: Version): Bool {
        hashCode() == src.hashCode() && size == src.size && unknownFields == src.unknownFields &&
        p_major == src.p_major && p_minor == src.p_minor && p_patch == src.p_patch &&
        p_suffix.data == src.p_suffix.data
    }

    public func copyFrom(src: Version): Version {
        p_major = src.p_major
        p_minor = src.p_minor
        p_patch = src.p_patch
        p_suffix = src.p_suffix
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): Version {
        return Version().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let _x = src.parseTag()
            match (_x[0]) {
                case 1 => p_major = src.parseInt32()
                case 2 => p_minor = src.parseInt32()
                case 3 => p_patch = src.parseInt32()
                case 4 => p_suffix.unpack(src)
                case _ => m_unknown(src, _x)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(_v) = p_major) { out.append(8); out.packVarint(_v) }
        if (let Some(_v) = p_minor) { out.append(16); out.packVarint(_v) }
        if (let Some(_v) = p_patch) { out.append(24); out.packVarint(_v) }
        if (let Some(_v) = p_suffix.data) { out.append(34); out.packBin(_v) }
        m_unknown(out)
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (let Some(_v) = p_major) { _x.append("major", _v) }
        if (let Some(_v) = p_minor) { _x.append("minor", _v) }
        if (let Some(_v) = p_patch) { _x.append("patch", _v) }
        if (isPresent(p_suffix.data)) { _x.append("suffix", p_suffix.get()) }
        return _x.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case _x: SimpleWriter => pack(_x) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case _x: SimpleReader => unpack(_x) case _ => unpack(src) } }

    public static func empty() { Version() }
    public static func newBuilder() { Version__Builder() }
    public static func fromBytes(src: Collection<Byte>) { let _x = Version(); _x.unpack(src); _x }
    public static func fromBytes(src: BytesReader) { let _x = Version(); _x.unpack(src); _x }
}

public class Version__Builder {
    public var major: ?Int32 = None
    public func setMajor(major: Int32) { this.major = major; return this }

    public var minor: ?Int32 = None
    public func setMinor(minor: Int32) { this.minor = minor; return this }

    public var patch: ?Int32 = None
    public func setPatch(patch: Int32) { this.patch = patch; return this }

    public var suffix: ?String = None
    public func setSuffix(suffix: String) { this.suffix = suffix; return this }

    public func build() { Version(this) }
}

public class CodeGeneratorRequest <: MessageLite & TypedMessage<CodeGeneratorRequest> {
    public let fileToGenerate: RepeatedString
    private var p_parameter: Pb2String
    public let protoFile: RepeatedMessage<google.protobuf.FileDescriptorProto>
    private var p_compilerVersion: Pb2Message<Version>

    public init(
        fileToGenerate!: Array<String> = [],
        parameter!: ?String = None,
        protoFile!: Array<google.protobuf.FileDescriptorProto> = [],
        compilerVersion!: ?Version = None
    ) {
        this.fileToGenerate = RepeatedString(fileToGenerate)
        this.p_parameter = Pb2String(parameter)
        this.protoFile = RepeatedMessage<google.protobuf.FileDescriptorProto>(protoFile)
        this.p_compilerVersion = Pb2Message<Version>(compilerVersion)
        m_init()
    }

    public init(src: CodeGeneratorRequest__Builder) {
        this.fileToGenerate = RepeatedString(src.fileToGenerate)
        this.p_parameter = Pb2String(src.parameter)
        this.protoFile = RepeatedMessage<google.protobuf.FileDescriptorProto>(src.protoFile)
        this.p_compilerVersion = Pb2Message<Version>(src.compilerVersion)
        m_init()
    }

    private func m_init() {
        m_init(fileToGenerate)
        m_init(protoFile)
        if (let Some(_v) = p_compilerVersion.data) { m_init(_v) }
        m_innerInit()
    }

    public func clearParameter() { p_parameter.clear(); markDirty() }
    public prop hasParameter: Bool { get() { isPresent(p_parameter.data) } }
    public mut prop parameter: String { get() { p_parameter.get() } set(_v) { p_parameter.set(_v); markDirty() } }

    public func clearCompilerVersion() { p_compilerVersion.removeFrom(this); markDirty() }
    public prop hasCompilerVersion: Bool { get() { isPresent(p_compilerVersion.data) } }
    public mut prop compilerVersion: Version { get() { p_compilerVersion.data.getOrThrow() } set(_v) { p_compilerVersion.set(this, _v); markDirty() } }

    protected func m_size(): Int64 {
        var _x = 0
        if (!fileToGenerate.isEmpty()) { _x += s_size(fileToGenerate, 1) }
        if (let Some(_v) = p_parameter.data) { _x += 1 + binSize(_v) }
        if (!protoFile.isEmpty()) { for (_i in protoFile) { _x += 1 + binSize(_i) } }
        if (let Some(_v) = p_compilerVersion.data) { _x += 1 + binSize(_v) }
        return _x
    }

    protected func m_hashCode(): Int64 {
        var _x = DefaultHasher()
        if (!fileToGenerate.isEmpty()) { _x.write(fileToGenerate.hashCode()) }
        if (let Some(_v) = p_parameter.data) { _x.write(_v.hashCode()) }
        if (!protoFile.isEmpty()) { _x.write(protoFile.hashCode()) }
        if (let Some(_v) = p_compilerVersion.data) { _x.write(_v.hashCode()) }
        return _x.finish()
    }

    protected func m_isEmpty(): Bool {
        fileToGenerate.isEmpty() && isNone(p_parameter.data) && protoFile.isEmpty() && isNone(p_compilerVersion.data)
    }

    protected func m_clear(): Unit {
        fileToGenerate.clear()
        p_parameter.clear()
        protoFile.clear()
        p_compilerVersion.removeFrom(this)
    }

    public operator func !=(src: CodeGeneratorRequest): Bool { !(this == src) }
    public operator func ==(src: CodeGeneratorRequest): Bool {
        hashCode() == src.hashCode() && size == src.size && unknownFields == src.unknownFields &&
        fileToGenerate == src.fileToGenerate && p_parameter.data == src.p_parameter.data &&
        protoFile == src.protoFile && p_compilerVersion.data == src.p_compilerVersion.data
    }

    public func copyFrom(src: CodeGeneratorRequest): CodeGeneratorRequest {
        fileToGenerate.copyFrom(src.fileToGenerate)
        p_parameter = src.p_parameter
        protoFile.copyFrom(src.protoFile)
        p_compilerVersion.copyFrom(this, src.p_compilerVersion.data)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): CodeGeneratorRequest {
        return CodeGeneratorRequest().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let _x = src.parseTag()
            match (_x[0]) {
                case 1 => s_add(fileToGenerate, src)
                case 2 => p_parameter.unpack(src)
                case 15 => s_add(protoFile, src)
                case 3 => p_compilerVersion.getOrDefault(this).unpack(subReader(src))
                case _ => m_unknown(src, _x)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!fileToGenerate.isEmpty()) { s_pack(1, fileToGenerate, out) }
        if (let Some(_v) = p_parameter.data) { out.append(18); out.packBin(_v) }
        if (!protoFile.isEmpty()) { for (_i in protoFile) { out.append(122); out.packVarint(_i.size); _i.pack(out) } }
        if (let Some(_v) = p_compilerVersion.data) { out.append(26); out.packVarint(_v.size); _v.pack(out) }
        m_unknown(out)
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (!fileToGenerate.isEmpty()) { _x.append("fileToGenerate", fileToGenerate) }
        if (isPresent(p_parameter.data)) { _x.append("parameter", p_parameter.get()) }
        if (!protoFile.isEmpty()) { _x.append("protoFile", protoFile) }
        if (let Some(_v) = p_compilerVersion.data) { _x.append("compilerVersion", _v) }
        return _x.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case _x: SimpleWriter => pack(_x) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case _x: SimpleReader => unpack(_x) case _ => unpack(src) } }

    public static func empty() { CodeGeneratorRequest() }
    public static func newBuilder() { CodeGeneratorRequest__Builder() }
    public static func fromBytes(src: Collection<Byte>) { let _x = CodeGeneratorRequest(); _x.unpack(src); _x }
    public static func fromBytes(src: BytesReader) { let _x = CodeGeneratorRequest(); _x.unpack(src); _x }
}

public class CodeGeneratorRequest__Builder {
    public var fileToGenerate: Array<String> = []
    public func setFileToGenerate(fileToGenerate: Array<String>) { this.fileToGenerate = fileToGenerate; return this }

    public var parameter: ?String = None
    public func setParameter(parameter: String) { this.parameter = parameter; return this }

    public var protoFile: Array<google.protobuf.FileDescriptorProto> = []
    public func setProtoFile(protoFile: Array<google.protobuf.FileDescriptorProto>) { this.protoFile = protoFile; return this }

    public var compilerVersion: ?Version = None
    public func setCompilerVersion(compilerVersion: Version) { this.compilerVersion = compilerVersion; return this }

    public func build() { CodeGeneratorRequest(this) }
}

public class CodeGeneratorResponse_File <: MessageLite & TypedMessage<CodeGeneratorResponse_File> {
    private var p_name: Pb2String
    private var p_insertionPoint: Pb2String
    private var p_content: Pb2String
    private var p_generatedCodeInfo: Pb2Message<google.protobuf.GeneratedCodeInfo>

    public init(
        name!: ?String = None,
        insertionPoint!: ?String = None,
        content!: ?String = None,
        generatedCodeInfo!: ?google.protobuf.GeneratedCodeInfo = None
    ) {
        this.p_name = Pb2String(name)
        this.p_insertionPoint = Pb2String(insertionPoint)
        this.p_content = Pb2String(content)
        this.p_generatedCodeInfo = Pb2Message<google.protobuf.GeneratedCodeInfo>(generatedCodeInfo)
        m_init()
    }

    public init(src: CodeGeneratorResponse_File__Builder) {
        this.p_name = Pb2String(src.name)
        this.p_insertionPoint = Pb2String(src.insertionPoint)
        this.p_content = Pb2String(src.content)
        this.p_generatedCodeInfo = Pb2Message<google.protobuf.GeneratedCodeInfo>(src.generatedCodeInfo)
        m_init()
    }

    private func m_init() {
        if (let Some(_v) = p_generatedCodeInfo.data) { m_init(_v) }
        m_innerInit()
    }

    public func clearName() { p_name.clear(); markDirty() }
    public prop hasName: Bool { get() { isPresent(p_name.data) } }
    public mut prop name: String { get() { p_name.get() } set(_v) { p_name.set(_v); markDirty() } }

    public func clearInsertionPoint() { p_insertionPoint.clear(); markDirty() }
    public prop hasInsertionPoint: Bool { get() { isPresent(p_insertionPoint.data) } }
    public mut prop insertionPoint: String { get() { p_insertionPoint.get() } set(_v) { p_insertionPoint.set(_v); markDirty() } }

    public func clearContent() { p_content.clear(); markDirty() }
    public prop hasContent: Bool { get() { isPresent(p_content.data) } }
    public mut prop content: String { get() { p_content.get() } set(_v) { p_content.set(_v); markDirty() } }

    public func clearGeneratedCodeInfo() { p_generatedCodeInfo.removeFrom(this); markDirty() }
    public prop hasGeneratedCodeInfo: Bool { get() { isPresent(p_generatedCodeInfo.data) } }
    public mut prop generatedCodeInfo: google.protobuf.GeneratedCodeInfo { get() { p_generatedCodeInfo.data.getOrThrow() } set(_v) { p_generatedCodeInfo.set(this, _v); markDirty() } }

    protected func m_size(): Int64 {
        var _x = 0
        if (let Some(_v) = p_name.data) { _x += 1 + binSize(_v) }
        if (let Some(_v) = p_insertionPoint.data) { _x += 1 + binSize(_v) }
        if (let Some(_v) = p_content.data) { _x += 1 + binSize(_v) }
        if (let Some(_v) = p_generatedCodeInfo.data) { _x += 2 + binSize(_v) }
        return _x
    }

    protected func m_hashCode(): Int64 {
        var _x = DefaultHasher()
        if (let Some(_v) = p_name.data) { _x.write(_v.hashCode()) }
        if (let Some(_v) = p_insertionPoint.data) { _x.write(_v.hashCode()) }
        if (let Some(_v) = p_content.data) { _x.write(_v.hashCode()) }
        if (let Some(_v) = p_generatedCodeInfo.data) { _x.write(_v.hashCode()) }
        return _x.finish()
    }

    protected func m_isEmpty(): Bool {
        isNone(p_name.data) && isNone(p_insertionPoint.data) && isNone(p_content.data) &&
        isNone(p_generatedCodeInfo.data)
    }

    protected func m_clear(): Unit {
        p_name.clear()
        p_insertionPoint.clear()
        p_content.clear()
        p_generatedCodeInfo.removeFrom(this)
    }

    public operator func !=(src: CodeGeneratorResponse_File): Bool { !(this == src) }
    public operator func ==(src: CodeGeneratorResponse_File): Bool {
        hashCode() == src.hashCode() && size == src.size && unknownFields == src.unknownFields &&
        p_name.data == src.p_name.data && p_insertionPoint.data == src.p_insertionPoint.data &&
        p_content.data == src.p_content.data && p_generatedCodeInfo.data == src.p_generatedCodeInfo.data
    }

    public func copyFrom(src: CodeGeneratorResponse_File): CodeGeneratorResponse_File {
        p_name = src.p_name
        p_insertionPoint = src.p_insertionPoint
        p_content = src.p_content
        p_generatedCodeInfo.copyFrom(this, src.p_generatedCodeInfo.data)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): CodeGeneratorResponse_File {
        return CodeGeneratorResponse_File().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let _x = src.parseTag()
            match (_x[0]) {
                case 1 => p_name.unpack(src)
                case 2 => p_insertionPoint.unpack(src)
                case 15 => p_content.unpack(src)
                case 16 => p_generatedCodeInfo.getOrDefault(this).unpack(subReader(src))
                case _ => m_unknown(src, _x)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(_v) = p_name.data) { out.append(10); out.packBin(_v) }
        if (let Some(_v) = p_insertionPoint.data) { out.append(18); out.packBin(_v) }
        if (let Some(_v) = p_content.data) { out.append(122); out.packBin(_v) }
        if (let Some(_v) = p_generatedCodeInfo.data) { out.packTag(16, PREFIXED); out.packVarint(_v.size); _v.pack(out) }
        m_unknown(out)
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (isPresent(p_name.data)) { _x.append("name", p_name.get()) }
        if (isPresent(p_insertionPoint.data)) { _x.append("insertionPoint", p_insertionPoint.get()) }
        if (isPresent(p_content.data)) { _x.append("content", p_content.get()) }
        if (let Some(_v) = p_generatedCodeInfo.data) { _x.append("generatedCodeInfo", _v) }
        return _x.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case _x: SimpleWriter => pack(_x) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case _x: SimpleReader => unpack(_x) case _ => unpack(src) } }

    public static func empty() { CodeGeneratorResponse_File() }
    public static func newBuilder() { CodeGeneratorResponse_File__Builder() }
    public static func fromBytes(src: Collection<Byte>) { let _x = CodeGeneratorResponse_File(); _x.unpack(src); _x }
    public static func fromBytes(src: BytesReader) { let _x = CodeGeneratorResponse_File(); _x.unpack(src); _x }
}

public class CodeGeneratorResponse_File__Builder {
    public var name: ?String = None
    public func setName(name: String) { this.name = name; return this }

    public var insertionPoint: ?String = None
    public func setInsertionPoint(insertionPoint: String) { this.insertionPoint = insertionPoint; return this }

    public var content: ?String = None
    public func setContent(content: String) { this.content = content; return this }

    public var generatedCodeInfo: ?google.protobuf.GeneratedCodeInfo = None
    public func setGeneratedCodeInfo(generatedCodeInfo: google.protobuf.GeneratedCodeInfo) { this.generatedCodeInfo = generatedCodeInfo; return this }

    public func build() { CodeGeneratorResponse_File(this) }
}

public enum CodeGeneratorResponse_Feature <: Enum<CodeGeneratorResponse_Feature> {
    FEATURE_NONE | FEATURE_PROTO3_OPTIONAL

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

    public operator func==(value: CodeGeneratorResponse_Feature) {
        match((this, value)) {
            case (FEATURE_NONE, FEATURE_NONE) => true
            case (FEATURE_PROTO3_OPTIONAL, FEATURE_PROTO3_OPTIONAL) => true
            case _ => false
        }
    }

    public static func parse(value: Int32): CodeGeneratorResponse_Feature {
        match(value) {
            case 0 => FEATURE_NONE
            case 1 => FEATURE_PROTO3_OPTIONAL
            case _ => throw InvalidEnumValueException("CodeGeneratorResponse_Feature", value)
        }
    }

    public static func parse(value: String): CodeGeneratorResponse_Feature {
        match(value) {
            case "FEATURE_NONE" => FEATURE_NONE
            case "FEATURE_PROTO3_OPTIONAL" => FEATURE_PROTO3_OPTIONAL
            case _ => throw UnmatchedEnumStringException("CodeGeneratorResponse_Feature", value)
        }
    }
}

public class CodeGeneratorResponse <: MessageLite & TypedMessage<CodeGeneratorResponse> {
    private var p_error: Pb2String
    private var p_supportedFeatures: ?UInt64
    public let file: RepeatedMessage<CodeGeneratorResponse_File>

    public init(
        error!: ?String = None,
        supportedFeatures!: ?UInt64 = None,
        file!: Array<CodeGeneratorResponse_File> = []
    ) {
        this.p_error = Pb2String(error)
        this.p_supportedFeatures = supportedFeatures
        this.file = RepeatedMessage<CodeGeneratorResponse_File>(file)
        m_init()
    }

    public init(src: CodeGeneratorResponse__Builder) {
        this.p_error = Pb2String(src.error)
        this.p_supportedFeatures = src.supportedFeatures
        this.file = RepeatedMessage<CodeGeneratorResponse_File>(src.file)
        m_init()
    }

    private func m_init() {
        m_init(file)
        m_innerInit()
    }

    public func clearError() { p_error.clear(); markDirty() }
    public prop hasError: Bool { get() { isPresent(p_error.data) } }
    public mut prop error: String { get() { p_error.get() } set(_v) { p_error.set(_v); markDirty() } }

    public func clearSupportedFeatures() { p_supportedFeatures = None; markDirty() }
    public prop hasSupportedFeatures: Bool { get() { isPresent(p_supportedFeatures) } }
    public mut prop supportedFeatures: UInt64 { get() { p_supportedFeatures.getOrThrow() } set(_x) { p_supportedFeatures = _x; markDirty() } }

    protected func m_size(): Int64 {
        var _x = 0
        if (let Some(_v) = p_error.data) { _x += 1 + binSize(_v) }
        if (let Some(_v) = p_supportedFeatures) { _x += 1 + varintSize(_v) }
        if (!file.isEmpty()) { for (_i in file) { _x += 1 + binSize(_i) } }
        return _x
    }

    protected func m_hashCode(): Int64 {
        var _x = DefaultHasher()
        if (let Some(_v) = p_error.data) { _x.write(_v.hashCode()) }
        if (let Some(_v) = p_supportedFeatures) { _x.write(_v) }
        if (!file.isEmpty()) { _x.write(file.hashCode()) }
        return _x.finish()
    }

    protected func m_isEmpty(): Bool {
        isNone(p_error.data) && isNone(p_supportedFeatures) && file.isEmpty()
    }

    protected func m_clear(): Unit {
        p_error.clear()
        p_supportedFeatures = None
        file.clear()
    }

    public operator func !=(src: CodeGeneratorResponse): Bool { !(this == src) }
    public operator func ==(src: CodeGeneratorResponse): Bool {
        hashCode() == src.hashCode() && size == src.size && unknownFields == src.unknownFields &&
        p_error.data == src.p_error.data && p_supportedFeatures == src.p_supportedFeatures && file == src.file
    }

    public func copyFrom(src: CodeGeneratorResponse): CodeGeneratorResponse {
        p_error = src.p_error
        p_supportedFeatures = src.p_supportedFeatures
        file.copyFrom(src.file)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): CodeGeneratorResponse {
        return CodeGeneratorResponse().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let _x = src.parseTag()
            match (_x[0]) {
                case 1 => p_error.unpack(src)
                case 2 => p_supportedFeatures = src.parseUInt64()
                case 15 => s_add(file, src)
                case _ => m_unknown(src, _x)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(_v) = p_error.data) { out.append(10); out.packBin(_v) }
        if (let Some(_v) = p_supportedFeatures) { out.append(16); out.packVarint(_v) }
        if (!file.isEmpty()) { for (_i in file) { out.append(122); out.packVarint(_i.size); _i.pack(out) } }
        m_unknown(out)
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (isPresent(p_error.data)) { _x.append("error", p_error.get()) }
        if (let Some(_v) = p_supportedFeatures) { _x.append("supportedFeatures", _v) }
        if (!file.isEmpty()) { _x.append("file", file) }
        return _x.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case _x: SimpleWriter => pack(_x) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case _x: SimpleReader => unpack(_x) case _ => unpack(src) } }

    public static func empty() { CodeGeneratorResponse() }
    public static func newBuilder() { CodeGeneratorResponse__Builder() }
    public static func fromBytes(src: Collection<Byte>) { let _x = CodeGeneratorResponse(); _x.unpack(src); _x }
    public static func fromBytes(src: BytesReader) { let _x = CodeGeneratorResponse(); _x.unpack(src); _x }
}

public class CodeGeneratorResponse__Builder {
    public var error: ?String = None
    public func setError(error: String) { this.error = error; return this }

    public var supportedFeatures: ?UInt64 = None
    public func setSupportedFeatures(supportedFeatures: UInt64) { this.supportedFeatures = supportedFeatures; return this }

    public var file: Array<CodeGeneratorResponse_File> = []
    public func setFile(file: Array<CodeGeneratorResponse_File>) { this.file = file; return this }

    public func build() { CodeGeneratorResponse(this) }
}
