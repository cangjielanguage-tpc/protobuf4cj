package google.protobuf.compiler

from std import collection.*
from protobuf import protobuf.*
import google.protobuf.*

public class Version <: Message & TypedMessage<Version> {
    private var p_major: ?Int32 = None
    private var p_minor: ?Int32 = None
    private var p_patch: ?Int32 = None
    private var p_suffix = Pb2String()

    public init() {
        m_innerInit()
    }

    public func clearMajor() { p_major = None; markDirty() }
    public prop let hasMajor: Bool { get() { isPresent(p_major) } }
    public prop var major: Int32 { get() { p_major.getOrThrow() } set(i_tmp) { p_major = i_tmp; markDirty() } }

    public func clearMinor() { p_minor = None; markDirty() }
    public prop let hasMinor: Bool { get() { isPresent(p_minor) } }
    public prop var minor: Int32 { get() { p_minor.getOrThrow() } set(i_tmp) { p_minor = i_tmp; markDirty() } }

    public func clearPatch() { p_patch = None; markDirty() }
    public prop let hasPatch: Bool { get() { isPresent(p_patch) } }
    public prop var patch: Int32 { get() { p_patch.getOrThrow() } set(i_tmp) { p_patch = i_tmp; markDirty() } }

    public func clearSuffix() { p_suffix.clear(); markDirty() }
    public prop let hasSuffix: Bool { get() { isPresent(p_suffix.data) } }
    public prop var suffix: String { get() { p_suffix.get() } set(i_vtmp) { p_suffix.set(i_vtmp); markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_major) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = p_minor) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = p_patch) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = p_suffix.data) { i_tmp += 1 + binSize(i_vtmp) }
        return i_tmp
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
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_major = src.parseInt32()
                case 2 => p_minor = src.parseInt32()
                case 3 => p_patch = src.parseInt32()
                case 4 => p_suffix.unpack(src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = p_major) { out.append(8); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = p_minor) { out.append(16); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = p_patch) { out.append(24); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = p_suffix.data) { out.append(34); out.packBin(i_vtmp) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = p_major) { i_tmp.append("major", i_vtmp) }
        if (let Some(i_vtmp) = p_minor) { i_tmp.append("minor", i_vtmp) }
        if (let Some(i_vtmp) = p_patch) { i_tmp.append("patch", i_vtmp) }
        if (isPresent(p_suffix.data)) { i_tmp.append("suffix", p_suffix.get()) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { Version() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = Version(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = Version(); i_tmp.unpack(src); i_tmp }
}

public class CodeGeneratorRequest <: Message & TypedMessage<CodeGeneratorRequest> {
    public let fileToGenerate = RepeatedString()
    private var p_parameter = Pb2String()
    public let protoFile = RepeatedMessage<google.protobuf.FileDescriptorProto>()
    private var p_compilerVersion = Pb2Message<Version>()

    public init() {
        m_init(fileToGenerate)
        m_init(protoFile)
        m_innerInit()
    }

    public func clearParameter() { p_parameter.clear(); markDirty() }
    public prop let hasParameter: Bool { get() { isPresent(p_parameter.data) } }
    public prop var parameter: String { get() { p_parameter.get() } set(i_vtmp) { p_parameter.set(i_vtmp); markDirty() } }

    public func clearCompilerVersion() { p_compilerVersion.removeFrom(this); markDirty() }
    public prop let hasCompilerVersion: Bool { get() { isPresent(p_compilerVersion.data) } }
    public prop var compilerVersion: Version { get() { p_compilerVersion.data.getOrThrow() } set(i_vtmp) { p_compilerVersion.set(this, i_vtmp); markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (!fileToGenerate.isEmpty()) { i_tmp += m_size(fileToGenerate, 1) }
        if (let Some(i_vtmp) = p_parameter.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (!protoFile.isEmpty()) { for (i_itmp in protoFile) { i_tmp += 1 + binSize(i_itmp) } }
        if (let Some(i_vtmp) = p_compilerVersion.data) { i_tmp += 1 + binSize(i_vtmp) }
        return i_tmp
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
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => s_add(fileToGenerate, src)
                case 2 => p_parameter.unpack(src)
                case 15 => s_add(protoFile, src)
                case 3 => p_compilerVersion.getOrDefault(this).unpack(subReader(src))
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!fileToGenerate.isEmpty()) { s_pack(1, fileToGenerate, out) }
        if (let Some(i_vtmp) = p_parameter.data) { out.append(18); out.packBin(i_vtmp) }
        if (!protoFile.isEmpty()) { for (i_itmp in protoFile) { out.append(122); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (let Some(i_vtmp) = p_compilerVersion.data) { out.append(26); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!fileToGenerate.isEmpty()) { i_tmp.append("fileToGenerate", fileToGenerate) }
        if (isPresent(p_parameter.data)) { i_tmp.append("parameter", p_parameter.get()) }
        if (!protoFile.isEmpty()) { i_tmp.append("protoFile", protoFile) }
        if (let Some(i_vtmp) = p_compilerVersion.data) { i_tmp.append("compilerVersion", i_vtmp) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { CodeGeneratorRequest() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = CodeGeneratorRequest(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = CodeGeneratorRequest(); i_tmp.unpack(src); i_tmp }
}

public class CodeGeneratorResponse_File <: Message & TypedMessage<CodeGeneratorResponse_File> {
    private var p_name = Pb2String()
    private var p_insertionPoint = Pb2String()
    private var p_content = Pb2String()
    private var p_generatedCodeInfo = Pb2Message<google.protobuf.GeneratedCodeInfo>()

    public init() {
        m_innerInit()
    }

    public func clearName() { p_name.clear(); markDirty() }
    public prop let hasName: Bool { get() { isPresent(p_name.data) } }
    public prop var name: String { get() { p_name.get() } set(i_vtmp) { p_name.set(i_vtmp); markDirty() } }

    public func clearInsertionPoint() { p_insertionPoint.clear(); markDirty() }
    public prop let hasInsertionPoint: Bool { get() { isPresent(p_insertionPoint.data) } }
    public prop var insertionPoint: String { get() { p_insertionPoint.get() } set(i_vtmp) { p_insertionPoint.set(i_vtmp); markDirty() } }

    public func clearContent() { p_content.clear(); markDirty() }
    public prop let hasContent: Bool { get() { isPresent(p_content.data) } }
    public prop var content: String { get() { p_content.get() } set(i_vtmp) { p_content.set(i_vtmp); markDirty() } }

    public func clearGeneratedCodeInfo() { p_generatedCodeInfo.removeFrom(this); markDirty() }
    public prop let hasGeneratedCodeInfo: Bool { get() { isPresent(p_generatedCodeInfo.data) } }
    public prop var generatedCodeInfo: google.protobuf.GeneratedCodeInfo { get() { p_generatedCodeInfo.data.getOrThrow() } set(i_vtmp) { p_generatedCodeInfo.set(this, i_vtmp); markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_name.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_insertionPoint.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_content.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_generatedCodeInfo.data) { i_tmp += 2 + binSize(i_vtmp) }
        return i_tmp
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
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_name.unpack(src)
                case 2 => p_insertionPoint.unpack(src)
                case 15 => p_content.unpack(src)
                case 16 => p_generatedCodeInfo.getOrDefault(this).unpack(subReader(src))
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = p_name.data) { out.append(10); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_insertionPoint.data) { out.append(18); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_content.data) { out.append(122); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_generatedCodeInfo.data) { out.packTag(16, PREFIXED); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (isPresent(p_name.data)) { i_tmp.append("name", p_name.get()) }
        if (isPresent(p_insertionPoint.data)) { i_tmp.append("insertionPoint", p_insertionPoint.get()) }
        if (isPresent(p_content.data)) { i_tmp.append("content", p_content.get()) }
        if (let Some(i_vtmp) = p_generatedCodeInfo.data) { i_tmp.append("generatedCodeInfo", i_vtmp) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { CodeGeneratorResponse_File() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = CodeGeneratorResponse_File(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = CodeGeneratorResponse_File(); i_tmp.unpack(src); i_tmp }
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

public class CodeGeneratorResponse <: Message & TypedMessage<CodeGeneratorResponse> {
    private var p_error = Pb2String()
    private var p_supportedFeatures: ?UInt64 = None
    public let file = RepeatedMessage<CodeGeneratorResponse_File>()

    public init() {
        m_init(file)
        m_innerInit()
    }

    public func clearError() { p_error.clear(); markDirty() }
    public prop let hasError: Bool { get() { isPresent(p_error.data) } }
    public prop var error: String { get() { p_error.get() } set(i_vtmp) { p_error.set(i_vtmp); markDirty() } }

    public func clearSupportedFeatures() { p_supportedFeatures = None; markDirty() }
    public prop let hasSupportedFeatures: Bool { get() { isPresent(p_supportedFeatures) } }
    public prop var supportedFeatures: UInt64 { get() { p_supportedFeatures.getOrThrow() } set(i_tmp) { p_supportedFeatures = i_tmp; markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_error.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_supportedFeatures) { i_tmp += 1 + varintSize(i_vtmp) }
        if (!file.isEmpty()) { for (i_itmp in file) { i_tmp += 1 + binSize(i_itmp) } }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_error.data) && isNone(p_supportedFeatures) && file.isEmpty()
    }

    protected func m_clear(): Unit {
        p_error.clear()
        p_supportedFeatures = None
        file.clear()
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
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_error.unpack(src)
                case 2 => p_supportedFeatures = src.parseUInt64()
                case 15 => s_add(file, src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = p_error.data) { out.append(10); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_supportedFeatures) { out.append(16); out.packVarint(i_vtmp) }
        if (!file.isEmpty()) { for (i_itmp in file) { out.append(122); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (isPresent(p_error.data)) { i_tmp.append("error", p_error.get()) }
        if (let Some(i_vtmp) = p_supportedFeatures) { i_tmp.append("supportedFeatures", i_vtmp) }
        if (!file.isEmpty()) { i_tmp.append("file", file) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { CodeGeneratorResponse() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = CodeGeneratorResponse(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = CodeGeneratorResponse(); i_tmp.unpack(src); i_tmp }
}
