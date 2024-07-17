package grouptest

from std import collection.*
from protobuf import protobuf.*

public class Person_Teacher <: MessageLite & TypedMessage<Person_Teacher> {
    private var p_name: String
    private var p_age: Int32
    private var p_gender: Person_Gender
    private var p_subject: Person_Subject

    public init(
        name!: String = "",
        age!: Int32 = Int32(0),
        gender!: Person_Gender = Person_Gender.empty(),
        subject!: Person_Subject = Person_Subject.empty()
    ) {
        this.p_name = name
        this.p_age = age
        this.p_gender = gender
        this.p_subject = subject
        m_init()
    }

    public init(src: Person_Teacher__Builder) {
        this.p_name = src.name
        this.p_age = src.age
        this.p_gender = src.gender
        this.p_subject = src.subject
        m_init()
    }

    private func m_init() {
        m_innerInit()
    }

    public mut prop name: String { get() { p_name } set(_v) { p_name = _v; markDirty() } }

    public mut prop age: Int32 { get() { p_age } set(_v) { p_age = _v; markDirty() } }

    public mut prop gender: Person_Gender { get() { p_gender } set(_v) { p_gender = _v; markDirty() } }

    public mut prop subject: Person_Subject { get() { p_subject } set(_v) { p_subject = _v; markDirty() } }

    protected func m_size(): Int64 {
        var _x = 0
        if (!p_name.isEmpty()) { _x += 1 + binSize(p_name) }
        if (p_age != 0) { _x += 1 + varintSize(p_age) }
        if (!p_gender.isEmpty()) { _x += 1 + varintSize(p_gender) }
        if (!p_subject.isEmpty()) { _x += 1 + varintSize(p_subject) }
        return _x
    }

    protected func m_hashCode(): Int64 {
        var _x = DefaultHasher()
        if (!p_name.isEmpty()) { _x.write(p_name.hashCode()) }
        if (p_age != 0) { _x.write(p_age) }
        if (!p_gender.isEmpty()) { _x.write(p_gender.hashCode()) }
        if (!p_subject.isEmpty()) { _x.write(p_subject.hashCode()) }
        return _x.finish()
    }

    protected func m_isEmpty(): Bool {
        p_name.isEmpty() && p_age == 0 && p_gender.isEmpty() && p_subject.isEmpty()
    }

    protected func m_clear(): Unit {
        p_name = ""
        p_age = 0
        p_gender = Person_Gender.empty()
        p_subject = Person_Subject.empty()
    }

    public operator func !=(src: Person_Teacher): Bool { !(this == src) }
    public operator func ==(src: Person_Teacher): Bool {
        hashCode() == src.hashCode() && size == src.size && unknownFields == src.unknownFields &&
        p_name == src.p_name && p_age == src.p_age && p_gender == src.p_gender && p_subject == src.p_subject
    }

    public func mergeFrom(src: Person_Teacher): Unit {
        if (!src.p_name.isEmpty()) { p_name = src.p_name }
        if (src.p_age != 0) { p_age = src.p_age }
        if (!src.p_gender.isEmpty()) { p_gender = src.p_gender }
        if (!src.p_subject.isEmpty()) { p_subject = src.p_subject }
        if (!src.unknownFields.isEmpty()) { unknownFields.appendAll(src.unknownFields) }
        markDirty()
    }

