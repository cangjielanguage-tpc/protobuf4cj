package reflection

from std import sync.AtomicReference, sync.ReentrantMutex

public interface RoMessage <: ToString {
    func pack(out: BytesWriter): Unit
    func isEmpty(): Bool
}

public interface TypedRoMessage<M> <: RoMessage {
    static func empty(): M
    static func fromBytes(src: Bytes): M
}

/* type and label */
public enum FieldDescriptor_Type <: Int32Enum & TypedEnum<FieldDescriptor_Type> {
    INVALID | DOUBLE | FLOAT | INT64 | UINT64 | INT32 | FIXED64 | FIXED32 | BOOL | STRING | GROUP | MESSAGE | BYTES |
    UINT32 | ENUM | SFIXED32 | SFIXED64 | SINT32 | SINT64

    public func value(): Int32 {
        match(this) {
            case INVALID => 0
            case DOUBLE => 1
            case FLOAT => 2
            case INT64 => 3
            case UINT64 => 4
            case INT32 => 5
            case FIXED64 => 6
            case FIXED32 => 7
            case BOOL => 8
            case STRING => 9
            case GROUP => 10
            case MESSAGE => 11
            case BYTES => 12
            case UINT32 => 13
            case ENUM => 14
            case SFIXED32 => 15
            case SFIXED64 => 16
            case SINT32 => 17
            case SINT64 => 18
        }
    }

    public func toString(): String {
        match(this) {
            case INVALID => "INVALID"
            case DOUBLE => "DOUBLE"
            case FLOAT => "FLOAT"
            case INT64 => "INT64"
            case UINT64 => "UINT64"
            case INT32 => "INT32"
            case FIXED64 => "FIXED64"
            case FIXED32 => "FIXED32"
            case BOOL => "BOOL"
            case STRING => "STRING"
            case GROUP => "GROUP"
            case MESSAGE => "MESSAGE"
            case BYTES => "BYTES"
            case UINT32 => "UINT32"
            case ENUM => "ENUM"
            case SFIXED32 => "SFIXED32"
            case SFIXED64 => "SFIXED64"
            case SINT32 => "SINT32"
            case SINT64 => "SINT64"
        }
    }

    public operator func==(value: FieldDescriptor_Type) {
        match((this, value)) {
            case (INVALID, INVALID) => true
            case (DOUBLE, DOUBLE) => true
            case (FLOAT, FLOAT) => true
            case (INT64, INT64) => true
            case (UINT64, UINT64) => true
            case (INT32, INT32) => true
            case (FIXED64, FIXED64) => true
            case (FIXED32, FIXED32) => true
            case (BOOL, BOOL) => true
            case (STRING, STRING) => true
            case (GROUP, GROUP) => true
            case (MESSAGE, MESSAGE) => true
            case (BYTES, BYTES) => true
            case (UINT32, UINT32) => true
            case (ENUM, ENUM) => true
            case (SFIXED32, SFIXED32) => true
            case (SFIXED64, SFIXED64) => true
            case (SINT32, SINT32) => true
            case (SINT64, SINT64) => true
            case _ => false
        }
    }

    public func isEmpty() { match (this) { case INVALID => true case _ => false } }

    public static func empty(): FieldDescriptor_Type { INVALID }

    public static func parse(value: Int32): FieldDescriptor_Type {
        match(value) {
            case 0 => INVALID
            case 1 => DOUBLE
            case 2 => FLOAT
            case 3 => INT64
            case 4 => UINT64
            case 5 => INT32
            case 6 => FIXED64
            case 7 => FIXED32
            case 8 => BOOL
            case 9 => STRING
            case 10 => GROUP
            case 11 => MESSAGE
            case 12 => BYTES
            case 13 => UINT32
            case 14 => ENUM
            case 15 => SFIXED32
            case 16 => SFIXED64
            case 17 => SINT32
            case 18 => SINT64
            case _ => throw InvalidEnumValueException("FieldDescriptor_Type", value)
        }
    }

    public static func parse(value: String): FieldDescriptor_Type {
        match(value) {
            case "INVALID" => INVALID
            case "DOUBLE" => DOUBLE
            case "FLOAT" => FLOAT
            case "INT64" => INT64
            case "UINT64" => UINT64
            case "INT32" => INT32
            case "FIXED64" => FIXED64
            case "FIXED32" => FIXED32
            case "BOOL" => BOOL
            case "STRING" => STRING
            case "GROUP" => GROUP
            case "MESSAGE" => MESSAGE
            case "BYTES" => BYTES
            case "UINT32" => UINT32
            case "ENUM" => ENUM
            case "SFIXED32" => SFIXED32
            case "SFIXED64" => SFIXED64
            case "SINT32" => SINT32
            case "SINT64" => SINT64
            case _ => throw UnmatchedEnumStringException("FieldDescriptor_Type", value)
        }
    }

    public func getTypeName(): String { "reflection.FieldDescriptorType" }
}

public enum FieldDescriptor_Label <: Int32Enum & TypedEnum<FieldDescriptor_Label> {
    NONE | OPTIONAL | REQUIRED | REPEATED

    public func value(): Int32 {
        match(this) {
            case NONE => 0
            case OPTIONAL => 1
            case REQUIRED => 2
            case REPEATED => 3
        }
    }

    public func toString(): String {
        match(this) {
            case NONE => "NONE"
            case OPTIONAL => "OPTIONAL"
            case REQUIRED => "REQUIRED"
            case REPEATED => "REPEATED"
        }
    }

