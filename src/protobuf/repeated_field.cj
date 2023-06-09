package protobuf

public class RepeatedField<T> <: Collection<T> {
    private var parent: ?Message
    private var data: ArrayList<T>

    public init() {
        parent = None
        data = ArrayList()
    }

    public init(capacity: Int64) {
        parent = None
        data = ArrayList(capacity)
    }

    public init(size: Int64, initElement: (Int64) -> T) {
        parent = None
        data = ArrayList(size, initElement)
    }

    public init(elements: Array<T>) {
        parent = None
        data = ArrayList(elements)
    }

    public init(elements: Collection<T>) {
        parent = None
        data = ArrayList(elements)
    }

    public func get(index: Int64): ?T {
        data.get(index)
    }

    public func set(index: Int64, element: T): Unit {
        data.set(index, element)
        parent?.markDirty()
    }

    public func append(element: T): Unit {
        data.append(element)
        parent?.markDirty()
    }

    public func appendAll(elements: Collection<T>): Unit {
        data.appendAll(elements)
        parent?.markDirty()
    }

    public func insert(index: Int64, element: T): Unit {
        data.insert(index, element)
        parent?.markDirty()
    }

    public func insertAll(index: Int64, elements: Collection<T>): Unit {
        data.insertAll(index, elements)
        parent?.markDirty()
    }

    public func prepend(element: T): Unit {
        data.prepend(element)
        parent?.markDirty()
    }

    public func prependAll(elements: Collection<T>): Unit {
        data.prependAll(elements)
        parent?.markDirty()
    }

    public func remove(index: Int64): T {
        parent?.markDirty()
        data.remove(index)
    }

    public func remove(range: Range<Int64>): Unit {
        data.remove(range)
        parent?.markDirty()
    }

    public func removeIf(predicate: (T) -> Bool): Unit {
        data.removeIf(predicate)
        parent?.markDirty()
    }

    public func clear(): Unit {
        data.clear()
        parent?.markDirty()
    }

    public func copyFrom(rf: RepeatedField<T>): Unit {
        data = rf.data.clone()
        parent?.markDirty()
    }

    public func moveFrom(rf: RepeatedField<T>): Unit {
        let temp = rf.data
        rf.data = data
        rf.clear()

        data = temp
        parent?.markDirty()
    }

    public func swap(rf: RepeatedField<T>): Unit {
        let temp = rf.data
        rf.data = data
        rf.parent?.markDirty()

        data = temp
        parent?.markDirty()
    }

    public func reverse(): Unit { data.reverse() }
    public func sortBy(comparator: (T, T) -> Ordering, stable!: Bool = false): Unit { data.sortBy(comparator, stable: stable) }
    public func reserve(additional: Int64): Unit { data.reserve(additional) }
    public func toArray(): Array<T> { data.toArray() }
    public func version(): Int64 { data.version() }
    public func capacity(): Int64 { data.capacity() }
    public func iterator(): Iterator<T> { data.iterator() }
    public prop let size: Int64 { get() { data.size } }
    public func isEmpty(): Bool { data.isEmpty() }
    public func toArrayList(): ArrayList<T> { data.clone() }
    public operator func [](index: Int64): T { data[index] }
    public operator func [](index: Int64, value!: T): Unit { data[index] = value; parent?.markDirty() }

    func appendDirty(element: T): Unit { data.append(element) }
    func setParent(parent: Message): Unit { this.parent = parent }
    func getRawData() { data }
}

extend RepeatedField<T> <: ToString where T <: ToString {
    public func toString(): String {
        getRawData().toString()
    }
}

extend RepeatedField<T> <: Hashable where T <: Hashable {
    public func hashCode(): Int64 {
        var hasher = DefaultHasher()
        for (v in getRawData()) {
            hasher.write(v.hashCode())
        }
        return hasher.finish()
    }
}

extend RepeatedField<T> <: Equatable<RepeatedField<T>> where T <: Equatable<T> {
    public operator func ==(that: RepeatedField<T>): Bool {
        getRawData() == that.getRawData()
    }

    public operator func !=(that: RepeatedField<T>): Bool {
        getRawData() != that.getRawData()
    }

    public func contains(element: T): Bool {
        getRawData().contains(element)
    }
}

extend RepeatedField<T> <: Equatable<ArrayList<T>> where T <: Equatable<T> {
    public operator func ==(that: ArrayList<T>): Bool {
        getRawData() == that
    }

    public operator func !=(that: ArrayList<T>): Bool {
        getRawData() != that
    }
}