    public func copyFrom(src: Person_Teacher): Person_Teacher {
        p_name = src.p_name
        p_age = src.p_age
        p_gender = src.p_gender
        p_subject = src.p_subject
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): Person_Teacher {
        return Person_Teacher().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let _x = src.parseTag()
            match (_x[0]) {
                case 1 => p_name = src.parseString()
                case 2 => p_age = src.parseInt32()
                case 3 => p_gender = Person_Gender.parse(src.parseInt32())
                case 4 => p_subject = Person_Subject.parse(src.parseInt32())
                case _ => m_unknown(src, _x)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (!p_name.isEmpty()) { out.append(10); out.packBin(p_name) }
        if (p_age != 0) { out.append(16); out.packVarint(p_age) }
        if (!p_gender.isEmpty()) { out.append(24); out.packVarint(p_gender) }
        if (!p_subject.isEmpty()) { out.append(32); out.packVarint(p_subject) }
        m_unknown(out)
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (!p_name.isEmpty()) { _x.append("name", p_name) }
        if (p_age != 0) { _x.append("age", p_age) }
        if (!p_gender.isEmpty()) { _x.append("gender", p_gender) }
        if (!p_subject.isEmpty()) { _x.append("subject", p_subject) }
        return _x.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case _x: SimpleWriter => pack(_x) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case _x: SimpleReader => unpack(_x) case _ => unpack(src) } }

    public static func empty() { Person_Teacher() }
    public static func newBuilder() { Person_Teacher__Builder() }
    public static func fromBytes(src: Collection<Byte>) { let _x = Person_Teacher(); _x.unpack(src); _x }
    public static func fromBytes(src: BytesReader) { let _x = Person_Teacher(); _x.unpack(src); _x }
}

public class Person_Teacher__Builder {
    public var name: String = ""
    public func setName(name: String) { this.name = name; return this }

    public var age: Int32 = Int32(0)
    public func setAge(age: Int32) { this.age = age; return this }

    public var gender: Person_Gender = Person_Gender.empty()
    public func setGender(gender: Person_Gender) { this.gender = gender; return this }

    public var subject: Person_Subject = Person_Subject.empty()
    public func setSubject(subject: Person_Subject) { this.subject = subject; return this }

    public func build() { Person_Teacher(this) }
}

public class Person_Student_TestRecord <: MessageLite & TypedMessage<Person_Student_TestRecord> {
    private var p_subject: Person_Subject
    private var p_score: Int32

    public init(
        subject!: Person_Subject = Person_Subject.empty(),
        score!: Int32 = Int32(0)
    ) {
        this.p_subject = subject
        this.p_score = score
        m_init()
    }

    public init(src: Person_Student_TestRecord__Builder) {
        this.p_subject = src.subject
        this.p_score = src.score
        m_init()
    }

    private func m_init() {
        m_innerInit()
    }

    public mut prop subject: Person_Subject { get() { p_subject } set(_v) { p_subject = _v; markDirty() } }

    public mut prop score: Int32 { get() { p_score } set(_v) { p_score = _v; markDirty() } }

    protected func m_size(): Int64 {
        var _x = 0
        if (!p_subject.isEmpty()) { _x += 1 + varintSize(p_subject) }
        if (p_score != 0) { _x += 1 + varintSize(p_score) }
        return _x
    }

    protected func m_hashCode(): Int64 {
        var _x = DefaultHasher()
        if (!p_subject.isEmpty()) { _x.write(p_subject.hashCode()) }
        if (p_score != 0) { _x.write(p_score) }
        return _x.finish()
    }

    protected func m_isEmpty(): Bool {
        p_subject.isEmpty() && p_score == 0
    }

    protected func m_clear(): Unit {
        p_subject = Person_Subject.empty()
        p_score = 0
    }

    public operator func !=(src: Person_Student_TestRecord): Bool { !(this == src) }
    public operator func ==(src: Person_Student_TestRecord): Bool {
        hashCode() == src.hashCode() && size == src.size && unknownFields == src.unknownFields &&
        p_subject == src.p_subject && p_score == src.p_score
    }

    public func mergeFrom(src: Person_Student_TestRecord): Unit {
        if (!src.p_subject.isEmpty()) { p_subject = src.p_subject }
        if (src.p_score != 0) { p_score = src.p_score }
        if (!src.unknownFields.isEmpty()) { unknownFields.appendAll(src.unknownFields) }
        markDirty()
    }

