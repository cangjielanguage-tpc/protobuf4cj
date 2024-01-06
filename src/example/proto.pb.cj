package example

from std import collection.*
from protobuf import protobuf.*
from protobuf import reflection.*

let _proto_proto__descriptor = _internalAddGeneratedFile(".example.proto.proto",
    b"\n\vproto.proto\u{12}\u{7}example\"\u{f2}\u{1}\n\u{6}Person\u{12}\u{e}\n\u{2}id\u{18}\u{1} \u{2}(\u{5}R\u{2}id\u{12}\u{12}\n\u{4}name\u{18}\u{2} \u{2}(\tR\u{4}name\u{12}\u{14}\n\u{5}email\u{18}\u{3} \u{1}(\tR\u{5}email\u{12}.\n\u{6}gender\u{18}\u{4} \u{1}(\u{e}2\u{16}.example.Person.GenderR\u{6}gender\u{12}+\n\u{5}hobby\u{18}\u{e} \u{3}(\u{e}2\u{15}.example.Person.HobbyR\u{5}hobby\"\u{1e}\n\u{6}Gender\u{12}\b\n\u{4}Male\u{10}\u{1}\u{12}\n\n\u{6}Female\u{10}\u{2}\"1\n\u{5}Hobby\u{12}\t\n\u{5}Sleep\u{10}\u{2}\u{12}\t\n\u{5}Study\u{10}\u{3}\u{12}\b\n\u{4}Work\u{10}\b\u{12}\b\n\u{4}Game\u{10}\t\"|\n\u{5}Class\u{12}.\n\u{6}person\u{18}\u{1} \u{3}(\vR\u{6}person\u{a8}\u{1}\u{5}\u{b0}\u{1}\v\u{ba}\u{1}\u{f}.example.Person\u{12}\u{18}\n\u{4}name\u{18}\u{2} \u{3}(\vR\u{4}name\u{a8}\u{1}\u{5}\u{b0}\u{1}\t\u{12})\n\u{7}teacher\u{18}\u{4} \u{3}(\v2\u{f}.example.PersonR\u{7}teacher"
)

let _Person_Gender__descriptor = _internalAddGeneratedEnum<Person_Gender>(".example.Person.Gender", _proto_proto__descriptor)

public enum Person_Gender <: EnumValue & TypedEnum<Person_Gender> {
    Male | Female

    public func value(): Int32 {
        match(this) {
            case Male => 1
            case Female => 2
        }
    }

    public func toString(): String {
        match(this) {
            case Male => "Male"
            case Female => "Female"
        }
    }

    public operator func==(value: Person_Gender) {
        match((this, value)) {
            case (Male, Male) => true
            case (Female, Female) => true
            case _ => false
        }
    }

    public static func parse(value: Int32): Person_Gender {
        match(value) {
            case 1 => Male
            case 2 => Female
            case _ => throw InvalidEnumValueException("Person_Gender", value)
        }
    }

    public static func parse(value: String): Person_Gender {
        match(value) {
            case "Male" => Male
            case "Female" => Female
            case _ => throw UnmatchedEnumStringException("Person_Gender", value)
        }
    }

    public static func descriptor(): EnumDescriptor { _Person_Gender__descriptor.get() }
}

let _Person_Hobby__descriptor = _internalAddGeneratedEnum<Person_Hobby>(".example.Person.Hobby", _proto_proto__descriptor)

public enum Person_Hobby <: EnumValue & TypedEnum<Person_Hobby> {
    Sleep | Study | Work | Game

    public func value(): Int32 {
        match(this) {
            case Sleep => 2
            case Study => 3
            case Work => 8
            case Game => 9
        }
    }

    public func toString(): String {
        match(this) {
            case Sleep => "Sleep"
            case Study => "Study"
            case Work => "Work"
            case Game => "Game"
        }
    }

    public operator func==(value: Person_Hobby) {
        match((this, value)) {
            case (Sleep, Sleep) => true
            case (Study, Study) => true
            case (Work, Work) => true
            case (Game, Game) => true
            case _ => false
        }
    }

    public static func parse(value: Int32): Person_Hobby {
        match(value) {
            case 2 => Sleep
            case 3 => Study
            case 8 => Work
            case 9 => Game
            case _ => throw InvalidEnumValueException("Person_Hobby", value)
        }
    }

    public static func parse(value: String): Person_Hobby {
        match(value) {
            case "Sleep" => Sleep
            case "Study" => Study
            case "Work" => Work
            case "Game" => Game
            case _ => throw UnmatchedEnumStringException("Person_Hobby", value)
        }
    }

    public static func descriptor(): EnumDescriptor { _Person_Hobby__descriptor.get() }
}

