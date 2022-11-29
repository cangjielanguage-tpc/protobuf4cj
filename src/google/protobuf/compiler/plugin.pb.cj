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
    public prop let hasMajor: Bool { get() { match (m_major) { case None => false case _ => true } } }
    public prop var major: Int32 { get() { m_major.getOrThrow() } set(i_tmp) { m_major = i_tmp } }

    public func clearMinor() { m_minor = None }
    public prop let hasMinor: Bool { get() { match (m_minor) { case None => false case _ => true } } }
    public prop var minor: Int32 { get() { m_minor.getOrThrow() } set(i_tmp) { m_minor = i_tmp } }

    public func clearPatch() { m_patch = None }
    public prop let hasPatch: Bool { get() { match (m_patch) { case None => false case _ => true } } }
    public prop var patch: Int32 { get() { m_patch.getOrThrow() } set(i_tmp) { m_patch = i_tmp } }

    public func clearSuffix() { m_suffix = None }
    public prop let hasSuffix: Bool { get() { match (m_suffix) { case None => false case _ => true } } }
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
        if (let Some(i_vtmp) = m_major) { return false }
        if (let Some(i_vtmp) = m_minor) { return false }
        if (let Some(i_vtmp) = m_patch) { return false }
        if (let Some(i_vtmp) = m_suffix) { return false }
        if (!unknownFields.isEmpty()) { return false }
        return true
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

    public func unpack<T>(src: T): Unit where T <: BytesReader & SubReader<T> {
        while (!src.isEmpty()) {
            let i_tmp = tagParse(src)
            match (i_tmp[0]) {
                case 1 => m_major = int32Parse(src)
                case 2 => m_minor = int32Parse(src)
                case 3 => m_patch = int32Parse(src)
                case 4 => m_suffix = stringParse(src)
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_major) { tagPack(1, VARINT, out); varintPack(i_vtmp, out) }
        if (let Some(i_vtmp) = m_minor) { tagPack(2, VARINT, out); varintPack(i_vtmp, out) }
        if (let Some(i_vtmp) = m_patch) { tagPack(3, VARINT, out); varintPack(i_vtmp, out) }
        if (let Some(i_vtmp) = m_suffix) { tagPack(4, PREFIXED, out); binPack(i_vtmp, out) }
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

    public func packi(out: Bytes) { pack(out) }
    public func packi(out: BytesWriter) { match (out) { case i_tmp: Bytes => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }
    public func unpack(src: Collection<Byte>) { unpack(SimpleReader(src)) }

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
    public prop let hasParameter: Bool { get() { match (m_parameter) { case None => false case _ => true } } }
    public prop var parameter: String { get() { m_parameter.getOrThrow() } set(i_tmp) { m_parameter = i_tmp } }

    public func clearCompilerVersion() { m_compilerVersion = None }
    public prop let hasCompilerVersion: Bool { get() { match (m_compilerVersion) { case None => false case _ => true } } }
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
        if (!fileToGenerate.isEmpty()) { return false }
        if (let Some(i_vtmp) = m_parameter) { return false }
        if (!protoFile.isEmpty()) { return false }
        if (let Some(i_vtmp) = m_compilerVersion) { return false }
        if (!unknownFields.isEmpty()) { return false }
        return true
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

    public func unpack<T>(src: T): Unit where T <: BytesReader & SubReader<T> {
        while (!src.isEmpty()) {
            let i_tmp = tagParse(src)
            match (i_tmp[0]) {
                case 1 => fileToGenerate.append(stringParse(src))
                case 2 => m_parameter = stringParse(src)
                case 15 => protoFile.add().unpack(sub(src))
                case 3 => m_compilerVersion = m_compilerVersion ?? Version(); m_compilerVersion?.unpack(sub(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!fileToGenerate.isEmpty()) { for (i_itmp in fileToGenerate) { tagPack(1, PREFIXED, out); binPack(i_itmp, out) } }
        if (let Some(i_vtmp) = m_parameter) { tagPack(2, PREFIXED, out); binPack(i_vtmp, out) }
        if (!protoFile.isEmpty()) { for (i_itmp in protoFile) { tagPack(15, PREFIXED, out); varintPack(i_itmp.size, out); i_itmp.pack(out) } }
        if (let Some(i_vtmp) = m_compilerVersion) { tagPack(3, PREFIXED, out); varintPack(i_vtmp.size, out); i_vtmp.pack(out) }
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

    public func packi(out: Bytes) { pack(out) }
    public func packi(out: BytesWriter) { match (out) { case i_tmp: Bytes => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }
    public func unpack(src: Collection<Byte>) { unpack(SimpleReader(src)) }

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
    public prop let hasName: Bool { get() { match (m_name) { case None => false case _ => true } } }
    public prop var name: String { get() { m_name.getOrThrow() } set(i_tmp) { m_name = i_tmp } }

    public func clearInsertionPoint() { m_insertionPoint = None }
    public prop let hasInsertionPoint: Bool { get() { match (m_insertionPoint) { case None => false case _ => true } } }
    public prop var insertionPoint: String { get() { m_insertionPoint.getOrThrow() } set(i_tmp) { m_insertionPoint = i_tmp } }

    public func clearContent() { m_content = None }
    public prop let hasContent: Bool { get() { match (m_content) { case None => false case _ => true } } }
    public prop var content: String { get() { m_content.getOrThrow() } set(i_tmp) { m_content = i_tmp } }

    public func clearGeneratedCodeInfo() { m_generatedCodeInfo = None }
    public prop let hasGeneratedCodeInfo: Bool { get() { match (m_generatedCodeInfo) { case None => false case _ => true } } }
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
        if (let Some(i_vtmp) = m_name) { return false }
        if (let Some(i_vtmp) = m_insertionPoint) { return false }
        if (let Some(i_vtmp) = m_content) { return false }
        if (let Some(i_vtmp) = m_generatedCodeInfo) { return false }
        if (!unknownFields.isEmpty()) { return false }
        return true
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

    public func unpack<T>(src: T): Unit where T <: BytesReader & SubReader<T> {
        while (!src.isEmpty()) {
            let i_tmp = tagParse(src)
            match (i_tmp[0]) {
                case 1 => m_name = stringParse(src)
                case 2 => m_insertionPoint = stringParse(src)
                case 15 => m_content = stringParse(src)
                case 16 => m_generatedCodeInfo = m_generatedCodeInfo ?? google.protobuf.GeneratedCodeInfo(); m_generatedCodeInfo?.unpack(sub(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_name) { tagPack(1, PREFIXED, out); binPack(i_vtmp, out) }
        if (let Some(i_vtmp) = m_insertionPoint) { tagPack(2, PREFIXED, out); binPack(i_vtmp, out) }
        if (let Some(i_vtmp) = m_content) { tagPack(15, PREFIXED, out); binPack(i_vtmp, out) }
        if (let Some(i_vtmp) = m_generatedCodeInfo) { tagPack(16, PREFIXED, out); varintPack(i_vtmp.size, out); i_vtmp.pack(out) }
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

    public func packi(out: Bytes) { pack(out) }
    public func packi(out: BytesWriter) { match (out) { case i_tmp: Bytes => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }
    public func unpack(src: Collection<Byte>) { unpack(SimpleReader(src)) }

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

    public operator func==(e: CodeGeneratorResponse_Feature) {
        match((this, e)) {
            case (FEATURE_NONE, FEATURE_NONE) => true
            case (FEATURE_PROTO3_OPTIONAL, FEATURE_PROTO3_OPTIONAL) => true
            case _ => false
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

public class CodeGeneratorResponse <: Message & TypedMessage<CodeGeneratorResponse> {
    private var m_error: ?String = None
    private var m_supportedFeatures: ?UInt64 = None
    public var file = ArrayList<CodeGeneratorResponse_File>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearError() { m_error = None }
    public prop let hasError: Bool { get() { match (m_error) { case None => false case _ => true } } }
    public prop var error: String { get() { m_error.getOrThrow() } set(i_tmp) { m_error = i_tmp } }

    public func clearSupportedFeatures() { m_supportedFeatures = None }
    public prop let hasSupportedFeatures: Bool { get() { match (m_supportedFeatures) { case None => false case _ => true } } }
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
        if (let Some(i_vtmp) = m_error) { return false }
        if (let Some(i_vtmp) = m_supportedFeatures) { return false }
        if (!file.isEmpty()) { return false }
        if (!unknownFields.isEmpty()) { return false }
        return true
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

    public func unpack<T>(src: T): Unit where T <: BytesReader & SubReader<T> {
        while (!src.isEmpty()) {
            let i_tmp = tagParse(src)
            match (i_tmp[0]) {
                case 1 => m_error = stringParse(src)
                case 2 => m_supportedFeatures = uint64Parse(src)
                case 15 => file.add().unpack(sub(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_error) { tagPack(1, PREFIXED, out); binPack(i_vtmp, out) }
        if (let Some(i_vtmp) = m_supportedFeatures) { tagPack(2, VARINT, out); varintPack(i_vtmp, out) }
        if (!file.isEmpty()) { for (i_itmp in file) { tagPack(15, PREFIXED, out); varintPack(i_itmp.size, out); i_itmp.pack(out) } }
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

    public func packi(out: Bytes) { pack(out) }
    public func packi(out: BytesWriter) { match (out) { case i_tmp: Bytes => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }
    public func unpack(src: Collection<Byte>) { unpack(SimpleReader(src)) }

    public static func empty() { CodeGeneratorResponse() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = CodeGeneratorResponse(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = CodeGeneratorResponse(); i_tmp.unpacki(src); i_tmp }
}
