package protobuf

/* read only array */
public struct RoArray<T> {
    /* raw data of ro-array */
    let data: Array<T>

    public init() {
        data = Array()
    }

    public init(size:Int64, item!:T) {
        data = Array(size, item: item)
    }

    /* constuct ro-array from the copy of collection */
    public init(data: Collection<T>) {
        this.data = data.toArray()
    }

    public init(size: Int64, initElement: (Int64)->T) {
        data = Array(size, initElement)
    }

    /* [Private] constuct ro-array from array reference. */
    private init(data: Array<T>, placeholder: Unit) {
        this.data = data
    }

    /* [unsafe] constuct ro-array from an array reference that will not be modified. */
    public unsafe static func grab(data: Array<T>) {
        RoArray<T>(data, ())
    }

    /* [unsafe] get the raw array of this ro-array */
    public unsafe func getRawArray() {
        data
    }

    public func get(index: Int64) {
        data.get(index)
    }

    /**
     * @throws IndexOutOfBoundsException if `index` is negative or
     *         greater than or equal to the size of array.
     */
    public operator func [](index: Int64) {
        data[index]
    }

    public operator func [](range: Range<Int64>) {
        RoArray(data[range], ())
    }

    public func slice(start: Int64, len: Int64) {
        RoArray(data.slice(start, len), ())
    }

    public func copyTo(dst: Array<T>, dstStart: Int64) {
        data.copyTo(dst, 0, dstStart, data.size)
    }

    public func clone(): RoArray<T> {
        RoArray(data.clone(), ())
    }
}

extend RoArray<T> <: Collection<T> {
    /** Returns an iterator over the elements in this Array in proper sequence. */
    public func iterator(): Iterator<T> {
        data.iterator()
    }

    /**
     * Call 'size' on array type variable will be processed by compiler.
     * Only call based on 'Collection' type will use this function.
     */
    public prop let size: Int64 {
        get() {
            data.size
        }
    }

    /** Returns true if this Array contains no elements. */
    public func isEmpty(): Bool {
        data.isEmpty()
    }

    public func toArray(): Array<T> {
        data.toArray()
    }
}

extend RoArray<T> <: ToString where T <: ToString {
    public func toString(): String {
        data.toString()
    }
}

extend RoArray<T> <: Equatable<RoArray<T>> where T <: Equatable<T> {
    public operator func ==(that: RoArray<T>): Bool {
        this.data == that.data
    }

    public operator func !=(that: RoArray<T>): Bool {
        !(this == that)
    }

    public func contains(element: T): Bool {
        data.contains(element)
    }
}