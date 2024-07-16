// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var p: Person = Person()
    p.name = "test"
    p.id = 100
    p.email = "test@huawei.com"
    var b = p.pack()
    println("Serialize result: ${b}")

    var p2 = Person()
    p2.unpack(b)
    println("p2 = ${p2}")
    if(!p.name.equals("test") || p.id != 100 || !p.email.equals("test@huawei.com")) {
        println(-1)
        return -1
    }

    return 0
}



public class Person <: MessageLite & TypedMessage<Person> {
    private var p_name = Pb3String()
    private var p_id = Int32(0)
    private var p_email = Pb3String()

    public init() {
        m_innerInit()
    }

    public mut prop name: String { get() { p_name.get() } set(i_vtmp) { p_name.set(i_vtmp); markDirty() } }

    public mut prop id: Int32 { get() { p_id } set(i_vtmp) { p_id = i_vtmp; markDirty() } }

    public mut prop email: String { get() { p_email.get() } set(i_vtmp) { p_email.set(i_vtmp); markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (!p_name.isEmpty()) { i_tmp += 1 + binSize(p_name.data) }
        if (p_id != 0) { i_tmp += 1 + varintSize(p_id) }
        if (!p_email.isEmpty()) { i_tmp += 1 + binSize(p_email.data) }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        p_name.isEmpty() && p_id == 0 && p_email.isEmpty()
    }

    protected func m_clear(): Unit {
        p_name.clear()
        p_id = 0
        p_email.clear()
    }

    public func copyFrom(src: Person): Person {
        p_name = src.p_name
        p_id = src.p_id
        p_email = src.p_email
        m_innerCopyFrom(src)
        return this
    }

    public func clone(): Person {
        return Person().copyFrom(this)
    }

    public func unpack<T>(src: T): Unit where T <: BytesReader {
        while (!src.isEmpty()) {
            let i_tmp = src.parseTag()
            match (i_tmp[0]) {
                case 1 => p_name.unpack(src)
                case 2 => p_id = src.parseInt32()
                case 3 => p_email.unpack(src)
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        if (!p_name.isEmpty()) { out.append(10); out.packBin(p_name.data) }
        if (p_id != 0) { out.append(16); out.packVarint(p_id) }
        if (!p_email.isEmpty()) { out.append(26); out.packBin(p_email.data) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (!p_name.isEmpty()) { i_tmp.append("name", p_name.get()) }
        if (p_id != 0) { i_tmp.append("id", p_id) }
        if (!p_email.isEmpty()) { i_tmp.append("email", p_email.get()) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { Person() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = Person(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = Person(); i_tmp.unpack(src); i_tmp }
}