    public operator func==(value: FieldDescriptor_Label) {
        match((this, value)) {
            case (NONE, NONE) => true
            case (OPTIONAL, OPTIONAL) => true
            case (REQUIRED, REQUIRED) => true
            case (REPEATED, REPEATED) => true
            case _ => false
        }
    }

    public func isEmpty() { match (this) { case NONE => true case _ => false } }

    public static func empty(): FieldDescriptor_Label { NONE }

    public static func parse(value: Int32): FieldDescriptor_Label {
        match(value) {
            case 0 => NONE
            case 1 => OPTIONAL
            case 2 => REQUIRED
            case 3 => REPEATED
            case _ => throw InvalidEnumValueException("FieldDescriptor_Label", value)
        }
    }

    public static func parse(value: String): FieldDescriptor_Label {
        match(value) {
            case "NONE" => NONE
            case "OPTIONAL" => OPTIONAL
            case "REQUIRED" => REQUIRED
            case "REPEATED" => REPEATED
            case _ => throw UnmatchedEnumStringException("FieldDescriptor_Label", value)
        }
    }

    public func getTypeName(): String { "reflection.FieldDescriptorLabel" }
}

/* options */
public class FileOptions <: TypedRoMessage<FileOptions> {
    public FileOptions(
        public let deprecated!: Bool = false
    ) { }

    public static func empty(): FileOptions {
        FileOptions()
    }

    public static func fromBytes(src: Bytes): FileOptions {
        FileOptions(SimpleReader(unsafe { BytesSlice.move(src) }))
    }

    public init(src: SimpleReader) {
        var deprecated = false
        while (!src.isEmpty()) {
            let (_t, _w) = src.parseTag()
            match (_t) {
                case 23 => deprecated = src.parseBool()
                case _ => discard(_w, src)
            }
        }
        this.deprecated = deprecated
    }

    public func pack(out: BytesWriter): Unit {
        if (deprecated) {
            out.packTag(23, VARINT)
            out.packBool(deprecated)
        }
    }

    public func isEmpty(): Bool {
        !deprecated
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (deprecated) {
            _x.append("deprecated", deprecated)
        }
        return _x.done().toString()
    }
}

public class MessageOptions <: TypedRoMessage<MessageOptions> {
    public MessageOptions(
        public let deprecated!: Bool = false,
        public let mapEntry!: Bool = false
    ) { }

    public static func empty(): MessageOptions {
        MessageOptions()
    }

    public static func fromBytes(src: Bytes): MessageOptions {
        MessageOptions(SimpleReader(unsafe { BytesSlice.move(src) }))
    }

    public init(src: SimpleReader) {
        var deprecated = false
        var mapEntry = false
        while (!src.isEmpty()) {
            let (_t, _w) = src.parseTag()
            match (_t) {
                case 3 => deprecated = src.parseBool()
                case 7 => mapEntry = src.parseBool()
                case _ => discard(_w, src)
            }
        }
        this.deprecated = deprecated
        this.mapEntry = mapEntry
    }

    public func pack(out: BytesWriter): Unit {
        if (deprecated) {
            out.packTag(3, VARINT)
            out.packBool(deprecated)
        }
        if (mapEntry) {
            out.packTag(7, VARINT)
            out.packBool(mapEntry)
        }
    }

    public func isEmpty(): Bool {
        !deprecated && !mapEntry
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (deprecated) {
            _x.append("deprecated", deprecated)
        }
        if (mapEntry) {
            _x.append("mapEntry", mapEntry)
        }
        return _x.done().toString()
    }
}

public class FieldOptions <: TypedRoMessage<FieldOptions> {
    public FieldOptions(
        public let packed!: Bool = false,
        public let deprecated!: Bool = false
    ) { }

    public static func empty(): FieldOptions {
        FieldOptions()
    }

    public static func fromBytes(src: Bytes): FieldOptions {
        FieldOptions(SimpleReader(unsafe { BytesSlice.move(src) }))
    }

    public init(src: SimpleReader) {
        var packed = false
        var deprecated = false
        while (!src.isEmpty()) {
            let (_t, _w) = src.parseTag()
            match (_t) {
                case 2 => packed = src.parseBool()
                case 3 => deprecated = src.parseBool()
                case _ => discard(_w, src)
            }
        }
        this.deprecated = deprecated
        this.packed = packed
    }

    public func pack(out: BytesWriter): Unit {
        if (packed) {
            out.packTag(2, VARINT)
            out.packBool(packed)
        }
        if (deprecated) {
            out.packTag(3, VARINT)
            out.packBool(deprecated)
        }
    }

    public func isEmpty(): Bool {
        !packed && !deprecated
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (packed) {
            _x.append("packed", packed)
        }
        if (deprecated) {
            _x.append("deprecated", deprecated)
        }
        return _x.done().toString()
    }
}

public class EnumOptions <: TypedRoMessage<EnumOptions> {
    public EnumOptions(
        public let allowAlias!: Bool = false,
        public let deprecated!: Bool = false
    ) { }

    public static func empty(): EnumOptions {
        EnumOptions()
    }

    public static func fromBytes(src: Bytes): EnumOptions {
        EnumOptions(SimpleReader(unsafe { BytesSlice.move(src) }))
    }