let _Person__descriptor = _internalAddGeneratedMessage<Person>(".example.Person", _proto_proto__descriptor)

public class Person <: Message & TypedMessage<Person> {
    private var p_id: ?Int32
    private var p_name: ?String
    private var p_email: ?String
    private var p_gender: ?Person_Gender
    public let hobby: RepeatedField<Person_Hobby>

    public init(
        id!: ?Int32 = None,
        name!: ?String = None,
        email!: ?String = None,
        gender!: ?Person_Gender = None,
        hobby!: Array<Person_Hobby> = []
    ) {
        this.p_id = id
        this.p_name = name
        this.p_email = email
        this.p_gender = gender
        this.hobby = RepeatedField<Person_Hobby>(hobby)
        m_init()
    }

    public init(src: Person__Builder) {
        this.p_id = src.id
        this.p_name = src.name
        this.p_email = src.email
        this.p_gender = src.gender
        this.hobby = RepeatedField<Person_Hobby>(src.hobby)
        m_init()
    }

    private func m_init() {
        m_init(hobby)
        m_innerInit()
    }

    public func clearId() { p_id = None; markDirty() }
    public prop hasId: Bool { get() { isPresent(p_id) } }
    public mut prop id: Int32 { get() { p_id.getOrThrow() } set(_x) { p_id = _x; markDirty() } }
    public func tryGetId() { p_id }

    public func clearName() { p_name = None; markDirty() }
    public prop hasName: Bool { get() { isPresent(p_name) } }
    public mut prop name: String { get() { p_name.getOrThrow() } set(_x) { p_name = _x; markDirty() } }
    public func tryGetName() { p_name }

    public func clearEmail() { p_email = None; markDirty() }
    public prop hasEmail: Bool { get() { isPresent(p_email) } }
    public mut prop email: String { get() { p_email.getOrThrow() } set(_x) { p_email = _x; markDirty() } }
    public func tryGetEmail() { p_email }

    public func clearGender() { p_gender = None; markDirty() }
    public prop hasGender: Bool { get() { isPresent(p_gender) } }
    public mut prop gender: Person_Gender { get() { p_gender.getOrThrow() } set(_x) { p_gender = _x; markDirty() } }
    public func tryGetGender() { p_gender }

    public static func descriptor(): MessageDescriptor { _Person__descriptor.get() }
    public func getDescriptor(): MessageDescriptor { descriptor() }

    protected func m_get(_t: Tag): Option<Field> {
        match (_t) {
            case 1 where hasId => id
            case 2 where hasName => name
            case 3 where hasEmail => email
            case 4 where hasGender => gender
            case 14 => hobby
            case _ => None
        }
    }

    protected func m_set(_t: Tag, _v: Field): Unit { /* throws */
        match (_t) {
            case 1 => id = typecast(_v)
            case 2 => name = typecast(_v)
            case 3 => email = typecast(_v)
            case 4 => gender = typecast(_v)
            case _ => throw InvalidOperationException()
        }
    }

    protected func m_reset(_t: Tag): Unit {
        match (_t) {
            case 1 => p_id = None
            case 2 => p_name = None
            case 3 => p_email = None
            case 4 => p_gender = None
            case 14 => hobby.clear()
            case _ => return
        }
        markDirty()
    }

    protected func m_size(): Int64 {
        var _x = 0
        if (let Some(_v) <- p_id) { _x += 1 + varintSize(_v) }
        if (let Some(_v) <- p_name) { _x += 1 + binSize(_v) }
        if (let Some(_v) <- p_email) { _x += 1 + binSize(_v) }
        if (let Some(_v) <- p_gender) { _x += 1 + varintSize(_v) }
        if (!hobby.isEmpty()) { for (_i in hobby) { _x += 1 + varintSize(_i) } }
        return _x
    }

    protected func m_hashCode(): Int64 {
        var _x = DefaultHasher()
        if (let Some(_v) <- p_id) { _x.write(_v) }
        if (let Some(_v) <- p_name) { _x.write(_v.hashCode()) }
        if (let Some(_v) <- p_email) { _x.write(_v.hashCode()) }
        if (let Some(_v) <- p_gender) { _x.write(_v.hashCode()) }
        if (!hobby.isEmpty()) { _x.write(hobby.hashCode()) }
        return _x.finish()
    }

    protected func m_isEmpty(): Bool {
        isNone(p_id) && isNone(p_name) && isNone(p_email) && isNone(p_gender) && hobby.isEmpty()
    }

    protected func m_clear(): Unit {
        p_id = None
        p_name = None
        p_email = None
        p_gender = None
        hobby.clear()
    }

