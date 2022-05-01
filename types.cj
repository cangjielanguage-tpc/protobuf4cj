package protobuf

/* 语言不支持通过泛型类型参数构建对象, 通过此接口间接构建泛型对象 */
public interface Default<T> {
    static func default(): T
}

extend Int32 <: Default<Int32> {
    public static func default(): Int32 { 0 }
}

extend UInt32 <: Default<UInt32> {
    public static func default(): UInt32 { 0 }
}

extend Int64 <: Default<Int64> {
    public static func default(): Int64 { 0 }
}

extend UInt64 <: Default<UInt64> {
    public static func default(): UInt64 { 0 }
}

extend Float32 <: Default<Float32> {
    public static func default(): Float32 { .0 }
}

extend Float64 <: Default<Float64> {
    public static func default(): Float64 { .0 }
}

extend Bool <: Default<Bool> {
    public static func default(): Bool { false }
}

extend String <: Default<String> {
    public static func default(): String { "" }
}

extend Buffer<T> <: Default<Buffer<T>> {
    public static func default(): Buffer<T> { Buffer() }
}

/* 是否是值類型的`0`值 */
func zeroish(val: Any): Bool {
    match (val) {
        case a: Int32 => a == 0
        case a: UInt32 => a == 0
        case a: Int64 => a == 0
        case a: UInt64 => a == 0
        case a: Bool => a == false
        case a: Float32 => a == .0
        case a: Float64 => a == .0
        // todo enum
        case a: String => a.isEmpty()
        case _ => false
    }
}

/* 是否在引用類型的值 */
func reference(val: Any): Bool {
    match (val) {
        case _: Int32 => false
        case _: UInt32 => false
        case _: Int64 => false
        case _: UInt64 => false
        case _: Bool => false
        case _: Float32 => false
        case _: Float64 => false
        // todo enum
        case _: String => false
        case _ => true
    }
}

public func debug(val: Any, id: String): Unit {
    print("debug[${id}]: val(")
    match (val) {
        case s: ToString => print("${s})")
        case _ => print("Invalid)")
    }
    match (val) {
        case a: Int32 => println("<Int32>")
        case a: UInt32 => println("<UInt32>")
        case a: Int64 => println("<Int64>")
        case a: UInt64 => println("<UInt64>")
        case a: Bool => println("<Bool>")
        case a: Float32 => println("<Float32>")
        case a: Float64 => println("<Float64>")
        case a: String => println("<String>")
        case _ => println("<Others>")
    }
    println("debug[${id}]: val is String: ${val is String}, val as String: ${val as String}")
}