extend RepeatedField<T> <: Equatable<Bytes> where T <: BytesSlice {
    public operator func ==(that: Bytes): Bool {
        for (s in getRawData() where s != that) {
            return false
        }

        return true
    }

    public operator func !=(that: Bytes): Bool {
        !(this == that)
    }
}

public class RepeatedMessage<T> <: Collection<T> & ToString & Hashable where T <: Message & TypedMessage<T> {
    private var parent: ?Message
    private var data: ArrayList<T>

    public init() {
        parent = None
        data = ArrayList()
    }

    public init(capacity: Int64) {
        parent = None
        data = ArrayList(capacity)
    }

    public init(size: Int64, initElement: (Int64) -> T) {
        parent = None
        data = ArrayList(size, initElement)
    }

    public init(elements: Array<T>) {
        parent = None
        data = ArrayList(elements)
    }

    public init(elements: Collection<T>) {
        parent = None
        data = ArrayList(elements)
    }

    public func get(index: Int64): ?T {
        data.get(index)
    }

    public func set(index: Int64, element: T): Unit {
        unlink(this[index])
        data.set(index, element)
        parent?.markDirty()
        link(element)
    }

    public func add(): T {
        let m = T.empty()
        append(m)
        m
    }

    public func append(element: T): Unit {
        data.append(element)
        parent?.markDirty()
        link(element)
    }

    public func appendAll(elements: Collection<T>): Unit {
        data.appendAll(elements)
        parent?.markDirty()
        link(elements)
    }

    public func insert(index: Int64, element: T): Unit {
        data.insert(index, element)
        parent?.markDirty()
        link(element)
    }

    public func insertAll(index: Int64, elements: Collection<T>): Unit {
        data.insertAll(index, elements)
        parent?.markDirty()
        link(elements)
    }

    public func prepend(element: T): Unit {
        data.prepend(element)
        parent?.markDirty()
        link(element)
    }

    public func prependAll(elements: Collection<T>): Unit {
        data.prependAll(elements)
        parent?.markDirty()
        link(elements)
    }

    public func remove(index: Int64): T {
        unlink(data[index])
        parent?.markDirty()
        data.remove(index)
    }

    public func remove(range: Range<Int64>): Unit {
        unlink(data[range])
        data.remove(range)
        parent?.markDirty()
    }

    public func removeIf(predicate: (T) -> Bool): Unit {
        data.removeIf { e =>
            if (predicate(e)) { unlink(e); true } else { false }
        }
        parent?.markDirty()
    }

    public func clear(): Unit {
        unlink(data)
        data.clear()
        parent?.markDirty()
    }

    public func copyFrom(rf: RepeatedMessage<T>): Unit {
        unlink(data)
        data.clear()
        for (m in rf.data) {
            let c = m.clone()
            data.append(c)
            link(c)
        }
        parent?.markDirty()
    }

    public func moveFrom(rf: RepeatedMessage<T>): Unit {
        let temp = rf.data
        rf.unlink(rf.data)
        rf.data = ArrayList()
        rf.parent?.markDirty()

        unlink(data)
        link(temp)
        data = temp
        parent?.markDirty()
    }

    public func swap(rf: RepeatedMessage<T>): Unit {
        let temp = rf.data
        rf.unlink(temp)
        rf.link(data)
        rf.data = data
        rf.parent?.markDirty()

        unlink(data)
        link(temp)
        data = temp
        parent?.markDirty()
    }

    private func link(element: Message) { element.m_parents.insert(parent ?? return) }
    private func unlink(element: Message) { element.m_parents.remove(parent ?? return) }

    private func link(elements: Collection<T>) {
        let m = parent ?? return ()
        for (e in elements) { let ee: Message = e; ee.m_parents.insert(m) }
    }

    private func unlink(elements: Collection<T>) {
        let m = parent ?? return ()
        for (e in elements) { let ee: Message = e; ee.m_parents.remove(m) }
    }

    public func hashCode(): Int64 {
        var hasher = DefaultHasher()
        for (m in data) {
            hasher.write(m.hashCode())
        }
        return hasher.finish()
    }