    public init(src: SimpleReader) {
        var allowAlias = false
        var deprecated = false
        while (!src.isEmpty()) {
            let (_t, _w) = src.parseTag()
            match (_t) {
                case 2 => allowAlias = src.parseBool()
                case 3 => deprecated = src.parseBool()
                case _ => discard(_w, src)
            }
        }
        this.allowAlias = allowAlias
        this.deprecated = deprecated
    }

    public func pack(out: BytesWriter): Unit {
        if (allowAlias) {
            out.packTag(2, VARINT)
            out.packBool(allowAlias)
        }
        if (deprecated) {
            out.packTag(3, VARINT)
            out.packBool(deprecated)
        }
    }

    public func isEmpty(): Bool {
        !allowAlias && !deprecated
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (allowAlias) {
            _x.append("allowAlias", allowAlias)
        }
        if (deprecated) {
            _x.append("deprecated", deprecated)
        }
        return _x.done().toString()
    }
}

public class EnumValueOptions <: TypedRoMessage<EnumValueOptions> {
    public EnumValueOptions(
        public let deprecated!: Bool = false
    ) { }

    public static func empty(): EnumValueOptions {
        EnumValueOptions()
    }

    public static func fromBytes(src: Bytes): EnumValueOptions {
        EnumValueOptions(SimpleReader(unsafe { BytesSlice.move(src) }))
    }

    public init(src: SimpleReader) {
        var deprecated = false
        while (!src.isEmpty()) {
            let (_t, _w) = src.parseTag()
            match (_t) {
                case 1 => deprecated = src.parseBool()
                case _ => discard(_w, src)
            }
        }
        this.deprecated = deprecated
    }

    public func pack(out: BytesWriter): Unit {
        if (deprecated) {
            out.packTag(1, VARINT)
            out.packBool(deprecated)
        }
    }

    public func isEmpty(): Bool {
        !deprecated
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (deprecated) {
            _x.append("deprecated", deprecated)
        }
        return _x.done().toString()
    }
}

/* descriptors */
public class FileDescriptor <: TypedRoMessage<FileDescriptor> {
    public FileDescriptor(
        public let name!: String = "",
        public let package_!: String = "",
        public let dependency!: RoArray<String> = RoArray(),
        public let messageType!: RoArray<MessageDescriptor> = RoArray(),
        public let enumType!: RoArray<EnumDescriptor> = RoArray(),
        public let options!: FileOptions = FileOptions(),
        public let syntax!: String = "proto2"
    ) { }

    public static func empty(): FileDescriptor {
        FileDescriptor()
    }

    public static func fromBytes(src: Bytes): FileDescriptor {
        FileDescriptor(SimpleReader(unsafe { BytesSlice.move(src) }))
    }

    /* EDITED */
    public init(src: SimpleReader) {
        var name = ""
        var package_ = ""
        var dependency = ArrayList<String>()
        var messageType = ArrayList<MessageDescriptor>()
        var enumType = ArrayList<EnumDescriptor>()
        var options = FileOptions()
        var syntax = "proto2"
        var prefix = ""
        while (!src.isEmpty()) {
            let (_t, _w) = src.parseTag()
            match (_t) {
                case 1 => name = src.parseString()
                case 2 => package_ = src.parseString(); if (!package_.isEmpty()) { prefix = ".${package_}" }
                case 3 => dependency.append(src.parseString())
                case 4 => messageType.append(MessageDescriptor(subReader(src), prefix: prefix))
                case 5 => enumType.append(EnumDescriptor(subReader(src), prefix: prefix))
                case 8 => options = FileOptions(subReader(src))
                case 12 => syntax = src.parseString()
                case _ => discard(_w, src)
            }
        }
        this.name = name
        this.package_ = package_
        this.dependency = dependency.toRoArray()
        this.messageType = messageType.toRoArray()
        this.enumType = enumType.toRoArray()
        this.options = options
        this.syntax = syntax
    }

    public func pack(out: BytesWriter): Unit {
        if (!name.isEmpty()) {
            out.packTag(1, PREFIXED)
            out.packBin(name)
        }
        if (!package_.isEmpty()) {
            out.packTag(2, PREFIXED)
            out.packBin(package_)
        }
        for (_i in dependency) {
            out.packTag(3, PREFIXED)
            out.packBin(_i)
        }
        for (_i in messageType) {
            out.packTag(4, PREFIXED)
            packRoMessag(out, _i)
        }
        for (_i in enumType) {
            out.packTag(5, PREFIXED)
            packRoMessag(out, _i)
        }
        if (!options.isEmpty()) {
            out.packTag(8, PREFIXED)
            packRoMessag(out, options)
        }
        if (syntax != "proto2") {
            out.packTag(12, PREFIXED)
            out.packBin(syntax)
        }
    }

    public func isEmpty(): Bool {
        name.isEmpty() && package_.isEmpty() && dependency.isEmpty() && messageType.isEmpty() &&
        enumType.isEmpty() && options.isEmpty() && syntax == "proto2"
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (!name.isEmpty()) {
            _x.append("name", name)
        }
        if (!package_.isEmpty()) {
            _x.append("package", package_)
        }
        if (!dependency.isEmpty()) {
            _x.append("dependency", dependency)
        }
        if (!messageType.isEmpty()) {
            _x.append("messageType", messageType)
        }
        if (!enumType.isEmpty()) {
            _x.append("enumType", enumType)
        }
        if (!options.isEmpty()) {
            _x.append("options", options)
        }
        if (syntax != "proto2") {
            _x.append("syntax", syntax)
        }
        return _x.done().toString()
    }
}

