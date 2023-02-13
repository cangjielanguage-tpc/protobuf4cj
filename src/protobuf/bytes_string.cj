package protobuf

public enum BytesString <: ToString & Equatable<BytesString> & Equatable<String> {
    Bytes(BytesSlice) | String(String)

    public prop let size: Int64 { get() {
        match (this) {
            case Bytes(bytes) => bytes.size
            case String(string) => string.utf8View.size
        }
    } }

    public func isEmpty() {
        match (this) {
            case Bytes(bytes) => bytes.isEmpty()
            case String(string) => string.isEmpty()
        }
    }

    public unsafe func getRawBytes(): Bytes {
        match (this) {
            case Bytes(bytes) => bytes.getRawArray()
            case String(string) => string.utf8View.getRawBytes()
        }
    }

    public func toString() {
        match (this) {
            case Bytes(bytes) => unsafe { String.fromUtf8Unchecked(bytes.getRawArray()) }
            case String(string) => string
        }
    }

    public operator func ==(that: BytesString): Bool {
        unsafe { getRawBytes() == that.getRawBytes() }
    }

    public operator func !=(that: BytesString): Bool {
        unsafe { getRawBytes() != that.getRawBytes() }
    }

    public operator func ==(that: String): Bool {
        unsafe { getRawBytes() == that.utf8View.getRawBytes() }
    }

    public operator func !=(that: String): Bool {
        unsafe { getRawBytes() != that.utf8View.getRawBytes() }
    }
}

public struct Pb3String {
    public var data: BytesString

    public init() { data = String("") }

    public mut func get(): String {
        match (data) {
            case Bytes(bytes) =>
                let string = unsafe { String.fromUtf8Unchecked(bytes.getRawArray()) }
                data = String(string)
                return string
            case String(string) => return string
        }
    }

    public mut func set(str: String): Unit { data = String(str) }
    public func toString() { data.toString() }
    public func isEmpty(): Bool { data.isEmpty() }
    public mut func clear() { data = String("") }
    public mut func pack<T>(out: T) where T <: BytesWriter { out.packBin(data) }
    public mut func unpack<T>(src: T) where T <: BytesReader { data = Bytes(src.parseBytesSlice()) }
}

public struct Pb2String {
    public var data: ?BytesString

    public init() { data = None }

    public mut func get(): String {
        match (data.getOrThrow()) {
            case Bytes(bytes) =>
                let string = unsafe { String.fromUtf8Unchecked(bytes.getRawArray()) }
                data = String(string)
                return string
            case String(string) => return string
        }
    }

    public mut func set(str: String): Unit { data = String(str) }
    public func isEmpty(): Bool { isNone(data) }
    public mut func clear() { data = None }
    public mut func unpack<T>(src: T) where T <: BytesReader { data = Bytes(src.parseBytesSlice()) }
}

public class RepeatedString <: Collection<String> & ToString {
    private var parent: ?AbstractMessage
    private var data: ArrayList<BytesString>

    public init() {
        parent = None
        data = ArrayList()
    }

    public init(capacity: Int64) {
        parent = None
        data = ArrayList(capacity)
    }

    public init(size: Int64, initElement: (Int64) -> BytesString) {
        parent = None
        data = ArrayList(size, initElement)
    }

    public init(elements: Array<BytesString>) {
        parent = None
        data = ArrayList(elements)
    }

    public init(elements: Collection<BytesString>) {
        parent = None
        data = ArrayList(elements)
    }

    public func get(index: Int64): ?String {
        match (data.get(index)) {
            case Some(Bytes(bytes)) =>
                let string = unsafe { String.fromUtf8Unchecked(bytes.getRawArray()) }
                set(index, string)
                return string
            case Some(String(string)) => return string
            case _ => return None
        }
    }

    public func set(index: Int64, element: String): Unit {
        data.set(index, String(element))
        parent?.markDirty()
    }

    public func set(index: Int64, element: BytesString): Unit {
        data.set(index, element)
        parent?.markDirty()
    }

