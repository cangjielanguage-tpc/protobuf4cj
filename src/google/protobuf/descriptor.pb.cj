package google.protobuf

from std import collection.*
from protobuf import protobuf.*

public class FileDescriptorSet <: Message & TypedMessage<FileDescriptorSet> {
    public let file = RepeatedMessage<FileDescriptorProto>()

    public init() {
        m_init(file)
    }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (!file.isEmpty()) { for (i_itmp in file) { i_tmp += 1 + binSize(i_itmp) } }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        file.isEmpty()
    }

    protected func m_clear(): Unit {
        file.clear()
    }

    public func copyFrom(src: FileDescriptorSet): FileDescriptorSet {
        file.copyFrom(src.file)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): FileDescriptorSet {
        return FileDescriptorSet().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => s_add(file, src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!file.isEmpty()) { for (i_itmp in file) { out.append(10); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!file.isEmpty()) { i_tmp.append("file", file) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { FileDescriptorSet() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = FileDescriptorSet(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = FileDescriptorSet(); i_tmp.unpack(src); i_tmp }
}

public class FileDescriptorProto <: Message & TypedMessage<FileDescriptorProto> {
    private var p_name = Pb2String()
    private var p_package = Pb2String()
    public let dependency = RepeatedString()
    public let publicDependency = RepeatedField<Int32>()
    public let weakDependency = RepeatedField<Int32>()
    public let messageType = RepeatedMessage<DescriptorProto>()
    public let enumType = RepeatedMessage<EnumDescriptorProto>()
    public let service = RepeatedMessage<ServiceDescriptorProto>()
    public let extension = RepeatedMessage<FieldDescriptorProto>()
    private var p_options = Pb2Message<FileOptions>()
    private var p_sourceCodeInfo = Pb2Message<SourceCodeInfo>()
    private var p_syntax = Pb2String()

    public init() {
        m_init(dependency)
        m_init(publicDependency)
        m_init(weakDependency)
        m_init(messageType)
        m_init(enumType)
        m_init(service)
        m_init(extension)
    }

    public func clearName() { p_name.clear(); markDirty() }
    public prop let hasName: Bool { get() { isPresent(p_name.data) } }
    public prop var name: String { get() { p_name.get() } set(i_vtmp) { p_name.set(i_vtmp); markDirty() } }

    public func clearPackage() { p_package.clear(); markDirty() }
    public prop let hasPackage: Bool { get() { isPresent(p_package.data) } }
    public prop var package_: String { get() { p_package.get() } set(i_vtmp) { p_package.set(i_vtmp); markDirty() } }

    public func clearOptions() { p_options.removeFrom(this); markDirty() }
    public prop let hasOptions: Bool { get() { isPresent(p_options.data) } }
    public prop var options: FileOptions { get() { p_options.data.getOrThrow() } set(i_vtmp) { p_options.set(this, i_vtmp); markDirty() } }

    public func clearSourceCodeInfo() { p_sourceCodeInfo.removeFrom(this); markDirty() }
    public prop let hasSourceCodeInfo: Bool { get() { isPresent(p_sourceCodeInfo.data) } }
    public prop var sourceCodeInfo: SourceCodeInfo { get() { p_sourceCodeInfo.data.getOrThrow() } set(i_vtmp) { p_sourceCodeInfo.set(this, i_vtmp); markDirty() } }

    public func clearSyntax() { p_syntax.clear(); markDirty() }
    public prop let hasSyntax: Bool { get() { isPresent(p_syntax.data) } }
    public prop var syntax: String { get() { p_syntax.get() } set(i_vtmp) { p_syntax.set(i_vtmp); markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_name.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_package.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (!dependency.isEmpty()) { i_tmp += m_size(dependency, 1) }
        if (!publicDependency.isEmpty()) { for (i_itmp in publicDependency) { i_tmp += 1 + varintSize(i_itmp) } }
        if (!weakDependency.isEmpty()) { for (i_itmp in weakDependency) { i_tmp += 1 + varintSize(i_itmp) } }
        if (!messageType.isEmpty()) { for (i_itmp in messageType) { i_tmp += 1 + binSize(i_itmp) } }
        if (!enumType.isEmpty()) { for (i_itmp in enumType) { i_tmp += 1 + binSize(i_itmp) } }
        if (!service.isEmpty()) { for (i_itmp in service) { i_tmp += 1 + binSize(i_itmp) } }
        if (!extension.isEmpty()) { for (i_itmp in extension) { i_tmp += 1 + binSize(i_itmp) } }
        if (let Some(i_vtmp) = p_options.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_sourceCodeInfo.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_syntax.data) { i_tmp += 1 + binSize(i_vtmp) }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_name.data) && isNone(p_package.data) && dependency.isEmpty() && publicDependency.isEmpty() &&
        weakDependency.isEmpty() && messageType.isEmpty() && enumType.isEmpty() && service.isEmpty() &&
        extension.isEmpty() && isNone(p_options.data) && isNone(p_sourceCodeInfo.data) && isNone(p_syntax.data)
    }

    protected func m_clear(): Unit {
        p_name.clear()
        p_package.clear()
        dependency.clear()
        publicDependency.clear()
        weakDependency.clear()
        messageType.clear()
        enumType.clear()
        service.clear()
        extension.clear()
        p_options.removeFrom(this)
        p_sourceCodeInfo.removeFrom(this)
        p_syntax.clear()
    }

    public func copyFrom(src: FileDescriptorProto): FileDescriptorProto {
        p_name = src.p_name
        p_package = src.p_package
        dependency.copyFrom(src.dependency)
        publicDependency.copyFrom(src.publicDependency)
        weakDependency.copyFrom(src.weakDependency)
        messageType.copyFrom(src.messageType)
        enumType.copyFrom(src.enumType)
        service.copyFrom(src.service)
        extension.copyFrom(src.extension)
        p_options.copyFrom(this, src.p_options.data)
        p_sourceCodeInfo.copyFrom(this, src.p_sourceCodeInfo.data)
        p_syntax = src.p_syntax
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): FileDescriptorProto {
        return FileDescriptorProto().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_name.unpack(src)
                case 2 => p_package.unpack(src)
                case 3 => s_add(dependency, src)
                case 10 => s_add(publicDependency, src.parseInt32())
                case 11 => s_add(weakDependency, src.parseInt32())
                case 4 => s_add(messageType, src)
                case 5 => s_add(enumType, src)
                case 6 => s_add(service, src)
                case 7 => s_add(extension, src)
                case 8 => p_options.getOrDefault(this).unpack(subReader(src))
                case 9 => p_sourceCodeInfo.getOrDefault(this).unpack(subReader(src))
                case 12 => p_syntax.unpack(src)
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
        if (let Some(i_vtmp) = p_package.data) { out.append(18); out.packBin(i_vtmp) }
        if (!dependency.isEmpty()) { s_pack(3, dependency, out) }
        if (!publicDependency.isEmpty()) { for (i_itmp in publicDependency) { out.append(80); out.packVarint(i_itmp) } }
        if (!weakDependency.isEmpty()) { for (i_itmp in weakDependency) { out.append(88); out.packVarint(i_itmp) } }
        if (!messageType.isEmpty()) { for (i_itmp in messageType) { out.append(34); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!enumType.isEmpty()) { for (i_itmp in enumType) { out.append(42); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!service.isEmpty()) { for (i_itmp in service) { out.append(50); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!extension.isEmpty()) { for (i_itmp in extension) { out.append(58); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (let Some(i_vtmp) = p_options.data) { out.append(66); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (let Some(i_vtmp) = p_sourceCodeInfo.data) { out.append(74); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (let Some(i_vtmp) = p_syntax.data) { out.append(98); out.packBin(i_vtmp) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (isPresent(p_name.data)) { i_tmp.append("name", p_name.get()) }
        if (isPresent(p_package.data)) { i_tmp.append("package", p_package.get()) }
        if (!dependency.isEmpty()) { i_tmp.append("dependency", dependency) }
        if (!publicDependency.isEmpty()) { i_tmp.append("publicDependency", publicDependency) }
        if (!weakDependency.isEmpty()) { i_tmp.append("weakDependency", weakDependency) }
        if (!messageType.isEmpty()) { i_tmp.append("messageType", messageType) }
        if (!enumType.isEmpty()) { i_tmp.append("enumType", enumType) }
        if (!service.isEmpty()) { i_tmp.append("service", service) }
        if (!extension.isEmpty()) { i_tmp.append("extension", extension) }
        if (let Some(i_vtmp) = p_options.data) { i_tmp.append("options", i_vtmp) }
        if (let Some(i_vtmp) = p_sourceCodeInfo.data) { i_tmp.append("sourceCodeInfo", i_vtmp) }
        if (isPresent(p_syntax.data)) { i_tmp.append("syntax", p_syntax.get()) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { FileDescriptorProto() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = FileDescriptorProto(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = FileDescriptorProto(); i_tmp.unpack(src); i_tmp }
}

public class DescriptorProto_ExtensionRange <: Message & TypedMessage<DescriptorProto_ExtensionRange> {
    private var p_start: ?Int32 = None
    private var p_end: ?Int32 = None
    private var p_options = Pb2Message<ExtensionRangeOptions>()

    public init() {
    }

    public func clearStart() { p_start = None; markDirty() }
    public prop let hasStart: Bool { get() { isPresent(p_start) } }
    public prop var start: Int32 { get() { p_start.getOrThrow() } set(i_tmp) { p_start = i_tmp; markDirty() } }

    public func clearEnd() { p_end = None; markDirty() }
    public prop let hasEnd: Bool { get() { isPresent(p_end) } }
    public prop var end: Int32 { get() { p_end.getOrThrow() } set(i_tmp) { p_end = i_tmp; markDirty() } }

    public func clearOptions() { p_options.removeFrom(this); markDirty() }
    public prop let hasOptions: Bool { get() { isPresent(p_options.data) } }
    public prop var options: ExtensionRangeOptions { get() { p_options.data.getOrThrow() } set(i_vtmp) { p_options.set(this, i_vtmp); markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_start) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = p_end) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = p_options.data) { i_tmp += 1 + binSize(i_vtmp) }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_start) && isNone(p_end) && isNone(p_options.data)
    }

    protected func m_clear(): Unit {
        p_start = None
        p_end = None
        p_options.removeFrom(this)
    }

    public func copyFrom(src: DescriptorProto_ExtensionRange): DescriptorProto_ExtensionRange {
        p_start = src.p_start
        p_end = src.p_end
        p_options.copyFrom(this, src.p_options.data)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): DescriptorProto_ExtensionRange {
        return DescriptorProto_ExtensionRange().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_start = src.parseInt32()
                case 2 => p_end = src.parseInt32()
                case 3 => p_options.getOrDefault(this).unpack(subReader(src))
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = p_start) { out.append(8); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = p_end) { out.append(16); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = p_options.data) { out.append(26); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = p_start) { i_tmp.append("start", i_vtmp) }
        if (let Some(i_vtmp) = p_end) { i_tmp.append("end", i_vtmp) }
        if (let Some(i_vtmp) = p_options.data) { i_tmp.append("options", i_vtmp) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { DescriptorProto_ExtensionRange() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = DescriptorProto_ExtensionRange(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = DescriptorProto_ExtensionRange(); i_tmp.unpack(src); i_tmp }
}

public class DescriptorProto_ReservedRange <: Message & TypedMessage<DescriptorProto_ReservedRange> {
    private var p_start: ?Int32 = None
    private var p_end: ?Int32 = None

    public init() {
    }

    public func clearStart() { p_start = None; markDirty() }
    public prop let hasStart: Bool { get() { isPresent(p_start) } }
    public prop var start: Int32 { get() { p_start.getOrThrow() } set(i_tmp) { p_start = i_tmp; markDirty() } }

    public func clearEnd() { p_end = None; markDirty() }
    public prop let hasEnd: Bool { get() { isPresent(p_end) } }
    public prop var end: Int32 { get() { p_end.getOrThrow() } set(i_tmp) { p_end = i_tmp; markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_start) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = p_end) { i_tmp += 1 + varintSize(i_vtmp) }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_start) && isNone(p_end)
    }

    protected func m_clear(): Unit {
        p_start = None
        p_end = None
    }

    public func copyFrom(src: DescriptorProto_ReservedRange): DescriptorProto_ReservedRange {
        p_start = src.p_start
        p_end = src.p_end
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): DescriptorProto_ReservedRange {
        return DescriptorProto_ReservedRange().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_start = src.parseInt32()
                case 2 => p_end = src.parseInt32()
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = p_start) { out.append(8); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = p_end) { out.append(16); out.packVarint(i_vtmp) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = p_start) { i_tmp.append("start", i_vtmp) }
        if (let Some(i_vtmp) = p_end) { i_tmp.append("end", i_vtmp) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { DescriptorProto_ReservedRange() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = DescriptorProto_ReservedRange(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = DescriptorProto_ReservedRange(); i_tmp.unpack(src); i_tmp }
}

public class DescriptorProto <: Message & TypedMessage<DescriptorProto> {
    private var p_name = Pb2String()
    public let field = RepeatedMessage<FieldDescriptorProto>()
    public let extension = RepeatedMessage<FieldDescriptorProto>()
    public let nestedType = RepeatedMessage<DescriptorProto>()
    public let enumType = RepeatedMessage<EnumDescriptorProto>()
    public let extensionRange = RepeatedMessage<DescriptorProto_ExtensionRange>()
    public let oneofDecl = RepeatedMessage<OneofDescriptorProto>()
    private var p_options = Pb2Message<MessageOptions>()
    public let reservedRange = RepeatedMessage<DescriptorProto_ReservedRange>()
    public let reservedName = RepeatedString()

    public init() {
        m_init(field)
        m_init(extension)
        m_init(nestedType)
        m_init(enumType)
        m_init(extensionRange)
        m_init(oneofDecl)
        m_init(reservedRange)
        m_init(reservedName)
    }

    public func clearName() { p_name.clear(); markDirty() }
    public prop let hasName: Bool { get() { isPresent(p_name.data) } }
    public prop var name: String { get() { p_name.get() } set(i_vtmp) { p_name.set(i_vtmp); markDirty() } }

    public func clearOptions() { p_options.removeFrom(this); markDirty() }
    public prop let hasOptions: Bool { get() { isPresent(p_options.data) } }
    public prop var options: MessageOptions { get() { p_options.data.getOrThrow() } set(i_vtmp) { p_options.set(this, i_vtmp); markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_name.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (!field.isEmpty()) { for (i_itmp in field) { i_tmp += 1 + binSize(i_itmp) } }
        if (!extension.isEmpty()) { for (i_itmp in extension) { i_tmp += 1 + binSize(i_itmp) } }
        if (!nestedType.isEmpty()) { for (i_itmp in nestedType) { i_tmp += 1 + binSize(i_itmp) } }
        if (!enumType.isEmpty()) { for (i_itmp in enumType) { i_tmp += 1 + binSize(i_itmp) } }
        if (!extensionRange.isEmpty()) { for (i_itmp in extensionRange) { i_tmp += 1 + binSize(i_itmp) } }
        if (!oneofDecl.isEmpty()) { for (i_itmp in oneofDecl) { i_tmp += 1 + binSize(i_itmp) } }
        if (let Some(i_vtmp) = p_options.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (!reservedRange.isEmpty()) { for (i_itmp in reservedRange) { i_tmp += 1 + binSize(i_itmp) } }
        if (!reservedName.isEmpty()) { i_tmp += m_size(reservedName, 1) }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_name.data) && field.isEmpty() && extension.isEmpty() && nestedType.isEmpty() && enumType.isEmpty() &&
        extensionRange.isEmpty() && oneofDecl.isEmpty() && isNone(p_options.data) && reservedRange.isEmpty() &&
        reservedName.isEmpty()
    }

    protected func m_clear(): Unit {
        p_name.clear()
        field.clear()
        extension.clear()
        nestedType.clear()
        enumType.clear()
        extensionRange.clear()
        oneofDecl.clear()
        p_options.removeFrom(this)
        reservedRange.clear()
        reservedName.clear()
    }

    public func copyFrom(src: DescriptorProto): DescriptorProto {
        p_name = src.p_name
        field.copyFrom(src.field)
        extension.copyFrom(src.extension)
        nestedType.copyFrom(src.nestedType)
        enumType.copyFrom(src.enumType)
        extensionRange.copyFrom(src.extensionRange)
        oneofDecl.copyFrom(src.oneofDecl)
        p_options.copyFrom(this, src.p_options.data)
        reservedRange.copyFrom(src.reservedRange)
        reservedName.copyFrom(src.reservedName)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): DescriptorProto {
        return DescriptorProto().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_name.unpack(src)
                case 2 => s_add(field, src)
                case 6 => s_add(extension, src)
                case 3 => s_add(nestedType, src)
                case 4 => s_add(enumType, src)
                case 5 => s_add(extensionRange, src)
                case 8 => s_add(oneofDecl, src)
                case 7 => p_options.getOrDefault(this).unpack(subReader(src))
                case 9 => s_add(reservedRange, src)
                case 10 => s_add(reservedName, src)
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
        if (!field.isEmpty()) { for (i_itmp in field) { out.append(18); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!extension.isEmpty()) { for (i_itmp in extension) { out.append(50); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!nestedType.isEmpty()) { for (i_itmp in nestedType) { out.append(26); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!enumType.isEmpty()) { for (i_itmp in enumType) { out.append(34); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!extensionRange.isEmpty()) { for (i_itmp in extensionRange) { out.append(42); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!oneofDecl.isEmpty()) { for (i_itmp in oneofDecl) { out.append(66); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (let Some(i_vtmp) = p_options.data) { out.append(58); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (!reservedRange.isEmpty()) { for (i_itmp in reservedRange) { out.append(74); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!reservedName.isEmpty()) { s_pack(10, reservedName, out) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (isPresent(p_name.data)) { i_tmp.append("name", p_name.get()) }
        if (!field.isEmpty()) { i_tmp.append("field", field) }
        if (!extension.isEmpty()) { i_tmp.append("extension", extension) }
        if (!nestedType.isEmpty()) { i_tmp.append("nestedType", nestedType) }
        if (!enumType.isEmpty()) { i_tmp.append("enumType", enumType) }
        if (!extensionRange.isEmpty()) { i_tmp.append("extensionRange", extensionRange) }
        if (!oneofDecl.isEmpty()) { i_tmp.append("oneofDecl", oneofDecl) }
        if (let Some(i_vtmp) = p_options.data) { i_tmp.append("options", i_vtmp) }
        if (!reservedRange.isEmpty()) { i_tmp.append("reservedRange", reservedRange) }
        if (!reservedName.isEmpty()) { i_tmp.append("reservedName", reservedName) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { DescriptorProto() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = DescriptorProto(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = DescriptorProto(); i_tmp.unpack(src); i_tmp }
}

public class ExtensionRangeOptions <: Message & TypedMessage<ExtensionRangeOptions> {
    public let uninterpretedOption = RepeatedMessage<UninterpretedOption>()

    public init() {
        m_init(uninterpretedOption)
    }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        uninterpretedOption.isEmpty()
    }

    protected func m_clear(): Unit {
        uninterpretedOption.clear()
    }

    public func copyFrom(src: ExtensionRangeOptions): ExtensionRangeOptions {
        uninterpretedOption.copyFrom(src.uninterpretedOption)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): ExtensionRangeOptions {
        return ExtensionRangeOptions().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 999 => s_add(uninterpretedOption, src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { ExtensionRangeOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = ExtensionRangeOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = ExtensionRangeOptions(); i_tmp.unpack(src); i_tmp }
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
    private var p_name = Pb2String()
    private var p_number: ?Int32 = None
    private var p_label: ?FieldDescriptorProto_Label = None
    private var p_type: ?FieldDescriptorProto_Type = None
    private var p_typeName = Pb2String()
    private var p_extendee = Pb2String()
    private var p_defaultValue = Pb2String()
    private var p_oneofIndex: ?Int32 = None
    private var p_jsonName = Pb2String()
    private var p_options = Pb2Message<FieldOptions>()
    private var p_proto3Optional: ?Bool = None
    public let mapEntry = RepeatedMessage<FieldDescriptorProto>()

    public init() {
        m_init(mapEntry)
    }

    public func clearName() { p_name.clear(); markDirty() }
    public prop let hasName: Bool { get() { isPresent(p_name.data) } }
    public prop var name: String { get() { p_name.get() } set(i_vtmp) { p_name.set(i_vtmp); markDirty() } }

    public func clearNumber() { p_number = None; markDirty() }
    public prop let hasNumber: Bool { get() { isPresent(p_number) } }
    public prop var number: Int32 { get() { p_number.getOrThrow() } set(i_tmp) { p_number = i_tmp; markDirty() } }

    public func clearLabel() { p_label = None; markDirty() }
    public prop let hasLabel: Bool { get() { isPresent(p_label) } }
    public prop var label: FieldDescriptorProto_Label { get() { p_label.getOrThrow() } set(i_tmp) { p_label = i_tmp; markDirty() } }

    public func clearType() { p_type = None; markDirty() }
    public prop let hasType: Bool { get() { isPresent(p_type) } }
    public prop var type_: FieldDescriptorProto_Type { get() { p_type.getOrThrow() } set(i_tmp) { p_type = i_tmp; markDirty() } }

    public func clearTypeName() { p_typeName.clear(); markDirty() }
    public prop let hasTypeName: Bool { get() { isPresent(p_typeName.data) } }
    public prop var typeName: String { get() { p_typeName.get() } set(i_vtmp) { p_typeName.set(i_vtmp); markDirty() } }

    public func clearExtendee() { p_extendee.clear(); markDirty() }
    public prop let hasExtendee: Bool { get() { isPresent(p_extendee.data) } }
    public prop var extendee: String { get() { p_extendee.get() } set(i_vtmp) { p_extendee.set(i_vtmp); markDirty() } }

    public func clearDefaultValue() { p_defaultValue.clear(); markDirty() }
    public prop let hasDefaultValue: Bool { get() { isPresent(p_defaultValue.data) } }
    public prop var defaultValue: String { get() { p_defaultValue.get() } set(i_vtmp) { p_defaultValue.set(i_vtmp); markDirty() } }

    public func clearOneofIndex() { p_oneofIndex = None; markDirty() }
    public prop let hasOneofIndex: Bool { get() { isPresent(p_oneofIndex) } }
    public prop var oneofIndex: Int32 { get() { p_oneofIndex.getOrThrow() } set(i_tmp) { p_oneofIndex = i_tmp; markDirty() } }

    public func clearJsonName() { p_jsonName.clear(); markDirty() }
    public prop let hasJsonName: Bool { get() { isPresent(p_jsonName.data) } }
    public prop var jsonName: String { get() { p_jsonName.get() } set(i_vtmp) { p_jsonName.set(i_vtmp); markDirty() } }

    public func clearOptions() { p_options.removeFrom(this); markDirty() }
    public prop let hasOptions: Bool { get() { isPresent(p_options.data) } }
    public prop var options: FieldOptions { get() { p_options.data.getOrThrow() } set(i_vtmp) { p_options.set(this, i_vtmp); markDirty() } }

    public func clearProto3Optional() { p_proto3Optional = None; markDirty() }
    public prop let hasProto3Optional: Bool { get() { isPresent(p_proto3Optional) } }
    public prop var proto3Optional: Bool { get() { p_proto3Optional.getOrThrow() } set(i_tmp) { p_proto3Optional = i_tmp; markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_name.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_number) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = p_label) { i_tmp += 1 + varintSize(i_vtmp.value()) }
        if (let Some(i_vtmp) = p_type) { i_tmp += 1 + varintSize(i_vtmp.value()) }
        if (let Some(i_vtmp) = p_typeName.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_extendee.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_defaultValue.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_oneofIndex) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = p_jsonName.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_options.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_proto3Optional) { i_tmp += 2 + 1 }
        if (!mapEntry.isEmpty()) { for (i_itmp in mapEntry) { i_tmp += 3 + binSize(i_itmp) } }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_name.data) && isNone(p_number) && isNone(p_label) && isNone(p_type) && isNone(p_typeName.data) &&
        isNone(p_extendee.data) && isNone(p_defaultValue.data) && isNone(p_oneofIndex) && isNone(p_jsonName.data) &&
        isNone(p_options.data) && isNone(p_proto3Optional) && mapEntry.isEmpty()
    }

    protected func m_clear(): Unit {
        p_name.clear()
        p_number = None
        p_label = None
        p_type = None
        p_typeName.clear()
        p_extendee.clear()
        p_defaultValue.clear()
        p_oneofIndex = None
        p_jsonName.clear()
        p_options.removeFrom(this)
        p_proto3Optional = None
        mapEntry.clear()
    }

    public func copyFrom(src: FieldDescriptorProto): FieldDescriptorProto {
        p_name = src.p_name
        p_number = src.p_number
        p_label = src.p_label
        p_type = src.p_type
        p_typeName = src.p_typeName
        p_extendee = src.p_extendee
        p_defaultValue = src.p_defaultValue
        p_oneofIndex = src.p_oneofIndex
        p_jsonName = src.p_jsonName
        p_options.copyFrom(this, src.p_options.data)
        p_proto3Optional = src.p_proto3Optional
        mapEntry.copyFrom(src.mapEntry)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): FieldDescriptorProto {
        return FieldDescriptorProto().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_name.unpack(src)
                case 3 => p_number = src.parseInt32()
                case 4 => p_label = FieldDescriptorProto_Label.parse(src.parseInt32())
                case 5 => p_type = FieldDescriptorProto_Type.parse(src.parseInt32())
                case 6 => p_typeName.unpack(src)
                case 2 => p_extendee.unpack(src)
                case 7 => p_defaultValue.unpack(src)
                case 9 => p_oneofIndex = src.parseInt32()
                case 10 => p_jsonName.unpack(src)
                case 8 => p_options.getOrDefault(this).unpack(subReader(src))
                case 17 => p_proto3Optional = src.parseBool()
                case 9999 => s_add(mapEntry, src)
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
        if (let Some(i_vtmp) = p_number) { out.append(24); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = p_label) { out.append(32); out.packVarint(i_vtmp.value()) }
        if (let Some(i_vtmp) = p_type) { out.append(40); out.packVarint(i_vtmp.value()) }
        if (let Some(i_vtmp) = p_typeName.data) { out.append(50); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_extendee.data) { out.append(18); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_defaultValue.data) { out.append(58); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_oneofIndex) { out.append(72); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = p_jsonName.data) { out.append(82); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_options.data) { out.append(66); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (let Some(i_vtmp) = p_proto3Optional) { out.packTag(17, VARINT); out.packBool(i_vtmp) }
        if (!mapEntry.isEmpty()) { for (i_itmp in mapEntry) { out.packTag(9999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (isPresent(p_name.data)) { i_tmp.append("name", p_name.get()) }
        if (let Some(i_vtmp) = p_number) { i_tmp.append("number", i_vtmp) }
        if (let Some(i_vtmp) = p_label) { i_tmp.append("label", i_vtmp) }
        if (let Some(i_vtmp) = p_type) { i_tmp.append("type", i_vtmp) }
        if (isPresent(p_typeName.data)) { i_tmp.append("typeName", p_typeName.get()) }
        if (isPresent(p_extendee.data)) { i_tmp.append("extendee", p_extendee.get()) }
        if (isPresent(p_defaultValue.data)) { i_tmp.append("defaultValue", p_defaultValue.get()) }
        if (let Some(i_vtmp) = p_oneofIndex) { i_tmp.append("oneofIndex", i_vtmp) }
        if (isPresent(p_jsonName.data)) { i_tmp.append("jsonName", p_jsonName.get()) }
        if (let Some(i_vtmp) = p_options.data) { i_tmp.append("options", i_vtmp) }
        if (let Some(i_vtmp) = p_proto3Optional) { i_tmp.append("proto3Optional", i_vtmp) }
        if (!mapEntry.isEmpty()) { i_tmp.append("mapEntry", mapEntry) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { FieldDescriptorProto() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = FieldDescriptorProto(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = FieldDescriptorProto(); i_tmp.unpack(src); i_tmp }
}

public class OneofDescriptorProto <: Message & TypedMessage<OneofDescriptorProto> {
    private var p_name = Pb2String()
    private var p_options = Pb2Message<OneofOptions>()

    public init() {
    }

    public func clearName() { p_name.clear(); markDirty() }
    public prop let hasName: Bool { get() { isPresent(p_name.data) } }
    public prop var name: String { get() { p_name.get() } set(i_vtmp) { p_name.set(i_vtmp); markDirty() } }

    public func clearOptions() { p_options.removeFrom(this); markDirty() }
    public prop let hasOptions: Bool { get() { isPresent(p_options.data) } }
    public prop var options: OneofOptions { get() { p_options.data.getOrThrow() } set(i_vtmp) { p_options.set(this, i_vtmp); markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_name.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_options.data) { i_tmp += 1 + binSize(i_vtmp) }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_name.data) && isNone(p_options.data)
    }

    protected func m_clear(): Unit {
        p_name.clear()
        p_options.removeFrom(this)
    }

    public func copyFrom(src: OneofDescriptorProto): OneofDescriptorProto {
        p_name = src.p_name
        p_options.copyFrom(this, src.p_options.data)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): OneofDescriptorProto {
        return OneofDescriptorProto().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_name.unpack(src)
                case 2 => p_options.getOrDefault(this).unpack(subReader(src))
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
        if (let Some(i_vtmp) = p_options.data) { out.append(18); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (isPresent(p_name.data)) { i_tmp.append("name", p_name.get()) }
        if (let Some(i_vtmp) = p_options.data) { i_tmp.append("options", i_vtmp) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { OneofDescriptorProto() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = OneofDescriptorProto(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = OneofDescriptorProto(); i_tmp.unpack(src); i_tmp }
}

public class EnumDescriptorProto_EnumReservedRange <: Message & TypedMessage<EnumDescriptorProto_EnumReservedRange> {
    private var p_start: ?Int32 = None
    private var p_end: ?Int32 = None

    public init() {
    }

    public func clearStart() { p_start = None; markDirty() }
    public prop let hasStart: Bool { get() { isPresent(p_start) } }
    public prop var start: Int32 { get() { p_start.getOrThrow() } set(i_tmp) { p_start = i_tmp; markDirty() } }

    public func clearEnd() { p_end = None; markDirty() }
    public prop let hasEnd: Bool { get() { isPresent(p_end) } }
    public prop var end: Int32 { get() { p_end.getOrThrow() } set(i_tmp) { p_end = i_tmp; markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_start) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = p_end) { i_tmp += 1 + varintSize(i_vtmp) }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_start) && isNone(p_end)
    }

    protected func m_clear(): Unit {
        p_start = None
        p_end = None
    }

    public func copyFrom(src: EnumDescriptorProto_EnumReservedRange): EnumDescriptorProto_EnumReservedRange {
        p_start = src.p_start
        p_end = src.p_end
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): EnumDescriptorProto_EnumReservedRange {
        return EnumDescriptorProto_EnumReservedRange().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_start = src.parseInt32()
                case 2 => p_end = src.parseInt32()
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = p_start) { out.append(8); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = p_end) { out.append(16); out.packVarint(i_vtmp) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = p_start) { i_tmp.append("start", i_vtmp) }
        if (let Some(i_vtmp) = p_end) { i_tmp.append("end", i_vtmp) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { EnumDescriptorProto_EnumReservedRange() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = EnumDescriptorProto_EnumReservedRange(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = EnumDescriptorProto_EnumReservedRange(); i_tmp.unpack(src); i_tmp }
}

public class EnumDescriptorProto <: Message & TypedMessage<EnumDescriptorProto> {
    private var p_name = Pb2String()
    public let value = RepeatedMessage<EnumValueDescriptorProto>()
    private var p_options = Pb2Message<EnumOptions>()
    public let reservedRange = RepeatedMessage<EnumDescriptorProto_EnumReservedRange>()
    public let reservedName = RepeatedString()

    public init() {
        m_init(value)
        m_init(reservedRange)
        m_init(reservedName)
    }

    public func clearName() { p_name.clear(); markDirty() }
    public prop let hasName: Bool { get() { isPresent(p_name.data) } }
    public prop var name: String { get() { p_name.get() } set(i_vtmp) { p_name.set(i_vtmp); markDirty() } }

    public func clearOptions() { p_options.removeFrom(this); markDirty() }
    public prop let hasOptions: Bool { get() { isPresent(p_options.data) } }
    public prop var options: EnumOptions { get() { p_options.data.getOrThrow() } set(i_vtmp) { p_options.set(this, i_vtmp); markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_name.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (!value.isEmpty()) { for (i_itmp in value) { i_tmp += 1 + binSize(i_itmp) } }
        if (let Some(i_vtmp) = p_options.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (!reservedRange.isEmpty()) { for (i_itmp in reservedRange) { i_tmp += 1 + binSize(i_itmp) } }
        if (!reservedName.isEmpty()) { i_tmp += m_size(reservedName, 1) }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_name.data) && value.isEmpty() && isNone(p_options.data) && reservedRange.isEmpty() &&
        reservedName.isEmpty()
    }

    protected func m_clear(): Unit {
        p_name.clear()
        value.clear()
        p_options.removeFrom(this)
        reservedRange.clear()
        reservedName.clear()
    }

    public func copyFrom(src: EnumDescriptorProto): EnumDescriptorProto {
        p_name = src.p_name
        value.copyFrom(src.value)
        p_options.copyFrom(this, src.p_options.data)
        reservedRange.copyFrom(src.reservedRange)
        reservedName.copyFrom(src.reservedName)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): EnumDescriptorProto {
        return EnumDescriptorProto().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_name.unpack(src)
                case 2 => s_add(value, src)
                case 3 => p_options.getOrDefault(this).unpack(subReader(src))
                case 4 => s_add(reservedRange, src)
                case 5 => s_add(reservedName, src)
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
        if (!value.isEmpty()) { for (i_itmp in value) { out.append(18); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (let Some(i_vtmp) = p_options.data) { out.append(26); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (!reservedRange.isEmpty()) { for (i_itmp in reservedRange) { out.append(34); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (!reservedName.isEmpty()) { s_pack(5, reservedName, out) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (isPresent(p_name.data)) { i_tmp.append("name", p_name.get()) }
        if (!value.isEmpty()) { i_tmp.append("value", value) }
        if (let Some(i_vtmp) = p_options.data) { i_tmp.append("options", i_vtmp) }
        if (!reservedRange.isEmpty()) { i_tmp.append("reservedRange", reservedRange) }
        if (!reservedName.isEmpty()) { i_tmp.append("reservedName", reservedName) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { EnumDescriptorProto() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = EnumDescriptorProto(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = EnumDescriptorProto(); i_tmp.unpack(src); i_tmp }
}

public class EnumValueDescriptorProto <: Message & TypedMessage<EnumValueDescriptorProto> {
    private var p_name = Pb2String()
    private var p_number: ?Int32 = None
    private var p_options = Pb2Message<EnumValueOptions>()

    public init() {
    }

    public func clearName() { p_name.clear(); markDirty() }
    public prop let hasName: Bool { get() { isPresent(p_name.data) } }
    public prop var name: String { get() { p_name.get() } set(i_vtmp) { p_name.set(i_vtmp); markDirty() } }

    public func clearNumber() { p_number = None; markDirty() }
    public prop let hasNumber: Bool { get() { isPresent(p_number) } }
    public prop var number: Int32 { get() { p_number.getOrThrow() } set(i_tmp) { p_number = i_tmp; markDirty() } }

    public func clearOptions() { p_options.removeFrom(this); markDirty() }
    public prop let hasOptions: Bool { get() { isPresent(p_options.data) } }
    public prop var options: EnumValueOptions { get() { p_options.data.getOrThrow() } set(i_vtmp) { p_options.set(this, i_vtmp); markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_name.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_number) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = p_options.data) { i_tmp += 1 + binSize(i_vtmp) }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_name.data) && isNone(p_number) && isNone(p_options.data)
    }

    protected func m_clear(): Unit {
        p_name.clear()
        p_number = None
        p_options.removeFrom(this)
    }

    public func copyFrom(src: EnumValueDescriptorProto): EnumValueDescriptorProto {
        p_name = src.p_name
        p_number = src.p_number
        p_options.copyFrom(this, src.p_options.data)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): EnumValueDescriptorProto {
        return EnumValueDescriptorProto().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_name.unpack(src)
                case 2 => p_number = src.parseInt32()
                case 3 => p_options.getOrDefault(this).unpack(subReader(src))
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
        if (let Some(i_vtmp) = p_number) { out.append(16); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = p_options.data) { out.append(26); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (isPresent(p_name.data)) { i_tmp.append("name", p_name.get()) }
        if (let Some(i_vtmp) = p_number) { i_tmp.append("number", i_vtmp) }
        if (let Some(i_vtmp) = p_options.data) { i_tmp.append("options", i_vtmp) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { EnumValueDescriptorProto() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = EnumValueDescriptorProto(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = EnumValueDescriptorProto(); i_tmp.unpack(src); i_tmp }
}

public class ServiceDescriptorProto <: Message & TypedMessage<ServiceDescriptorProto> {
    private var p_name = Pb2String()
    public let method = RepeatedMessage<MethodDescriptorProto>()
    private var p_options = Pb2Message<ServiceOptions>()

    public init() {
        m_init(method)
    }

    public func clearName() { p_name.clear(); markDirty() }
    public prop let hasName: Bool { get() { isPresent(p_name.data) } }
    public prop var name: String { get() { p_name.get() } set(i_vtmp) { p_name.set(i_vtmp); markDirty() } }

    public func clearOptions() { p_options.removeFrom(this); markDirty() }
    public prop let hasOptions: Bool { get() { isPresent(p_options.data) } }
    public prop var options: ServiceOptions { get() { p_options.data.getOrThrow() } set(i_vtmp) { p_options.set(this, i_vtmp); markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_name.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (!method.isEmpty()) { for (i_itmp in method) { i_tmp += 1 + binSize(i_itmp) } }
        if (let Some(i_vtmp) = p_options.data) { i_tmp += 1 + binSize(i_vtmp) }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_name.data) && method.isEmpty() && isNone(p_options.data)
    }

    protected func m_clear(): Unit {
        p_name.clear()
        method.clear()
        p_options.removeFrom(this)
    }

    public func copyFrom(src: ServiceDescriptorProto): ServiceDescriptorProto {
        p_name = src.p_name
        method.copyFrom(src.method)
        p_options.copyFrom(this, src.p_options.data)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): ServiceDescriptorProto {
        return ServiceDescriptorProto().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_name.unpack(src)
                case 2 => s_add(method, src)
                case 3 => p_options.getOrDefault(this).unpack(subReader(src))
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
        if (!method.isEmpty()) { for (i_itmp in method) { out.append(18); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (let Some(i_vtmp) = p_options.data) { out.append(26); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (isPresent(p_name.data)) { i_tmp.append("name", p_name.get()) }
        if (!method.isEmpty()) { i_tmp.append("method", method) }
        if (let Some(i_vtmp) = p_options.data) { i_tmp.append("options", i_vtmp) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { ServiceDescriptorProto() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = ServiceDescriptorProto(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = ServiceDescriptorProto(); i_tmp.unpack(src); i_tmp }
}

public class MethodDescriptorProto <: Message & TypedMessage<MethodDescriptorProto> {
    private var p_name = Pb2String()
    private var p_inputType = Pb2String()
    private var p_outputType = Pb2String()
    private var p_options = Pb2Message<MethodOptions>()
    private var p_clientStreaming: ?Bool = None
    private var p_serverStreaming: ?Bool = None
    private var p_funcName = Pb2String()

    public init() {
    }

    public func clearName() { p_name.clear(); markDirty() }
    public prop let hasName: Bool { get() { isPresent(p_name.data) } }
    public prop var name: String { get() { p_name.get() } set(i_vtmp) { p_name.set(i_vtmp); markDirty() } }

    public func clearInputType() { p_inputType.clear(); markDirty() }
    public prop let hasInputType: Bool { get() { isPresent(p_inputType.data) } }
    public prop var inputType: String { get() { p_inputType.get() } set(i_vtmp) { p_inputType.set(i_vtmp); markDirty() } }

    public func clearOutputType() { p_outputType.clear(); markDirty() }
    public prop let hasOutputType: Bool { get() { isPresent(p_outputType.data) } }
    public prop var outputType: String { get() { p_outputType.get() } set(i_vtmp) { p_outputType.set(i_vtmp); markDirty() } }

    public func clearOptions() { p_options.removeFrom(this); markDirty() }
    public prop let hasOptions: Bool { get() { isPresent(p_options.data) } }
    public prop var options: MethodOptions { get() { p_options.data.getOrThrow() } set(i_vtmp) { p_options.set(this, i_vtmp); markDirty() } }

    public func clearClientStreaming() { p_clientStreaming = None; markDirty() }
    public prop let hasClientStreaming: Bool { get() { isPresent(p_clientStreaming) } }
    public prop var clientStreaming: Bool { get() { p_clientStreaming ?? false } set(i_tmp) { p_clientStreaming = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    public func clearServerStreaming() { p_serverStreaming = None; markDirty() }
    public prop let hasServerStreaming: Bool { get() { isPresent(p_serverStreaming) } }
    public prop var serverStreaming: Bool { get() { p_serverStreaming ?? false } set(i_tmp) { p_serverStreaming = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    public func clearFuncName() { p_funcName.clear(); markDirty() }
    public prop let hasFuncName: Bool { get() { isPresent(p_funcName.data) } }
    public prop var funcName: String { get() { p_funcName.get() } set(i_vtmp) { p_funcName.set(i_vtmp); markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_name.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_inputType.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_outputType.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_options.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_clientStreaming) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = p_serverStreaming) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = p_funcName.data) { i_tmp += 3 + binSize(i_vtmp) }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_name.data) && isNone(p_inputType.data) && isNone(p_outputType.data) && isNone(p_options.data) &&
        isNone(p_clientStreaming) && isNone(p_serverStreaming) && isNone(p_funcName.data)
    }

    protected func m_clear(): Unit {
        p_name.clear()
        p_inputType.clear()
        p_outputType.clear()
        p_options.removeFrom(this)
        p_clientStreaming = None
        p_serverStreaming = None
        p_funcName.clear()
    }

    public func copyFrom(src: MethodDescriptorProto): MethodDescriptorProto {
        p_name = src.p_name
        p_inputType = src.p_inputType
        p_outputType = src.p_outputType
        p_options.copyFrom(this, src.p_options.data)
        p_clientStreaming = src.p_clientStreaming
        p_serverStreaming = src.p_serverStreaming
        p_funcName = src.p_funcName
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): MethodDescriptorProto {
        return MethodDescriptorProto().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_name.unpack(src)
                case 2 => p_inputType.unpack(src)
                case 3 => p_outputType.unpack(src)
                case 4 => p_options.getOrDefault(this).unpack(subReader(src))
                case 5 => clientStreaming = src.parseBool()
                case 6 => serverStreaming = src.parseBool()
                case 9999 => p_funcName.unpack(src)
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
        if (let Some(i_vtmp) = p_inputType.data) { out.append(18); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_outputType.data) { out.append(26); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_options.data) { out.append(34); out.packVarint(i_vtmp.size); i_vtmp.pack(out) }
        if (let Some(i_vtmp) = p_clientStreaming) { out.append(40); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_serverStreaming) { out.append(48); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_funcName.data) { out.packTag(9999, PREFIXED); out.packBin(i_vtmp) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (isPresent(p_name.data)) { i_tmp.append("name", p_name.get()) }
        if (isPresent(p_inputType.data)) { i_tmp.append("inputType", p_inputType.get()) }
        if (isPresent(p_outputType.data)) { i_tmp.append("outputType", p_outputType.get()) }
        if (let Some(i_vtmp) = p_options.data) { i_tmp.append("options", i_vtmp) }
        if (let Some(i_vtmp) = p_clientStreaming) { i_tmp.append("clientStreaming", i_vtmp) }
        if (let Some(i_vtmp) = p_serverStreaming) { i_tmp.append("serverStreaming", i_vtmp) }
        if (isPresent(p_funcName.data)) { i_tmp.append("funcName", p_funcName.get()) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { MethodDescriptorProto() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = MethodDescriptorProto(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = MethodDescriptorProto(); i_tmp.unpack(src); i_tmp }
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
    private var p_javaPackage = Pb2String()
    private var p_javaOuterClassname = Pb2String()
    private var p_javaMultipleFiles: ?Bool = None
    private var p_javaGenerateEqualsAndHash: ?Bool = None
    private var p_javaStringCheckUtf8: ?Bool = None
    private var p_optimizeFor: ?FileOptions_OptimizeMode = None
    private var p_goPackage = Pb2String()
    private var p_ccGenericServices: ?Bool = None
    private var p_javaGenericServices: ?Bool = None
    private var p_pyGenericServices: ?Bool = None
    private var p_phpGenericServices: ?Bool = None
    private var p_deprecated: ?Bool = None
    private var p_ccEnableArenas: ?Bool = None
    private var p_objcClassPrefix = Pb2String()
    private var p_csharpNamespace = Pb2String()
    private var p_swiftPrefix = Pb2String()
    private var p_phpClassPrefix = Pb2String()
    private var p_phpNamespace = Pb2String()
    private var p_phpMetadataNamespace = Pb2String()
    private var p_rubyPackage = Pb2String()
    public let uninterpretedOption = RepeatedMessage<UninterpretedOption>()

    public init() {
        m_init(uninterpretedOption)
    }

    public func clearJavaPackage() { p_javaPackage.clear(); markDirty() }
    public prop let hasJavaPackage: Bool { get() { isPresent(p_javaPackage.data) } }
    public prop var javaPackage: String { get() { p_javaPackage.get() } set(i_vtmp) { p_javaPackage.set(i_vtmp); markDirty() } }

    public func clearJavaOuterClassname() { p_javaOuterClassname.clear(); markDirty() }
    public prop let hasJavaOuterClassname: Bool { get() { isPresent(p_javaOuterClassname.data) } }
    public prop var javaOuterClassname: String { get() { p_javaOuterClassname.get() } set(i_vtmp) { p_javaOuterClassname.set(i_vtmp); markDirty() } }

    public func clearJavaMultipleFiles() { p_javaMultipleFiles = None; markDirty() }
    public prop let hasJavaMultipleFiles: Bool { get() { isPresent(p_javaMultipleFiles) } }
    public prop var javaMultipleFiles: Bool { get() { p_javaMultipleFiles ?? false } set(i_tmp) { p_javaMultipleFiles = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    public func clearJavaGenerateEqualsAndHash() { p_javaGenerateEqualsAndHash = None; markDirty() }
    public prop let hasJavaGenerateEqualsAndHash: Bool { get() { isPresent(p_javaGenerateEqualsAndHash) } }
    public prop var javaGenerateEqualsAndHash: Bool { get() { p_javaGenerateEqualsAndHash.getOrThrow() } set(i_tmp) { p_javaGenerateEqualsAndHash = i_tmp; markDirty() } }

    public func clearJavaStringCheckUtf8() { p_javaStringCheckUtf8 = None; markDirty() }
    public prop let hasJavaStringCheckUtf8: Bool { get() { isPresent(p_javaStringCheckUtf8) } }
    public prop var javaStringCheckUtf8: Bool { get() { p_javaStringCheckUtf8 ?? false } set(i_tmp) { p_javaStringCheckUtf8 = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    public func clearOptimizeFor() { p_optimizeFor = None; markDirty() }
    public prop let hasOptimizeFor: Bool { get() { isPresent(p_optimizeFor) } }
    public prop var optimizeFor: FileOptions_OptimizeMode { get() { p_optimizeFor ?? SPEED } set(i_tmp) { p_optimizeFor = if (i_tmp == SPEED) { None } else { i_tmp }; markDirty() } }

    public func clearGoPackage() { p_goPackage.clear(); markDirty() }
    public prop let hasGoPackage: Bool { get() { isPresent(p_goPackage.data) } }
    public prop var goPackage: String { get() { p_goPackage.get() } set(i_vtmp) { p_goPackage.set(i_vtmp); markDirty() } }

    public func clearCcGenericServices() { p_ccGenericServices = None; markDirty() }
    public prop let hasCcGenericServices: Bool { get() { isPresent(p_ccGenericServices) } }
    public prop var ccGenericServices: Bool { get() { p_ccGenericServices ?? false } set(i_tmp) { p_ccGenericServices = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    public func clearJavaGenericServices() { p_javaGenericServices = None; markDirty() }
    public prop let hasJavaGenericServices: Bool { get() { isPresent(p_javaGenericServices) } }
    public prop var javaGenericServices: Bool { get() { p_javaGenericServices ?? false } set(i_tmp) { p_javaGenericServices = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    public func clearPyGenericServices() { p_pyGenericServices = None; markDirty() }
    public prop let hasPyGenericServices: Bool { get() { isPresent(p_pyGenericServices) } }
    public prop var pyGenericServices: Bool { get() { p_pyGenericServices ?? false } set(i_tmp) { p_pyGenericServices = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    public func clearPhpGenericServices() { p_phpGenericServices = None; markDirty() }
    public prop let hasPhpGenericServices: Bool { get() { isPresent(p_phpGenericServices) } }
    public prop var phpGenericServices: Bool { get() { p_phpGenericServices ?? false } set(i_tmp) { p_phpGenericServices = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    public func clearDeprecated() { p_deprecated = None; markDirty() }
    public prop let hasDeprecated: Bool { get() { isPresent(p_deprecated) } }
    public prop var deprecated: Bool { get() { p_deprecated ?? false } set(i_tmp) { p_deprecated = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    public func clearCcEnableArenas() { p_ccEnableArenas = None; markDirty() }
    public prop let hasCcEnableArenas: Bool { get() { isPresent(p_ccEnableArenas) } }
    public prop var ccEnableArenas: Bool { get() { p_ccEnableArenas ?? true } set(i_tmp) { p_ccEnableArenas = if (i_tmp == true) { None } else { i_tmp }; markDirty() } }

    public func clearObjcClassPrefix() { p_objcClassPrefix.clear(); markDirty() }
    public prop let hasObjcClassPrefix: Bool { get() { isPresent(p_objcClassPrefix.data) } }
    public prop var objcClassPrefix: String { get() { p_objcClassPrefix.get() } set(i_vtmp) { p_objcClassPrefix.set(i_vtmp); markDirty() } }

    public func clearCsharpNamespace() { p_csharpNamespace.clear(); markDirty() }
    public prop let hasCsharpNamespace: Bool { get() { isPresent(p_csharpNamespace.data) } }
    public prop var csharpNamespace: String { get() { p_csharpNamespace.get() } set(i_vtmp) { p_csharpNamespace.set(i_vtmp); markDirty() } }

    public func clearSwiftPrefix() { p_swiftPrefix.clear(); markDirty() }
    public prop let hasSwiftPrefix: Bool { get() { isPresent(p_swiftPrefix.data) } }
    public prop var swiftPrefix: String { get() { p_swiftPrefix.get() } set(i_vtmp) { p_swiftPrefix.set(i_vtmp); markDirty() } }

    public func clearPhpClassPrefix() { p_phpClassPrefix.clear(); markDirty() }
    public prop let hasPhpClassPrefix: Bool { get() { isPresent(p_phpClassPrefix.data) } }
    public prop var phpClassPrefix: String { get() { p_phpClassPrefix.get() } set(i_vtmp) { p_phpClassPrefix.set(i_vtmp); markDirty() } }

    public func clearPhpNamespace() { p_phpNamespace.clear(); markDirty() }
    public prop let hasPhpNamespace: Bool { get() { isPresent(p_phpNamespace.data) } }
    public prop var phpNamespace: String { get() { p_phpNamespace.get() } set(i_vtmp) { p_phpNamespace.set(i_vtmp); markDirty() } }

    public func clearPhpMetadataNamespace() { p_phpMetadataNamespace.clear(); markDirty() }
    public prop let hasPhpMetadataNamespace: Bool { get() { isPresent(p_phpMetadataNamespace.data) } }
    public prop var phpMetadataNamespace: String { get() { p_phpMetadataNamespace.get() } set(i_vtmp) { p_phpMetadataNamespace.set(i_vtmp); markDirty() } }

    public func clearRubyPackage() { p_rubyPackage.clear(); markDirty() }
    public prop let hasRubyPackage: Bool { get() { isPresent(p_rubyPackage.data) } }
    public prop var rubyPackage: String { get() { p_rubyPackage.get() } set(i_vtmp) { p_rubyPackage.set(i_vtmp); markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_javaPackage.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_javaOuterClassname.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_javaMultipleFiles) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = p_javaGenerateEqualsAndHash) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = p_javaStringCheckUtf8) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = p_optimizeFor) { i_tmp += 1 + varintSize(i_vtmp.value()) }
        if (let Some(i_vtmp) = p_goPackage.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_ccGenericServices) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = p_javaGenericServices) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = p_pyGenericServices) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = p_phpGenericServices) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = p_deprecated) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = p_ccEnableArenas) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = p_objcClassPrefix.data) { i_tmp += 2 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_csharpNamespace.data) { i_tmp += 2 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_swiftPrefix.data) { i_tmp += 2 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_phpClassPrefix.data) { i_tmp += 2 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_phpNamespace.data) { i_tmp += 2 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_phpMetadataNamespace.data) { i_tmp += 2 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_rubyPackage.data) { i_tmp += 2 + binSize(i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_javaPackage.data) && isNone(p_javaOuterClassname.data) && isNone(p_javaMultipleFiles) &&
        isNone(p_javaGenerateEqualsAndHash) && isNone(p_javaStringCheckUtf8) && isNone(p_optimizeFor) &&
        isNone(p_goPackage.data) && isNone(p_ccGenericServices) && isNone(p_javaGenericServices) &&
        isNone(p_pyGenericServices) && isNone(p_phpGenericServices) && isNone(p_deprecated) &&
        isNone(p_ccEnableArenas) && isNone(p_objcClassPrefix.data) && isNone(p_csharpNamespace.data) &&
        isNone(p_swiftPrefix.data) && isNone(p_phpClassPrefix.data) && isNone(p_phpNamespace.data) &&
        isNone(p_phpMetadataNamespace.data) && isNone(p_rubyPackage.data) && uninterpretedOption.isEmpty()
    }

    protected func m_clear(): Unit {
        p_javaPackage.clear()
        p_javaOuterClassname.clear()
        p_javaMultipleFiles = None
        p_javaGenerateEqualsAndHash = None
        p_javaStringCheckUtf8 = None
        p_optimizeFor = None
        p_goPackage.clear()
        p_ccGenericServices = None
        p_javaGenericServices = None
        p_pyGenericServices = None
        p_phpGenericServices = None
        p_deprecated = None
        p_ccEnableArenas = None
        p_objcClassPrefix.clear()
        p_csharpNamespace.clear()
        p_swiftPrefix.clear()
        p_phpClassPrefix.clear()
        p_phpNamespace.clear()
        p_phpMetadataNamespace.clear()
        p_rubyPackage.clear()
        uninterpretedOption.clear()
    }

    public func copyFrom(src: FileOptions): FileOptions {
        p_javaPackage = src.p_javaPackage
        p_javaOuterClassname = src.p_javaOuterClassname
        p_javaMultipleFiles = src.p_javaMultipleFiles
        p_javaGenerateEqualsAndHash = src.p_javaGenerateEqualsAndHash
        p_javaStringCheckUtf8 = src.p_javaStringCheckUtf8
        p_optimizeFor = src.p_optimizeFor
        p_goPackage = src.p_goPackage
        p_ccGenericServices = src.p_ccGenericServices
        p_javaGenericServices = src.p_javaGenericServices
        p_pyGenericServices = src.p_pyGenericServices
        p_phpGenericServices = src.p_phpGenericServices
        p_deprecated = src.p_deprecated
        p_ccEnableArenas = src.p_ccEnableArenas
        p_objcClassPrefix = src.p_objcClassPrefix
        p_csharpNamespace = src.p_csharpNamespace
        p_swiftPrefix = src.p_swiftPrefix
        p_phpClassPrefix = src.p_phpClassPrefix
        p_phpNamespace = src.p_phpNamespace
        p_phpMetadataNamespace = src.p_phpMetadataNamespace
        p_rubyPackage = src.p_rubyPackage
        uninterpretedOption.copyFrom(src.uninterpretedOption)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): FileOptions {
        return FileOptions().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_javaPackage.unpack(src)
                case 8 => p_javaOuterClassname.unpack(src)
                case 10 => javaMultipleFiles = src.parseBool()
                case 20 => p_javaGenerateEqualsAndHash = src.parseBool()
                case 27 => javaStringCheckUtf8 = src.parseBool()
                case 9 => optimizeFor = FileOptions_OptimizeMode.parse(src.parseInt32())
                case 11 => p_goPackage.unpack(src)
                case 16 => ccGenericServices = src.parseBool()
                case 17 => javaGenericServices = src.parseBool()
                case 18 => pyGenericServices = src.parseBool()
                case 42 => phpGenericServices = src.parseBool()
                case 23 => deprecated = src.parseBool()
                case 31 => ccEnableArenas = src.parseBool()
                case 36 => p_objcClassPrefix.unpack(src)
                case 37 => p_csharpNamespace.unpack(src)
                case 39 => p_swiftPrefix.unpack(src)
                case 40 => p_phpClassPrefix.unpack(src)
                case 41 => p_phpNamespace.unpack(src)
                case 44 => p_phpMetadataNamespace.unpack(src)
                case 45 => p_rubyPackage.unpack(src)
                case 999 => s_add(uninterpretedOption, src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = p_javaPackage.data) { out.append(10); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_javaOuterClassname.data) { out.append(66); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_javaMultipleFiles) { out.append(80); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_javaGenerateEqualsAndHash) { out.packTag(20, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_javaStringCheckUtf8) { out.packTag(27, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_optimizeFor) { out.append(72); out.packVarint(i_vtmp.value()) }
        if (let Some(i_vtmp) = p_goPackage.data) { out.append(90); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_ccGenericServices) { out.packTag(16, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_javaGenericServices) { out.packTag(17, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_pyGenericServices) { out.packTag(18, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_phpGenericServices) { out.packTag(42, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_deprecated) { out.packTag(23, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_ccEnableArenas) { out.packTag(31, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_objcClassPrefix.data) { out.packTag(36, PREFIXED); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_csharpNamespace.data) { out.packTag(37, PREFIXED); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_swiftPrefix.data) { out.packTag(39, PREFIXED); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_phpClassPrefix.data) { out.packTag(40, PREFIXED); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_phpNamespace.data) { out.packTag(41, PREFIXED); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_phpMetadataNamespace.data) { out.packTag(44, PREFIXED); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_rubyPackage.data) { out.packTag(45, PREFIXED); out.packBin(i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (isPresent(p_javaPackage.data)) { i_tmp.append("javaPackage", p_javaPackage.get()) }
        if (isPresent(p_javaOuterClassname.data)) { i_tmp.append("javaOuterClassname", p_javaOuterClassname.get()) }
        if (let Some(i_vtmp) = p_javaMultipleFiles) { i_tmp.append("javaMultipleFiles", i_vtmp) }
        if (let Some(i_vtmp) = p_javaGenerateEqualsAndHash) { i_tmp.append("javaGenerateEqualsAndHash", i_vtmp) }
        if (let Some(i_vtmp) = p_javaStringCheckUtf8) { i_tmp.append("javaStringCheckUtf8", i_vtmp) }
        if (let Some(i_vtmp) = p_optimizeFor) { i_tmp.append("optimizeFor", i_vtmp) }
        if (isPresent(p_goPackage.data)) { i_tmp.append("goPackage", p_goPackage.get()) }
        if (let Some(i_vtmp) = p_ccGenericServices) { i_tmp.append("ccGenericServices", i_vtmp) }
        if (let Some(i_vtmp) = p_javaGenericServices) { i_tmp.append("javaGenericServices", i_vtmp) }
        if (let Some(i_vtmp) = p_pyGenericServices) { i_tmp.append("pyGenericServices", i_vtmp) }
        if (let Some(i_vtmp) = p_phpGenericServices) { i_tmp.append("phpGenericServices", i_vtmp) }
        if (let Some(i_vtmp) = p_deprecated) { i_tmp.append("deprecated", i_vtmp) }
        if (let Some(i_vtmp) = p_ccEnableArenas) { i_tmp.append("ccEnableArenas", i_vtmp) }
        if (isPresent(p_objcClassPrefix.data)) { i_tmp.append("objcClassPrefix", p_objcClassPrefix.get()) }
        if (isPresent(p_csharpNamespace.data)) { i_tmp.append("csharpNamespace", p_csharpNamespace.get()) }
        if (isPresent(p_swiftPrefix.data)) { i_tmp.append("swiftPrefix", p_swiftPrefix.get()) }
        if (isPresent(p_phpClassPrefix.data)) { i_tmp.append("phpClassPrefix", p_phpClassPrefix.get()) }
        if (isPresent(p_phpNamespace.data)) { i_tmp.append("phpNamespace", p_phpNamespace.get()) }
        if (isPresent(p_phpMetadataNamespace.data)) { i_tmp.append("phpMetadataNamespace", p_phpMetadataNamespace.get()) }
        if (isPresent(p_rubyPackage.data)) { i_tmp.append("rubyPackage", p_rubyPackage.get()) }
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { FileOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = FileOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = FileOptions(); i_tmp.unpack(src); i_tmp }
}

public class MessageOptions <: Message & TypedMessage<MessageOptions> {
    private var p_messageSetWireFormat: ?Bool = None
    private var p_noStandardDescriptorAccessor: ?Bool = None
    private var p_deprecated: ?Bool = None
    private var p_mapEntry: ?Bool = None
    public let uninterpretedOption = RepeatedMessage<UninterpretedOption>()

    public init() {
        m_init(uninterpretedOption)
    }

    public func clearMessageSetWireFormat() { p_messageSetWireFormat = None; markDirty() }
    public prop let hasMessageSetWireFormat: Bool { get() { isPresent(p_messageSetWireFormat) } }
    public prop var messageSetWireFormat: Bool { get() { p_messageSetWireFormat ?? false } set(i_tmp) { p_messageSetWireFormat = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    public func clearNoStandardDescriptorAccessor() { p_noStandardDescriptorAccessor = None; markDirty() }
    public prop let hasNoStandardDescriptorAccessor: Bool { get() { isPresent(p_noStandardDescriptorAccessor) } }
    public prop var noStandardDescriptorAccessor: Bool { get() { p_noStandardDescriptorAccessor ?? false } set(i_tmp) { p_noStandardDescriptorAccessor = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    public func clearDeprecated() { p_deprecated = None; markDirty() }
    public prop let hasDeprecated: Bool { get() { isPresent(p_deprecated) } }
    public prop var deprecated: Bool { get() { p_deprecated ?? false } set(i_tmp) { p_deprecated = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    public func clearMapEntry() { p_mapEntry = None; markDirty() }
    public prop let hasMapEntry: Bool { get() { isPresent(p_mapEntry) } }
    public prop var mapEntry: Bool { get() { p_mapEntry.getOrThrow() } set(i_tmp) { p_mapEntry = i_tmp; markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_messageSetWireFormat) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = p_noStandardDescriptorAccessor) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = p_deprecated) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = p_mapEntry) { i_tmp += 1 + 1 }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_messageSetWireFormat) && isNone(p_noStandardDescriptorAccessor) && isNone(p_deprecated) &&
        isNone(p_mapEntry) && uninterpretedOption.isEmpty()
    }

    protected func m_clear(): Unit {
        p_messageSetWireFormat = None
        p_noStandardDescriptorAccessor = None
        p_deprecated = None
        p_mapEntry = None
        uninterpretedOption.clear()
    }

    public func copyFrom(src: MessageOptions): MessageOptions {
        p_messageSetWireFormat = src.p_messageSetWireFormat
        p_noStandardDescriptorAccessor = src.p_noStandardDescriptorAccessor
        p_deprecated = src.p_deprecated
        p_mapEntry = src.p_mapEntry
        uninterpretedOption.copyFrom(src.uninterpretedOption)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): MessageOptions {
        return MessageOptions().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => messageSetWireFormat = src.parseBool()
                case 2 => noStandardDescriptorAccessor = src.parseBool()
                case 3 => deprecated = src.parseBool()
                case 7 => p_mapEntry = src.parseBool()
                case 999 => s_add(uninterpretedOption, src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = p_messageSetWireFormat) { out.append(8); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_noStandardDescriptorAccessor) { out.append(16); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_deprecated) { out.append(24); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_mapEntry) { out.append(56); out.packBool(i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = p_messageSetWireFormat) { i_tmp.append("messageSetWireFormat", i_vtmp) }
        if (let Some(i_vtmp) = p_noStandardDescriptorAccessor) { i_tmp.append("noStandardDescriptorAccessor", i_vtmp) }
        if (let Some(i_vtmp) = p_deprecated) { i_tmp.append("deprecated", i_vtmp) }
        if (let Some(i_vtmp) = p_mapEntry) { i_tmp.append("mapEntry", i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { MessageOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = MessageOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = MessageOptions(); i_tmp.unpack(src); i_tmp }
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
    private var p_ctype: ?FieldOptions_CType = None
    private var p_packed: ?Bool = None
    private var p_jstype: ?FieldOptions_JSType = None
    private var p_lazy: ?Bool = None
    private var p_unverifiedLazy: ?Bool = None
    private var p_deprecated: ?Bool = None
    private var p_weak: ?Bool = None
    public let uninterpretedOption = RepeatedMessage<UninterpretedOption>()

    public init() {
        m_init(uninterpretedOption)
    }

    public func clearCtype() { p_ctype = None; markDirty() }
    public prop let hasCtype: Bool { get() { isPresent(p_ctype) } }
    public prop var ctype: FieldOptions_CType { get() { p_ctype ?? STRING } set(i_tmp) { p_ctype = if (i_tmp == STRING) { None } else { i_tmp }; markDirty() } }

    public func clearPacked() { p_packed = None; markDirty() }
    public prop let hasPacked: Bool { get() { isPresent(p_packed) } }
    public prop var packed: Bool { get() { p_packed.getOrThrow() } set(i_tmp) { p_packed = i_tmp; markDirty() } }

    public func clearJstype() { p_jstype = None; markDirty() }
    public prop let hasJstype: Bool { get() { isPresent(p_jstype) } }
    public prop var jstype: FieldOptions_JSType { get() { p_jstype ?? JS_NORMAL } set(i_tmp) { p_jstype = if (i_tmp == JS_NORMAL) { None } else { i_tmp }; markDirty() } }

    public func clearLazy() { p_lazy = None; markDirty() }
    public prop let hasLazy: Bool { get() { isPresent(p_lazy) } }
    public prop var lazy: Bool { get() { p_lazy ?? false } set(i_tmp) { p_lazy = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    public func clearUnverifiedLazy() { p_unverifiedLazy = None; markDirty() }
    public prop let hasUnverifiedLazy: Bool { get() { isPresent(p_unverifiedLazy) } }
    public prop var unverifiedLazy: Bool { get() { p_unverifiedLazy ?? false } set(i_tmp) { p_unverifiedLazy = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    public func clearDeprecated() { p_deprecated = None; markDirty() }
    public prop let hasDeprecated: Bool { get() { isPresent(p_deprecated) } }
    public prop var deprecated: Bool { get() { p_deprecated ?? false } set(i_tmp) { p_deprecated = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    public func clearWeak() { p_weak = None; markDirty() }
    public prop let hasWeak: Bool { get() { isPresent(p_weak) } }
    public prop var weak: Bool { get() { p_weak ?? false } set(i_tmp) { p_weak = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_ctype) { i_tmp += 1 + varintSize(i_vtmp.value()) }
        if (let Some(i_vtmp) = p_packed) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = p_jstype) { i_tmp += 1 + varintSize(i_vtmp.value()) }
        if (let Some(i_vtmp) = p_lazy) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = p_unverifiedLazy) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = p_deprecated) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = p_weak) { i_tmp += 1 + 1 }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_ctype) && isNone(p_packed) && isNone(p_jstype) && isNone(p_lazy) && isNone(p_unverifiedLazy) &&
        isNone(p_deprecated) && isNone(p_weak) && uninterpretedOption.isEmpty()
    }

    protected func m_clear(): Unit {
        p_ctype = None
        p_packed = None
        p_jstype = None
        p_lazy = None
        p_unverifiedLazy = None
        p_deprecated = None
        p_weak = None
        uninterpretedOption.clear()
    }

    public func copyFrom(src: FieldOptions): FieldOptions {
        p_ctype = src.p_ctype
        p_packed = src.p_packed
        p_jstype = src.p_jstype
        p_lazy = src.p_lazy
        p_unverifiedLazy = src.p_unverifiedLazy
        p_deprecated = src.p_deprecated
        p_weak = src.p_weak
        uninterpretedOption.copyFrom(src.uninterpretedOption)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): FieldOptions {
        return FieldOptions().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => ctype = FieldOptions_CType.parse(src.parseInt32())
                case 2 => p_packed = src.parseBool()
                case 6 => jstype = FieldOptions_JSType.parse(src.parseInt32())
                case 5 => lazy = src.parseBool()
                case 15 => unverifiedLazy = src.parseBool()
                case 3 => deprecated = src.parseBool()
                case 10 => weak = src.parseBool()
                case 999 => s_add(uninterpretedOption, src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = p_ctype) { out.append(8); out.packVarint(i_vtmp.value()) }
        if (let Some(i_vtmp) = p_packed) { out.append(16); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_jstype) { out.append(48); out.packVarint(i_vtmp.value()) }
        if (let Some(i_vtmp) = p_lazy) { out.append(40); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_unverifiedLazy) { out.append(120); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_deprecated) { out.append(24); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_weak) { out.append(80); out.packBool(i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = p_ctype) { i_tmp.append("ctype", i_vtmp) }
        if (let Some(i_vtmp) = p_packed) { i_tmp.append("packed", i_vtmp) }
        if (let Some(i_vtmp) = p_jstype) { i_tmp.append("jstype", i_vtmp) }
        if (let Some(i_vtmp) = p_lazy) { i_tmp.append("lazy", i_vtmp) }
        if (let Some(i_vtmp) = p_unverifiedLazy) { i_tmp.append("unverifiedLazy", i_vtmp) }
        if (let Some(i_vtmp) = p_deprecated) { i_tmp.append("deprecated", i_vtmp) }
        if (let Some(i_vtmp) = p_weak) { i_tmp.append("weak", i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { FieldOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = FieldOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = FieldOptions(); i_tmp.unpack(src); i_tmp }
}

public class OneofOptions <: Message & TypedMessage<OneofOptions> {
    public let uninterpretedOption = RepeatedMessage<UninterpretedOption>()

    public init() {
        m_init(uninterpretedOption)
    }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        uninterpretedOption.isEmpty()
    }

    protected func m_clear(): Unit {
        uninterpretedOption.clear()
    }

    public func copyFrom(src: OneofOptions): OneofOptions {
        uninterpretedOption.copyFrom(src.uninterpretedOption)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): OneofOptions {
        return OneofOptions().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 999 => s_add(uninterpretedOption, src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { OneofOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = OneofOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = OneofOptions(); i_tmp.unpack(src); i_tmp }
}

public class EnumOptions <: Message & TypedMessage<EnumOptions> {
    private var p_allowAlias: ?Bool = None
    private var p_deprecated: ?Bool = None
    public let uninterpretedOption = RepeatedMessage<UninterpretedOption>()

    public init() {
        m_init(uninterpretedOption)
    }

    public func clearAllowAlias() { p_allowAlias = None; markDirty() }
    public prop let hasAllowAlias: Bool { get() { isPresent(p_allowAlias) } }
    public prop var allowAlias: Bool { get() { p_allowAlias.getOrThrow() } set(i_tmp) { p_allowAlias = i_tmp; markDirty() } }

    public func clearDeprecated() { p_deprecated = None; markDirty() }
    public prop let hasDeprecated: Bool { get() { isPresent(p_deprecated) } }
    public prop var deprecated: Bool { get() { p_deprecated ?? false } set(i_tmp) { p_deprecated = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_allowAlias) { i_tmp += 1 + 1 }
        if (let Some(i_vtmp) = p_deprecated) { i_tmp += 1 + 1 }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_allowAlias) && isNone(p_deprecated) && uninterpretedOption.isEmpty()
    }

    protected func m_clear(): Unit {
        p_allowAlias = None
        p_deprecated = None
        uninterpretedOption.clear()
    }

    public func copyFrom(src: EnumOptions): EnumOptions {
        p_allowAlias = src.p_allowAlias
        p_deprecated = src.p_deprecated
        uninterpretedOption.copyFrom(src.uninterpretedOption)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): EnumOptions {
        return EnumOptions().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 2 => p_allowAlias = src.parseBool()
                case 3 => deprecated = src.parseBool()
                case 999 => s_add(uninterpretedOption, src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = p_allowAlias) { out.append(16); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_deprecated) { out.append(24); out.packBool(i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = p_allowAlias) { i_tmp.append("allowAlias", i_vtmp) }
        if (let Some(i_vtmp) = p_deprecated) { i_tmp.append("deprecated", i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { EnumOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = EnumOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = EnumOptions(); i_tmp.unpack(src); i_tmp }
}

public class EnumValueOptions <: Message & TypedMessage<EnumValueOptions> {
    private var p_deprecated: ?Bool = None
    public let uninterpretedOption = RepeatedMessage<UninterpretedOption>()

    public init() {
        m_init(uninterpretedOption)
    }

    public func clearDeprecated() { p_deprecated = None; markDirty() }
    public prop let hasDeprecated: Bool { get() { isPresent(p_deprecated) } }
    public prop var deprecated: Bool { get() { p_deprecated ?? false } set(i_tmp) { p_deprecated = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_deprecated) { i_tmp += 1 + 1 }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_deprecated) && uninterpretedOption.isEmpty()
    }

    protected func m_clear(): Unit {
        p_deprecated = None
        uninterpretedOption.clear()
    }

    public func copyFrom(src: EnumValueOptions): EnumValueOptions {
        p_deprecated = src.p_deprecated
        uninterpretedOption.copyFrom(src.uninterpretedOption)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): EnumValueOptions {
        return EnumValueOptions().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => deprecated = src.parseBool()
                case 999 => s_add(uninterpretedOption, src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = p_deprecated) { out.append(8); out.packBool(i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = p_deprecated) { i_tmp.append("deprecated", i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { EnumValueOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = EnumValueOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = EnumValueOptions(); i_tmp.unpack(src); i_tmp }
}

public class ServiceOptions <: Message & TypedMessage<ServiceOptions> {
    private var p_deprecated: ?Bool = None
    public let uninterpretedOption = RepeatedMessage<UninterpretedOption>()

    public init() {
        m_init(uninterpretedOption)
    }

    public func clearDeprecated() { p_deprecated = None; markDirty() }
    public prop let hasDeprecated: Bool { get() { isPresent(p_deprecated) } }
    public prop var deprecated: Bool { get() { p_deprecated ?? false } set(i_tmp) { p_deprecated = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_deprecated) { i_tmp += 2 + 1 }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_deprecated) && uninterpretedOption.isEmpty()
    }

    protected func m_clear(): Unit {
        p_deprecated = None
        uninterpretedOption.clear()
    }

    public func copyFrom(src: ServiceOptions): ServiceOptions {
        p_deprecated = src.p_deprecated
        uninterpretedOption.copyFrom(src.uninterpretedOption)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): ServiceOptions {
        return ServiceOptions().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 33 => deprecated = src.parseBool()
                case 999 => s_add(uninterpretedOption, src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = p_deprecated) { out.packTag(33, VARINT); out.packBool(i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = p_deprecated) { i_tmp.append("deprecated", i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { ServiceOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = ServiceOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = ServiceOptions(); i_tmp.unpack(src); i_tmp }
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
    private var p_deprecated: ?Bool = None
    private var p_idempotencyLevel: ?MethodOptions_IdempotencyLevel = None
    public let uninterpretedOption = RepeatedMessage<UninterpretedOption>()

    public init() {
        m_init(uninterpretedOption)
    }

    public func clearDeprecated() { p_deprecated = None; markDirty() }
    public prop let hasDeprecated: Bool { get() { isPresent(p_deprecated) } }
    public prop var deprecated: Bool { get() { p_deprecated ?? false } set(i_tmp) { p_deprecated = if (i_tmp == false) { None } else { i_tmp }; markDirty() } }

    public func clearIdempotencyLevel() { p_idempotencyLevel = None; markDirty() }
    public prop let hasIdempotencyLevel: Bool { get() { isPresent(p_idempotencyLevel) } }
    public prop var idempotencyLevel: MethodOptions_IdempotencyLevel { get() { p_idempotencyLevel ?? IDEMPOTENCY_UNKNOWN } set(i_tmp) { p_idempotencyLevel = if (i_tmp == IDEMPOTENCY_UNKNOWN) { None } else { i_tmp }; markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_deprecated) { i_tmp += 2 + 1 }
        if (let Some(i_vtmp) = p_idempotencyLevel) { i_tmp += 2 + varintSize(i_vtmp.value()) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { i_tmp += 2 + binSize(i_itmp) } }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_deprecated) && isNone(p_idempotencyLevel) && uninterpretedOption.isEmpty()
    }

    protected func m_clear(): Unit {
        p_deprecated = None
        p_idempotencyLevel = None
        uninterpretedOption.clear()
    }

    public func copyFrom(src: MethodOptions): MethodOptions {
        p_deprecated = src.p_deprecated
        p_idempotencyLevel = src.p_idempotencyLevel
        uninterpretedOption.copyFrom(src.uninterpretedOption)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): MethodOptions {
        return MethodOptions().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 33 => deprecated = src.parseBool()
                case 34 => idempotencyLevel = MethodOptions_IdempotencyLevel.parse(src.parseInt32())
                case 999 => s_add(uninterpretedOption, src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = p_deprecated) { out.packTag(33, VARINT); out.packBool(i_vtmp) }
        if (let Some(i_vtmp) = p_idempotencyLevel) { out.packTag(34, VARINT); out.packVarint(i_vtmp.value()) }
        if (!uninterpretedOption.isEmpty()) { for (i_itmp in uninterpretedOption) { out.packTag(999, PREFIXED); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) = p_deprecated) { i_tmp.append("deprecated", i_vtmp) }
        if (let Some(i_vtmp) = p_idempotencyLevel) { i_tmp.append("idempotencyLevel", i_vtmp) }
        if (!uninterpretedOption.isEmpty()) { i_tmp.append("uninterpretedOption", uninterpretedOption) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { MethodOptions() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = MethodOptions(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = MethodOptions(); i_tmp.unpack(src); i_tmp }
}

public class UninterpretedOption_NamePart <: Message & TypedMessage<UninterpretedOption_NamePart> {
    private var p_namePart = Pb2String()
    private var p_isExtension: ?Bool = None

    public init() {
    }

    public func clearNamePart() { p_namePart.clear(); markDirty() }
    public prop let hasNamePart: Bool { get() { isPresent(p_namePart.data) } }
    public prop var namePart: String { get() { p_namePart.get() } set(i_vtmp) { p_namePart.set(i_vtmp); markDirty() } }

    public func clearIsExtension() { p_isExtension = None; markDirty() }
    public prop let hasIsExtension: Bool { get() { isPresent(p_isExtension) } }
    public prop var isExtension: Bool { get() { p_isExtension.getOrThrow() } set(i_tmp) { p_isExtension = i_tmp; markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) = p_namePart.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_isExtension) { i_tmp += 1 + 1 }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_namePart.data) && isNone(p_isExtension)
    }

    protected func m_clear(): Unit {
        p_namePart.clear()
        p_isExtension = None
    }

    public func copyFrom(src: UninterpretedOption_NamePart): UninterpretedOption_NamePart {
        p_namePart = src.p_namePart
        p_isExtension = src.p_isExtension
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): UninterpretedOption_NamePart {
        return UninterpretedOption_NamePart().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_namePart.unpack(src)
                case 2 => p_isExtension = src.parseBool()
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
        if (isNone(p_namePart.data)) { throw RequiredFieldNotSetException("namePart") }
        if (isNone(p_isExtension)) { throw RequiredFieldNotSetException("isExtension") }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) = p_namePart.data) { out.append(10); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_isExtension) { out.append(16); out.packBool(i_vtmp) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (isPresent(p_namePart.data)) { i_tmp.append("namePart", p_namePart.get()) }
        if (let Some(i_vtmp) = p_isExtension) { i_tmp.append("isExtension", i_vtmp) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { UninterpretedOption_NamePart() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = UninterpretedOption_NamePart(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = UninterpretedOption_NamePart(); i_tmp.unpack(src); i_tmp }
}

public class UninterpretedOption <: Message & TypedMessage<UninterpretedOption> {
    public let name = RepeatedMessage<UninterpretedOption_NamePart>()
    private var p_identifierValue = Pb2String()
    private var p_positiveIntValue: ?UInt64 = None
    private var p_negativeIntValue: ?Int64 = None
    private var p_doubleValue: ?Float64 = None
    private var p_stringValue: ?BytesSlice = None
    private var p_aggregateValue = Pb2String()

    public init() {
        m_init(name)
    }

    public func clearIdentifierValue() { p_identifierValue.clear(); markDirty() }
    public prop let hasIdentifierValue: Bool { get() { isPresent(p_identifierValue.data) } }
    public prop var identifierValue: String { get() { p_identifierValue.get() } set(i_vtmp) { p_identifierValue.set(i_vtmp); markDirty() } }

    public func clearPositiveIntValue() { p_positiveIntValue = None; markDirty() }
    public prop let hasPositiveIntValue: Bool { get() { isPresent(p_positiveIntValue) } }
    public prop var positiveIntValue: UInt64 { get() { p_positiveIntValue.getOrThrow() } set(i_tmp) { p_positiveIntValue = i_tmp; markDirty() } }

    public func clearNegativeIntValue() { p_negativeIntValue = None; markDirty() }
    public prop let hasNegativeIntValue: Bool { get() { isPresent(p_negativeIntValue) } }
    public prop var negativeIntValue: Int64 { get() { p_negativeIntValue.getOrThrow() } set(i_tmp) { p_negativeIntValue = i_tmp; markDirty() } }

    public func clearDoubleValue() { p_doubleValue = None; markDirty() }
    public prop let hasDoubleValue: Bool { get() { isPresent(p_doubleValue) } }
    public prop var doubleValue: Float64 { get() { p_doubleValue.getOrThrow() } set(i_tmp) { p_doubleValue = i_tmp; markDirty() } }

    public func clearStringValue() { p_stringValue = None; markDirty() }
    public prop let hasStringValue: Bool { get() { isPresent(p_stringValue) } }
    public prop var stringValue: BytesSlice { get() { p_stringValue.getOrThrow() } set(i_tmp) { p_stringValue = i_tmp; markDirty() } }

    public func clearAggregateValue() { p_aggregateValue.clear(); markDirty() }
    public prop let hasAggregateValue: Bool { get() { isPresent(p_aggregateValue.data) } }
    public prop var aggregateValue: String { get() { p_aggregateValue.get() } set(i_vtmp) { p_aggregateValue.set(i_vtmp); markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (!name.isEmpty()) { for (i_itmp in name) { i_tmp += 1 + binSize(i_itmp) } }
        if (let Some(i_vtmp) = p_identifierValue.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_positiveIntValue) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = p_negativeIntValue) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = p_doubleValue) { i_tmp += 1 + 8 }
        if (let Some(i_vtmp) = p_stringValue) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_aggregateValue.data) { i_tmp += 1 + binSize(i_vtmp) }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        name.isEmpty() && isNone(p_identifierValue.data) && isNone(p_positiveIntValue) && isNone(p_negativeIntValue) &&
        isNone(p_doubleValue) && isNone(p_stringValue) && isNone(p_aggregateValue.data)
    }

    protected func m_clear(): Unit {
        name.clear()
        p_identifierValue.clear()
        p_positiveIntValue = None
        p_negativeIntValue = None
        p_doubleValue = None
        p_stringValue = None
        p_aggregateValue.clear()
    }

    public func copyFrom(src: UninterpretedOption): UninterpretedOption {
        name.copyFrom(src.name)
        p_identifierValue = src.p_identifierValue
        p_positiveIntValue = src.p_positiveIntValue
        p_negativeIntValue = src.p_negativeIntValue
        p_doubleValue = src.p_doubleValue
        p_stringValue = src.p_stringValue
        p_aggregateValue = src.p_aggregateValue
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): UninterpretedOption {
        return UninterpretedOption().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 2 => s_add(name, src)
                case 3 => p_identifierValue.unpack(src)
                case 4 => p_positiveIntValue = src.parseUInt64()
                case 5 => p_negativeIntValue = src.parseInt64()
                case 6 => p_doubleValue = src.parseFloat64()
                case 7 => p_stringValue = src.parseBytesSlice()
                case 8 => p_aggregateValue.unpack(src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!name.isEmpty()) { for (i_itmp in name) { out.append(18); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        if (let Some(i_vtmp) = p_identifierValue.data) { out.append(26); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_positiveIntValue) { out.append(32); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = p_negativeIntValue) { out.append(40); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = p_doubleValue) { out.append(49); out.packFixed(i_vtmp) }
        if (let Some(i_vtmp) = p_stringValue) { out.append(58); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_aggregateValue.data) { out.append(66); out.packBin(i_vtmp) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!name.isEmpty()) { i_tmp.append("name", name) }
        if (isPresent(p_identifierValue.data)) { i_tmp.append("identifierValue", p_identifierValue.get()) }
        if (let Some(i_vtmp) = p_positiveIntValue) { i_tmp.append("positiveIntValue", i_vtmp) }
        if (let Some(i_vtmp) = p_negativeIntValue) { i_tmp.append("negativeIntValue", i_vtmp) }
        if (let Some(i_vtmp) = p_doubleValue) { i_tmp.append("doubleValue", i_vtmp) }
        if (let Some(i_vtmp) = p_stringValue) { i_tmp.append("stringValue", i_vtmp) }
        if (isPresent(p_aggregateValue.data)) { i_tmp.append("aggregateValue", p_aggregateValue.get()) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { UninterpretedOption() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = UninterpretedOption(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = UninterpretedOption(); i_tmp.unpack(src); i_tmp }
}

public class SourceCodeInfo_Location <: Message & TypedMessage<SourceCodeInfo_Location> {
    public let path = RepeatedField<Int32>()
    public let span = RepeatedField<Int32>()
    private var p_leadingComments = Pb2String()
    private var p_trailingComments = Pb2String()
    public let leadingDetachedComments = RepeatedString()

    public init() {
        m_init(path)
        m_init(span)
        m_init(leadingDetachedComments)
    }

    public func clearLeadingComments() { p_leadingComments.clear(); markDirty() }
    public prop let hasLeadingComments: Bool { get() { isPresent(p_leadingComments.data) } }
    public prop var leadingComments: String { get() { p_leadingComments.get() } set(i_vtmp) { p_leadingComments.set(i_vtmp); markDirty() } }

    public func clearTrailingComments() { p_trailingComments.clear(); markDirty() }
    public prop let hasTrailingComments: Bool { get() { isPresent(p_trailingComments.data) } }
    public prop var trailingComments: String { get() { p_trailingComments.get() } set(i_vtmp) { p_trailingComments.set(i_vtmp); markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (!path.isEmpty()) { var i_stmp = 0; for (i_itmp in path) { i_stmp += varintSize(i_itmp) }; i_tmp += 1 + varintSize(i_stmp) + i_stmp }
        if (!span.isEmpty()) { var i_stmp = 0; for (i_itmp in span) { i_stmp += varintSize(i_itmp) }; i_tmp += 1 + varintSize(i_stmp) + i_stmp }
        if (let Some(i_vtmp) = p_leadingComments.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_trailingComments.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (!leadingDetachedComments.isEmpty()) { i_tmp += m_size(leadingDetachedComments, 1) }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        path.isEmpty() && span.isEmpty() && isNone(p_leadingComments.data) && isNone(p_trailingComments.data) &&
        leadingDetachedComments.isEmpty()
    }

    protected func m_clear(): Unit {
        path.clear()
        span.clear()
        p_leadingComments.clear()
        p_trailingComments.clear()
        leadingDetachedComments.clear()
    }

    public func copyFrom(src: SourceCodeInfo_Location): SourceCodeInfo_Location {
        path.copyFrom(src.path)
        span.copyFrom(src.span)
        p_leadingComments = src.p_leadingComments
        p_trailingComments = src.p_trailingComments
        leadingDetachedComments.copyFrom(src.leadingDetachedComments)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): SourceCodeInfo_Location {
        return SourceCodeInfo_Location().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => let i_stmp = subReader(src); while (!i_stmp.isEmpty()) { s_add(path, i_stmp.parseInt32()) }
                case 2 => let i_stmp = subReader(src); while (!i_stmp.isEmpty()) { s_add(span, i_stmp.parseInt32()) }
                case 3 => p_leadingComments.unpack(src)
                case 4 => p_trailingComments.unpack(src)
                case 6 => s_add(leadingDetachedComments, src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!path.isEmpty()) { out.append(10); var i_stmp = 0; for (i_itmp in path) { i_stmp += varintSize(i_itmp) }; out.packVarint(i_stmp); for (i_itmp in path) { out.packVarint(i_itmp) } }
        if (!span.isEmpty()) { out.append(18); var i_stmp = 0; for (i_itmp in span) { i_stmp += varintSize(i_itmp) }; out.packVarint(i_stmp); for (i_itmp in span) { out.packVarint(i_itmp) } }
        if (let Some(i_vtmp) = p_leadingComments.data) { out.append(26); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_trailingComments.data) { out.append(34); out.packBin(i_vtmp) }
        if (!leadingDetachedComments.isEmpty()) { s_pack(6, leadingDetachedComments, out) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!path.isEmpty()) { i_tmp.append("path", path) }
        if (!span.isEmpty()) { i_tmp.append("span", span) }
        if (isPresent(p_leadingComments.data)) { i_tmp.append("leadingComments", p_leadingComments.get()) }
        if (isPresent(p_trailingComments.data)) { i_tmp.append("trailingComments", p_trailingComments.get()) }
        if (!leadingDetachedComments.isEmpty()) { i_tmp.append("leadingDetachedComments", leadingDetachedComments) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { SourceCodeInfo_Location() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = SourceCodeInfo_Location(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = SourceCodeInfo_Location(); i_tmp.unpack(src); i_tmp }
}

public class SourceCodeInfo <: Message & TypedMessage<SourceCodeInfo> {
    public let location = RepeatedMessage<SourceCodeInfo_Location>()

    public init() {
        m_init(location)
    }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (!location.isEmpty()) { for (i_itmp in location) { i_tmp += 1 + binSize(i_itmp) } }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        location.isEmpty()
    }

    protected func m_clear(): Unit {
        location.clear()
    }

    public func copyFrom(src: SourceCodeInfo): SourceCodeInfo {
        location.copyFrom(src.location)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): SourceCodeInfo {
        return SourceCodeInfo().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => s_add(location, src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!location.isEmpty()) { for (i_itmp in location) { out.append(10); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!location.isEmpty()) { i_tmp.append("location", location) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { SourceCodeInfo() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = SourceCodeInfo(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = SourceCodeInfo(); i_tmp.unpack(src); i_tmp }
}

public class GeneratedCodeInfo_Annotation <: Message & TypedMessage<GeneratedCodeInfo_Annotation> {
    public let path = RepeatedField<Int32>()
    private var p_sourceFile = Pb2String()
    private var p_begin: ?Int32 = None
    private var p_end: ?Int32 = None

    public init() {
        m_init(path)
    }

    public func clearSourceFile() { p_sourceFile.clear(); markDirty() }
    public prop let hasSourceFile: Bool { get() { isPresent(p_sourceFile.data) } }
    public prop var sourceFile: String { get() { p_sourceFile.get() } set(i_vtmp) { p_sourceFile.set(i_vtmp); markDirty() } }

    public func clearBegin() { p_begin = None; markDirty() }
    public prop let hasBegin: Bool { get() { isPresent(p_begin) } }
    public prop var begin: Int32 { get() { p_begin.getOrThrow() } set(i_tmp) { p_begin = i_tmp; markDirty() } }

    public func clearEnd() { p_end = None; markDirty() }
    public prop let hasEnd: Bool { get() { isPresent(p_end) } }
    public prop var end: Int32 { get() { p_end.getOrThrow() } set(i_tmp) { p_end = i_tmp; markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (!path.isEmpty()) { var i_stmp = 0; for (i_itmp in path) { i_stmp += varintSize(i_itmp) }; i_tmp += 1 + varintSize(i_stmp) + i_stmp }
        if (let Some(i_vtmp) = p_sourceFile.data) { i_tmp += 1 + binSize(i_vtmp) }
        if (let Some(i_vtmp) = p_begin) { i_tmp += 1 + varintSize(i_vtmp) }
        if (let Some(i_vtmp) = p_end) { i_tmp += 1 + varintSize(i_vtmp) }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        path.isEmpty() && isNone(p_sourceFile.data) && isNone(p_begin) && isNone(p_end)
    }

    protected func m_clear(): Unit {
        path.clear()
        p_sourceFile.clear()
        p_begin = None
        p_end = None
    }

    public func copyFrom(src: GeneratedCodeInfo_Annotation): GeneratedCodeInfo_Annotation {
        path.copyFrom(src.path)
        p_sourceFile = src.p_sourceFile
        p_begin = src.p_begin
        p_end = src.p_end
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): GeneratedCodeInfo_Annotation {
        return GeneratedCodeInfo_Annotation().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => let i_stmp = subReader(src); while (!i_stmp.isEmpty()) { s_add(path, i_stmp.parseInt32()) }
                case 2 => p_sourceFile.unpack(src)
                case 3 => p_begin = src.parseInt32()
                case 4 => p_end = src.parseInt32()
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!path.isEmpty()) { out.append(10); var i_stmp = 0; for (i_itmp in path) { i_stmp += varintSize(i_itmp) }; out.packVarint(i_stmp); for (i_itmp in path) { out.packVarint(i_itmp) } }
        if (let Some(i_vtmp) = p_sourceFile.data) { out.append(18); out.packBin(i_vtmp) }
        if (let Some(i_vtmp) = p_begin) { out.append(24); out.packVarint(i_vtmp) }
        if (let Some(i_vtmp) = p_end) { out.append(32); out.packVarint(i_vtmp) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!path.isEmpty()) { i_tmp.append("path", path) }
        if (isPresent(p_sourceFile.data)) { i_tmp.append("sourceFile", p_sourceFile.get()) }
        if (let Some(i_vtmp) = p_begin) { i_tmp.append("begin", i_vtmp) }
        if (let Some(i_vtmp) = p_end) { i_tmp.append("end", i_vtmp) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { GeneratedCodeInfo_Annotation() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = GeneratedCodeInfo_Annotation(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = GeneratedCodeInfo_Annotation(); i_tmp.unpack(src); i_tmp }
}

public class GeneratedCodeInfo <: Message & TypedMessage<GeneratedCodeInfo> {
    public let annotation = RepeatedMessage<GeneratedCodeInfo_Annotation>()

    public init() {
        m_init(annotation)
    }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (!annotation.isEmpty()) { for (i_itmp in annotation) { i_tmp += 1 + binSize(i_itmp) } }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        annotation.isEmpty()
    }

    protected func m_clear(): Unit {
        annotation.clear()
    }

    public func copyFrom(src: GeneratedCodeInfo): GeneratedCodeInfo {
        annotation.copyFrom(src.annotation)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): GeneratedCodeInfo {
        return GeneratedCodeInfo().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => s_add(annotation, src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!annotation.isEmpty()) { for (i_itmp in annotation) { out.append(10); out.packVarint(i_itmp.size); i_itmp.pack(out) } }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!annotation.isEmpty()) { i_tmp.append("annotation", annotation) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { GeneratedCodeInfo() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = GeneratedCodeInfo(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = GeneratedCodeInfo(); i_tmp.unpack(src); i_tmp }
}