public class MessageDescriptor <: TypedRoMessage<MessageDescriptor> {
    public MessageDescriptor(
        public let fullName!: String = "",
        public let fields!: RoArray<FieldDescriptor> = RoArray(),
        public let nestedType!: RoArray<MessageDescriptor> = RoArray(),
        public let enumType!: RoArray<EnumDescriptor> = RoArray(),
        public let options!: MessageOptions = MessageOptions(),
        public let oneofDecl!: RoArray<OneofDescriptor> = RoArray()
    ) { }

    public static func empty(): MessageDescriptor {
        MessageDescriptor()
    }

    public static func fromBytes(src: Bytes): MessageDescriptor {
        MessageDescriptor(SimpleReader(unsafe { BytesSlice.move(src) }))
    }

    /* TODO, bug: depends onCangjie(731) */
    private static func init_(src: SimpleReader, prefix!: String = ""): MessageDescriptor {
        MessageDescriptor(src, prefix: prefix)
    }

    /* EDITED */
    public init(src: SimpleReader, prefix!: String = "") {
        var fullName = ""
        var fields = ArrayList<FieldDescriptor>()
        var nestedType = ArrayList<MessageDescriptor>()
        var enumType = ArrayList<EnumDescriptor>()
        var options = MessageOptions()
        var oneofDecl = ArrayList<OneofDescriptor>()
        while (!src.isEmpty()) {
            let (_t, _w) = src.parseTag()
            match (_t) {
                case 1 => fullName = "${prefix}.${src.parseString()}"
                case 2 => fields.append(FieldDescriptor(subReader(src)))
                case 3 => nestedType.append(MessageDescriptor.init_(subReader(src), prefix: fullName))
                case 4 => enumType.append(EnumDescriptor(subReader(src), prefix: fullName))
                case 7 => options = MessageOptions(subReader(src))
                case 8 => oneofDecl.append(OneofDescriptor(subReader(src)))
                case _ => discard(_w, src)
            }
        }
        this.fullName = fullName
        this.fields = fields.toRoArray()
        this.nestedType = nestedType.toRoArray()
        this.enumType = enumType.toRoArray()
        this.options = options
        this.oneofDecl = oneofDecl.toRoArray()
    }

    /* EDITED */
    public func pack(out: BytesWriter): Unit {
        if (!fullName.isEmpty()) {
            out.packTag(1, PREFIXED)
            out.packBin(fullName.strip())
        }
        for (_i in fields) {
            out.packTag(2, PREFIXED)
            packRoMessag(out, _i)
        }
        for (_i in nestedType where !_i.isMapEntry()) {
            out.packTag(3, PREFIXED)
            packRoMessag(out, _i)
        }
        for (_i in enumType) {
            out.packTag(4, PREFIXED)
            packRoMessag(out, _i)
        }
        if (!options.isEmpty()) {
            out.packTag(7, PREFIXED)
            packRoMessag(out, options)
        }
        for (_i in oneofDecl) {
            out.packTag(8, PREFIXED)
            packRoMessag(out, _i)
        }
    }

    public func isEmpty(): Bool {
        fullName.isEmpty() && fields.isEmpty() && nestedType.isEmpty() && enumType.isEmpty() &&
        options.isEmpty() && oneofDecl.isEmpty()
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (!fullName.isEmpty()) {
            _x.append("fullName", fullName)
        }
        if (!fields.isEmpty()) {
            _x.append("fields", fields)
        }
        if (!nestedType.isEmpty()) {
            _x.append("nestedType", nestedType)
        }
        if (!enumType.isEmpty()) {
            _x.append("enumType", enumType)
        }
        if (!options.isEmpty()) {
            _x.append("options", options)
        }
        if (!oneofDecl.isEmpty()) {
            _x.append("oneofDecl", oneofDecl)
        }
        return _x.done().toString()
    }
}

public class FieldDescriptor <: TypedRoMessage<FieldDescriptor> {
    public FieldDescriptor(
        public let name!: String = "",
        public let extendee!: String = "",
        public let tag!: UInt32 = 0,
        public let label!: FieldDescriptor_Label = NONE,
        public let type_!: FieldDescriptor_Type = INVALID,
        public let typeName!: String = "",
        public let defaultValue!: String = "",
        public let options!: FieldOptions = FieldOptions(),
        public let oneofIndex!: Int64 = -1,
        public let jsonName!: String = "",
        public let proto3Optional!: Bool = false,
        public let mapKeyType!: FieldDescriptor_Type = INVALID,
        public let mapValueType!: FieldDescriptor_Type = INVALID,
        public let mapValueTypeName!: String = ""
    ) { }

    public static func empty(): FieldDescriptor {
        FieldDescriptor()
    }

    public static func fromBytes(src: Bytes): FieldDescriptor {
        FieldDescriptor(SimpleReader(unsafe { BytesSlice.move(src) }))
    }