    public operator func ==(src: MessageLite): Bool { src as Person == this }
    public operator func ==(src: Person): Bool {
        m_innerEquals(src) && p_id == src.p_id && p_name == src.p_name && p_email == src.p_email &&
        p_gender == src.p_gender && hobby == src.hobby
    }

    public func copyFrom(src: Person): Person {
        p_id = src.p_id
        p_name = src.p_name
        p_email = src.p_email
        p_gender = src.p_gender
        hobby.copyFrom(src.hobby)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): Person {
        return Person().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let _x = src.parseTag()
            match (_x[0]) {
                case 1 => p_id = src.parseInt32()
                case 2 => p_name = src.parseString()
                case 3 => p_email = src.parseString()
                case 4 => p_gender = Person_Gender.parse(src.parseInt32())
                case 14 => s_add(hobby, Person_Hobby.parse(src.parseInt32()))
                case _ => m_unknown(src, _x)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
        if (isNone(p_id)) { throw RequiredFieldNotSetException("id") }
        if (isNone(p_name)) { throw RequiredFieldNotSetException("name") }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(_v) <- p_id) { out.append(8); out.packVarint(_v) }
        if (let Some(_v) <- p_name) { out.append(18); out.packBin(_v) }
        if (let Some(_v) <- p_email) { out.append(26); out.packBin(_v) }
        if (let Some(_v) <- p_gender) { out.append(32); out.packVarint(_v) }
        if (!hobby.isEmpty()) { for (_i in hobby) { out.append(112); out.packVarint(_i) } }
        m_unknown(out)
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (let Some(_v) <- p_id) { _x.append("id", _v) }
        if (let Some(_v) <- p_name) { _x.append("name", _v) }
        if (let Some(_v) <- p_email) { _x.append("email", _v) }
        if (let Some(_v) <- p_gender) { _x.append("gender", _v) }
        if (!hobby.isEmpty()) { _x.append("hobby", hobby) }
        return _x.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case _x: SimpleWriter => pack(_x) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case _x: SimpleReader => unpack(_x) case _ => unpack(src) } }

    public static func empty() { Person() }
    public static func newBuilder() { Person__Builder() }
    public static func fromBytes(src: Collection<Byte>) { let _x = Person(); _x.unpack(src); _x }
    public static func fromBytes(src: BytesReader) { let _x = Person(); _x.unpack(src); _x }
}

public class Person__Builder {
    public var id: ?Int32 = None
    public func setId(id: Int32) { this.id = id; return this }

    public var name: ?String = None
    public func setName(name: String) { this.name = name; return this }

    public var email: ?String = None
    public func setEmail(email: String) { this.email = email; return this }

    public var gender: ?Person_Gender = None
    public func setGender(gender: Person_Gender) { this.gender = gender; return this }

    public var hobby: Array<Person_Hobby> = []
    public func setHobby(hobby: Array<Person_Hobby>) { this.hobby = hobby; return this }

    public func build() { Person(this) }
}

let _Class__descriptor = _internalAddGeneratedMessage<Class>(".example.Class", _proto_proto__descriptor)

public class Class <: Message & TypedMessage<Class> {
    public let person: MapMessage<Int32, Person>
    public let name: MapField<Int32, String>
    public let teacher: RepeatedMessage<Person>

    public init(
        person!: Array<(Int32, Person)> = [],
        name!: Array<(Int32, String)> = [],
        teacher!: Array<Person> = []
    ) {
        this.person = MapMessage<Int32, Person>(person)
        this.name = MapField<Int32, String>(name)
        this.teacher = RepeatedMessage<Person>(teacher)
        m_init()
    }

    public init(src: Class__Builder) {
        this.person = MapMessage<Int32, Person>(src.person)
        this.name = MapField<Int32, String>(src.name)
        this.teacher = RepeatedMessage<Person>(src.teacher)
        m_init()
    }

    private func m_init() {
        m_init(person)
        m_init(name)
        m_init(teacher)
        m_innerInit()
    }

    public static func descriptor(): MessageDescriptor { _Class__descriptor.get() }
    public func getDescriptor(): MessageDescriptor { descriptor() }

    protected func m_get(_t: Tag): Option<Field> {
        match (_t) {
            case 1 => person
            case 2 => name
            case 4 => teacher
            case _ => None
        }
    }

    protected func m_set(_t: Tag, _v: Field): Unit { /* throws */
        match (_t) {
            case _ => throw InvalidOperationException()
        }
    }

    protected func m_reset(_t: Tag): Unit {
        match (_t) {
            case 1 => person.clear()
            case 2 => name.clear()
            case 4 => teacher.clear()
            case _ => return
        }
        markDirty()
    }