    public func copyFrom(src: Person_Student_TestRecord): Person_Student_TestRecord {
        p_subject = src.p_subject
        p_score = src.p_score
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): Person_Student_TestRecord {
        return Person_Student_TestRecord().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let _x = src.parseTag()
            match (_x[0]) {
                case 1 => p_subject = Person_Subject.parse(src.parseInt32())
                case 2 => p_score = src.parseInt32()
                case _ => m_unknown(src, _x)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (!p_subject.isEmpty()) { out.append(8); out.packVarint(p_subject) }
        if (p_score != 0) { out.append(16); out.packVarint(p_score) }
        m_unknown(out)
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (!p_subject.isEmpty()) { _x.append("subject", p_subject) }
        if (p_score != 0) { _x.append("score", p_score) }
        return _x.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case _x: SimpleWriter => pack(_x) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case _x: SimpleReader => unpack(_x) case _ => unpack(src) } }

    public static func empty() { Person_Student_TestRecord() }
    public static func newBuilder() { Person_Student_TestRecord__Builder() }
    public static func fromBytes(src: Collection<Byte>) { let _x = Person_Student_TestRecord(); _x.unpack(src); _x }
    public static func fromBytes(src: BytesReader) { let _x = Person_Student_TestRecord(); _x.unpack(src); _x }
}

public class Person_Student_TestRecord__Builder {
    public var subject: Person_Subject = Person_Subject.empty()
    public func setSubject(subject: Person_Subject) { this.subject = subject; return this }

    public var score: Int32 = Int32(0)
    public func setScore(score: Int32) { this.score = score; return this }

    public func build() { Person_Student_TestRecord(this) }
}

public class Person_Student <: MessageLite & TypedMessage<Person_Student> {
    private var p_name: String
    private var p_age: Int32
    private var p_gender: Person_Gender
    public let records: RepeatedMessage<Person_Student_TestRecord>

    public init(
        name!: String = "",
        age!: Int32 = Int32(0),
        gender!: Person_Gender = Person_Gender.empty(),
        records!: Array<Person_Student_TestRecord> = []
    ) {
        this.p_name = name
        this.p_age = age
        this.p_gender = gender
        this.records = RepeatedMessage<Person_Student_TestRecord>(records)
        m_init()
    }

    public init(src: Person_Student__Builder) {
        this.p_name = src.name
        this.p_age = src.age
        this.p_gender = src.gender
        this.records = RepeatedMessage<Person_Student_TestRecord>(src.records)
        m_init()
    }

    private func m_init() {
        m_init(records)
        m_innerInit()
    }

    public mut prop name: String { get() { p_name } set(_v) { p_name = _v; markDirty() } }

    public mut prop age: Int32 { get() { p_age } set(_v) { p_age = _v; markDirty() } }

    public mut prop gender: Person_Gender { get() { p_gender } set(_v) { p_gender = _v; markDirty() } }

    protected func m_size(): Int64 {
        var _x = 0
        if (!p_name.isEmpty()) { _x += 1 + binSize(p_name) }
        if (p_age != 0) { _x += 1 + varintSize(p_age) }
        if (!p_gender.isEmpty()) { _x += 1 + varintSize(p_gender) }
        if (!records.isEmpty()) { for (_i in records) { _x += 1 + binSize(_i) } }
        return _x
    }

    protected func m_hashCode(): Int64 {
        var _x = DefaultHasher()
        if (!p_name.isEmpty()) { _x.write(p_name.hashCode()) }
        if (p_age != 0) { _x.write(p_age) }
        if (!p_gender.isEmpty()) { _x.write(p_gender.hashCode()) }
        if (!records.isEmpty()) { _x.write(records.hashCode()) }
        return _x.finish()
    }

    protected func m_isEmpty(): Bool {
        p_name.isEmpty() && p_age == 0 && p_gender.isEmpty() && records.isEmpty()
    }

