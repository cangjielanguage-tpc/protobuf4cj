// DEPENDENCE: ./build.sh
 EXEC: bash build.sh %import-path %L %l ffi-typecast.o

from std import collection.*
from std import io.*

main() {

    var pm: Pb2Message<Person> = Pb2Message<Person>()

    match (pm.data) {
        case None => ()
        case Some(m) =>
            println(-1)
            return -1
    }

    var p: Person = Person()
    p.id = 1

    //pm.set(parent: MessageLite, that: M)

    return 0
}

public class Person <: MessageLite & TypedMessage<Person> {
    private var p_id: ?Int32 = None

    public init() {
        m_innerInit()
    }

    public func clearId() { p_id = None; markDirty() }
    public prop hasId: Bool { get() { isPresent(p_id) } }
    public mut prop id: Int32 { get() { p_id.getOrThrow() } set(i_tmp) { p_id = i_tmp; markDirty() } }

    protected func m_size(): Int64 {
        var i_tmp = 0
        if (let Some(i_vtmp) <- p_id) { i_tmp += 1 + varintSize(i_vtmp) }
        return i_tmp
    }

    protected func m_isEmpty(): Bool {
        isNone(p_id)
    }

    protected func m_clear(): Unit {
        p_id = None
    }

    public func copyFrom(src: Person): Person {
        p_id = src.p_id
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
                case 2 => p_id = src.parseInt32()
                case _ => m_unknown(src, i_tmp)
            }
        }
        markDirty()
    }

    public func check(): Unit /* throws RequiredFieldNotSetException */ {
        if (isNone(p_id)) { throw RequiredFieldNotSetException("id") }
    }

    public func pack<T>(out: T): Unit where T <: BytesWriter {
        check()
        if (let Some(i_vtmp) <- p_id) { out.append(16); out.packVarint(i_vtmp) }
        m_unknown(out)
    }

    public func toString(): String {
        var i_tmp = StructPrinter()
        if (let Some(i_vtmp) <- p_id) { i_tmp.append("id", i_vtmp) }
        return i_tmp.done().toString()
    }

    public func packi(out: BytesWriter) { match (out) { case i_tmp: SimpleWriter => pack(i_tmp) case _ => pack(out) } }
    public func unpacki(src: BytesReader) { match (src) { case i_stmp: SimpleReader => unpack(i_stmp) case _ => unpack(src) } }

    public static func empty() { Person() }
    public static func fromBytes(src: Collection<Byte>) { let i_tmp = Person(); i_tmp.unpack(src); i_tmp }
    public static func fromBytes(src: BytesReader) { let i_tmp = Person(); i_tmp.unpack(src); i_tmp }
}