    public func append(element: String): Unit {
        data.append(String(element))
        parent?.markDirty()
    }

    public func append(element: BytesString): Unit {
        data.append(element)
        parent?.markDirty()
    }

    public func appendAll(elements: Collection<String>): Unit {
        for (e in elements) {
            data.append(String(e))
        }
        parent?.markDirty()
    }

    public func appendAll(elements: Collection<BytesString>): Unit {
        data.appendAll(elements)
        parent?.markDirty()
    }

    public func insert(index: Int64, element: BytesString): Unit {
        data.insert(index, element)
        parent?.markDirty()
    }

    public func insert(index: Int64, element: String): Unit {
        data.insert(index, String(element))
        parent?.markDirty()
    }

    public func insertAll(index: Int64, elements: Collection<BytesString>): Unit {
        data.insertAll(index, elements)
        parent?.markDirty()
    }

    public func prepend(element: BytesString): Unit {
        data.prepend(element)
        parent?.markDirty()
    }

    public func prepend(element: String): Unit {
        data.prepend(String(element))
        parent?.markDirty()
    }

    public func prependAll(elements: Collection<BytesString>): Unit {
        data.prependAll(elements)
        parent?.markDirty()
    }

    public func remove(index: Int64): BytesString {
        parent?.markDirty()
        data.remove(index)
    }

    public func remove(range: Range<Int64>): Unit {
        data.remove(range)
        parent?.markDirty()
    }

    public func removeIf(predicate: (BytesString) -> Bool): Unit {
        data.removeIf(predicate)
        parent?.markDirty()
    }

    public func removeIf(predicate: (String) -> Bool): Unit {
        data.removeIf { e => predicate(e.toString()) }
        parent?.markDirty()
    }

    public func clear(): Unit {
        data.clear()
        parent?.markDirty()
    }

    public func copyFrom(rf: RepeatedString): Unit {
        data = rf.data.clone()
        parent?.markDirty()
    }

    public func moveFrom(rf: RepeatedString): Unit {
        let temp = rf.data
        rf.data = data
        rf.clear()

        data = temp
        parent?.markDirty()
    }

    public func swap(rf: RepeatedString): Unit {
        let temp = rf.data
        rf.data = data
        rf.parent?.markDirty()

        data = temp
        parent?.markDirty()
    }

    public func toArray(): Array<String> {
        let array = Array<String>(data.size, item: "")
        for (i in 0..size) {
            array[i] = this[i]
        }

        return array
    }

    public func toString(): String {
        let buffer = StringBuilder("[")
        var sep = false
        for (s in this) {
            if (sep) { buffer.append(", ") } else { sep = true }
            buffer.append("\"s\"")
        }
        return buffer.append(']').toString()
    }

    public func reverse(): Unit { data.reverse() }
    public func sortBy(comparator: (BytesString, BytesString) -> Ordering, stable!: Bool = false): Unit { data.sortBy(comparator, stable: stable) }
    public func reserve(additional: Int64): Unit { data.reserve(additional) }
    public func version(): Int64 { data.version() }
    public func capacity(): Int64 { data.capacity() }
    public func iterator(): Iterator<String> { RepeatedStringIterator(this) }
    public prop let size: Int64 { get() { data.size } }
    public func isEmpty(): Bool { data.isEmpty() }
    public func getBytesString(index: Int64): ?BytesString { data.get(index) }

    public operator func [](index: Int64): String { get(index).getOrThrow() }
    public operator func [](index: Int64, value!: String): Unit { set(index, value) }
    public operator func [](index: Int64, value!: BytesString): Unit { set(index, value) }

    func appendDirty(element: BytesSlice): Unit { data.append(Bytes(element)) }
    func setParent(parent: AbstractMessage): Unit { this.parent = parent }
    func getRawData() { data }
}

public class RepeatedStringIterator <: Iterator<String> {
    public RepeatedStringIterator(let data: RepeatedString, var index!: Int64 = 0) { }

    public func next(): ?String { let ret = data.get(index); index++; return ret }

    public func iterator() { this }
}