    protected func m_clear(): Unit {
        p_name = ""
        p_age = 0
        p_gender = Person_Gender.empty()
        records.clear()
    }

    public operator func !=(src: Person_Student): Bool { !(this == src) }
    public operator func ==(src: Person_Student): Bool {
        hashCode() == src.hashCode() && size == src.size && unknownFields == src.unknownFields &&
        p_name == src.p_name && p_age == src.p_age && p_gender == src.p_gender && records == src.records
    }

    public func mergeFrom(src: Person_Student): Unit {
        if (!src.p_name.isEmpty()) { p_name = src.p_name }
        if (src.p_age != 0) { p_age = src.p_age }
        if (!src.p_gender.isEmpty()) { p_gender = src.p_gender }
        if (!src.records.isEmpty()) { records.appendAll(src.records) }
        if (!src.unknownFields.isEmpty()) { unknownFields.appendAll(src.unknownFields) }
        markDirty()
    }

    public func copyFrom(src: Person_Student): Person_Student {
        p_name = src.p_name
        p_age = src.p_age
        p_gender = src.p_gender
        records.copyFrom(src.records)
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): Person_Student {
        return Person_Student().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let _x = src.parseTag()
            match (_x[0]) {
                case 1 => p_name = src.parseString()
                case 2 => p_age = src.parseInt32()
                case 3 => p_gender = Person_Gender.parse(src.parseInt32())
                case 4 => s_add(records, src)
                case _ => m_unknown(src, _x)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (!p_name.isEmpty()) { out.append(10); out.packBin(p_name) }
        if (p_age != 0) { out.append(16); out.packVarint(p_age) }
        if (!p_gender.isEmpty()) { out.append(24); out.packVarint(p_gender) }
        if (!records.isEmpty()) { for (_i in records) { out.append(34); out.packVarint(_i.size); _i.pack(out) } }
        m_unknown(out)
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (!p_name.isEmpty()) { _x.append("name", p_name) }
        if (p_age != 0) { _x.append("age", p_age) }
        if (!p_gender.isEmpty()) { _x.append("gender", p_gender) }
        if (!records.isEmpty()) { _x.append("records", records) }
        return _x.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case _x: SimpleWriter => pack(_x) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case _x: SimpleReader => unpack(_x) case _ => unpack(src) } }

    public static func empty() { Person_Student() }
    public static func newBuilder() { Person_Student__Builder() }
    public static func fromBytes(src: Collection<Byte>) { let _x = Person_Student(); _x.unpack(src); _x }
    public static func fromBytes(src: BytesReader) { let _x = Person_Student(); _x.unpack(src); _x }
}

public class Person_Student__Builder {
    public var name: String = ""
    public func setName(name: String) { this.name = name; return this }

    public var age: Int32 = Int32(0)
    public func setAge(age: Int32) { this.age = age; return this }

    public var gender: Person_Gender = Person_Gender.empty()
    public func setGender(gender: Person_Gender) { this.gender = gender; return this }

    public var records: Array<Person_Student_TestRecord> = []
    public func setRecords(records: Array<Person_Student_TestRecord>) { this.records = records; return this }

    public func build() { Person_Student(this) }
}

public enum Person_Gender <: Enum<Person_Gender> {
    MAN | FEMALE

    public func value(): Int32 {
        match(this) {
            case MAN => 0
            case FEMALE => 1
        }
    }

    public func toString(): String {
        match(this) {
            case MAN => "MAN"
            case FEMALE => "FEMALE"
        }
    }

    public operator func==(value: Person_Gender) {
        match((this, value)) {
            case (MAN, MAN) => true
            case (FEMALE, FEMALE) => true
            case _ => false
        }
    }

    public func isEmpty() { match (this) { case MAN => true case _ => false } }

    public static func empty(): Person_Gender { MAN }

    public static func parse(value: Int32): Person_Gender {
        match(value) {
            case 0 => MAN
            case 1 => FEMALE
            case _ => throw InvalidEnumValueException("Person_Gender", value)
        }
    }

