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

    public init(data: Collection<T>) {
        this.data = data.toArray()
    }

    public init(size: Int64, initElement: (Int64)->T) {
        data = Array(size, initElement)
    }

    /* [unsafe] constuct ro-array from array refence. */
    unsafe init(data: Array<T>, placeholder: Int64) {
        this.data = data
    }

    /* [unsafe] get the raw array of this ro-array */
    @fastCall
    public unsafe func getRawArray() {
        data
    }

    /* [unsafe] detach ro-array from array */
    @fastCall
    public unsafe static func detach(data: Array<T>) {
        RoArray<T>(data, 0)
    }

    @fastCall
    public func get(index: Int64) {
        data.get(index)
    }

    /**
     * @throws IndexOutOfBoundsException if `index` is negative or
     *         greater than or equal to the size of array.
     */
    @fastCall
    public operator func [](index: Int64) {
        data[index]
    }

    @fastCall
    public func slice(start: Int64, len: Int64) {
        RoArraySlice(this, start, len)
    }

    @fastCall
    public func copyTo(dst: Array<T>, srcStart: Int64, dstStart: Int64, copyLen: Int64) {
        data.copyTo(dst, srcStart, dstStart, copyLen)
    }
}

extend RoArray<T> <: Collection<T> {
    /** Returns an iterator over the elements in this Array in proper sequence. */
    @fastCall
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
    @fastCall
    public func isEmpty(): Bool {
        data.isEmpty()
    }

    @fastCall
    public func toArray(): Array<T> {
        data.toArray()
    }
}

extend RoArray<T> <: ToString where T <: ToString {
    @fastCall
    public func toString(): String {
        data.toString()
    }
}

extend RoArray<T> <: Equatable<RoArray<T>> where T <: Equatable<T> {
    @fastCall
    public operator func ==(that: RoArray<T>): Bool {
        this.data == that.data
    }

    @fastCall
    public operator func !=(that: RoArray<T>): Bool {
        !(this == that)
    }

    @fastCall
    public func contains(element: T): Bool {
        data.contains(element)
    }
}

public interface Ro { }
extend Array<T> <: Ro {
    /* [unsafe] make ro-array */
    @fastCall
    public unsafe func ro() {
        RoArray<T>(this, 0)
    }
}

public struct RoArraySlice<T> {
    public RoArraySlice(
        public let rawData: RoArray<T>,
        public let start: Int64,
        public let size: Int64          /* length */
    ) {
        if (start < 0 || size < 0 || start + size > rawData.size) {
            throw IllegalArgumentException("Arguments out of range.")
        }
    }

    @fastCall
    @overflowWrapping
    public func get(index: Int64): ?T {
        if (index >= 0 && index < size) {
            return rawData.data.get(start + index)
        }
        None
    }

    @fastCall
    @overflowWrapping
    public operator func [](index: Int64) {
        if (index >= 0 && index < size) {
           return rawData.data[start + index]
        }

        throw IndexOutOfBoundsException()
    }

    @fastCall
    public func toArray() {
        rawData.data.slice(start, size)
    }

    @fastCall
    @overflowWrapping
    public func slice(start: Int64, len: Int64) {
        RoArraySlice(rawData, this.start + start, len)
    }

    @fastCall
    public func copyTo(dst: Array<T>, dstStart: Int64) {
        rawData.data.copyTo(dst, start, dstStart, size)
    }
}