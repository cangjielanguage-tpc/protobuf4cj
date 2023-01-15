package google.protobuf.compiler

from std import collection.*
from protobuf import protobuf.*
import google.protobuf.*

public class Version <: Message & TypedMessage<Version> {
    private var m_major: ?Int32 = None
    private var m_minor: ?Int32 = None
    private var m_patch: ?Int32 = None
    private var m_suffix: ?String = None
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearMajor() { m_major = None }
    public prop let hasMajor: Bool { get() { isPresent(m_major) } }
    public prop var major: Int32 { get() { m_major.getOrThrow() } set(i_tmp) { m_major = i_tmp } }

    public func clearMinor() { m_minor = None }
    public prop let hasMinor: Bool { get() { isPresent(m_minor) } }
    public prop var minor: Int32 { get() { m_minor.getOrThrow() } set(i_tmp) { m_minor = i_tmp } }

    public func clearPatch() { m_patch = None }
    public prop let hasPatch: Bool { get() { isPresent(m_patch) } }
    public prop var patch: Int32 { get() { m_patch.getOrThrow() } set(i_tmp) { m_patch = i_tmp } }

    public func clearSuffix() { m_suffix = None }
    public prop let hasSuffix: Bool { get() { isPresent(m_suffix) } }
    public prop var suffix: String { get() { m_suffix.getOrThrow() } set(i_tmp) { m_suffix = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_major) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = m_minor) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = m_patch) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = m_suffix) { i_tmp += 1 + binSize(i_vtmp) }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_major) && isNone(m_minor) && isNone(m_patch) && isNone(m_suffix) &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_major = None
        m_minor = None
        m_patch = None
        m_suffix = None
        unknownFields.clear()
    }

    public func clone(): Version {
        let i_tmp = Version()
        i_tmp.m_major = m_major
        i_tmp.m_minor = m_minor
        i_tmp.m_patch = m_patch
        i_tmp.m_suffix = m_suffix
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => m_major = src.parseInt32()
                case 2 => m_minor = src.parseInt32()
                case 3 => m_patch = src.parseInt32()
                case 4 => m_suffix = src.parseString()
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_major) { out.append(8); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = m_minor) { out.append(16); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = m_patch) { out.append(24); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = m_suffix) { out.append(34); out.packBin(i_vtmp) }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_major) { i_tmp.append("major", i_vtmp) }
        if (let Some(i_vtmp) = m_minor) { i_tmp.append("minor", i_vtmp) }
        if (let Some(i_vtmp) = m_patch) { i_tmp.append("patch", i_vtmp) }
        if (let Some(i_vtmp) = m_suffix) { i_tmp.append("suffix", i_vtmp) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { Version() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = Version(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = Version(); i_tmp.unpacki(src); i_tmp }
}

public class CodeGeneratorRequest <: Message & TypedMessage<CodeGeneratorRequest> {
    public var fileToGenerate = ArrayList<String>()
    private var m_parameter: ?String = None
    public var protoFile = ArrayList<google.protobuf.FileDescriptorProto>()
    private var m_compilerVersion: ?Version = None
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearParameter() { m_parameter = None }
    public prop let hasParameter: Bool { get() { isPresent(m_parameter) } }
    public prop var parameter: String { get() { m_parameter.getOrThrow() } set(i_tmp) { m_parameter = i_tmp } }

    public func clearCompilerVersion() { m_compilerVersion = None }
    public prop let hasCompilerVersion: Bool { get() { isPresent(m_compilerVersion) } }
    public prop var compilerVersion: Version { get() { m_compilerVersion.getOrThrow() } set(i_tmp) { m_compilerVersion = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (!fileToGenerate.isEmpty()) { for (i_itmp in fileToGenerate) { i_tmp += 1 + binSize(i_itmp) } }
        if (let Some(i_vtmp) = m_parameter) { i_tmp += 1 + binSize(i_vtmp) }
        if (!protoFile.isEmpty()) { for (i_itmp in protoFile) { i_tmp += 1 + binSize(i_itmp) } }
        if (let Some(i_vtmp) = m_compilerVersion) { i_tmp += 1 + binSize(i_vtmp) }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        fileToGenerate.isEmpty() && isNone(m_parameter) && protoFile.isEmpty() && isNone(m_compilerVersion) &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        fileToGenerate.clear()
        m_parameter = None
        protoFile.clear()
        m_compilerVersion = None
        unknownFields.clear()
    }

    public func clone(): CodeGeneratorRequest {
        let i_tmp = CodeGeneratorRequest()
        i_tmp.fileToGenerate = fileToGenerate.clone()
        i_tmp.m_parameter = m_parameter
        i_tmp.protoFile = ArrayList(protoFile.size, { i => protoFile[i].clone() })
        i_tmp.m_compilerVersion = m_compilerVersion?.clone()
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => fileToGenerate.append(src.parseString())
                case 2 => m_parameter = src.parseString()
                case 15 => protoFile.add().unpack(subReader(src))
                case 3 => m_compilerVersion = m_compilerVersion ?? Version(); m_compilerVersion?.unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!fileToGenerate.isEmpty()) { for (i_itmp in fileToGenerate) { out.append(10); out.packBin(i_itmp) } }
        if (let Some(i_vtmp) = m_parameter) { out.append(18); out.packBin(i_vtmp) }
        if (!protoFile.isEmpty()) { for (i_itmp in protoFile) { out.append(122); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (let Some(i_vtmp) = m_compilerVersion) { out.append(26); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!fileToGenerate.isEmpty()) { i_tmp.append("fileToGenerate", fileToGenerate) }
        if (let Some(i_vtmp) = m_parameter) { i_tmp.append("parameter", i_vtmp) }
        if (!protoFile.isEmpty()) { i_tmp.append("protoFile", protoFile) }
        if (let Some(i_vtmp) = m_compilerVersion) { i_tmp.append("compilerVersion", i_vtmp) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { CodeGeneratorRequest() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = CodeGeneratorRequest(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = CodeGeneratorRequest(); i_tmp.unpacki(src); i_tmp }
}

public class CodeGeneratorResponse_File <: Message & TypedMessage<CodeGeneratorResponse_File> {
    private var m_name: ?String = None
    private var m_insertionPoint: ?String = None
    private var m_content: ?String = None
    private var m_generatedCodeInfo: ?google.protobuf.GeneratedCodeInfo = None
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearName() { m_name = None }
    public prop let hasName: Bool { get() { isPresent(m_name) } }
    public prop var name: String { get() { m_name.getOrThrow() } set(i_tmp) { m_name = i_tmp } }

    public func clearInsertionPoint() { m_insertionPoint = None }
    public prop let hasInsertionPoint: Bool { get() { isPresent(m_insertionPoint) } }
    public prop var insertionPoint: String { get() { m_insertionPoint.getOrThrow() } set(i_tmp) { m_insertionPoint = i_tmp } }

    public func clearContent() { m_content = None }
    public prop let hasContent: Bool { get() { isPresent(m_content) } }
    public prop var content: String { get() { m_content.getOrThrow() } set(i_tmp) { m_content = i_tmp } }

    public func clearGeneratedCodeInfo() { m_generatedCodeInfo = None }
    public prop let hasGeneratedCodeInfo: Bool { get() { isPresent(m_generatedCodeInfo) } }
    public prop var generatedCodeInfo: google.protobuf.GeneratedCodeInfo { get() { m_generatedCodeInfo.getOrThrow() } set(i_tmp) { m_generatedCodeInfo = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_name) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_insertionPoint) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_content) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_generatedCodeInfo) { i_tmp += 2 + binSize(i_vtmp) }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_name) && isNone(m_insertionPoint) && isNone(m_content) && isNone(m_generatedCodeInfo) &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_name = None
        m_insertionPoint = None
        m_content = None
        m_generatedCodeInfo = None
        unknownFields.clear()
    }

    public func clone(): CodeGeneratorResponse_File {
        let i_tmp = CodeGeneratorResponse_File()
        i_tmp.m_name = m_name
        i_tmp.m_insertionPoint = m_insertionPoint
        i_tmp.m_content = m_content
        i_tmp.m_generatedCodeInfo = m_generatedCodeInfo?.clone()
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => m_name = src.parseString()
                case 2 => m_insertionPoint = src.parseString()
                case 15 => m_content = src.parseString()
                case 16 => m_generatedCodeInfo = m_generatedCodeInfo ?? google.protobuf.GeneratedCodeInfo(); m_generatedCodeInfo?.unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_name) { out.append(10); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_insertionPoint) { out.append(18); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_content) { out.append(122); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_generatedCodeInfo) { out.packTag(16, PREFIXED); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_name) { i_tmp.append("name", i_vtmp) }
        if (let Some(i_vtmp) = m_insertionPoint) { i_tmp.append("insertionPoint", i_vtmp) }
        if (let Some(i_vtmp) = m_content) { i_tmp.append("content", i_vtmp) }
        if (let Some(i_vtmp) = m_generatedCodeInfo) { i_tmp.append("generatedCodeInfo", i_vtmp) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { CodeGeneratorResponse_File() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = CodeGeneratorResponse_File(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = CodeGeneratorResponse_File(); i_tmp.unpacki(src); i_tmp }
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
    private var m_error: ?String = None
    private var m_supportedFeatures: ?UInt64 = None
    public var file = ArrayList<CodeGeneratorResponse_File>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearError() { m_error = None }
    public prop let hasError: Bool { get() { isPresent(m_error) } }
    public prop var error: String { get() { m_error.getOrThrow() } set(i_tmp) { m_error = i_tmp } }

    public func clearSupportedFeatures() { m_supportedFeatures = None }
    public prop let hasSupportedFeatures: Bool { get() { isPresent(m_supportedFeatures) } }
    public prop var supportedFeatures: UInt64 { get() { m_supportedFeatures.getOrThrow() } set(i_tmp) { m_supportedFeatures = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_error) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_supportedFeatures) { i_tmp += 1 + varintSize(i_vtmp) }
        if (!file.isEmpty()) { for (i_itmp in file) { i_tmp += 1 + binSize(i_itmp) } }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_error) && isNone(m_supportedFeatures) && file.isEmpty() &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_error = None
        m_supportedFeatures = None
        file.clear()
        unknownFields.clear()
    }

    public func clone(): CodeGeneratorResponse {
        let i_tmp = CodeGeneratorResponse()
        i_tmp.m_error = m_error
        i_tmp.m_supportedFeatures = m_supportedFeatures
        i_tmp.file = ArrayList(file.size, { i => file[i].clone() })
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => m_error = src.parseString()
                case 2 => m_supportedFeatures = src.parseUInt64()
                case 15 => file.add().unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_error) { out.append(10); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_supportedFeatures) { out.append(16); out.packVarint(i_vtmp) }
        if (!file.isEmpty()) { for (i_itmp in file) { out.append(122); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_error) { i_tmp.append("error", i_vtmp) }
        if (let Some(i_vtmp) = m_supportedFeatures) { i_tmp.append("supportedFeatures", i_vtmp) }
        if (!file.isEmpty()) { i_tmp.append("file", file) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { CodeGeneratorResponse() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = CodeGeneratorResponse(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = CodeGeneratorResponse(); i_tmp.unpacki(src); i_tmp }
}