    public static func parse(value: String): Person_Gender {
        match(value) {
            case "MAN" => MAN
            case "FEMALE" => FEMALE
            case _ => throw UnmatchedEnumStringException("Person_Gender", value)
        }
    }
}

public enum Person_Subject <: Enum<Person_Subject> {
    LANGUAGE | MATH | HISTORY

    public func value(): Int32 {
        match(this) {
            case LANGUAGE => 0
            case MATH => 1
            case HISTORY => 2
        }
    }

    public func toString(): String {
        match(this) {
            case LANGUAGE => "LANGUAGE"
            case MATH => "MATH"
            case HISTORY => "HISTORY"
        }
    }

    public operator func==(value: Person_Subject) {
        match((this, value)) {
            case (LANGUAGE, LANGUAGE) => true
            case (MATH, MATH) => true
            case (HISTORY, HISTORY) => true
            case _ => false
        }
    }

    public func isEmpty() { match (this) { case LANGUAGE => true case _ => false } }

    public static func empty(): Person_Subject { LANGUAGE }

    public static func parse(value: Int32): Person_Subject {
        match(value) {
            case 0 => LANGUAGE
            case 1 => MATH
            case 2 => HISTORY
            case _ => throw InvalidEnumValueException("Person_Subject", value)
        }
    }

    public static func parse(value: String): Person_Subject {
        match(value) {
            case "LANGUAGE" => LANGUAGE
            case "MATH" => MATH
            case "HISTORY" => HISTORY
            case _ => throw UnmatchedEnumStringException("Person_Subject", value)
        }
    }
}

public class Person <: MessageLite & TypedMessage<Person> {
    public init() { m_innerInit() }
    protected func m_size(): Int64 { 0 }
    protected func m_hashCode(): Int64 { 0 }
    protected func m_isEmpty(): Bool { true }
    protected func m_clear(): Unit { }
    public operator func !=(src: Person): Bool { !(this == src) }
    public operator func ==(src: Person): Bool { hashCode() == src.hashCode() && size == src.size && unknownFields == src.unknownFields }
    public func mergeFrom(src: Person): Unit { if(!src.unknownFields.isEmpty()) { unknownFields.appendAll(src.unknownFields) } }
    public func copyFrom(src: Person): Person { m_innerCopyFrom(src); return this }
    public func clone(): Person { return Person().copyFrom(this) }
    public func unpack<T>(src: T): Unit where T <: BytesReader { while (!src.isEmpty()) { m_unknown(src, src.parseTag()) }; markDirty() }
    public func pack<T>(out: T): Unit where T <: BytesWriter { m_unknown(out) }
    public func toString(): String { "{}" }
    public func packi(out: BytesWriter) { pack(out) }
    public func unpacki(src: BytesReader) { unpack(src) }

    public static func empty() { Person() }
    public static func fromBytes(src: Collection<Byte>) { let m = Person(); m.unpack(src); m }
    public static func fromBytes(src: BytesReader) { let m = Person(); m.unpack(src); m }
}

public class School <: MessageLite & TypedMessage<School> {
    public let teacherArray: RepeatedMessage<Person_Teacher>
    public let studentArray: RepeatedMessage<Person_Student>
    private var p_testOneof: School_Oneof_TestOneof

    public init(
        teacherArray!: Array<Person_Teacher> = [],
        studentArray!: Array<Person_Student> = [],
        testOneof!: School_Oneof_TestOneof = School_Oneof_TestOneof.None
    ) {
        this.teacherArray = RepeatedMessage<Person_Teacher>(teacherArray)
        this.studentArray = RepeatedMessage<Person_Student>(studentArray)
        this.p_testOneof = testOneof
        m_init()
    }

    public init(src: School__Builder) {
        this.teacherArray = RepeatedMessage<Person_Teacher>(src.teacherArray)
        this.studentArray = RepeatedMessage<Person_Student>(src.studentArray)
        this.p_testOneof = src.testOneof
        m_init()
    }