    public init(src: SimpleReader) {
        var name = ""
        var extendee = ""
        var tag = UInt32(0)
        var label = NONE
        var type_ = INVALID
        var typeName = ""
        var defaultValue = ""
        var options = FieldOptions()
        var oneofIndex = -1
        var jsonName = ""
        var proto3Optional = false
        var mapKeyType = INVALID
        var mapValueType = INVALID
        var mapValueTypeName = ""
        while (!src.isEmpty()) {
            let (_t, _w) = src.parseTag()
            match (_t) {
                case 1 => name = src.parseString()
                case 2 => extendee = src.parseString()
                case 3 => tag = src.parseUInt32()
                case 4 => label = FieldDescriptor_Label.parse(src.parseInt32())
                case 5 => type_ = FieldDescriptor_Type.parse(src.parseInt32())
                case 6 => typeName = src.parseString()
                case 7 => defaultValue = src.parseString()
                case 8 => options = FieldOptions(subReader(src))
                case 9 => oneofIndex = src.parseInt64()
                case 10 => jsonName = src.parseString()
                case 17 => proto3Optional = src.parseBool()
                case 21 => mapKeyType = FieldDescriptor_Type.parse(src.parseInt32())
                case 22 => mapValueType = FieldDescriptor_Type.parse(src.parseInt32())
                case 23 => mapValueTypeName = src.parseString()
                case _ => discard(_w, src)
            }
        }
        this.name = name
        this.extendee = extendee
        this.tag = tag
        this.label = label
        this.type_ = type_
        this.typeName = typeName
        this.defaultValue = defaultValue
        this.options = options
        this.oneofIndex = oneofIndex
        this.jsonName = jsonName
        this.proto3Optional = proto3Optional
        this.mapKeyType = mapKeyType
        this.mapValueType = mapValueType
        this.mapValueTypeName = mapValueTypeName
    }

    /* EDITED */
    public func pack(out: BytesWriter): Unit {
        if (!name.isEmpty()) {
            out.packTag(1, PREFIXED)
            out.packBin(name)
        }
        if (!extendee.isEmpty()) {
            out.packTag(2, PREFIXED)
            out.packBin(extendee)
        }
        if (tag != 0) {
            out.packTag(3, VARINT)
            out.packVarint(tag)
        }
        if (!label.isEmpty()) {
            out.packTag(4, VARINT)
            out.packVarint(label)
        }
        if (!type_.isEmpty()) {
            out.packTag(5, VARINT)
            out.packVarint(type_)
        }
        if (!typeName.isEmpty() && mapKeyType.isEmpty() && mapValueType.isEmpty()) {
            out.packTag(6, PREFIXED)
            out.packBin(typeName)
        }
        if (!defaultValue.isEmpty()) {
            out.packTag(7, PREFIXED)
            out.packBin(defaultValue)
        }
        if (!options.isEmpty()) {
            out.packTag(8, PREFIXED)
            packRoMessag(out, options)
        }
        if (oneofIndex != -1) {
            out.packTag(9, VARINT)
            out.packVarint(oneofIndex)
        }
        if (!jsonName.isEmpty()) {
            out.packTag(10, PREFIXED)
            out.packBin(jsonName)
        }
        if (proto3Optional) {
            out.packTag(17, VARINT)
            out.packBool(proto3Optional)
        }
        if (!mapKeyType.isEmpty()) {
            out.packTag(21, VARINT)
            out.packVarint(mapKeyType)
        }
        if (!mapValueType.isEmpty()) {
            out.packTag(22, VARINT)
            out.packVarint(mapValueType)
        }
        if (!mapValueTypeName.isEmpty()) {
            out.packTag(23, PREFIXED)
            out.packBin(mapValueTypeName)
        }
    }

    public func isEmpty(): Bool {
        name.isEmpty() && extendee.isEmpty() && tag == 0 && label.isEmpty() &&
        type_.isEmpty() && typeName.isEmpty() && defaultValue.isEmpty() && options.isEmpty() &&
        oneofIndex == -1 && jsonName.isEmpty() && !proto3Optional && mapKeyType.isEmpty() &&
        mapValueType.isEmpty() && mapValueTypeName.isEmpty()
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (!name.isEmpty()) {
            _x.append("name", name)
        }
        if (!extendee.isEmpty()) {
            _x.append("extendee", extendee)
        }
        if (tag != 0) {
            _x.append("tag", tag)
        }
        if (!label.isEmpty()) {
            _x.append("label", label)
        }
        if (!type_.isEmpty()) {
            _x.append("type", type_)
        }
        if (!typeName.isEmpty()) {
            _x.append("typeName", typeName)
        }
        if (!defaultValue.isEmpty()) {
            _x.append("defaultValue", defaultValue)
        }
        if (!options.isEmpty()) {
            _x.append("options", options)
        }
        if (oneofIndex != -1) {
            _x.append("oneofIndex", oneofIndex)
        }
        if (!jsonName.isEmpty()) {
            _x.append("jsonName", jsonName)
        }
        if (proto3Optional) {
            _x.append("proto3", proto3Optional)
        }
        if (!mapKeyType.isEmpty()) {
            _x.append("mapKeyType", mapKeyType)
        }
        if (!mapValueType.isEmpty()) {
            _x.append("mapValueType", mapValueType)
        }
        if (!mapValueTypeName.isEmpty()) {
            _x.append("mapValueTypeName", mapValueTypeName)
        }
        return _x.done().toString()
    }
}

public class OneofDescriptor <: TypedRoMessage<OneofDescriptor> {
    public OneofDescriptor(
        public let name!: String = ""
    ) { }

    public static func empty(): OneofDescriptor {
        OneofDescriptor()
    }

    public static func fromBytes(src: Bytes): OneofDescriptor {
        OneofDescriptor(SimpleReader(unsafe { BytesSlice.move(src) }))
    }