    protected func m_size(): Int64 {
        var _x = 0
        if (!person.isEmpty()) { for ((_k, _v) in person) { var _s = 0; if (_k != 0) { _s += 1 + varintSize(_k) }; if (!_v.isEmpty()) { _s += 1 + binSize(_v) }; _x += 1 + varintSize(_s) + _s } }
        if (!name.isEmpty()) { for ((_k, _v) in name) { var _s = 0; if (_k != 0) { _s += 1 + varintSize(_k) }; if (!_v.isEmpty()) { _s += 1 + binSize(_v) }; _x += 1 + varintSize(_s) + _s } }
        if (!teacher.isEmpty()) { for (_i in teacher) { _x += 1 + binSize(_i) } }
        return _x
    }

    protected func m_hashCode(): Int64 {
        var _x = DefaultHasher()
        if (!person.isEmpty()) { _x.write(person.hashCode()) }
        if (!name.isEmpty()) { _x.write(name.hashCode()) }
        if (!teacher.isEmpty()) { _x.write(teacher.hashCode()) }
        return _x.finish()
    }

    protected func m_isEmpty(): Bool {
        person.isEmpty() && name.isEmpty() && teacher.isEmpty()
    }

    protected func m_clear(): Unit {
        person.clear()
        name.clear()
        teacher.clear()
    }

    public operator func ==(src: MessageLite): Bool { src as Class == this }
    public operator func ==(src: Class): Bool {
        m_innerEquals(src) && person == src.person && name == src.name && teacher == src.teacher
    }

    public func copyFrom(src: Class): Class {
        person.copyFrom(src.person)
        name.copyFrom(src.name)
        teacher.copyFrom(src.teacher)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): Class {
        return Class().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let _x = src.parseTag()
            match (_x[0]) {
                case 1 => let _s = subReader(src); var _k = Int32(0); var _v = Person(); while (!_s.isEmpty()) { match (_s.parseTag()[0]) { case 1 => _k = _s.parseInt32() case 2 => _v.unpack(subReader(_s)) case _ => throw ParseValueExecption("map") } }; s_add(person, _k, _v)
                case 2 => let _s = subReader(src); var _k = Int32(0); var _v = ""; while (!_s.isEmpty()) { match (_s.parseTag()[0]) { case 1 => _k = _s.parseInt32() case 2 => _v = _s.parseString() case _ => throw ParseValueExecption("map") } }; s_add(name, _k, _v)
                case 4 => s_add(teacher, src)
                case _ => m_unknown(src, _x)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (!person.isEmpty()) { for ((_k, _v) in person) { out.append(10); var _s = 0; if (_k != 0) { _s += 1 + varintSize(_k) }; if (!_v.isEmpty()) { _s += 1 + binSize(_v) }; out.packVarint(_s); if (_k != 0) { out.append(8); out.packVarint(_k) }; if (!_v.isEmpty()) { out.append(18); out.packVarint(_v.size); _v.pack(out) } } }
        if (!name.isEmpty()) { for ((_k, _v) in name) { out.append(18); var _s = 0; if (_k != 0) { _s += 1 + varintSize(_k) }; if (!_v.isEmpty()) { _s += 1 + binSize(_v) }; out.packVarint(_s); if (_k != 0) { out.append(8); out.packVarint(_k) }; if (!_v.isEmpty()) { out.append(18); out.packBin(_v) } } }
        if (!teacher.isEmpty()) { for (_i in teacher) { out.append(34); out.packVarint(_i.size); _i.pack(out) } }
        m_unknown(out)
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (!person.isEmpty()) { _x.append("person", person) }
        if (!name.isEmpty()) { _x.append("name", name) }
        if (!teacher.isEmpty()) { _x.append("teacher", teacher) }
        return _x.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case _x: SimpleWriter => pack(_x) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case _x: SimpleReader => unpack(_x) case _ => unpack(src) } }

    public static func empty() { Class() }
    public static func newBuilder() { Class__Builder() }
    public static func fromBytes(src: Collection<Byte>) { let _x = Class(); _x.unpack(src); _x }
    public static func fromBytes(src: BytesReader) { let _x = Class(); _x.unpack(src); _x }
}

public class Class__Builder {
    public var person: Array<(Int32, Person)> = []
    public func setPerson(person: Array<(Int32, Person)>) { this.person = person; return this }

    public var name: Array<(Int32, String)> = []
    public func setName(name: Array<(Int32, String)>) { this.name = name; return this }

    public var teacher: Array<Person> = []
    public func setTeacher(teacher: Array<Person>) { this.teacher = teacher; return this }

    public func build() { Class(this) }
}
