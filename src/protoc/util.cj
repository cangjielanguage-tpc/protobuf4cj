package protoc

from protobuf import reflection.*

func buildFileDescriptor(desc: FileDescriptorProto, helper: GenCodeHelper): FileDescriptor {
    FileDescriptor.fromBytes(desc.pack())
}

func encodeLiterals(desc: RoMessage): String {
    let writer = Writer()
    desc.pack(writer)

    encodeLiterals(writer.data.toArray())
}

func encodeLiterals(bytes: Bytes): String {
    let buffer = LiteralsBuilder()
    buffer.reserve(bytes.size * 2)
    buffer.append(b"b\"")
    for (byte in bytes) {
        buffer.addLiterals(byte)
    }

    buffer.append(b"\"")
    buffer.toString()
}

class Writer <: BytesWriter {
    let data = ArrayList<Byte>()

    public func append(byte: Byte): Unit { data.append(byte) }
    public func appendBytes(bytes: Bytes): Unit { data.appendAll(bytes) }
}

extend ArrayList<T> {
    func toRoArray(): RoArray<T> {
        unsafe { RoArray<T>.move(this.toArray()) }
    }
}

public class LiteralsBuilder {
    private var data: Array<Byte>
    private var index: Int64 = 0

    public init(capacity!: Int64 = 32) {
        if (capacity <= 0) {
            throw IllegalArgumentException("The capacity should be positive.")
        }
        data = Array<Byte>(capacity, item: 0)
    }

    public func toString(): String {
        return unsafe { String.fromUtf8Unchecked(data[0 .. index]) }
    }

    @OverflowThrowing
    public func reserve(additional: Int64): Unit {
        if (data.size >= index + additional) {
            return
        }
        
        let oldCapacity = data.size
        let minCapacity = index + additional
        var newCapacity = oldCapacity + (oldCapacity >> 1)
        if (newCapacity < minCapacity) {
            newCapacity = minCapacity
        }

        let itemData = Array<Byte>(newCapacity, item: 0)
        data.copyTo(itemData, 0, 0, index)
        data = itemData
    }

    @OverflowThrowing
    public func append(bytes: Bytes): Unit {
        let itemLen = bytes.size
        if (itemLen == 0) {
            return
        }

        reserve(itemLen)
        bytes.copyTo(data, 0, index, itemLen)
        index += itemLen
    }

    @OverflowThrowing
    public func append(b: Byte): Unit {
        reserve(1)
        data[index] = b
        index++
    }

    private static let hex = b"0123456789abcdef"

    @OverflowWrapping
    public func addHex(byte: Byte) {
        if (byte <= 0x0f) {
            return append(hex[Int64(byte)])
        }

        append(hex[Int64(byte >> 4)])
        append(hex[Int64(byte & 0x0f)])
    }

    public func addLiterals(byte: Byte) {
        match (byte) {
            case 0 => append(b"\\0")
            case b'\b' => append(b"\\b")
            case b'\t' => append(b"\\t")
            case b'\n' => append(b"\\n")
            case b'\v' => append(b"\\v")
            case b'\f' => append(b"\\f")
            case b'\r' => append(b"\\r")
            case b'"' => append(b"\\\"")    /* literals boundary */
            case b'\\' => append(b"\\\\")   /* escape character */
            case b where b >= b' ' && b <= b'~' => append(byte) /* visible characters */
            case _ => append(b"\\u{"); addHex(byte); append(b'}')
        }
    }
}