    public init(src: SimpleReader) {
        var name = ""
        while (!src.isEmpty()) {
            let (_t, _w) = src.parseTag()
            match (_t) {
                case 1 => name = src.parseString()
                case _ => discard(_w, src)
            }
        }
        this.name = name
    }

    public func pack(out: BytesWriter): Unit {
        if (!name.isEmpty()) {
            out.packTag(1, PREFIXED)
            out.packBin(name)
        }
    }

    public func isEmpty(): Bool {
        name.isEmpty()
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (!name.isEmpty()) {
            _x.append("name", name)
        }
        return _x.done().toString()
    }
}

public class EnumDescriptor <: TypedRoMessage<EnumDescriptor> {
    public EnumDescriptor(
        public let fullName!: String = "",
        public let values!: RoArray<EnumValueDescriptor> = RoArray(),
        public let options!: EnumOptions = EnumOptions()
    ) { }

    public static func empty(): EnumDescriptor {
        EnumDescriptor()
    }

    public static func fromBytes(src: Bytes): EnumDescriptor {
        EnumDescriptor(SimpleReader(unsafe { BytesSlice.move(src) }))
    }

    /* EDITED */
    public init(src: SimpleReader, prefix!: String = "") {
        var fullName = ""
        var values = ArrayList<EnumValueDescriptor>()
        var options = EnumOptions()
        while (!src.isEmpty()) {
            let (_t, _w) = src.parseTag()
            match (_t) {
                case 1 => fullName = "${prefix}.${src.parseString()}"
                case 2 => values.append(EnumValueDescriptor(subReader(src)))
                case 3 => options = EnumOptions(subReader(src))
                case _ => discard(_w, src)
            }
        }
        this.fullName = fullName
        this.values = values.toRoArray()
        this.options = options
    }

    /* EDITED */
    public func pack(out: BytesWriter): Unit {
        if (!fullName.isEmpty()) {
            out.packTag(1, PREFIXED)
            out.packBin(fullName.strip())
        }
        for (_i in values) {
            out.packTag(2, PREFIXED)
            packRoMessag(out, _i)
        }
        if (!options.isEmpty()) {
            out.packTag(3, PREFIXED)
            packRoMessag(out, options)
        }
    }

    public func isEmpty(): Bool {
        fullName.isEmpty() && values.isEmpty() && options.isEmpty()
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (!fullName.isEmpty()) {
            _x.append("fullName", fullName)
        }
        if (!values.isEmpty()) {
            _x.append("values", values)
        }
        if (!options.isEmpty()) {
            _x.append("options", options)
        }
        return _x.done().toString()
    }
}

public class EnumValueDescriptor <: TypedRoMessage<EnumValueDescriptor> {
    public EnumValueDescriptor(
        public let name!: String = "",
        public let number!: Int32 = 0,
        public let options!: EnumValueOptions = EnumValueOptions()
    ) { }

    public static func empty(): EnumValueDescriptor {
        EnumValueDescriptor()
    }

    public static func fromBytes(src: Bytes): EnumValueDescriptor {
        EnumValueDescriptor(SimpleReader(unsafe { BytesSlice.move(src) }))
    }

    public init(src: SimpleReader) {
        var name = ""
        var number = Int32(0)
        var options = EnumValueOptions()
        while (!src.isEmpty()) {
            let (_t, _w) = src.parseTag()
            match (_t) {
                case 1 => name = src.parseString()
                case 2 => number = src.parseInt32()
                case 3 => options = EnumValueOptions(subReader(src))
                case _ => discard(_w, src)
            }
        }
        this.name = name
        this.number = number
        this.options = options
    }

    public func pack(out: BytesWriter): Unit {
        if (!name.isEmpty()) {
            out.packTag(1, PREFIXED)
            out.packBin(name)
        }
        if (number != 0) {
            out.packTag(2, VARINT)
            out.packVarint(number)
        }
        if (!options.isEmpty()) {
            out.packTag(3, PREFIXED)
            packRoMessag(out, options)
        }
    }

    public func isEmpty(): Bool {
        name.isEmpty() && number == 0 && options.isEmpty()
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (!name.isEmpty()) {
            _x.append("name", name)
        }
        if (number != 0) {
            _x.append("number", number)
        }
        if (!options.isEmpty()) {
            _x.append("options", options)
        }
        return _x.done().toString()
    }
}

extend FileDescriptor {
    public prop fullName: String { get() {
        ".${package_}.${name}"
    } }

    /* find nested message */
    public func findMessageByName(name: String): ?MessageDescriptor {
        if (name.isEmpty()) {
            return None
        }

        let fullName = if (name.startsWith(".${package_}.")) {
            name
        } else if (name[0] == b'.') {
            return None
        } else {
            ".${package_}.${name}"
        }

        for (msg in messageType where fullName.startsWith(msg.fullName)) {
            if (fullName == msg.fullName) {
                return msg
            }

            return msg.findMessageByName(fullName)
        }

        return None
    }

    /* find nested enum */
    public func findEnumByName(name: String): ?EnumDescriptor {
        if (name.isEmpty()) {
            return None
        }

        let fullName = if (name.startsWith(".${package_}.")) {
            name
        } else if (name[0] == b'.') {
            return None
        } else {
            ".${package_}.${name}"
        }

        for (e in enumType where fullName == e.fullName) {
            return e
        }

        for (msg in messageType where fullName.startsWith(msg.fullName)) {
            return msg.findEnumByName(fullName)
        }

        return None
    }
}

