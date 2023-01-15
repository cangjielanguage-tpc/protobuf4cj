package google.protobuf

from std import collection.*
from protobuf import protobuf.*

public class FileDescriptorSet <: Message & TypedMessage<FileDescriptorSet> {
    public var file = ArrayList<FileDescriptorProto>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (!file.isEmpty()) { for (i_itmp in file) { i_tmp += 1 + binSize(i_itmp) } }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        file.isEmpty() &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        file.clear()
        unknownFields.clear()
    }

    public func clone(): FileDescriptorSet {
        let i_tmp = FileDescriptorSet()
        i_tmp.file = ArrayList(file.size, { i => file[i].clone() })
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => file.add().unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!file.isEmpty()) { for (i_itmp in file) { out.append(10); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!file.isEmpty()) { i_tmp.append("file", file) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { FileDescriptorSet() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = FileDescriptorSet(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = FileDescriptorSet(); i_tmp.unpacki(src); i_tmp }
}

public class FileDescriptorProto <: Message & TypedMessage<FileDescriptorProto> {
    private var m_name: ?String = None
    private var m_package: ?String = None
    public var dependency = ArrayList<String>()
    public var publicDependency = ArrayList<Int32>()
    public var weakDependency = ArrayList<Int32>()
    public var messageType = ArrayList<DescriptorProto>()
    public var enumType = ArrayList<EnumDescriptorProto>()
    public var service = ArrayList<ServiceDescriptorProto>()
    public var extension = ArrayList<FieldDescriptorProto>()
    private var m_options: ?FileOptions = None
    private var m_sourceCodeInfo: ?SourceCodeInfo = None
    private var m_syntax: ?String = None
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearName() { m_name = None }
    public prop let hasName: Bool { get() { match (m_name) { case None => false case _ => true } } }
    public prop var name: String { get() { m_name.getOrThrow() } set(i_tmp) { m_name = i_tmp } }

    public func clearPackage() { m_package = None }
    public prop let hasPackage: Bool { get() { match (m_package) { case None => false case _ => true } } }
    public prop var package_: String { get() { m_package.getOrThrow() } set(i_tmp) { m_package = i_tmp } }

    public func clearOptions() { m_options = None }
    public prop let hasOptions: Bool { get() { match (m_options) { case None => false case _ => true } } }
    public prop var options: FileOptions { get() { m_options.getOrThrow() } set(i_tmp) { m_options = i_tmp } }

    public func clearSourceCodeInfo() { m_sourceCodeInfo = None }
    public prop let hasSourceCodeInfo: Bool { get() { match (m_sourceCodeInfo) { case None => false case _ => true } } }
    public prop var sourceCodeInfo: SourceCodeInfo { get() { m_sourceCodeInfo.getOrThrow() } set(i_tmp) { m_sourceCodeInfo = i_tmp } }

    public func clearSyntax() { m_syntax = None }
    public prop let hasSyntax: Bool { get() { match (m_syntax) { case None => false case _ => true } } }
    public prop var syntax: String { get() { m_syntax.getOrThrow() } set(i_tmp) { m_syntax = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_name) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_package) { i_tmp += 1 + binSize(i_vtmp) }
        if (!dependency.isEmpty()) { for (i_itmp in dependency) { i_tmp += 1 + binSize(i_itmp) } }
        if (!publicDependency.isEmpty()) { for (i_itmp in publicDependency) { i_tmp += 1 + varintSize(i_itmp) } }
        if (!weakDependency.isEmpty()) { for (i_itmp in weakDependency) { i_tmp += 1 + varintSize(i_itmp) } }
        if (!messageType.isEmpty()) { for (i_itmp in messageType) { i_tmp += 1 + binSize(i_itmp) } }
        if (!enumType.isEmpty()) { for (i_itmp in enumType) { i_tmp += 1 + binSize(i_itmp) } }
        if (!service.isEmpty()) { for (i_itmp in service) { i_tmp += 1 + binSize(i_itmp) } }
        if (!extension.isEmpty()) { for (i_itmp in extension) { i_tmp += 1 + binSize(i_itmp) } }
        if (let Some(i_vtmp) = m_options) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_sourceCodeInfo) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_syntax) { i_tmp += 1 + binSize(i_vtmp) }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_name) && isNone(m_package) && dependency.isEmpty() && publicDependency.isEmpty() &&
        weakDependency.isEmpty() && messageType.isEmpty() && enumType.isEmpty() && service.isEmpty() &&
        extension.isEmpty() && isNone(m_options) && isNone(m_sourceCodeInfo) && isNone(m_syntax) &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_name = None
        m_package = None
        dependency.clear()
        publicDependency.clear()
        weakDependency.clear()
        messageType.clear()
        enumType.clear()
        service.clear()
        extension.clear()
        m_options = None
        m_sourceCodeInfo = None
        m_syntax = None
        unknownFields.clear()
    }

    public func clone(): FileDescriptorProto {
        let i_tmp = FileDescriptorProto()
        i_tmp.m_name = m_name
        i_tmp.m_package = m_package
        i_tmp.dependency = dependency.clone()
        i_tmp.publicDependency = publicDependency.clone()
        i_tmp.weakDependency = weakDependency.clone()
        i_tmp.messageType = ArrayList(messageType.size, { i => messageType[i].clone() })
        i_tmp.enumType = ArrayList(enumType.size, { i => enumType[i].clone() })
        i_tmp.service = ArrayList(service.size, { i => service[i].clone() })
        i_tmp.extension = ArrayList(extension.size, { i => extension[i].clone() })
        i_tmp.m_options = m_options?.clone()
        i_tmp.m_sourceCodeInfo = m_sourceCodeInfo?.clone()
        i_tmp.m_syntax = m_syntax
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => m_name = src.parseString()
                case 2 => m_package = src.parseString()
                case 3 => dependency.append(src.parseString())
                case 10 => publicDependency.append(src.parseInt32())
                case 11 => weakDependency.append(src.parseInt32())
                case 4 => messageType.add().unpack(subReader(src))
                case 5 => enumType.add().unpack(subReader(src))
                case 6 => service.add().unpack(subReader(src))
                case 7 => extension.add().unpack(subReader(src))
                case 8 => m_options = m_options ?? FileOptions(); m_options?.unpack(subReader(src))
                case 9 => m_sourceCodeInfo = m_sourceCodeInfo ?? SourceCodeInfo(); m_sourceCodeInfo?.unpack(subReader(src))
                case 12 => m_syntax = src.parseString()
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_name) { out.append(10); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_package) { out.append(18); out.packBin(i_vtmp) }
        if (!dependency.isEmpty()) { for (i_itmp in dependency) { out.append(26); out.packBin(i_itmp) } }
        if (!publicDependency.isEmpty()) { for (i_itmp in publicDependency) { out.append(80); out.packVarint(i_itmp) } }
        if (!weakDependency.isEmpty()) { for (i_itmp in weakDependency) { out.append(88); out.packVarint(i_itmp) } }
        if (!messageType.isEmpty()) { for (i_itmp in messageType) { out.append(34); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!enumType.isEmpty()) { for (i_itmp in enumType) { out.append(42); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!service.isEmpty()) { for (i_itmp in service) { out.append(50); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!extension.isEmpty()) { for (i_itmp in extension) { out.append(58); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (let Some(i_vtmp) = m_options) { out.append(66); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (let Some(i_vtmp) = m_sourceCodeInfo) { out.append(74); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (let Some(i_vtmp) = m_syntax) { out.append(98); out.packBin(i_vtmp) }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_name) { i_tmp.append("name", i_vtmp) }
        if (let Some(i_vtmp) = m_package) { i_tmp.append("package", i_vtmp) }
        if (!dependency.isEmpty()) { i_tmp.append("dependency", dependency) }
        if (!publicDependency.isEmpty()) { i_tmp.append("publicDependency", publicDependency) }
        if (!weakDependency.isEmpty()) { i_tmp.append("weakDependency", weakDependency) }
        if (!messageType.isEmpty()) { i_tmp.append("messageType", messageType) }
        if (!enumType.isEmpty()) { i_tmp.append("enumType", enumType) }
        if (!service.isEmpty()) { i_tmp.append("service", service) }
        if (!extension.isEmpty()) { i_tmp.append("extension", extension) }
        if (let Some(i_vtmp) = m_options) { i_tmp.append("options", i_vtmp) }
        if (let Some(i_vtmp) = m_sourceCodeInfo) { i_tmp.append("sourceCodeInfo", i_vtmp) }
        if (let Some(i_vtmp) = m_syntax) { i_tmp.append("syntax", i_vtmp) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { FileDescriptorProto() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = FileDescriptorProto(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = FileDescriptorProto(); i_tmp.unpacki(src); i_tmp }
}

public class DescriptorProto_ExtensionRange <: Message & TypedMessage<DescriptorProto_ExtensionRange> {
    private var m_start: ?Int32 = None
    private var m_end: ?Int32 = None
    private var m_options: ?ExtensionRangeOptions = None
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearStart() { m_start = None }
    public prop let hasStart: Bool { get() { match (m_start) { case None => false case _ => true } } }
    public prop var start: Int32 { get() { m_start.getOrThrow() } set(i_tmp) { m_start = i_tmp } }

    public func clearEnd() { m_end = None }
    public prop let hasEnd: Bool { get() { match (m_end) { case None => false case _ => true } } }
    public prop var end: Int32 { get() { m_end.getOrThrow() } set(i_tmp) { m_end = i_tmp } }

    public func clearOptions() { m_options = None }
    public prop let hasOptions: Bool { get() { match (m_options) { case None => false case _ => true } } }
    public prop var options: ExtensionRangeOptions { get() { m_options.getOrThrow() } set(i_tmp) { m_options = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_start) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = m_end) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = m_options) { i_tmp += 1 + binSize(i_vtmp) }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_start) && isNone(m_end) && isNone(m_options) &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_start = None
        m_end = None
        m_options = None
        unknownFields.clear()
    }

    public func clone(): DescriptorProto_ExtensionRange {
        let i_tmp = DescriptorProto_ExtensionRange()
        i_tmp.m_start = m_start
        i_tmp.m_end = m_end
        i_tmp.m_options = m_options?.clone()
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => m_start = src.parseInt32()
                case 2 => m_end = src.parseInt32()
                case 3 => m_options = m_options ?? ExtensionRangeOptions(); m_options?.unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_start) { out.append(8); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = m_end) { out.append(16); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = m_options) { out.append(26); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_start) { i_tmp.append("start", i_vtmp) }
        if (let Some(i_vtmp) = m_end) { i_tmp.append("end", i_vtmp) }
        if (let Some(i_vtmp) = m_options) { i_tmp.append("options", i_vtmp) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { DescriptorProto_ExtensionRange() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = DescriptorProto_ExtensionRange(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = DescriptorProto_ExtensionRange(); i_tmp.unpacki(src); i_tmp }
}

public class DescriptorProto_ReservedRange <: Message & TypedMessage<DescriptorProto_ReservedRange> {
    private var m_start: ?Int32 = None
    private var m_end: ?Int32 = None
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearStart() { m_start = None }
    public prop let hasStart: Bool { get() { match (m_start) { case None => false case _ => true } } }
    public prop var start: Int32 { get() { m_start.getOrThrow() } set(i_tmp) { m_start = i_tmp } }

    public func clearEnd() { m_end = None }
    public prop let hasEnd: Bool { get() { match (m_end) { case None => false case _ => true } } }
    public prop var end: Int32 { get() { m_end.getOrThrow() } set(i_tmp) { m_end = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_start) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = m_end) { i_tmp += 1 + varintSize(i_vtmp) }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_start) && isNone(m_end) &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_start = None
        m_end = None
        unknownFields.clear()
    }

    public func clone(): DescriptorProto_ReservedRange {
        let i_tmp = DescriptorProto_ReservedRange()
        i_tmp.m_start = m_start
        i_tmp.m_end = m_end
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => m_start = src.parseInt32()
                case 2 => m_end = src.parseInt32()
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_start) { out.append(8); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = m_end) { out.append(16); out.packVarint(i_vtmp) }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_start) { i_tmp.append("start", i_vtmp) }
        if (let Some(i_vtmp) = m_end) { i_tmp.append("end", i_vtmp) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { DescriptorProto_ReservedRange() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = DescriptorProto_ReservedRange(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = DescriptorProto_ReservedRange(); i_tmp.unpacki(src); i_tmp }
}

public class DescriptorProto <: Message & TypedMessage<DescriptorProto> {
    private var m_name: ?String = None
    public var field = ArrayList<FieldDescriptorProto>()
    public var extension = ArrayList<FieldDescriptorProto>()
    public var nestedType = ArrayList<DescriptorProto>()
    public var enumType = ArrayList<EnumDescriptorProto>()
    public var extensionRange = ArrayList<DescriptorProto_ExtensionRange>()
    public var oneofDecl = ArrayList<OneofDescriptorProto>()
    private var m_options: ?MessageOptions = None
    public var reservedRange = ArrayList<DescriptorProto_ReservedRange>()
    public var reservedName = ArrayList<String>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearName() { m_name = None }
    public prop let hasName: Bool { get() { match (m_name) { case None => false case _ => true } } }
    public prop var name: String { get() { m_name.getOrThrow() } set(i_tmp) { m_name = i_tmp } }

    public func clearOptions() { m_options = None }
    public prop let hasOptions: Bool { get() { match (m_options) { case None => false case _ => true } } }
    public prop var options: MessageOptions { get() { m_options.getOrThrow() } set(i_tmp) { m_options = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_name) { i_tmp += 1 + binSize(i_vtmp) }
        if (!field.isEmpty()) { for (i_itmp in field) { i_tmp += 1 + binSize(i_itmp) } }
        if (!extension.isEmpty()) { for (i_itmp in extension) { i_tmp += 1 + binSize(i_itmp) } }
        if (!nestedType.isEmpty()) { for (i_itmp in nestedType) { i_tmp += 1 + binSize(i_itmp) } }
        if (!enumType.isEmpty()) { for (i_itmp in enumType) { i_tmp += 1 + binSize(i_itmp) } }
        if (!extensionRange.isEmpty()) { for (i_itmp in extensionRange) { i_tmp += 1 + binSize(i_itmp) } }
        if (!oneofDecl.isEmpty()) { for (i_itmp in oneofDecl) { i_tmp += 1 + binSize(i_itmp) } }
        if (let Some(i_vtmp) = m_options) { i_tmp += 1 + binSize(i_vtmp) }
        if (!reservedRange.isEmpty()) { for (i_itmp in reservedRange) { i_tmp += 1 + binSize(i_itmp) } }
        if (!reservedName.isEmpty()) { for (i_itmp in reservedName) { i_tmp += 1 + binSize(i_itmp) } }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_name) && field.isEmpty() && extension.isEmpty() && nestedType.isEmpty() && enumType.isEmpty() &&
        extensionRange.isEmpty() && oneofDecl.isEmpty() && isNone(m_options) && reservedRange.isEmpty() &&
        reservedName.isEmpty() &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_name = None
        field.clear()
        extension.clear()
        nestedType.clear()
        enumType.clear()
        extensionRange.clear()
        oneofDecl.clear()
        m_options = None
        reservedRange.clear()
        reservedName.clear()
        unknownFields.clear()
    }

    public func clone(): DescriptorProto {
        let i_tmp = DescriptorProto()
        i_tmp.m_name = m_name
        i_tmp.field = ArrayList(field.size, { i => field[i].clone() })
        i_tmp.extension = ArrayList(extension.size, { i => extension[i].clone() })
        i_tmp.nestedType = ArrayList(nestedType.size, { i => nestedType[i].clone() })
        i_tmp.enumType = ArrayList(enumType.size, { i => enumType[i].clone() })
        i_tmp.extensionRange = ArrayList(extensionRange.size, { i => extensionRange[i].clone() })
        i_tmp.oneofDecl = ArrayList(oneofDecl.size, { i => oneofDecl[i].clone() })
        i_tmp.m_options = m_options?.clone()
        i_tmp.reservedRange = ArrayList(reservedRange.size, { i => reservedRange[i].clone() })
        i_tmp.reservedName = reservedName.clone()
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => m_name = src.parseString()
                case 2 => field.add().unpack(subReader(src))
                case 6 => extension.add().unpack(subReader(src))
                case 3 => nestedType.add().unpack(subReader(src))
                case 4 => enumType.add().unpack(subReader(src))
                case 5 => extensionRange.add().unpack(subReader(src))
                case 8 => oneofDecl.add().unpack(subReader(src))
                case 7 => m_options = m_options ?? MessageOptions(); m_options?.unpack(subReader(src))
                case 9 => reservedRange.add().unpack(subReader(src))
                case 10 => reservedName.append(src.parseString())
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_name) { out.append(10); out.packBin(i_vtmp) }
        if (!field.isEmpty()) { for (i_itmp in field) { out.append(18); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!extension.isEmpty()) { for (i_itmp in extension) { out.append(50); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!nestedType.isEmpty()) { for (i_itmp in nestedType) { out.append(26); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!enumType.isEmpty()) { for (i_itmp in enumType) { out.append(34); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!extensionRange.isEmpty()) { for (i_itmp in extensionRange) { out.append(42); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!oneofDecl.isEmpty()) { for (i_itmp in oneofDecl) { out.append(66); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (let Some(i_vtmp) = m_options) { out.append(58); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (!reservedRange.isEmpty()) { for (i_itmp in reservedRange) { out.append(74); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!reservedName.isEmpty()) { for (i_itmp in reservedName) { out.append(82); out.packBin(i_itmp) } }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_name) { i_tmp.append("name", i_vtmp) }
        if (!field.isEmpty()) { i_tmp.append("field", field) }
        if (!extension.isEmpty()) { i_tmp.append("extension", extension) }
        if (!nestedType.isEmpty()) { i_tmp.append("nestedType", nestedType) }
        if (!enumType.isEmpty()) { i_tmp.append("enumType", enumType) }
        if (!extensionRange.isEmpty()) { i_tmp.append("extensionRange", extensionRange) }
        if (!oneofDecl.isEmpty()) { i_tmp.append("oneofDecl", oneofDecl) }
        if (let Some(i_vtmp) = m_options) { i_tmp.append("options", i_vtmp) }
        if (!reservedRange.isEmpty()) { i_tmp.append("reservedRange", reservedRange) }
        if (!reservedName.isEmpty()) { i_tmp.append("reservedName", reservedName) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { DescriptorProto() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = DescriptorProto(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = DescriptorProto(); i_tmp.unpacki(src); i_tmp }
}

public class ExtensionRangeOptions <: Message & TypedMessage<ExtensionRangeOptions> {
    public var uninterpretedOption = ArrayList<UninterpretedOption>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        uninterpretedOption.isEmpty() &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        uninterpretedOption.clear()
        unknownFields.clear()
    }

    public func clone(): ExtensionRangeOptions {
        let i_tmp = ExtensionRangeOptions()
        i_tmp.uninterpretedOption = ArrayList(uninterpretedOption.size, { i => uninterpretedOption[i].clone() })
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 999 => uninterpretedOption.add().unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { ExtensionRangeOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = ExtensionRangeOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = ExtensionRangeOptions(); i_tmp.unpacki(src); i_tmp }
}

public enum FieldDescriptorProto_Type <: Enum<FieldDescriptorProto_Type> {
    TYPE_DOUBLE | TYPE_FLOAT | TYPE_INT64 | TYPE_UINT64 | TYPE_INT32 | TYPE_FIXED64 | TYPE_FIXED32 | TYPE_BOOL |
    TYPE_STRING | TYPE_GROUP | TYPE_MESSAGE | TYPE_BYTES | TYPE_UINT32 | TYPE_ENUM | TYPE_SFIXED32 | TYPE_SFIXED64 |
    TYPE_SINT32 | TYPE_SINT64

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

    public operator func==(value: FieldDescriptorProto_Type) {
        match((this, value)) {
            case (TYPE_DOUBLE, TYPE_DOUBLE) => true
            case (TYPE_FLOAT, TYPE_FLOAT) => true
            case (TYPE_INT64, TYPE_INT64) => true
            case (TYPE_UINT64, TYPE_UINT64) => true
            case (TYPE_INT32, TYPE_INT32) => true
            case (TYPE_FIXED64, TYPE_FIXED64) => true
            case (TYPE_FIXED32, TYPE_FIXED32) => true
            case (TYPE_BOOL, TYPE_BOOL) => true
            case (TYPE_STRING, TYPE_STRING) => true
            case (TYPE_GROUP, TYPE_GROUP) => true
            case (TYPE_MESSAGE, TYPE_MESSAGE) => true
            case (TYPE_BYTES, TYPE_BYTES) => true
            case (TYPE_UINT32, TYPE_UINT32) => true
            case (TYPE_ENUM, TYPE_ENUM) => true
            case (TYPE_SFIXED32, TYPE_SFIXED32) => true
            case (TYPE_SFIXED64, TYPE_SFIXED64) => true
            case (TYPE_SINT32, TYPE_SINT32) => true
            case (TYPE_SINT64, TYPE_SINT64) => true
            case _ => false
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
            case _ => throw InvalidEnumValueException("FieldDescriptorProto_Type", value)
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
            case _ => throw UnmatchedEnumStringException("FieldDescriptorProto_Type", value)
        }
    }
}

public enum FieldDescriptorProto_Label <: Enum<FieldDescriptorProto_Label> {
    LABEL_OPTIONAL | LABEL_REQUIRED | LABEL_REPEATED

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

    public operator func==(value: FieldDescriptorProto_Label) {
        match((this, value)) {
            case (LABEL_OPTIONAL, LABEL_OPTIONAL) => true
            case (LABEL_REQUIRED, LABEL_REQUIRED) => true
            case (LABEL_REPEATED, LABEL_REPEATED) => true
            case _ => false
        }
    }

    public static func parse(value: Int32): FieldDescriptorProto_Label {
        match(value) {
            case 1 => LABEL_OPTIONAL
            case 2 => LABEL_REQUIRED
            case 3 => LABEL_REPEATED
            case _ => throw InvalidEnumValueException("FieldDescriptorProto_Label", value)
        }
    }

    public static func parse(value: String): FieldDescriptorProto_Label {
        match(value) {
            case "LABEL_OPTIONAL" => LABEL_OPTIONAL
            case "LABEL_REQUIRED" => LABEL_REQUIRED
            case "LABEL_REPEATED" => LABEL_REPEATED
            case _ => throw UnmatchedEnumStringException("FieldDescriptorProto_Label", value)
        }
    }
}

public class FieldDescriptorProto <: Message & TypedMessage<FieldDescriptorProto> {
    private var m_name: ?String = None
    private var m_number: ?Int32 = None
    private var m_label: ?FieldDescriptorProto_Label = None
    private var m_type: ?FieldDescriptorProto_Type = None
    private var m_typeName: ?String = None
    private var m_extendee: ?String = None
    private var m_defaultValue: ?String = None
    private var m_oneofIndex: ?Int32 = None
    private var m_jsonName: ?String = None
    private var m_options: ?FieldOptions = None
    private var m_proto3Optional: ?Bool = None
    public var mapEntry = ArrayList<FieldDescriptorProto>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearName() { m_name = None }
    public prop let hasName: Bool { get() { match (m_name) { case None => false case _ => true } } }
    public prop var name: String { get() { m_name.getOrThrow() } set(i_tmp) { m_name = i_tmp } }

    public func clearNumber() { m_number = None }
    public prop let hasNumber: Bool { get() { match (m_number) { case None => false case _ => true } } }
    public prop var number: Int32 { get() { m_number.getOrThrow() } set(i_tmp) { m_number = i_tmp } }

    public func clearLabel() { m_label = None }
    public prop let hasLabel: Bool { get() { match (m_label) { case None => false case _ => true } } }
    public prop var label: FieldDescriptorProto_Label { get() { m_label.getOrThrow() } set(i_tmp) { m_label = i_tmp } }

    public func clearType() { m_type = None }
    public prop let hasType: Bool { get() { match (m_type) { case None => false case _ => true } } }
    public prop var type_: FieldDescriptorProto_Type { get() { m_type.getOrThrow() } set(i_tmp) { m_type = i_tmp } }

    public func clearTypeName() { m_typeName = None }
    public prop let hasTypeName: Bool { get() { match (m_typeName) { case None => false case _ => true } } }
    public prop var typeName: String { get() { m_typeName.getOrThrow() } set(i_tmp) { m_typeName = i_tmp } }

    public func clearExtendee() { m_extendee = None }
    public prop let hasExtendee: Bool { get() { match (m_extendee) { case None => false case _ => true } } }
    public prop var extendee: String { get() { m_extendee.getOrThrow() } set(i_tmp) { m_extendee = i_tmp } }

    public func clearDefaultValue() { m_defaultValue = None }
    public prop let hasDefaultValue: Bool { get() { match (m_defaultValue) { case None => false case _ => true } } }
    public prop var defaultValue: String { get() { m_defaultValue.getOrThrow() } set(i_tmp) { m_defaultValue = i_tmp } }

    public func clearOneofIndex() { m_oneofIndex = None }
    public prop let hasOneofIndex: Bool { get() { match (m_oneofIndex) { case None => false case _ => true } } }
    public prop var oneofIndex: Int32 { get() { m_oneofIndex.getOrThrow() } set(i_tmp) { m_oneofIndex = i_tmp } }

    public func clearJsonName() { m_jsonName = None }
    public prop let hasJsonName: Bool { get() { match (m_jsonName) { case None => false case _ => true } } }
    public prop var jsonName: String { get() { m_jsonName.getOrThrow() } set(i_tmp) { m_jsonName = i_tmp } }

    public func clearOptions() { m_options = None }
    public prop let hasOptions: Bool { get() { match (m_options) { case None => false case _ => true } } }
    public prop var options: FieldOptions { get() { m_options.getOrThrow() } set(i_tmp) { m_options = i_tmp } }

    public func clearProto3Optional() { m_proto3Optional = None }
    public prop let hasProto3Optional: Bool { get() { match (m_proto3Optional) { case None => false case _ => true } } }
    public prop var proto3Optional: Bool { get() { m_proto3Optional.getOrThrow() } set(i_tmp) { m_proto3Optional = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_name) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_number) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = m_label) { i_tmp += 1 + varintSize(i_vtmp.value()) }
        if (let Some(i_vtmp) = m_type) { i_tmp += 1 + varintSize(i_vtmp.value()) }
        if (let Some(i_vtmp) = m_typeName) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_extendee) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_defaultValue) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_oneofIndex) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = m_jsonName) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_options) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_proto3Optional) { i_tmp += 2 + 1 }
        if (!mapEntry.isEmpty()) { for (i_itmp in mapEntry) { i_tmp += 3 + binSize(i_itmp) } }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_name) && isNone(m_number) && isNone(m_label) && isNone(m_type) && isNone(m_typeName) &&
        isNone(m_extendee) && isNone(m_defaultValue) && isNone(m_oneofIndex) && isNone(m_jsonName) &&
        isNone(m_options) && isNone(m_proto3Optional) && mapEntry.isEmpty() &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_name = None
        m_number = None
        m_label = None
        m_type = None
        m_typeName = None
        m_extendee = None
        m_defaultValue = None
        m_oneofIndex = None
        m_jsonName = None
        m_options = None
        m_proto3Optional = None
        mapEntry.clear()
        unknownFields.clear()
    }

    public func clone(): FieldDescriptorProto {
        let i_tmp = FieldDescriptorProto()
        i_tmp.m_name = m_name
        i_tmp.m_number = m_number
        i_tmp.m_label = m_label
        i_tmp.m_type = m_type
        i_tmp.m_typeName = m_typeName
        i_tmp.m_extendee = m_extendee
        i_tmp.m_defaultValue = m_defaultValue
        i_tmp.m_oneofIndex = m_oneofIndex
        i_tmp.m_jsonName = m_jsonName
        i_tmp.m_options = m_options?.clone()
        i_tmp.m_proto3Optional = m_proto3Optional
        i_tmp.mapEntry = ArrayList(mapEntry.size, { i => mapEntry[i].clone() })
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => m_name = src.parseString()
                case 3 => m_number = src.parseInt32()
                case 4 => m_label = FieldDescriptorProto_Label.parse(src.parseInt32())
                case 5 => m_type = FieldDescriptorProto_Type.parse(src.parseInt32())
                case 6 => m_typeName = src.parseString()
                case 2 => m_extendee = src.parseString()
                case 7 => m_defaultValue = src.parseString()
                case 9 => m_oneofIndex = src.parseInt32()
                case 10 => m_jsonName = src.parseString()
                case 8 => m_options = m_options ?? FieldOptions(); m_options?.unpack(subReader(src))
                case 17 => m_proto3Optional = src.parseBool()
                case 9999 => mapEntry.add().unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_name) { out.append(10); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_number) { out.append(24); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = m_label) { out.append(32); out.packVarint(i_vtmp.value()) }
        if (let Some(i_vtmp) = m_type) { out.append(40); out.packVarint(i_vtmp.value()) }
        if (let Some(i_vtmp) = m_typeName) { out.append(50); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_extendee) { out.append(18); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_defaultValue) { out.append(58); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_oneofIndex) { out.append(72); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = m_jsonName) { out.append(82); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_options) { out.append(66); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (let Some(i_vtmp) = m_proto3Optional) { out.packTag(17, VARINT); out.packBool(i_vtmp) }
        if (!mapEntry.isEmpty()) { for (i_itmp in mapEntry) { out.packTag(9999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_name) { i_tmp.append("name", i_vtmp) }
        if (let Some(i_vtmp) = m_number) { i_tmp.append("number", i_vtmp) }
        if (let Some(i_vtmp) = m_label) { i_tmp.append("label", i_vtmp) }
        if (let Some(i_vtmp) = m_type) { i_tmp.append("type", i_vtmp) }
        if (let Some(i_vtmp) = m_typeName) { i_tmp.append("typeName", i_vtmp) }
        if (let Some(i_vtmp) = m_extendee) { i_tmp.append("extendee", i_vtmp) }
        if (let Some(i_vtmp) = m_defaultValue) { i_tmp.append("defaultValue", i_vtmp) }
        if (let Some(i_vtmp) = m_oneofIndex) { i_tmp.append("oneofIndex", i_vtmp) }
        if (let Some(i_vtmp) = m_jsonName) { i_tmp.append("jsonName", i_vtmp) }
        if (let Some(i_vtmp) = m_options) { i_tmp.append("options", i_vtmp) }
        if (let Some(i_vtmp) = m_proto3Optional) { i_tmp.append("proto3Optional", i_vtmp) }
        if (!mapEntry.isEmpty()) { i_tmp.append("mapEntry", mapEntry) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { FieldDescriptorProto() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = FieldDescriptorProto(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = FieldDescriptorProto(); i_tmp.unpacki(src); i_tmp }
}

public class OneofDescriptorProto <: Message & TypedMessage<OneofDescriptorProto> {
    private var m_name: ?String = None
    private var m_options: ?OneofOptions = None
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearName() { m_name = None }
    public prop let hasName: Bool { get() { match (m_name) { case None => false case _ => true } } }
    public prop var name: String { get() { m_name.getOrThrow() } set(i_tmp) { m_name = i_tmp } }

    public func clearOptions() { m_options = None }
    public prop let hasOptions: Bool { get() { match (m_options) { case None => false case _ => true } } }
    public prop var options: OneofOptions { get() { m_options.getOrThrow() } set(i_tmp) { m_options = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_name) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_options) { i_tmp += 1 + binSize(i_vtmp) }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_name) && isNone(m_options) &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_name = None
        m_options = None
        unknownFields.clear()
    }

    public func clone(): OneofDescriptorProto {
        let i_tmp = OneofDescriptorProto()
        i_tmp.m_name = m_name
        i_tmp.m_options = m_options?.clone()
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => m_name = src.parseString()
                case 2 => m_options = m_options ?? OneofOptions(); m_options?.unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_name) { out.append(10); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_options) { out.append(18); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_name) { i_tmp.append("name", i_vtmp) }
        if (let Some(i_vtmp) = m_options) { i_tmp.append("options", i_vtmp) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { OneofDescriptorProto() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = OneofDescriptorProto(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = OneofDescriptorProto(); i_tmp.unpacki(src); i_tmp }
}

public class EnumDescriptorProto_EnumReservedRange <: Message & TypedMessage<EnumDescriptorProto_EnumReservedRange> {
    private var m_start: ?Int32 = None
    private var m_end: ?Int32 = None
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearStart() { m_start = None }
    public prop let hasStart: Bool { get() { match (m_start) { case None => false case _ => true } } }
    public prop var start: Int32 { get() { m_start.getOrThrow() } set(i_tmp) { m_start = i_tmp } }

    public func clearEnd() { m_end = None }
    public prop let hasEnd: Bool { get() { match (m_end) { case None => false case _ => true } } }
    public prop var end: Int32 { get() { m_end.getOrThrow() } set(i_tmp) { m_end = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_start) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = m_end) { i_tmp += 1 + varintSize(i_vtmp) }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_start) && isNone(m_end) &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_start = None
        m_end = None
        unknownFields.clear()
    }

    public func clone(): EnumDescriptorProto_EnumReservedRange {
        let i_tmp = EnumDescriptorProto_EnumReservedRange()
        i_tmp.m_start = m_start
        i_tmp.m_end = m_end
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => m_start = src.parseInt32()
                case 2 => m_end = src.parseInt32()
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_start) { out.append(8); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = m_end) { out.append(16); out.packVarint(i_vtmp) }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_start) { i_tmp.append("start", i_vtmp) }
        if (let Some(i_vtmp) = m_end) { i_tmp.append("end", i_vtmp) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { EnumDescriptorProto_EnumReservedRange() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = EnumDescriptorProto_EnumReservedRange(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = EnumDescriptorProto_EnumReservedRange(); i_tmp.unpacki(src); i_tmp }
}

public class EnumDescriptorProto <: Message & TypedMessage<EnumDescriptorProto> {
    private var m_name: ?String = None
    public var value = ArrayList<EnumValueDescriptorProto>()
    private var m_options: ?EnumOptions = None
    public var reservedRange = ArrayList<EnumDescriptorProto_EnumReservedRange>()
    public var reservedName = ArrayList<String>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearName() { m_name = None }
    public prop let hasName: Bool { get() { match (m_name) { case None => false case _ => true } } }
    public prop var name: String { get() { m_name.getOrThrow() } set(i_tmp) { m_name = i_tmp } }

    public func clearOptions() { m_options = None }
    public prop let hasOptions: Bool { get() { match (m_options) { case None => false case _ => true } } }
    public prop var options: EnumOptions { get() { m_options.getOrThrow() } set(i_tmp) { m_options = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_name) { i_tmp += 1 + binSize(i_vtmp) }
        if (!value.isEmpty()) { for (i_itmp in value) { i_tmp += 1 + binSize(i_itmp) } }
        if (let Some(i_vtmp) = m_options) { i_tmp += 1 + binSize(i_vtmp) }
        if (!reservedRange.isEmpty()) { for (i_itmp in reservedRange) { i_tmp += 1 + binSize(i_itmp) } }
        if (!reservedName.isEmpty()) { for (i_itmp in reservedName) { i_tmp += 1 + binSize(i_itmp) } }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_name) && value.isEmpty() && isNone(m_options) && reservedRange.isEmpty() && reservedName.isEmpty() &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_name = None
        value.clear()
        m_options = None
        reservedRange.clear()
        reservedName.clear()
        unknownFields.clear()
    }

    public func clone(): EnumDescriptorProto {
        let i_tmp = EnumDescriptorProto()
        i_tmp.m_name = m_name
        i_tmp.value = ArrayList(value.size, { i => value[i].clone() })
        i_tmp.m_options = m_options?.clone()
        i_tmp.reservedRange = ArrayList(reservedRange.size, { i => reservedRange[i].clone() })
        i_tmp.reservedName = reservedName.clone()
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => m_name = src.parseString()
                case 2 => value.add().unpack(subReader(src))
                case 3 => m_options = m_options ?? EnumOptions(); m_options?.unpack(subReader(src))
                case 4 => reservedRange.add().unpack(subReader(src))
                case 5 => reservedName.append(src.parseString())
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_name) { out.append(10); out.packBin(i_vtmp) }
        if (!value.isEmpty()) { for (i_itmp in value) { out.append(18); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (let Some(i_vtmp) = m_options) { out.append(26); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (!reservedRange.isEmpty()) { for (i_itmp in reservedRange) { out.append(34); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!reservedName.isEmpty()) { for (i_itmp in reservedName) { out.append(42); out.packBin(i_itmp) } }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_name) { i_tmp.append("name", i_vtmp) }
        if (!value.isEmpty()) { i_tmp.append("value", value) }
        if (let Some(i_vtmp) = m_options) { i_tmp.append("options", i_vtmp) }
        if (!reservedRange.isEmpty()) { i_tmp.append("reservedRange", reservedRange) }
        if (!reservedName.isEmpty()) { i_tmp.append("reservedName", reservedName) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { EnumDescriptorProto() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = EnumDescriptorProto(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = EnumDescriptorProto(); i_tmp.unpacki(src); i_tmp }
}

public class EnumValueDescriptorProto <: Message & TypedMessage<EnumValueDescriptorProto> {
    private var m_name: ?String = None
    private var m_number: ?Int32 = None
    private var m_options: ?EnumValueOptions = None
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearName() { m_name = None }
    public prop let hasName: Bool { get() { match (m_name) { case None => false case _ => true } } }
    public prop var name: String { get() { m_name.getOrThrow() } set(i_tmp) { m_name = i_tmp } }

    public func clearNumber() { m_number = None }
    public prop let hasNumber: Bool { get() { match (m_number) { case None => false case _ => true } } }
    public prop var number: Int32 { get() { m_number.getOrThrow() } set(i_tmp) { m_number = i_tmp } }

    public func clearOptions() { m_options = None }
    public prop let hasOptions: Bool { get() { match (m_options) { case None => false case _ => true } } }
    public prop var options: EnumValueOptions { get() { m_options.getOrThrow() } set(i_tmp) { m_options = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_name) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_number) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = m_options) { i_tmp += 1 + binSize(i_vtmp) }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_name) && isNone(m_number) && isNone(m_options) &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_name = None
        m_number = None
        m_options = None
        unknownFields.clear()
    }

    public func clone(): EnumValueDescriptorProto {
        let i_tmp = EnumValueDescriptorProto()
        i_tmp.m_name = m_name
        i_tmp.m_number = m_number
        i_tmp.m_options = m_options?.clone()
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => m_name = src.parseString()
                case 2 => m_number = src.parseInt32()
                case 3 => m_options = m_options ?? EnumValueOptions(); m_options?.unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_name) { out.append(10); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_number) { out.append(16); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = m_options) { out.append(26); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_name) { i_tmp.append("name", i_vtmp) }
        if (let Some(i_vtmp) = m_number) { i_tmp.append("number", i_vtmp) }
        if (let Some(i_vtmp) = m_options) { i_tmp.append("options", i_vtmp) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { EnumValueDescriptorProto() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = EnumValueDescriptorProto(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = EnumValueDescriptorProto(); i_tmp.unpacki(src); i_tmp }
}

public class ServiceDescriptorProto <: Message & TypedMessage<ServiceDescriptorProto> {
    private var m_name: ?String = None
    public var method = ArrayList<MethodDescriptorProto>()
    private var m_options: ?ServiceOptions = None
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearName() { m_name = None }
    public prop let hasName: Bool { get() { match (m_name) { case None => false case _ => true } } }
    public prop var name: String { get() { m_name.getOrThrow() } set(i_tmp) { m_name = i_tmp } }

    public func clearOptions() { m_options = None }
    public prop let hasOptions: Bool { get() { match (m_options) { case None => false case _ => true } } }
    public prop var options: ServiceOptions { get() { m_options.getOrThrow() } set(i_tmp) { m_options = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_name) { i_tmp += 1 + binSize(i_vtmp) }
        if (!method.isEmpty()) { for (i_itmp in method) { i_tmp += 1 + binSize(i_itmp) } }
        if (let Some(i_vtmp) = m_options) { i_tmp += 1 + binSize(i_vtmp) }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_name) && method.isEmpty() && isNone(m_options) &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_name = None
        method.clear()
        m_options = None
        unknownFields.clear()
    }

    public func clone(): ServiceDescriptorProto {
        let i_tmp = ServiceDescriptorProto()
        i_tmp.m_name = m_name
        i_tmp.method = ArrayList(method.size, { i => method[i].clone() })
        i_tmp.m_options = m_options?.clone()
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => m_name = src.parseString()
                case 2 => method.add().unpack(subReader(src))
                case 3 => m_options = m_options ?? ServiceOptions(); m_options?.unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_name) { out.append(10); out.packBin(i_vtmp) }
        if (!method.isEmpty()) { for (i_itmp in method) { out.append(18); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (let Some(i_vtmp) = m_options) { out.append(26); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_name) { i_tmp.append("name", i_vtmp) }
        if (!method.isEmpty()) { i_tmp.append("method", method) }
        if (let Some(i_vtmp) = m_options) { i_tmp.append("options", i_vtmp) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { ServiceDescriptorProto() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = ServiceDescriptorProto(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = ServiceDescriptorProto(); i_tmp.unpacki(src); i_tmp }
}

public class MethodDescriptorProto <: Message & TypedMessage<MethodDescriptorProto> {
    private var m_name: ?String = None
    private var m_inputType: ?String = None
    private var m_outputType: ?String = None
    private var m_options: ?MethodOptions = None
    private var m_clientStreaming: ?Bool = None
    private var m_serverStreaming: ?Bool = None
    private var m_funcName: ?String = None
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearName() { m_name = None }
    public prop let hasName: Bool { get() { match (m_name) { case None => false case _ => true } } }
    public prop var name: String { get() { m_name.getOrThrow() } set(i_tmp) { m_name = i_tmp } }

    public func clearInputType() { m_inputType = None }
    public prop let hasInputType: Bool { get() { match (m_inputType) { case None => false case _ => true } } }
    public prop var inputType: String { get() { m_inputType.getOrThrow() } set(i_tmp) { m_inputType = i_tmp } }

    public func clearOutputType() { m_outputType = None }
    public prop let hasOutputType: Bool { get() { match (m_outputType) { case None => false case _ => true } } }
    public prop var outputType: String { get() { m_outputType.getOrThrow() } set(i_tmp) { m_outputType = i_tmp } }

    public func clearOptions() { m_options = None }
    public prop let hasOptions: Bool { get() { match (m_options) { case None => false case _ => true } } }
    public prop var options: MethodOptions { get() { m_options.getOrThrow() } set(i_tmp) { m_options = i_tmp } }

    public func clearClientStreaming() { m_clientStreaming = None }
    public prop let hasClientStreaming: Bool { get() { match (m_clientStreaming) { case None => false case _ => true } } }
    public prop var clientStreaming: Bool { get() { m_clientStreaming ?? false } set(i_tmp) { m_clientStreaming = if (i_tmp == false) { None } else { i_tmp } } }

    public func clearServerStreaming() { m_serverStreaming = None }
    public prop let hasServerStreaming: Bool { get() { match (m_serverStreaming) { case None => false case _ => true } } }
    public prop var serverStreaming: Bool { get() { m_serverStreaming ?? false } set(i_tmp) { m_serverStreaming = if (i_tmp == false) { None } else { i_tmp } } }

    public func clearFuncName() { m_funcName = None }
    public prop let hasFuncName: Bool { get() { match (m_funcName) { case None => false case _ => true } } }
    public prop var funcName: String { get() { m_funcName.getOrThrow() } set(i_tmp) { m_funcName = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_name) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_inputType) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_outputType) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_options) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_clientStreaming) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = m_serverStreaming) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = m_funcName) { i_tmp += 3 + binSize(i_vtmp) }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_name) && isNone(m_inputType) && isNone(m_outputType) && isNone(m_options) &&
        isNone(m_clientStreaming) && isNone(m_serverStreaming) && isNone(m_funcName) &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_name = None
        m_inputType = None
        m_outputType = None
        m_options = None
        m_clientStreaming = None
        m_serverStreaming = None
        m_funcName = None
        unknownFields.clear()
    }

    public func clone(): MethodDescriptorProto {
        let i_tmp = MethodDescriptorProto()
        i_tmp.m_name = m_name
        i_tmp.m_inputType = m_inputType
        i_tmp.m_outputType = m_outputType
        i_tmp.m_options = m_options?.clone()
        i_tmp.m_clientStreaming = m_clientStreaming
        i_tmp.m_serverStreaming = m_serverStreaming
        i_tmp.m_funcName = m_funcName
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => m_name = src.parseString()
                case 2 => m_inputType = src.parseString()
                case 3 => m_outputType = src.parseString()
                case 4 => m_options = m_options ?? MethodOptions(); m_options?.unpack(subReader(src))
                case 5 => clientStreaming = src.parseBool()
                case 6 => serverStreaming = src.parseBool()
                case 9999 => m_funcName = src.parseString()
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_name) { out.append(10); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_inputType) { out.append(18); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_outputType) { out.append(26); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_options) { out.append(34); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (let Some(i_vtmp) = m_clientStreaming) { out.append(40); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_serverStreaming) { out.append(48); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_funcName) { out.packTag(9999, PREFIXED); out.packBin(i_vtmp) }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_name) { i_tmp.append("name", i_vtmp) }
        if (let Some(i_vtmp) = m_inputType) { i_tmp.append("inputType", i_vtmp) }
        if (let Some(i_vtmp) = m_outputType) { i_tmp.append("outputType", i_vtmp) }
        if (let Some(i_vtmp) = m_options) { i_tmp.append("options", i_vtmp) }
        if (let Some(i_vtmp) = m_clientStreaming) { i_tmp.append("clientStreaming", i_vtmp) }
        if (let Some(i_vtmp) = m_serverStreaming) { i_tmp.append("serverStreaming", i_vtmp) }
        if (let Some(i_vtmp) = m_funcName) { i_tmp.append("funcName", i_vtmp) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { MethodDescriptorProto() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = MethodDescriptorProto(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = MethodDescriptorProto(); i_tmp.unpacki(src); i_tmp }
}

public enum FileOptions_OptimizeMode <: Enum<FileOptions_OptimizeMode> {
    SPEED | CODE_SIZE | LITE_RUNTIME

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

    public operator func==(value: FileOptions_OptimizeMode) {
        match((this, value)) {
            case (SPEED, SPEED) => true
            case (CODE_SIZE, CODE_SIZE) => true
            case (LITE_RUNTIME, LITE_RUNTIME) => true
            case _ => false
        }
    }

    public static func parse(value: Int32): FileOptions_OptimizeMode {
        match(value) {
            case 1 => SPEED
            case 2 => CODE_SIZE
            case 3 => LITE_RUNTIME
            case _ => throw InvalidEnumValueException("FileOptions_OptimizeMode", value)
        }
    }

    public static func parse(value: String): FileOptions_OptimizeMode {
        match(value) {
            case "SPEED" => SPEED
            case "CODE_SIZE" => CODE_SIZE
            case "LITE_RUNTIME" => LITE_RUNTIME
            case _ => throw UnmatchedEnumStringException("FileOptions_OptimizeMode", value)
        }
    }
}

public class FileOptions <: Message & TypedMessage<FileOptions> {
    private var m_javaPackage: ?String = None
    private var m_javaOuterClassname: ?String = None
    private var m_javaMultipleFiles: ?Bool = None
    private var m_javaGenerateEqualsAndHash: ?Bool = None
    private var m_javaStringCheckUtf8: ?Bool = None
    private var m_optimizeFor: ?FileOptions_OptimizeMode = None
    private var m_goPackage: ?String = None
    private var m_ccGenericServices: ?Bool = None
    private var m_javaGenericServices: ?Bool = None
    private var m_pyGenericServices: ?Bool = None
    private var m_phpGenericServices: ?Bool = None
    private var m_deprecated: ?Bool = None
    private var m_ccEnableArenas: ?Bool = None
    private var m_objcClassPrefix: ?String = None
    private var m_csharpNamespace: ?String = None
    private var m_swiftPrefix: ?String = None
    private var m_phpClassPrefix: ?String = None
    private var m_phpNamespace: ?String = None
    private var m_phpMetadataNamespace: ?String = None
    private var m_rubyPackage: ?String = None
    public var uninterpretedOption = ArrayList<UninterpretedOption>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearJavaPackage() { m_javaPackage = None }
    public prop let hasJavaPackage: Bool { get() { match (m_javaPackage) { case None => false case _ => true } } }
    public prop var javaPackage: String { get() { m_javaPackage.getOrThrow() } set(i_tmp) { m_javaPackage = i_tmp } }

    public func clearJavaOuterClassname() { m_javaOuterClassname = None }
    public prop let hasJavaOuterClassname: Bool { get() { match (m_javaOuterClassname) { case None => false case _ => true } } }
    public prop var javaOuterClassname: String { get() { m_javaOuterClassname.getOrThrow() } set(i_tmp) { m_javaOuterClassname = i_tmp } }

    public func clearJavaMultipleFiles() { m_javaMultipleFiles = None }
    public prop let hasJavaMultipleFiles: Bool { get() { match (m_javaMultipleFiles) { case None => false case _ => true } } }
    public prop var javaMultipleFiles: Bool { get() { m_javaMultipleFiles ?? false } set(i_tmp) { m_javaMultipleFiles = if (i_tmp == false) { None } else { i_tmp } } }

    public func clearJavaGenerateEqualsAndHash() { m_javaGenerateEqualsAndHash = None }
    public prop let hasJavaGenerateEqualsAndHash: Bool { get() { match (m_javaGenerateEqualsAndHash) { case None => false case _ => true } } }
    public prop var javaGenerateEqualsAndHash: Bool { get() { m_javaGenerateEqualsAndHash.getOrThrow() } set(i_tmp) { m_javaGenerateEqualsAndHash = i_tmp } }

    public func clearJavaStringCheckUtf8() { m_javaStringCheckUtf8 = None }
    public prop let hasJavaStringCheckUtf8: Bool { get() { match (m_javaStringCheckUtf8) { case None => false case _ => true } } }
    public prop var javaStringCheckUtf8: Bool { get() { m_javaStringCheckUtf8 ?? false } set(i_tmp) { m_javaStringCheckUtf8 = if (i_tmp == false) { None } else { i_tmp } } }

    public func clearOptimizeFor() { m_optimizeFor = None }
    public prop let hasOptimizeFor: Bool { get() { match (m_optimizeFor) { case None => false case _ => true } } }
    public prop var optimizeFor: FileOptions_OptimizeMode { get() { m_optimizeFor ?? SPEED } set(i_tmp) { m_optimizeFor = if (i_tmp == SPEED) { None } else { i_tmp } } }

    public func clearGoPackage() { m_goPackage = None }
    public prop let hasGoPackage: Bool { get() { match (m_goPackage) { case None => false case _ => true } } }
    public prop var goPackage: String { get() { m_goPackage.getOrThrow() } set(i_tmp) { m_goPackage = i_tmp } }

    public func clearCcGenericServices() { m_ccGenericServices = None }
    public prop let hasCcGenericServices: Bool { get() { match (m_ccGenericServices) { case None => false case _ => true } } }
    public prop var ccGenericServices: Bool { get() { m_ccGenericServices ?? false } set(i_tmp) { m_ccGenericServices = if (i_tmp == false) { None } else { i_tmp } } }

    public func clearJavaGenericServices() { m_javaGenericServices = None }
    public prop let hasJavaGenericServices: Bool { get() { match (m_javaGenericServices) { case None => false case _ => true } } }
    public prop var javaGenericServices: Bool { get() { m_javaGenericServices ?? false } set(i_tmp) { m_javaGenericServices = if (i_tmp == false) { None } else { i_tmp } } }

    public func clearPyGenericServices() { m_pyGenericServices = None }
    public prop let hasPyGenericServices: Bool { get() { match (m_pyGenericServices) { case None => false case _ => true } } }
    public prop var pyGenericServices: Bool { get() { m_pyGenericServices ?? false } set(i_tmp) { m_pyGenericServices = if (i_tmp == false) { None } else { i_tmp } } }

    public func clearPhpGenericServices() { m_phpGenericServices = None }
    public prop let hasPhpGenericServices: Bool { get() { match (m_phpGenericServices) { case None => false case _ => true } } }
    public prop var phpGenericServices: Bool { get() { m_phpGenericServices ?? false } set(i_tmp) { m_phpGenericServices = if (i_tmp == false) { None } else { i_tmp } } }

    public func clearDeprecated() { m_deprecated = None }
    public prop let hasDeprecated: Bool { get() { match (m_deprecated) { case None => false case _ => true } } }
    public prop var deprecated: Bool { get() { m_deprecated ?? false } set(i_tmp) { m_deprecated = if (i_tmp == false) { None } else { i_tmp } } }

    public func clearCcEnableArenas() { m_ccEnableArenas = None }
    public prop let hasCcEnableArenas: Bool { get() { match (m_ccEnableArenas) { case None => false case _ => true } } }
    public prop var ccEnableArenas: Bool { get() { m_ccEnableArenas ?? true } set(i_tmp) { m_ccEnableArenas = if (i_tmp == true) { None } else { i_tmp } } }

    public func clearObjcClassPrefix() { m_objcClassPrefix = None }
    public prop let hasObjcClassPrefix: Bool { get() { match (m_objcClassPrefix) { case None => false case _ => true } } }
    public prop var objcClassPrefix: String { get() { m_objcClassPrefix.getOrThrow() } set(i_tmp) { m_objcClassPrefix = i_tmp } }

    public func clearCsharpNamespace() { m_csharpNamespace = None }
    public prop let hasCsharpNamespace: Bool { get() { match (m_csharpNamespace) { case None => false case _ => true } } }
    public prop var csharpNamespace: String { get() { m_csharpNamespace.getOrThrow() } set(i_tmp) { m_csharpNamespace = i_tmp } }

    public func clearSwiftPrefix() { m_swiftPrefix = None }
    public prop let hasSwiftPrefix: Bool { get() { match (m_swiftPrefix) { case None => false case _ => true } } }
    public prop var swiftPrefix: String { get() { m_swiftPrefix.getOrThrow() } set(i_tmp) { m_swiftPrefix = i_tmp } }

    public func clearPhpClassPrefix() { m_phpClassPrefix = None }
    public prop let hasPhpClassPrefix: Bool { get() { match (m_phpClassPrefix) { case None => false case _ => true } } }
    public prop var phpClassPrefix: String { get() { m_phpClassPrefix.getOrThrow() } set(i_tmp) { m_phpClassPrefix = i_tmp } }

    public func clearPhpNamespace() { m_phpNamespace = None }
    public prop let hasPhpNamespace: Bool { get() { match (m_phpNamespace) { case None => false case _ => true } } }
    public prop var phpNamespace: String { get() { m_phpNamespace.getOrThrow() } set(i_tmp) { m_phpNamespace = i_tmp } }

    public func clearPhpMetadataNamespace() { m_phpMetadataNamespace = None }
    public prop let hasPhpMetadataNamespace: Bool { get() { match (m_phpMetadataNamespace) { case None => false case _ => true } } }
    public prop var phpMetadataNamespace: String { get() { m_phpMetadataNamespace.getOrThrow() } set(i_tmp) { m_phpMetadataNamespace = i_tmp } }

    public func clearRubyPackage() { m_rubyPackage = None }
    public prop let hasRubyPackage: Bool { get() { match (m_rubyPackage) { case None => false case _ => true } } }
    public prop var rubyPackage: String { get() { m_rubyPackage.getOrThrow() } set(i_tmp) { m_rubyPackage = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_javaPackage) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_javaOuterClassname) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_javaMultipleFiles) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = m_javaGenerateEqualsAndHash) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = m_javaStringCheckUtf8) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = m_optimizeFor) { i_tmp += 1 + varintSize(i_vtmp.value()) }
        if (let Some(i_vtmp) = m_goPackage) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_ccGenericServices) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = m_javaGenericServices) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = m_pyGenericServices) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = m_phpGenericServices) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = m_deprecated) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = m_ccEnableArenas) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = m_objcClassPrefix) { i_tmp += 2 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_csharpNamespace) { i_tmp += 2 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_swiftPrefix) { i_tmp += 2 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_phpClassPrefix) { i_tmp += 2 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_phpNamespace) { i_tmp += 2 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_phpMetadataNamespace) { i_tmp += 2 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_rubyPackage) { i_tmp += 2 + binSize(i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_javaPackage) && isNone(m_javaOuterClassname) && isNone(m_javaMultipleFiles) &&
        isNone(m_javaGenerateEqualsAndHash) && isNone(m_javaStringCheckUtf8) && isNone(m_optimizeFor) &&
        isNone(m_goPackage) && isNone(m_ccGenericServices) && isNone(m_javaGenericServices) &&
        isNone(m_pyGenericServices) && isNone(m_phpGenericServices) && isNone(m_deprecated) &&
        isNone(m_ccEnableArenas) && isNone(m_objcClassPrefix) && isNone(m_csharpNamespace) && isNone(m_swiftPrefix) &&
        isNone(m_phpClassPrefix) && isNone(m_phpNamespace) && isNone(m_phpMetadataNamespace) && isNone(m_rubyPackage) &&
        uninterpretedOption.isEmpty() &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_javaPackage = None
        m_javaOuterClassname = None
        m_javaMultipleFiles = None
        m_javaGenerateEqualsAndHash = None
        m_javaStringCheckUtf8 = None
        m_optimizeFor = None
        m_goPackage = None
        m_ccGenericServices = None
        m_javaGenericServices = None
        m_pyGenericServices = None
        m_phpGenericServices = None
        m_deprecated = None
        m_ccEnableArenas = None
        m_objcClassPrefix = None
        m_csharpNamespace = None
        m_swiftPrefix = None
        m_phpClassPrefix = None
        m_phpNamespace = None
        m_phpMetadataNamespace = None
        m_rubyPackage = None
        uninterpretedOption.clear()
        unknownFields.clear()
    }

    public func clone(): FileOptions {
        let i_tmp = FileOptions()
        i_tmp.m_javaPackage = m_javaPackage
        i_tmp.m_javaOuterClassname = m_javaOuterClassname
        i_tmp.m_javaMultipleFiles = m_javaMultipleFiles
        i_tmp.m_javaGenerateEqualsAndHash = m_javaGenerateEqualsAndHash
        i_tmp.m_javaStringCheckUtf8 = m_javaStringCheckUtf8
        i_tmp.m_optimizeFor = m_optimizeFor
        i_tmp.m_goPackage = m_goPackage
        i_tmp.m_ccGenericServices = m_ccGenericServices
        i_tmp.m_javaGenericServices = m_javaGenericServices
        i_tmp.m_pyGenericServices = m_pyGenericServices
        i_tmp.m_phpGenericServices = m_phpGenericServices
        i_tmp.m_deprecated = m_deprecated
        i_tmp.m_ccEnableArenas = m_ccEnableArenas
        i_tmp.m_objcClassPrefix = m_objcClassPrefix
        i_tmp.m_csharpNamespace = m_csharpNamespace
        i_tmp.m_swiftPrefix = m_swiftPrefix
        i_tmp.m_phpClassPrefix = m_phpClassPrefix
        i_tmp.m_phpNamespace = m_phpNamespace
        i_tmp.m_phpMetadataNamespace = m_phpMetadataNamespace
        i_tmp.m_rubyPackage = m_rubyPackage
        i_tmp.uninterpretedOption = ArrayList(uninterpretedOption.size, { i => uninterpretedOption[i].clone() })
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => m_javaPackage = src.parseString()
                case 8 => m_javaOuterClassname = src.parseString()
                case 10 => javaMultipleFiles = src.parseBool()
                case 20 => m_javaGenerateEqualsAndHash = src.parseBool()
                case 27 => javaStringCheckUtf8 = src.parseBool()
                case 9 => optimizeFor = FileOptions_OptimizeMode.parse(src.parseInt32())
                case 11 => m_goPackage = src.parseString()
                case 16 => ccGenericServices = src.parseBool()
                case 17 => javaGenericServices = src.parseBool()
                case 18 => pyGenericServices = src.parseBool()
                case 42 => phpGenericServices = src.parseBool()
                case 23 => deprecated = src.parseBool()
                case 31 => ccEnableArenas = src.parseBool()
                case 36 => m_objcClassPrefix = src.parseString()
                case 37 => m_csharpNamespace = src.parseString()
                case 39 => m_swiftPrefix = src.parseString()
                case 40 => m_phpClassPrefix = src.parseString()
                case 41 => m_phpNamespace = src.parseString()
                case 44 => m_phpMetadataNamespace = src.parseString()
                case 45 => m_rubyPackage = src.parseString()
                case 999 => uninterpretedOption.add().unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_javaPackage) { out.append(10); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_javaOuterClassname) { out.append(66); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_javaMultipleFiles) { out.append(80); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_javaGenerateEqualsAndHash) { out.packTag(20, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_javaStringCheckUtf8) { out.packTag(27, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_optimizeFor) { out.append(72); out.packVarint(i_vtmp.value()) }
        if (let Some(i_vtmp) = m_goPackage) { out.append(90); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_ccGenericServices) { out.packTag(16, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_javaGenericServices) { out.packTag(17, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_pyGenericServices) { out.packTag(18, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_phpGenericServices) { out.packTag(42, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_deprecated) { out.packTag(23, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_ccEnableArenas) { out.packTag(31, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_objcClassPrefix) { out.packTag(36, PREFIXED); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_csharpNamespace) { out.packTag(37, PREFIXED); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_swiftPrefix) { out.packTag(39, PREFIXED); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_phpClassPrefix) { out.packTag(40, PREFIXED); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_phpNamespace) { out.packTag(41, PREFIXED); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_phpMetadataNamespace) { out.packTag(44, PREFIXED); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_rubyPackage) { out.packTag(45, PREFIXED); out.packBin(i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_javaPackage) { i_tmp.append("javaPackage", i_vtmp) }
        if (let Some(i_vtmp) = m_javaOuterClassname) { i_tmp.append("javaOuterClassname", i_vtmp) }
        if (let Some(i_vtmp) = m_javaMultipleFiles) { i_tmp.append("javaMultipleFiles", i_vtmp) }
        if (let Some(i_vtmp) = m_javaGenerateEqualsAndHash) { i_tmp.append("javaGenerateEqualsAndHash", i_vtmp) }
        if (let Some(i_vtmp) = m_javaStringCheckUtf8) { i_tmp.append("javaStringCheckUtf8", i_vtmp) }
        if (let Some(i_vtmp) = m_optimizeFor) { i_tmp.append("optimizeFor", i_vtmp) }
        if (let Some(i_vtmp) = m_goPackage) { i_tmp.append("goPackage", i_vtmp) }
        if (let Some(i_vtmp) = m_ccGenericServices) { i_tmp.append("ccGenericServices", i_vtmp) }
        if (let Some(i_vtmp) = m_javaGenericServices) { i_tmp.append("javaGenericServices", i_vtmp) }
        if (let Some(i_vtmp) = m_pyGenericServices) { i_tmp.append("pyGenericServices", i_vtmp) }
        if (let Some(i_vtmp) = m_phpGenericServices) { i_tmp.append("phpGenericServices", i_vtmp) }
        if (let Some(i_vtmp) = m_deprecated) { i_tmp.append("deprecated", i_vtmp) }
        if (let Some(i_vtmp) = m_ccEnableArenas) { i_tmp.append("ccEnableArenas", i_vtmp) }
        if (let Some(i_vtmp) = m_objcClassPrefix) { i_tmp.append("objcClassPrefix", i_vtmp) }
        if (let Some(i_vtmp) = m_csharpNamespace) { i_tmp.append("csharpNamespace", i_vtmp) }
        if (let Some(i_vtmp) = m_swiftPrefix) { i_tmp.append("swiftPrefix", i_vtmp) }
        if (let Some(i_vtmp) = m_phpClassPrefix) { i_tmp.append("phpClassPrefix", i_vtmp) }
        if (let Some(i_vtmp) = m_phpNamespace) { i_tmp.append("phpNamespace", i_vtmp) }
        if (let Some(i_vtmp) = m_phpMetadataNamespace) { i_tmp.append("phpMetadataNamespace", i_vtmp) }
        if (let Some(i_vtmp) = m_rubyPackage) { i_tmp.append("rubyPackage", i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { FileOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = FileOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = FileOptions(); i_tmp.unpacki(src); i_tmp }
}

public class MessageOptions <: Message & TypedMessage<MessageOptions> {
    private var m_messageSetWireFormat: ?Bool = None
    private var m_noStandardDescriptorAccessor: ?Bool = None
    private var m_deprecated: ?Bool = None
    private var m_mapEntry: ?Bool = None
    public var uninterpretedOption = ArrayList<UninterpretedOption>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearMessageSetWireFormat() { m_messageSetWireFormat = None }
    public prop let hasMessageSetWireFormat: Bool { get() { match (m_messageSetWireFormat) { case None => false case _ => true } } }
    public prop var messageSetWireFormat: Bool { get() { m_messageSetWireFormat ?? false } set(i_tmp) { m_messageSetWireFormat = if (i_tmp == false) { None } else { i_tmp } } }

    public func clearNoStandardDescriptorAccessor() { m_noStandardDescriptorAccessor = None }
    public prop let hasNoStandardDescriptorAccessor: Bool { get() { match (m_noStandardDescriptorAccessor) { case None => false case _ => true } } }
    public prop var noStandardDescriptorAccessor: Bool { get() { m_noStandardDescriptorAccessor ?? false } set(i_tmp) { m_noStandardDescriptorAccessor = if (i_tmp == false) { None } else { i_tmp } } }

    public func clearDeprecated() { m_deprecated = None }
    public prop let hasDeprecated: Bool { get() { match (m_deprecated) { case None => false case _ => true } } }
    public prop var deprecated: Bool { get() { m_deprecated ?? false } set(i_tmp) { m_deprecated = if (i_tmp == false) { None } else { i_tmp } } }

    public func clearMapEntry() { m_mapEntry = None }
    public prop let hasMapEntry: Bool { get() { match (m_mapEntry) { case None => false case _ => true } } }
    public prop var mapEntry: Bool { get() { m_mapEntry.getOrThrow() } set(i_tmp) { m_mapEntry = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_messageSetWireFormat) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = m_noStandardDescriptorAccessor) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = m_deprecated) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = m_mapEntry) { i_tmp += 1 + 1 }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_messageSetWireFormat) && isNone(m_noStandardDescriptorAccessor) && isNone(m_deprecated) &&
        isNone(m_mapEntry) && uninterpretedOption.isEmpty() &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_messageSetWireFormat = None
        m_noStandardDescriptorAccessor = None
        m_deprecated = None
        m_mapEntry = None
        uninterpretedOption.clear()
        unknownFields.clear()
    }

    public func clone(): MessageOptions {
        let i_tmp = MessageOptions()
        i_tmp.m_messageSetWireFormat = m_messageSetWireFormat
        i_tmp.m_noStandardDescriptorAccessor = m_noStandardDescriptorAccessor
        i_tmp.m_deprecated = m_deprecated
        i_tmp.m_mapEntry = m_mapEntry
        i_tmp.uninterpretedOption = ArrayList(uninterpretedOption.size, { i => uninterpretedOption[i].clone() })
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => messageSetWireFormat = src.parseBool()
                case 2 => noStandardDescriptorAccessor = src.parseBool()
                case 3 => deprecated = src.parseBool()
                case 7 => m_mapEntry = src.parseBool()
                case 999 => uninterpretedOption.add().unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_messageSetWireFormat) { out.append(8); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_noStandardDescriptorAccessor) { out.append(16); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_deprecated) { out.append(24); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_mapEntry) { out.append(56); out.packBool(i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_messageSetWireFormat) { i_tmp.append("messageSetWireFormat", i_vtmp) }
        if (let Some(i_vtmp) = m_noStandardDescriptorAccessor) { i_tmp.append("noStandardDescriptorAccessor", i_vtmp) }
        if (let Some(i_vtmp) = m_deprecated) { i_tmp.append("deprecated", i_vtmp) }
        if (let Some(i_vtmp) = m_mapEntry) { i_tmp.append("mapEntry", i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { MessageOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = MessageOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = MessageOptions(); i_tmp.unpacki(src); i_tmp }
}

public enum FieldOptions_CType <: Enum<FieldOptions_CType> {
    STRING | CORD | STRING_PIECE

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

    public operator func==(value: FieldOptions_CType) {
        match((this, value)) {
            case (STRING, STRING) => true
            case (CORD, CORD) => true
            case (STRING_PIECE, STRING_PIECE) => true
            case _ => false
        }
    }

    public static func parse(value: Int32): FieldOptions_CType {
        match(value) {
            case 0 => STRING
            case 1 => CORD
            case 2 => STRING_PIECE
            case _ => throw InvalidEnumValueException("FieldOptions_CType", value)
        }
    }

    public static func parse(value: String): FieldOptions_CType {
        match(value) {
            case "STRING" => STRING
            case "CORD" => CORD
            case "STRING_PIECE" => STRING_PIECE
            case _ => throw UnmatchedEnumStringException("FieldOptions_CType", value)
        }
    }
}

public enum FieldOptions_JSType <: Enum<FieldOptions_JSType> {
    JS_NORMAL | JS_STRING | JS_NUMBER

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

    public operator func==(value: FieldOptions_JSType) {
        match((this, value)) {
            case (JS_NORMAL, JS_NORMAL) => true
            case (JS_STRING, JS_STRING) => true
            case (JS_NUMBER, JS_NUMBER) => true
            case _ => false
        }
    }

    public static func parse(value: Int32): FieldOptions_JSType {
        match(value) {
            case 0 => JS_NORMAL
            case 1 => JS_STRING
            case 2 => JS_NUMBER
            case _ => throw InvalidEnumValueException("FieldOptions_JSType", value)
        }
    }

    public static func parse(value: String): FieldOptions_JSType {
        match(value) {
            case "JS_NORMAL" => JS_NORMAL
            case "JS_STRING" => JS_STRING
            case "JS_NUMBER" => JS_NUMBER
            case _ => throw UnmatchedEnumStringException("FieldOptions_JSType", value)
        }
    }
}

public class FieldOptions <: Message & TypedMessage<FieldOptions> {
    private var m_ctype: ?FieldOptions_CType = None
    private var m_packed: ?Bool = None
    private var m_jstype: ?FieldOptions_JSType = None
    private var m_lazy: ?Bool = None
    private var m_unverifiedLazy: ?Bool = None
    private var m_deprecated: ?Bool = None
    private var m_weak: ?Bool = None
    public var uninterpretedOption = ArrayList<UninterpretedOption>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearCtype() { m_ctype = None }
    public prop let hasCtype: Bool { get() { match (m_ctype) { case None => false case _ => true } } }
    public prop var ctype: FieldOptions_CType { get() { m_ctype ?? STRING } set(i_tmp) { m_ctype = if (i_tmp == STRING) { None } else { i_tmp } } }

    public func clearPacked() { m_packed = None }
    public prop let hasPacked: Bool { get() { match (m_packed) { case None => false case _ => true } } }
    public prop var packed: Bool { get() { m_packed.getOrThrow() } set(i_tmp) { m_packed = i_tmp } }

    public func clearJstype() { m_jstype = None }
    public prop let hasJstype: Bool { get() { match (m_jstype) { case None => false case _ => true } } }
    public prop var jstype: FieldOptions_JSType { get() { m_jstype ?? JS_NORMAL } set(i_tmp) { m_jstype = if (i_tmp == JS_NORMAL) { None } else { i_tmp } } }

    public func clearLazy() { m_lazy = None }
    public prop let hasLazy: Bool { get() { match (m_lazy) { case None => false case _ => true } } }
    public prop var lazy: Bool { get() { m_lazy ?? false } set(i_tmp) { m_lazy = if (i_tmp == false) { None } else { i_tmp } } }

    public func clearUnverifiedLazy() { m_unverifiedLazy = None }
    public prop let hasUnverifiedLazy: Bool { get() { match (m_unverifiedLazy) { case None => false case _ => true } } }
    public prop var unverifiedLazy: Bool { get() { m_unverifiedLazy ?? false } set(i_tmp) { m_unverifiedLazy = if (i_tmp == false) { None } else { i_tmp } } }

    public func clearDeprecated() { m_deprecated = None }
    public prop let hasDeprecated: Bool { get() { match (m_deprecated) { case None => false case _ => true } } }
    public prop var deprecated: Bool { get() { m_deprecated ?? false } set(i_tmp) { m_deprecated = if (i_tmp == false) { None } else { i_tmp } } }

    public func clearWeak() { m_weak = None }
    public prop let hasWeak: Bool { get() { match (m_weak) { case None => false case _ => true } } }
    public prop var weak: Bool { get() { m_weak ?? false } set(i_tmp) { m_weak = if (i_tmp == false) { None } else { i_tmp } } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_ctype) { i_tmp += 1 + varintSize(i_vtmp.value()) }
        if (let Some(i_vtmp) = m_packed) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = m_jstype) { i_tmp += 1 + varintSize(i_vtmp.value()) }
        if (let Some(i_vtmp) = m_lazy) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = m_unverifiedLazy) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = m_deprecated) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = m_weak) { i_tmp += 1 + 1 }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_ctype) && isNone(m_packed) && isNone(m_jstype) && isNone(m_lazy) && isNone(m_unverifiedLazy) &&
        isNone(m_deprecated) && isNone(m_weak) && uninterpretedOption.isEmpty() &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_ctype = None
        m_packed = None
        m_jstype = None
        m_lazy = None
        m_unverifiedLazy = None
        m_deprecated = None
        m_weak = None
        uninterpretedOption.clear()
        unknownFields.clear()
    }

    public func clone(): FieldOptions {
        let i_tmp = FieldOptions()
        i_tmp.m_ctype = m_ctype
        i_tmp.m_packed = m_packed
        i_tmp.m_jstype = m_jstype
        i_tmp.m_lazy = m_lazy
        i_tmp.m_unverifiedLazy = m_unverifiedLazy
        i_tmp.m_deprecated = m_deprecated
        i_tmp.m_weak = m_weak
        i_tmp.uninterpretedOption = ArrayList(uninterpretedOption.size, { i => uninterpretedOption[i].clone() })
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => ctype = FieldOptions_CType.parse(src.parseInt32())
                case 2 => m_packed = src.parseBool()
                case 6 => jstype = FieldOptions_JSType.parse(src.parseInt32())
                case 5 => lazy = src.parseBool()
                case 15 => unverifiedLazy = src.parseBool()
                case 3 => deprecated = src.parseBool()
                case 10 => weak = src.parseBool()
                case 999 => uninterpretedOption.add().unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_ctype) { out.append(8); out.packVarint(i_vtmp.value()) }
        if (let Some(i_vtmp) = m_packed) { out.append(16); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_jstype) { out.append(48); out.packVarint(i_vtmp.value()) }
        if (let Some(i_vtmp) = m_lazy) { out.append(40); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_unverifiedLazy) { out.append(120); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_deprecated) { out.append(24); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_weak) { out.append(80); out.packBool(i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_ctype) { i_tmp.append("ctype", i_vtmp) }
        if (let Some(i_vtmp) = m_packed) { i_tmp.append("packed", i_vtmp) }
        if (let Some(i_vtmp) = m_jstype) { i_tmp.append("jstype", i_vtmp) }
        if (let Some(i_vtmp) = m_lazy) { i_tmp.append("lazy", i_vtmp) }
        if (let Some(i_vtmp) = m_unverifiedLazy) { i_tmp.append("unverifiedLazy", i_vtmp) }
        if (let Some(i_vtmp) = m_deprecated) { i_tmp.append("deprecated", i_vtmp) }
        if (let Some(i_vtmp) = m_weak) { i_tmp.append("weak", i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { FieldOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = FieldOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = FieldOptions(); i_tmp.unpacki(src); i_tmp }
}

public class OneofOptions <: Message & TypedMessage<OneofOptions> {
    public var uninterpretedOption = ArrayList<UninterpretedOption>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        uninterpretedOption.isEmpty() &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        uninterpretedOption.clear()
        unknownFields.clear()
    }

    public func clone(): OneofOptions {
        let i_tmp = OneofOptions()
        i_tmp.uninterpretedOption = ArrayList(uninterpretedOption.size, { i => uninterpretedOption[i].clone() })
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 999 => uninterpretedOption.add().unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { OneofOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = OneofOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = OneofOptions(); i_tmp.unpacki(src); i_tmp }
}

public class EnumOptions <: Message & TypedMessage<EnumOptions> {
    private var m_allowAlias: ?Bool = None
    private var m_deprecated: ?Bool = None
    public var uninterpretedOption = ArrayList<UninterpretedOption>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearAllowAlias() { m_allowAlias = None }
    public prop let hasAllowAlias: Bool { get() { match (m_allowAlias) { case None => false case _ => true } } }
    public prop var allowAlias: Bool { get() { m_allowAlias.getOrThrow() } set(i_tmp) { m_allowAlias = i_tmp } }

    public func clearDeprecated() { m_deprecated = None }
    public prop let hasDeprecated: Bool { get() { match (m_deprecated) { case None => false case _ => true } } }
    public prop var deprecated: Bool { get() { m_deprecated ?? false } set(i_tmp) { m_deprecated = if (i_tmp == false) { None } else { i_tmp } } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_allowAlias) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = m_deprecated) { i_tmp += 1 + 1 }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_allowAlias) && isNone(m_deprecated) && uninterpretedOption.isEmpty() &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_allowAlias = None
        m_deprecated = None
        uninterpretedOption.clear()
        unknownFields.clear()
    }

    public func clone(): EnumOptions {
        let i_tmp = EnumOptions()
        i_tmp.m_allowAlias = m_allowAlias
        i_tmp.m_deprecated = m_deprecated
        i_tmp.uninterpretedOption = ArrayList(uninterpretedOption.size, { i => uninterpretedOption[i].clone() })
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 2 => m_allowAlias = src.parseBool()
                case 3 => deprecated = src.parseBool()
                case 999 => uninterpretedOption.add().unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_allowAlias) { out.append(16); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_deprecated) { out.append(24); out.packBool(i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_allowAlias) { i_tmp.append("allowAlias", i_vtmp) }
        if (let Some(i_vtmp) = m_deprecated) { i_tmp.append("deprecated", i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { EnumOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = EnumOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = EnumOptions(); i_tmp.unpacki(src); i_tmp }
}

public class EnumValueOptions <: Message & TypedMessage<EnumValueOptions> {
    private var m_deprecated: ?Bool = None
    public var uninterpretedOption = ArrayList<UninterpretedOption>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearDeprecated() { m_deprecated = None }
    public prop let hasDeprecated: Bool { get() { match (m_deprecated) { case None => false case _ => true } } }
    public prop var deprecated: Bool { get() { m_deprecated ?? false } set(i_tmp) { m_deprecated = if (i_tmp == false) { None } else { i_tmp } } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_deprecated) { i_tmp += 1 + 1 }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_deprecated) && uninterpretedOption.isEmpty() &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_deprecated = None
        uninterpretedOption.clear()
        unknownFields.clear()
    }

    public func clone(): EnumValueOptions {
        let i_tmp = EnumValueOptions()
        i_tmp.m_deprecated = m_deprecated
        i_tmp.uninterpretedOption = ArrayList(uninterpretedOption.size, { i => uninterpretedOption[i].clone() })
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => deprecated = src.parseBool()
                case 999 => uninterpretedOption.add().unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_deprecated) { out.append(8); out.packBool(i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_deprecated) { i_tmp.append("deprecated", i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { EnumValueOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = EnumValueOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = EnumValueOptions(); i_tmp.unpacki(src); i_tmp }
}

public class ServiceOptions <: Message & TypedMessage<ServiceOptions> {
    private var m_deprecated: ?Bool = None
    public var uninterpretedOption = ArrayList<UninterpretedOption>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearDeprecated() { m_deprecated = None }
    public prop let hasDeprecated: Bool { get() { match (m_deprecated) { case None => false case _ => true } } }
    public prop var deprecated: Bool { get() { m_deprecated ?? false } set(i_tmp) { m_deprecated = if (i_tmp == false) { None } else { i_tmp } } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_deprecated) { i_tmp += 2 + 1 }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_deprecated) && uninterpretedOption.isEmpty() &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_deprecated = None
        uninterpretedOption.clear()
        unknownFields.clear()
    }

    public func clone(): ServiceOptions {
        let i_tmp = ServiceOptions()
        i_tmp.m_deprecated = m_deprecated
        i_tmp.uninterpretedOption = ArrayList(uninterpretedOption.size, { i => uninterpretedOption[i].clone() })
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 33 => deprecated = src.parseBool()
                case 999 => uninterpretedOption.add().unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_deprecated) { out.packTag(33, VARINT); out.packBool(i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_deprecated) { i_tmp.append("deprecated", i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { ServiceOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = ServiceOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = ServiceOptions(); i_tmp.unpacki(src); i_tmp }
}

public enum MethodOptions_IdempotencyLevel <: Enum<MethodOptions_IdempotencyLevel> {
    IDEMPOTENCY_UNKNOWN | NO_SIDE_EFFECTS | IDEMPOTENT

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

    public operator func==(value: MethodOptions_IdempotencyLevel) {
        match((this, value)) {
            case (IDEMPOTENCY_UNKNOWN, IDEMPOTENCY_UNKNOWN) => true
            case (NO_SIDE_EFFECTS, NO_SIDE_EFFECTS) => true
            case (IDEMPOTENT, IDEMPOTENT) => true
            case _ => false
        }
    }

    public static func parse(value: Int32): MethodOptions_IdempotencyLevel {
        match(value) {
            case 0 => IDEMPOTENCY_UNKNOWN
            case 1 => NO_SIDE_EFFECTS
            case 2 => IDEMPOTENT
            case _ => throw InvalidEnumValueException("MethodOptions_IdempotencyLevel", value)
        }
    }

    public static func parse(value: String): MethodOptions_IdempotencyLevel {
        match(value) {
            case "IDEMPOTENCY_UNKNOWN" => IDEMPOTENCY_UNKNOWN
            case "NO_SIDE_EFFECTS" => NO_SIDE_EFFECTS
            case "IDEMPOTENT" => IDEMPOTENT
            case _ => throw UnmatchedEnumStringException("MethodOptions_IdempotencyLevel", value)
        }
    }
}

public class MethodOptions <: Message & TypedMessage<MethodOptions> {
    private var m_deprecated: ?Bool = None
    private var m_idempotencyLevel: ?MethodOptions_IdempotencyLevel = None
    public var uninterpretedOption = ArrayList<UninterpretedOption>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearDeprecated() { m_deprecated = None }
    public prop let hasDeprecated: Bool { get() { match (m_deprecated) { case None => false case _ => true } } }
    public prop var deprecated: Bool { get() { m_deprecated ?? false } set(i_tmp) { m_deprecated = if (i_tmp == false) { None } else { i_tmp } } }

    public func clearIdempotencyLevel() { m_idempotencyLevel = None }
    public prop let hasIdempotencyLevel: Bool { get() { match (m_idempotencyLevel) { case None => false case _ => true } } }
    public prop var idempotencyLevel: MethodOptions_IdempotencyLevel { get() { m_idempotencyLevel ?? IDEMPOTENCY_UNKNOWN } set(i_tmp) { m_idempotencyLevel = if (i_tmp == IDEMPOTENCY_UNKNOWN) { None } else { i_tmp } } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_deprecated) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = m_idempotencyLevel) { i_tmp += 2 + varintSize(i_vtmp.value()) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_deprecated) && isNone(m_idempotencyLevel) && uninterpretedOption.isEmpty() &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_deprecated = None
        m_idempotencyLevel = None
        uninterpretedOption.clear()
        unknownFields.clear()
    }

    public func clone(): MethodOptions {
        let i_tmp = MethodOptions()
        i_tmp.m_deprecated = m_deprecated
        i_tmp.m_idempotencyLevel = m_idempotencyLevel
        i_tmp.uninterpretedOption = ArrayList(uninterpretedOption.size, { i => uninterpretedOption[i].clone() })
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 33 => deprecated = src.parseBool()
                case 34 => idempotencyLevel = MethodOptions_IdempotencyLevel.parse(src.parseInt32())
                case 999 => uninterpretedOption.add().unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_deprecated) { out.packTag(33, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = m_idempotencyLevel) { out.packTag(34, VARINT); out.packVarint(i_vtmp.value()) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_deprecated) { i_tmp.append("deprecated", i_vtmp) }
        if (let Some(i_vtmp) = m_idempotencyLevel) { i_tmp.append("idempotencyLevel", i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { MethodOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = MethodOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = MethodOptions(); i_tmp.unpacki(src); i_tmp }
}

public class UninterpretedOption_NamePart <: Message & TypedMessage<UninterpretedOption_NamePart> {
    private var m_namePart: ?String = None
    private var m_isExtension: ?Bool = None
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearNamePart() { m_namePart = None }
    public prop let hasNamePart: Bool { get() { match (m_namePart) { case None => false case _ => true } } }
    public prop var namePart: String { get() { m_namePart.getOrThrow() } set(i_tmp) { m_namePart = i_tmp } }

    public func clearIsExtension() { m_isExtension = None }
    public prop let hasIsExtension: Bool { get() { match (m_isExtension) { case None => false case _ => true } } }
    public prop var isExtension: Bool { get() { m_isExtension.getOrThrow() } set(i_tmp) { m_isExtension = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (let Some(i_vtmp) = m_namePart) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_isExtension) { i_tmp += 1 + 1 }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        isNone(m_namePart) && isNone(m_isExtension) &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        m_namePart = None
        m_isExtension = None
        unknownFields.clear()
    }

    public func clone(): UninterpretedOption_NamePart {
        let i_tmp = UninterpretedOption_NamePart()
        i_tmp.m_namePart = m_namePart
        i_tmp.m_isExtension = m_isExtension
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => m_namePart = src.parseString()
                case 2 => m_isExtension = src.parseBool()
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = m_namePart) { out.append(10); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_isExtension) { out.append(16); out.packBool(i_vtmp) }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
        match (m_namePart) { case None => throw RequiredFieldNotSetException("namePart") case _ => () }
        match (m_isExtension) { case None => throw RequiredFieldNotSetException("isExtension") case _ => () }
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = m_namePart) { i_tmp.append("namePart", i_vtmp) }
        if (let Some(i_vtmp) = m_isExtension) { i_tmp.append("isExtension", i_vtmp) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { UninterpretedOption_NamePart() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = UninterpretedOption_NamePart(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = UninterpretedOption_NamePart(); i_tmp.unpacki(src); i_tmp }
}

public class UninterpretedOption <: Message & TypedMessage<UninterpretedOption> {
    public var name = ArrayList<UninterpretedOption_NamePart>()
    private var m_identifierValue: ?String = None
    private var m_positiveIntValue: ?UInt64 = None
    private var m_negativeIntValue: ?Int64 = None
    private var m_doubleValue: ?Float64 = None
    private var m_stringValue: ?Bytes = None
    private var m_aggregateValue: ?String = None
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearIdentifierValue() { m_identifierValue = None }
    public prop let hasIdentifierValue: Bool { get() { match (m_identifierValue) { case None => false case _ => true } } }
    public prop var identifierValue: String { get() { m_identifierValue.getOrThrow() } set(i_tmp) { m_identifierValue = i_tmp } }

    public func clearPositiveIntValue() { m_positiveIntValue = None }
    public prop let hasPositiveIntValue: Bool { get() { match (m_positiveIntValue) { case None => false case _ => true } } }
    public prop var positiveIntValue: UInt64 { get() { m_positiveIntValue.getOrThrow() } set(i_tmp) { m_positiveIntValue = i_tmp } }

    public func clearNegativeIntValue() { m_negativeIntValue = None }
    public prop let hasNegativeIntValue: Bool { get() { match (m_negativeIntValue) { case None => false case _ => true } } }
    public prop var negativeIntValue: Int64 { get() { m_negativeIntValue.getOrThrow() } set(i_tmp) { m_negativeIntValue = i_tmp } }

    public func clearDoubleValue() { m_doubleValue = None }
    public prop let hasDoubleValue: Bool { get() { match (m_doubleValue) { case None => false case _ => true } } }
    public prop var doubleValue: Float64 { get() { m_doubleValue.getOrThrow() } set(i_tmp) { m_doubleValue = i_tmp } }

    public func clearStringValue() { m_stringValue = None }
    public prop let hasStringValue: Bool { get() { match (m_stringValue) { case None => false case _ => true } } }
    public prop var stringValue: Bytes { get() { m_stringValue.getOrThrow() } set(i_tmp) { m_stringValue = i_tmp } }

    public func clearAggregateValue() { m_aggregateValue = None }
    public prop let hasAggregateValue: Bool { get() { match (m_aggregateValue) { case None => false case _ => true } } }
    public prop var aggregateValue: String { get() { m_aggregateValue.getOrThrow() } set(i_tmp) { m_aggregateValue = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (!name.isEmpty()) { for (i_itmp in name) { i_tmp += 1 + binSize(i_itmp) } }
        if (let Some(i_vtmp) = m_identifierValue) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_positiveIntValue) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = m_negativeIntValue) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = m_doubleValue) { i_tmp += 1 + 8 }
        if (let Some(i_vtmp) = m_stringValue) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_aggregateValue) { i_tmp += 1 + binSize(i_vtmp) }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        name.isEmpty() && isNone(m_identifierValue) && isNone(m_positiveIntValue) && isNone(m_negativeIntValue) &&
        isNone(m_doubleValue) && isNone(m_stringValue) && isNone(m_aggregateValue) &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        name.clear()
        m_identifierValue = None
        m_positiveIntValue = None
        m_negativeIntValue = None
        m_doubleValue = None
        m_stringValue = None
        m_aggregateValue = None
        unknownFields.clear()
    }

    public func clone(): UninterpretedOption {
        let i_tmp = UninterpretedOption()
        i_tmp.name = ArrayList(name.size, { i => name[i].clone() })
        i_tmp.m_identifierValue = m_identifierValue
        i_tmp.m_positiveIntValue = m_positiveIntValue
        i_tmp.m_negativeIntValue = m_negativeIntValue
        i_tmp.m_doubleValue = m_doubleValue
        i_tmp.m_stringValue = m_stringValue?.clone()
        i_tmp.m_aggregateValue = m_aggregateValue
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 2 => name.add().unpack(subReader(src))
                case 3 => m_identifierValue = src.parseString()
                case 4 => m_positiveIntValue = src.parseUInt64()
                case 5 => m_negativeIntValue = src.parseInt64()
                case 6 => m_doubleValue = src.parseFloat64()
                case 7 => m_stringValue = src.parseBytes()
                case 8 => m_aggregateValue = src.parseString()
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!name.isEmpty()) { for (i_itmp in name) { out.append(18); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (let Some(i_vtmp) = m_identifierValue) { out.append(26); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_positiveIntValue) { out.append(32); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = m_negativeIntValue) { out.append(40); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = m_doubleValue) { out.append(49); out.packFixed(i_vtmp) }
        if (let Some(i_vtmp) = m_stringValue) { out.append(58); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_aggregateValue) { out.append(66); out.packBin(i_vtmp) }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!name.isEmpty()) { i_tmp.append("name", name) }
        if (let Some(i_vtmp) = m_identifierValue) { i_tmp.append("identifierValue", i_vtmp) }
        if (let Some(i_vtmp) = m_positiveIntValue) { i_tmp.append("positiveIntValue", i_vtmp) }
        if (let Some(i_vtmp) = m_negativeIntValue) { i_tmp.append("negativeIntValue", i_vtmp) }
        if (let Some(i_vtmp) = m_doubleValue) { i_tmp.append("doubleValue", i_vtmp) }
        if (let Some(i_vtmp) = m_stringValue) { i_tmp.append("stringValue", i_vtmp) }
        if (let Some(i_vtmp) = m_aggregateValue) { i_tmp.append("aggregateValue", i_vtmp) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { UninterpretedOption() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = UninterpretedOption(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = UninterpretedOption(); i_tmp.unpacki(src); i_tmp }
}

public class SourceCodeInfo_Location <: Message & TypedMessage<SourceCodeInfo_Location> {
    public var path = ArrayList<Int32>()
    public var span = ArrayList<Int32>()
    private var m_leadingComments: ?String = None
    private var m_trailingComments: ?String = None
    public var leadingDetachedComments = ArrayList<String>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearLeadingComments() { m_leadingComments = None }
    public prop let hasLeadingComments: Bool { get() { match (m_leadingComments) { case None => false case _ => true } } }
    public prop var leadingComments: String { get() { m_leadingComments.getOrThrow() } set(i_tmp) { m_leadingComments = i_tmp } }

    public func clearTrailingComments() { m_trailingComments = None }
    public prop let hasTrailingComments: Bool { get() { match (m_trailingComments) { case None => false case _ => true } } }
    public prop var trailingComments: String { get() { m_trailingComments.getOrThrow() } set(i_tmp) { m_trailingComments = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (!path.isEmpty()) { var i_stmp = 0; for (i_itmp in path) { i_stmp += varintSize(i_itmp) }; i_tmp += 1 + varintSize(i_stmp) + i_stmp }
        if (!span.isEmpty()) { var i_stmp = 0; for (i_itmp in span) { i_stmp += varintSize(i_itmp) }; i_tmp += 1 + varintSize(i_stmp) + i_stmp }
        if (let Some(i_vtmp) = m_leadingComments) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_trailingComments) { i_tmp += 1 + binSize(i_vtmp) }
        if (!leadingDetachedComments.isEmpty()) { for (i_itmp in leadingDetachedComments) { i_tmp += 1 + binSize(i_itmp) } }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        path.isEmpty() && span.isEmpty() && isNone(m_leadingComments) && isNone(m_trailingComments) &&
        leadingDetachedComments.isEmpty() &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        path.clear()
        span.clear()
        m_leadingComments = None
        m_trailingComments = None
        leadingDetachedComments.clear()
        unknownFields.clear()
    }

    public func clone(): SourceCodeInfo_Location {
        let i_tmp = SourceCodeInfo_Location()
        i_tmp.path = path.clone()
        i_tmp.span = span.clone()
        i_tmp.m_leadingComments = m_leadingComments
        i_tmp.m_trailingComments = m_trailingComments
        i_tmp.leadingDetachedComments = leadingDetachedComments.clone()
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => let i_stmp = subReader(src); while (!i_stmp.isEmpty()) { path.append(i_stmp.parseInt32()) }
                case 2 => let i_stmp = subReader(src); while (!i_stmp.isEmpty()) { span.append(i_stmp.parseInt32()) }
                case 3 => m_leadingComments = src.parseString()
                case 4 => m_trailingComments = src.parseString()
                case 6 => leadingDetachedComments.append(src.parseString())
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!path.isEmpty()) { out.append(10); var i_stmp = 0; for (i_itmp in path) { i_stmp += varintSize(i_itmp) }; out.packVarint(i_stmp); for (i_itmp in path) { out.packVarint(i_itmp) } }
        if (!span.isEmpty()) { out.append(18); var i_stmp = 0; for (i_itmp in span) { i_stmp += varintSize(i_itmp) }; out.packVarint(i_stmp); for (i_itmp in span) { out.packVarint(i_itmp) } }
        if (let Some(i_vtmp) = m_leadingComments) { out.append(26); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_trailingComments) { out.append(34); out.packBin(i_vtmp) }
        if (!leadingDetachedComments.isEmpty()) { for (i_itmp in leadingDetachedComments) { out.append(50); out.packBin(i_itmp) } }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!path.isEmpty()) { i_tmp.append("path", path) }
        if (!span.isEmpty()) { i_tmp.append("span", span) }
        if (let Some(i_vtmp) = m_leadingComments) { i_tmp.append("leadingComments", i_vtmp) }
        if (let Some(i_vtmp) = m_trailingComments) { i_tmp.append("trailingComments", i_vtmp) }
        if (!leadingDetachedComments.isEmpty()) { i_tmp.append("leadingDetachedComments", leadingDetachedComments) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { SourceCodeInfo_Location() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = SourceCodeInfo_Location(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = SourceCodeInfo_Location(); i_tmp.unpacki(src); i_tmp }
}

public class SourceCodeInfo <: Message & TypedMessage<SourceCodeInfo> {
    public var location = ArrayList<SourceCodeInfo_Location>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (!location.isEmpty()) { for (i_itmp in location) { i_tmp += 1 + binSize(i_itmp) } }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        location.isEmpty() &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        location.clear()
        unknownFields.clear()
    }

    public func clone(): SourceCodeInfo {
        let i_tmp = SourceCodeInfo()
        i_tmp.location = ArrayList(location.size, { i => location[i].clone() })
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => location.add().unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!location.isEmpty()) { for (i_itmp in location) { out.append(10); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!location.isEmpty()) { i_tmp.append("location", location) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { SourceCodeInfo() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = SourceCodeInfo(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = SourceCodeInfo(); i_tmp.unpacki(src); i_tmp }
}

public class GeneratedCodeInfo_Annotation <: Message & TypedMessage<GeneratedCodeInfo_Annotation> {
    public var path = ArrayList<Int32>()
    private var m_sourceFile: ?String = None
    private var m_begin: ?Int32 = None
    private var m_end: ?Int32 = None
    public var unknownFields = ArrayList<MessageUnknownField>()

    public func clearSourceFile() { m_sourceFile = None }
    public prop let hasSourceFile: Bool { get() { match (m_sourceFile) { case None => false case _ => true } } }
    public prop var sourceFile: String { get() { m_sourceFile.getOrThrow() } set(i_tmp) { m_sourceFile = i_tmp } }

    public func clearBegin() { m_begin = None }
    public prop let hasBegin: Bool { get() { match (m_begin) { case None => false case _ => true } } }
    public prop var begin: Int32 { get() { m_begin.getOrThrow() } set(i_tmp) { m_begin = i_tmp } }

    public func clearEnd() { m_end = None }
    public prop let hasEnd: Bool { get() { match (m_end) { case None => false case _ => true } } }
    public prop var end: Int32 { get() { m_end.getOrThrow() } set(i_tmp) { m_end = i_tmp } }

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (!path.isEmpty()) { var i_stmp = 0; for (i_itmp in path) { i_stmp += varintSize(i_itmp) }; i_tmp += 1 + varintSize(i_stmp) + i_stmp }
        if (let Some(i_vtmp) = m_sourceFile) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = m_begin) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = m_end) { i_tmp += 1 + varintSize(i_vtmp) }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        path.isEmpty() && isNone(m_sourceFile) && isNone(m_begin) && isNone(m_end) &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        path.clear()
        m_sourceFile = None
        m_begin = None
        m_end = None
        unknownFields.clear()
    }

    public func clone(): GeneratedCodeInfo_Annotation {
        let i_tmp = GeneratedCodeInfo_Annotation()
        i_tmp.path = path.clone()
        i_tmp.m_sourceFile = m_sourceFile
        i_tmp.m_begin = m_begin
        i_tmp.m_end = m_end
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => let i_stmp = subReader(src); while (!i_stmp.isEmpty()) { path.append(i_stmp.parseInt32()) }
                case 2 => m_sourceFile = src.parseString()
                case 3 => m_begin = src.parseInt32()
                case 4 => m_end = src.parseInt32()
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!path.isEmpty()) { out.append(10); var i_stmp = 0; for (i_itmp in path) { i_stmp += varintSize(i_itmp) }; out.packVarint(i_stmp); for (i_itmp in path) { out.packVarint(i_itmp) } }
        if (let Some(i_vtmp) = m_sourceFile) { out.append(18); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = m_begin) { out.append(24); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = m_end) { out.append(32); out.packVarint(i_vtmp) }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!path.isEmpty()) { i_tmp.append("path", path) }
        if (let Some(i_vtmp) = m_sourceFile) { i_tmp.append("sourceFile", i_vtmp) }
        if (let Some(i_vtmp) = m_begin) { i_tmp.append("begin", i_vtmp) }
        if (let Some(i_vtmp) = m_end) { i_tmp.append("end", i_vtmp) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { GeneratedCodeInfo_Annotation() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = GeneratedCodeInfo_Annotation(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = GeneratedCodeInfo_Annotation(); i_tmp.unpacki(src); i_tmp }
}

public class GeneratedCodeInfo <: Message & TypedMessage<GeneratedCodeInfo> {
    public var annotation = ArrayList<GeneratedCodeInfo_Annotation>()
    public var unknownFields = ArrayList<MessageUnknownField>()

    public prop let size: Int64 { get() {
        var i_tmp = 0
        if (!annotation.isEmpty()) { for (i_itmp in annotation) { i_tmp += 1 + binSize(i_itmp) } }
        for (i_itmp in unknownFields) { i_tmp += i_itmp.packSize() }
        return i_tmp
    } }

    public func isEmpty(): Bool {
        annotation.isEmpty() &&
        unknownFields.isEmpty()
    }

    public func clear(): Unit {
        annotation.clear()
        unknownFields.clear()
    }

    public func clone(): GeneratedCodeInfo {
        let i_tmp = GeneratedCodeInfo()
        i_tmp.annotation = ArrayList(annotation.size, { i => annotation[i].clone() })
        i_tmp.unknownFields = ArrayList(unknownFields.size) { i => unknownFields[i].clone() }
        return i_tmp
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => annotation.add().unpack(subReader(src))
                case _ => unknownFields.append(MessageUnknownField.unpack(i_tmp[0], i_tmp[1], src))
            }
        }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!annotation.isEmpty()) { for (i_itmp in annotation) { out.append(10); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!unknownFields.isEmpty()) { for (i_itmp in unknownFields) { i_itmp.pack(out) } }
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!annotation.isEmpty()) { i_tmp.append("annotation", annotation) }
        if (!unknownFields.isEmpty()) { i_tmp.append("unknownFields", unknownFields) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { GeneratedCodeInfo() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = GeneratedCodeInfo(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = GeneratedCodeInfo(); i_tmp.unpacki(src); i_tmp }
}