    public func reverse(): Unit { data.reverse() }
    public func sortBy(comparator: (T, T) -> Ordering, stable!: Bool = false): Unit { data.sortBy(comparator, stable: stable) }
    public func reserve(additional: Int64): Unit { data.reserve(additional) }
    public func toArray(): Array<T> { data.toArray() }
    public func version(): Int64 { data.version() }
    public func capacity(): Int64 { data.capacity() }
    public func iterator(): Iterator<T> { data.iterator() }
    public prop let size: Int64 { get() { data.size } }
    public func isEmpty(): Bool { data.isEmpty() }
    public func toArrayList(): ArrayList<T> { data.clone() }
    public func toString(): String { data.toString() }
    public operator func [](index: Int64): T { data[index] }
    public operator func [](index: Int64, value!: T): Unit { data[index] = value; parent?.markDirty(); link(value) }

    public operator func ==(that: RepeatedMessage<T>): Bool { data == that.data }
    public operator func !=(that: RepeatedMessage<T>): Bool { data != that.data }

    func appendDirty(element: T): Unit { data.append(element); link(element) }
    func setParent(parent: Message): Unit { this.parent = parent }
}

public class RepeatedString <: Collection<String> & Equatable<RepeatedString> & ToString & Hashable {
    private var parent: ?Message
    private var data: ArrayList<BytesString>

    public init() {
        parent = None
        data = ArrayList()
    }

    public init(capacity: Int64) {
        parent = None
        data = ArrayList(capacity)
    }

    public init(size: Int64, initElement: (Int64) -> String) {
        parent = None
        data = ArrayList(size) { i => String(initElement(i)) }
    }

    public init(elements: Array<String>) {
        parent = None
        data = ArrayList(elements.size) { i => String(elements[i]) }
    }

    public init(elements: Collection<String>) {
        parent = None
        let iter = elements.iterator()
        data = ArrayList(elements.size) { _ => String(iter.next().getOrThrow()) }
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

    public func insertAll(index: Int64, elements: Collection<String>): Unit {
        let iter = elements.iterator()
        data.insertAll(index, Array(elements.size) { _ => String(iter.next().getOrThrow()) })
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

    public func prependAll(elements: Collection<String>): Unit {
        let iter = elements.iterator()
        data.prependAll(Array(elements.size) { _ => String(iter.next().getOrThrow()) })
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
        Array<String>(data.size) { i => this[i]}
    }

    public func toString(): String {
        let buffer = StringBuilder("[")
        var sep = false
        for (s in this) {
            if (sep) { buffer.append(", ") } else { sep = true }
            buffer.append("\"${s}\"")
        }
        return buffer.append(']').toString()
    }

    public func hashCode(): Int64 {
        var hasher = DefaultHasher()
        for (s in data) {
            hasher.write(s.hashCode())
        }
        return hasher.finish()
    }

    public func reverse(): Unit { data.reverse() }
    public func sortBy(comparator: (String, String) -> Ordering, stable!: Bool = false): Unit { data.sortBy({ a, b => comparator(a.toString(), b.toString()) }, stable: stable) }
    public func sortBy(comparator: (BytesString, BytesString) -> Ordering, stable!: Bool = false): Unit { data.sortBy(comparator, stable: stable) }
    public func reserve(additional: Int64): Unit { data.reserve(additional) }
    public func version(): Int64 { data.version() }
    public func capacity(): Int64 { data.capacity() }
    public func iterator(): Iterator<String> { RepeatedStringIterator(this) }
    public prop let size: Int64 { get() { data.size } }
    public func isEmpty(): Bool { data.isEmpty() }
    public func contains(element: String): Bool { getRawData().contains(String(element)) }
    public func getBytesString(index: Int64): ?BytesString { data.get(index) }
    public func rawIterator() { data.iterator() }

    public operator func [](index: Int64): String { get(index).getOrThrow() }
    public operator func [](index: Int64, value!: String): Unit { set(index, value) }
    public operator func [](index: Int64, value!: BytesString): Unit { set(index, value) }

    public operator func ==(that: RepeatedString): Bool { data == that.data }
    public operator func !=(that: RepeatedString): Bool { data != that.data }

    func appendDirty(element: BytesSlice): Unit { data.append(Bytes(element)) }
    func setParent(parent: Message): Unit { this.parent = parent }
    func getRawData() { data }
}

public class RepeatedStringIterator <: Iterator<String> {
    public RepeatedStringIterator(let data: RepeatedString, var index!: Int64 = 0) { }

    public func next(): ?String { let ret = data.get(index); index++; return ret }

    public func iterator() { this }
}