    private func m_init() {
        m_init(teacherArray)
        m_init(studentArray)
        m_init(p_testOneof)
        m_innerInit()
    }

    public mut prop testOneof: School_Oneof_TestOneof { get() { p_testOneof } set(_v) { m_assign(p_testOneof, _v); p_testOneof = _v; markDirty() } }

    public prop hasId: Bool { get() { match(p_testOneof) { case Id(_) => true case _ => false } } }
    public mut prop id: String { get() { match (p_testOneof) { case Id(_v) => _v case _ => throw UnexpectedOneofException() } } set(_v) { m_assign(p_testOneof); p_testOneof = School_Oneof_TestOneof.Id(_v); markDirty() } }

    public prop hasNumber: Bool { get() { match(p_testOneof) { case Number(_) => true case _ => false } } }
    public mut prop number: String { get() { match (p_testOneof) { case Number(_v) => _v case _ => throw UnexpectedOneofException() } } set(_v) { m_assign(p_testOneof); p_testOneof = School_Oneof_TestOneof.Number(_v); markDirty() } }

    public prop hasNikename: Bool { get() { match(p_testOneof) { case Nikename(_) => true case _ => false } } }
    public mut prop nikename: String { get() { match (p_testOneof) { case Nikename(_v) => _v case _ => throw UnexpectedOneofException() } } set(_v) { m_assign(p_testOneof); p_testOneof = School_Oneof_TestOneof.Nikename(_v); markDirty() } }

    protected func m_size(): Int64 {
        var _x = 0
        if (!teacherArray.isEmpty()) { for (_i in teacherArray) { _x += 1 + binSize(_i) } }
        if (!studentArray.isEmpty()) { for (_i in studentArray) { _x += 1 + binSize(_i) } }
        match (p_testOneof) {
            case Id(_v) => _x += 1 + binSize(_v)
            case Number(_v) => _x += 1 + binSize(_v)
            case Nikename(_v) => _x += 1 + binSize(_v)
            case _ => ()
        }
        return _x
    }

    protected func m_hashCode(): Int64 {
        var _x = DefaultHasher()
        if (!teacherArray.isEmpty()) { _x.write(teacherArray.hashCode()) }
        if (!studentArray.isEmpty()) { _x.write(studentArray.hashCode()) }
        if (!p_testOneof.isEmpty()) { _x.write(p_testOneof.hashCode()) }
        return _x.finish()
    }

    protected func m_isEmpty(): Bool {
        teacherArray.isEmpty() && studentArray.isEmpty() && p_testOneof.isEmpty()
    }

    protected func m_clear(): Unit {
        teacherArray.clear()
        studentArray.clear()
        m_assign(p_testOneof); p_testOneof = None
    }

    public operator func !=(src: School): Bool { !(this == src) }
    public operator func ==(src: School): Bool {
        hashCode() == src.hashCode() && size == src.size && unknownFields == src.unknownFields &&
        teacherArray == src.teacherArray && studentArray == src.studentArray && p_testOneof == src.p_testOneof
    }

    public func mergeFrom(src: School): Unit {
        if (!src.teacherArray.isEmpty()) { teacherArray.appendAll(src.teacherArray) }
        if (!src.studentArray.isEmpty()) { studentArray.appendAll(src.studentArray) }
        if (!src.p_testOneof.isEmpty()) { testOneof = src.p_testOneof.clone() }
        if (!src.unknownFields.isEmpty()) { unknownFields.appendAll(src.unknownFields) }
        markDirty()
    }