extend MessageDescriptor {
    public prop file: FileDescriptor { get() {
        DescriptorPool.getFileByMessage(fullName).getOrThrow()
    } }

    public prop containingType: ?MessageDescriptor { get() {
        DescriptorPool.getMessageDescriptor(fullName.pop())
    } }

    public func findFieldByTag(tag: Tag): ?FieldDescriptor {
        for (field in fields where field.tag == tag) {
            return field
        }

        return None
    }

    public func findFieldByName(name: String): ?FieldDescriptor {
        for (field in fields where field.name == name || field.jsonName == name) {
            return field
        }

        return None
    }

    /* find nested message */
    public func findMessageByName(name: String): ?MessageDescriptor {
        if (name.isEmpty()) {
            return None
        }

        let fullName = if (name.startsWith(fullName)) {
            name
        } else if (name[0] == b'.') {
            return None
        } else {
            "${fullName}.${name}"
        }

        for (msg in nestedType where fullName.startsWith(msg.fullName)) {
            if (fullName == msg.fullName) {
                return msg
            }

            return msg.findMessageByName(fullName)
        }

        return None
    }

    /* find nested enum */
    public func findEnumByName(name: String): ?EnumDescriptor {
        if (name.isEmpty()) {
            return None
        }

        let fullName = if (name.startsWith(fullName)) {
            name
        } else if (name[0] == b'.') {
            return None
        } else {
            "${fullName}.${name}"
        }

        for (e in enumType where fullName == e.fullName) {
            return e
        }

        for (msg in nestedType where fullName.startsWith(msg.fullName)) {
            return msg.findEnumByName(fullName)
        }

        return None
    }

    public func isProto2(): Bool {
        file.syntax != "proto3"
    }

    public func isMapEntry(): Bool {
        options.mapEntry
    }
}

extend FieldDescriptor {
    public prop messageType: ?MessageDescriptor { get() {
        if (!isMessage()) {
            return None
        }

        if (let Some(desc) <- DescriptorPool.getMessageDescriptor(typeName)) {
            return desc
        }

        if (!isRepeated() || !typeName.endsWith(".${name.toAsciiTitle()}Entry")) {
            return None
        }

        if (let Some(msg) <- DescriptorPool.getMessageDescriptor(typeName.pop())) {
            return msg.findMessageByName(typeName)
        }

        return None
    } }

    public prop enumType: ?EnumDescriptor { get() {
        if (type_ != ENUM) {
            return None
        }

        return DescriptorPool.getEnumDescriptor(typeName)
    } }

    public func isRepeated(): Bool {
        label == REPEATED
    }

    public func isMessage(): Bool {
        type_ == MESSAGE
    }

    public func isPacked(): Bool {
        options.packed
    }

    public func isMap(): Bool {
        mapKeyType != INVALID && mapValueType != INVALID ||
        isRepeated() && isMessage() && messageType.getOrThrow().isMapEntry()
    }

    // public func getMapEntry(): ?(FieldDescriptor_Type, FieldDescriptor) {
    //     if (mapKeyType != INVALID && mapValueType != INVALID) {
    //         return (mapKeyType, FieldDescriptor(type_: mapValueType, typeName: mapValueTypeName))
    //     }

    //     if (!isRepeated() || !isMessage()) {
    //         return None
    //     }

    //     let desc = messageType ?? return None
    //     if (!desc.isMapEntry()) {
    //         return None
    //     }

    //     return (desc.fields[0].type_, desc.fields[1])
    // }

    public func getMapEntry(): ?(FieldDescriptor_Type, FieldDescriptor_Type, String) {
        if (mapKeyType != INVALID && mapValueType != INVALID) {
            return (mapKeyType, mapValueType, mapValueTypeName)
        }

        if (!isRepeated() || !isMessage()) {
            return None
        }

        let desc = messageType ?? return None
        if (!desc.isMapEntry()) {
            return None
        }

        return (desc.fields[0].type_, desc.fields[1].type_, desc.fields[1].typeName)
    }
}

extend EnumDescriptor {
    public func findEnumValueByName(name: String): ?EnumValueDescriptor {
        for (val in values where val.name == name) {
            return val
        }

        return None
    }

    public func findEnumValueByNumber(number: Int32): ?EnumValueDescriptor {
        for (val in values where val.number == number) {
            return val
        }

        return None
    }
}

extend String {
    func strip(): String {
        this[this.lastIndexOf(b'.').getOrThrow() + 1 .. ]
    }

    func pop(): String {
        this[ .. this.lastIndexOf(b'.').getOrThrow()]
    }
}

extend ArrayList<T> {
    func toRoArray(): RoArray<T> {
        unsafe { RoArray<T>.move(this.toArray()) }
    }
}

extend SimpleWriter {
    func toBytesSlice(): BytesSlice {
        unsafe { BytesSlice.move(this.data[ .. this.offset]) }
    }
}

class Writer <: BytesWriter {
    let data = ArrayList<Byte>(64)

    public func append(byte: Byte): Unit { data.append(byte) }
    public func appendBytes(bytes: Bytes): Unit { data.appendAll(bytes) }

    func toBytesSlice(): BytesSlice {
        unsafe { BytesSlice.move(this.data.getRawArray()[ .. this.data.size]) }
    }
}

func packRoMessag(out: BytesWriter, msg: RoMessage) {
    let writer = Writer()

    msg.pack(writer)
    out.packBin(writer.toBytesSlice())
}

