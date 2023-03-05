package protobuf

from encoding import base64.*

public struct StructPrinter <: ToString {
    private StructPrinter (
        private let stb: StringBuilder
    ) { }

    public init() { stb = StringBuilder("{") }

    private var sep = false

    public mut func append(key: String, str: ToString): Unit {
        if (sep) { stb.append(", ") } else { sep = true }
        stb.append(key).append(": ").append(str)
    }

    public mut func append(key: String, str: String): Unit {
        if (sep) { stb.append(", ") } else { sep = true }
        stb.append(key).append(": \"").append(str).append('"')
    }

    public mut func append(key: String, strs: RepeatedString): Unit {
        if (sep) { stb.append(", ") } else { sep = true }
        stb.append(key).append(": [")
        for ((i, str) in withIndex(strs)) {
            if (i != 0) { stb.append(", ") }
            stb.append('"').append(str).append('"')
        }
        stb.append(']')
    }

    public mut func append<T>(key: String, map: MapField<T, String>): Unit where T <: ToString & Hashable & Equatable<T> {
        var sp = subStruct(key)
        for ((k, v) in map) {
            sp.append(k.toString(), v)
        }
        sp.done()
    }

    public mut func subStruct(key: String) {
        if (sep) { stb.append(", ") } else { sep = true }
        stb.append(key).append(": {")
        StructPrinter(stb)
    }

    public mut func clear(): Unit { stb.clear().append('{'); sep = false }
    public func done() { stb.append('}'); this }
    public func toString() { stb.toString() }
}

public func subReader<T>(reader: T) where T <: BytesReader {
    SimpleReader(reader.read(reader.parseInt64()))
}

public func validate<T>(reader: T) where T <: BytesReader {
    while (!reader.isEmpty()) {
		match (reader.parseTag()[1]) {
			case 0 => reader.parseUInt32()
			case 1 => reader.parseFixed64()
			case 2 => reader.read(reader.parseInt64())
			case 5 => reader.parseFixed32()
			case _ => throw Exception("Invalid wire-type")
		}
	}
}

public func isNone<T>(val: ?T) {
    match (val) {
        case None => return true
        case _ => return false
    }
}

public func isPresent<T>(val: ?T) {
    match (val) {
        case None => return false
        case _ => return true
    }
}