    public func copyFrom(src: School): School {
        teacherArray.copyFrom(src.teacherArray)
        studentArray.copyFrom(src.studentArray)
        m_assign(p_testOneof); p_testOneof = m_init(src.p_testOneof.clone())
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): School {
        return School().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let _x = src.parseTag()
            match (_x[0]) {
                case 1 => s_add(teacherArray, src)
                case 2 => s_add(studentArray, src)
                case 3 => testOneof = School_Oneof_TestOneof.Id(src.parseString())
                case 4 => testOneof = School_Oneof_TestOneof.Number(src.parseString())
                case 5 => testOneof = School_Oneof_TestOneof.Nikename(src.parseString())
                case _ => m_unknown(src, _x)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (!teacherArray.isEmpty()) { for (_i in teacherArray) { out.append(10); out.packVarint(_i.size); _i.pack(out) } }
        if (!studentArray.isEmpty()) { for (_i in studentArray) { out.append(18); out.packVarint(_i.size); _i.pack(out) } }
        match (p_testOneof) {
            case Id(_v) => out.append(26); out.packBin(_v)
            case Number(_v) => out.append(34); out.packBin(_v)
            case Nikename(_v) => out.append(42); out.packBin(_v)
            case _ => ()
        }
        m_unknown(out)
    }

    public func toString(): String {
        var _x = StructPrinter()
        if (!teacherArray.isEmpty()) { _x.append("teacherArray", teacherArray) }
        if (!studentArray.isEmpty()) { _x.append("studentArray", studentArray) }
        if (!p_testOneof.isEmpty()) { _x.append(p_testOneof.which(), p_testOneof) }
        return _x.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case _x: SimpleWriter => pack(_x) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case _x: SimpleReader => unpack(_x) case _ => unpack(src) } }

    public static func empty() { School() }
    public static func newBuilder() { School__Builder() }
    public static func fromBytes(src: Collection<Byte>) { let _x = School(); _x.unpack(src); _x }
    public static func fromBytes(src: BytesReader) { let _x = School(); _x.unpack(src); _x }
}

public class School__Builder {
    public var teacherArray: Array<Person_Teacher> = []
    public func setTeacherArray(teacherArray: Array<Person_Teacher>) { this.teacherArray = teacherArray; return this }

    public var studentArray: Array<Person_Student> = []
    public func setStudentArray(studentArray: Array<Person_Student>) { this.studentArray = studentArray; return this }

    public var testOneof = School_Oneof_TestOneof.None
    public func setTestOneof(testOneof: School_Oneof_TestOneof) { this.testOneof = testOneof; return this }

    public func build() { School(this) }
}

public enum School_Oneof_TestOneof <: OneofGroup & Equatable<School_Oneof_TestOneof> {
    Id(String) | Number(String) | Nikename(String) | None

    public func clone(): School_Oneof_TestOneof {
        match (this) {
            case _ => this
        }
    }

    public func mutableData(): ?MessageLite {
        match (this) {
            case _ => Option<MessageLite>.None
        }
    }

    public func isEmpty(): Bool {
        match (this) {
            case None => true
            case _ => false
        }
    }

    public operator func !=(that: School_Oneof_TestOneof): Bool { !(this == that) }
    public operator func ==(that: School_Oneof_TestOneof): Bool {
        match ((this, that)) {
            case (Id(v1), Id(v2)) => v1 == v2
            case (Number(v1), Number(v2)) => v1 == v2
            case (Nikename(v1), Nikename(v2)) => v1 == v2
            case (None, None) => true
            case _ => false
        }
    }

    public func toString() {
        match (this) {
            case Id(v) => "\"${v}\""
            case Number(v) => "\"${v}\""
            case Nikename(v) => "\"${v}\""
            case None => ""
        }
    }

    public func hashCode(): Int64 {
        match (this) {
            case Id(v) => v.hashCode()
            case Number(v) => v.hashCode()
            case Nikename(v) => v.hashCode()
            case None => 0
        }
    }

    public func which() {
        match (this) {
            case Id(_) => "id"
            case Number(_) => "number"
            case Nikename(_) => "nikename"
            case None => ""
        }
    }
}
