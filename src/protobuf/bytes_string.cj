package protobuf

public enum BytesString <: ToString & Hashable & Equatable<BytesString> & Equatable<String> {
    Bytes(BytesSlice) | String(String)

    /* bytes size */
    public prop size: Int64 { get() {
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

    public unsafe func getRawBytes(): protobuf.Bytes {
        match (this) {
            case Bytes(bytes) => bytes.getRawArray()
            case String(string) => string.utf8View.getRawBytes()
        }
    }

    public func toString() {
        match (this) {
            case Bytes(bytes) => unsafe { core.String.fromUtf8Unchecked(bytes.getRawArray()) }
            case String(string) => string
        }
    }

    public func hashCode(): Int64 {
        match (this) {
            case Bytes(bytes) => bytes.hashCode()
            case String(string) =>
                var hasher = DefaultHasher()
                for (v in unsafe { string.utf8View.getRawBytes() }) {
                    hasher.write(v)
                }
                hasher.finish()
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

    public init(value: String) { data = String(value) }

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
    public func isEmpty(): Bool { data.isEmpty() }
    public mut func clear() { data = String("") }
    public mut func unpack<T>(src: T) where T <: BytesReader { data = Bytes(src.parseBytesSlice()) }
}

public struct Pb2String {
    public var data: ?BytesString
    public let default: ?String

    public init(value: ?String) {
        data = match (value) {
            case Some(s) => String(s)
            case _ => None
        }
        this.default = None
    }

    public init(value: ?String, default: String) {
        data = match (value) {
            case Some(s) => String(s)
            case _ => None
        }
        this.default = default
    }

    public mut func get(): String {
        match (data) {
            case Some(Bytes(bytes)) =>
                let string = unsafe { String.fromUtf8Unchecked(bytes.getRawArray()) }
                data = String(string)
                return string
            case Some(String(string)) => return string
            case _ => default.getOrThrow()
        }
    }

    public mut func set(str: String): Unit {
        data = if (default == str) { None } else { String(str) }
    }

    public mut func clear() { data = None }
    public mut func unpack<T>(src: T) where T <: BytesReader { data = Bytes(src.parseBytesSlice()) }
}
