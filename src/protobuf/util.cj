package protobuf

from encoding import base64.*
from json import json.{ Json, ToJson, JsonString, JsonArray, JsonNumber }
public from json import json.{ JsonReader, JsonStringReader, JsonObject }

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

    public mut func append(key: String, strs: ArrayList<String>): Unit {
        if (sep) { stb.append(", ") } else { sep = true }
        stb.append(key).append(": [")
        for ((i, str) in withIndex(strs)) {
            if (i != 0) { stb.append(", ") }
            stb.append('"').append(str).append('"')
        }
        stb.append(']')
    }

    /* cangjie 0.36.4, compile blocked if change to TreeMap */
    public mut func append(key: String, map: Map<String, String>): Unit {
        var sp = subStruct(key)
        for ((k, v) in map) {
            sp.append("\"${k}\"", v)
        }
        sp.done()
    }

    public mut func append<T>(key: String, map: TreeMap<T, String>): Unit where T <: ToString & Less<T> & Equatable<T> {
        var sp = subStruct(key)
        for ((k, v) in map) {
            sp.append(k.toString(), v)
        }
        sp.done()
    }

    public mut func append<T>(key: String, map: TreeMap<String, T>): Unit where T <: ToString {
        var sp = subStruct(key)
        for ((k, v) in map) {
            sp.append("\"${k}\"", v)
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

public func mapClone<K, V>(val: TreeMap<K, V>) where K <: Less<K> & Equatable<K>, V <: TypedMessage<V> {
    let map = val.clone()
    for ((k, v) in map) {
        map[k] = v.clone()
    }
    return map
}

public func mapClone<K>(val: TreeMap<K, Bytes>) where K <: Less<K> & Equatable<K> {
    let map = val.clone()
    for ((k, v) in map) {
        map[k] = v.clone()
    }
    return map
}

public func mapClone<K, V>(val: TreeMap<K, V>) where K <: Less<K> & Equatable<K> {
    val.clone()
}

/* parse enum from json */
func parseEnum<E>(src: Json) where E <: Enum<E> {
    match (src) {
        case c: JsonString => E.parse(c)
        case c: JsonNumber => E.parse(Int32(c))
        case _ => throw ParseValueExecption("Enum")
    }
}

/* parse bytes from json, support base64 and uint8 array. */
func parseBytes(src: Json) {
    /* parse as base64 string */
    if (src.isString) {
        return fromBase64String(src.asString()).getOrThrow()
    }

    let arr = src.asArray()
    Bytes(arr.size) { i => UInt8(arr[i].asNumber()) }
}

extend UInt64 {
    @overflowWrapping
    static func parse(src: Json) {
        UInt64(Int64.parse(src))
    }
}

extend Int64 {
    @overflowWrapping
    static func parse(src: Json) {
        match (src) {
            case c: JsonNumber => Int64(c)
            case c: JsonString => c.toInt64().getOrThrow()
            case _ => throw ParseValueExecption("Int64")
        }
    }
}

extend UInt32 {
    @overflowWrapping
    static func parse(src: Json) {
        UInt32(Int64.parse(src))
    }
}

extend Int32 {
    @overflowWrapping
    static func parse(src: Json) {
        Int32(Int64.parse(src))
    }
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