func discard(w: WireNum, src: SimpleReader) {
    match (w) {
        case 0 => src.parseVarintData()
        case 1 => src.read(8)
        case 2 => src.parseBytesSlice()
        case 5 => src.read(4)
        case _ => throw ParseValueExecption("Invalid WireNum `${w}`")
    }
}

/* lazy metadata and pool */
public struct LazyFileDescriptor {
    init(bytes: Bytes) {
        this.bytes = bytes
        this.value = AtomicReference<FileDescriptor>(unset)
    }

    init(value: FileDescriptor) {
        this.bytes = []
        this.value = AtomicReference<FileDescriptor>(value)
    }

    private let bytes: Bytes
    private let value: AtomicReference<FileDescriptor>
    private static let unset = FileDescriptor()

    public func get(): FileDescriptor {
        let val = value.load()
        if (!refEq(val, unset)) {
            return val
        }

        let new = FileDescriptor.fromBytes(bytes)
        if (value.compareAndSwap(unset, new)) {
            return new
        }

        return value.load()
    }
}

public class LazyMessageDescriptor {
    LazyMessageDescriptor(
        let fullName: String,
        let file: LazyFileDescriptor
    ) { }

    private var cached: ?MessageDescriptor = None

    public func get(): MessageDescriptor {
        if (let Some(v) <- cached) {
            return v
        }

        cached = file.get().findMessageByName(fullName)
        cached.getOrThrow()
    }
}

public class LazyEnumDescriptor {
    LazyEnumDescriptor(
        let fullName: String,
        let file: LazyFileDescriptor
    ) { }

    private var cached: ?EnumDescriptor = None

    public func get(): EnumDescriptor {
        if (let Some(v) <- cached) {
            return v
        }

        cached = file.get().findEnumByName(fullName)
        cached.getOrThrow()
    }
}

public class DescriptorPool {
    private let fileDescriptors = HashMap<String, LazyFileDescriptor>()
    private let messageDescriptors = HashMap<String, LazyMessageDescriptor>()
    private let enumDescriptors = HashMap<String, LazyEnumDescriptor>()

    func addFileDescriptor(fullName: String, file: LazyFileDescriptor): Unit {
        if (let Some(exist) <- fileDescriptors.put(fullName, file)) {
            fileDescriptors[fullName] = exist
            throw FullNameConflictException()
        }
    }

    func addMessageDescriptor(fullName: String, message: LazyMessageDescriptor): Unit {
        if (let Some(exist) <- messageDescriptors.put(fullName, message)) {
            messageDescriptors[fullName] = exist
            throw FullNameConflictException()
        }
    }

    func addEnumDescriptor(fullName: String, enum_: LazyEnumDescriptor): Unit {
        if (let Some(exist) <- enumDescriptors.put(fullName, enum_)) {
            enumDescriptors[fullName] = exist
            throw FullNameConflictException()
        }
    }

    public func getAllFile(): Collection<(String, LazyFileDescriptor)> { fileDescriptors }
    public func getAllMessage(): Collection<(String, LazyMessageDescriptor)> { messageDescriptors }
    public func getAllEnum(): Collection<(String, LazyEnumDescriptor)> { enumDescriptors }

    public static let generatedPool = DescriptorPool()
    public static let dynamicPool = DescriptorPool()
    public static let dynamicMutex = ReentrantMutex()

    public static func getFileDescriptor(fullName: String): ?FileDescriptor {
        generatedPool.fileDescriptors.get(fullName)?.get() ?? synchronized (dynamicMutex) { dynamicPool.fileDescriptors.get(fullName)?.get() }
    }

    public static func getMessageDescriptor(fullName: String): ?MessageDescriptor {
        generatedPool.messageDescriptors.get(fullName)?.get() ?? synchronized (dynamicMutex) { dynamicPool.messageDescriptors.get(fullName)?.get() }
    }

    public static func getEnumDescriptor(fullName: String): ?EnumDescriptor {
        generatedPool.enumDescriptors.get(fullName)?.get() ?? synchronized (dynamicMutex) { dynamicPool.enumDescriptors.get(fullName)?.get() }
    }

    public static func getFileByMessage(fullName: String): ?FileDescriptor {
        generatedPool.messageDescriptors.get(fullName)?.file.get()
    }
}

/* protobuf internal use. */
public func _internalAddGeneratedFile(
    fullName: String,
    metadata: Bytes
): LazyFileDescriptor {
    let file = LazyFileDescriptor(metadata)
    DescriptorPool.generatedPool.addFileDescriptor(fullName, file)
    return file
}

/* protobuf internal use. add metadata and prototype of message. */
public func _internalAddGeneratedMessage<M>(
    fullName: String,
    file: LazyFileDescriptor
): LazyMessageDescriptor where M <: Message & TypedMessage<M> {
    Prototype.registerMessagePrototype<M>(fullName)

    let message = LazyMessageDescriptor(fullName, file)
    DescriptorPool.generatedPool.addMessageDescriptor(fullName, message)
    return message
}

/* protobuf internal use. add metadata and prototype of enum. */
public func _internalAddGeneratedEnum<E>(
    fullName: String,
    file: LazyFileDescriptor
): LazyEnumDescriptor where E <: EnumValue & TypedEnum<E> {
    Prototype.registerEnumPrototype<E>(fullName)

    let enum_ = LazyEnumDescriptor(fullName, file)
    DescriptorPool.generatedPool.addEnumDescriptor(fullName, enum_)
    return enum_
}