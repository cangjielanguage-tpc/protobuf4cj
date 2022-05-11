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

/* 给repeated bytes, repeated message增加add()接口 */
public interface Reference {}
extend Buffer<T> <: Reference { }
extend MessageLite <: Reference { }
extend HashMap<K, V> <: Reference { }
/* 当前extend导出规则不允许此形式导出, 暂时使用AddReference<T>进行兼容 */
// extend Buffer<T> where T <: Reference & Default<T> {
//     public func add() { let rv = T.default(); this.add(rv); rv }
// }
public interface AddReference<T> {
    func add(): T
}
extend Buffer<T> <: AddReference<T> where T <: Reference & Default<T> {
    public func add() { let rv = T.default(); this.add(rv); rv }
}

/** 
 * 兼容cangjie 0.28.4部分场景下通过Any传参后无法通过as操作符复原
 * 目前仅发现内置的数值类型、String类型存在该问题, enum、class并未发现此问题
 */
interface Self<T> {
    func self(): T { (this as T).getOrThrow() }
}

extend Int32 <: Self<Int32> {
    public func self() { this }
}

extend UInt32 <: Self<UInt32> {
    public func self() { this }
}

extend Int64 <: Self<Int64> {
    public func self() { this }
}

extend UInt64 <: Self<UInt64> {
    public func self() { this }
}

extend Bool <: Self<Bool> {
    public func self() { this }
}

extend Float32 <: Self<Float32> {
    public func self() { this }
}

extend Float64 <: Self<Float64> {
    public func self() { this }
}

extend String <: Self<String> {
    public func self() { this }
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
        case a: String => a.isEmpty()
        case a: ValuedEnum => a.value() == 0
        case a: Self<Int32> => a.self() == 0
        case a: Self<UInt32> => a.self() == 0
        case a: Self<Int64> => a.self() == 0
        case a: Self<UInt64> => a.self() == 0
        case a: Self<Bool> => a.self() == false
        case a: Self<Float32> => a.self() == .0
        case a: Self<Float64> => a.self() == .0
        case a: Self<String> => a.self().isEmpty()
        case _ => false
    }
}

/* 是否是引用類型的值 */
func reference(val: Any): Bool {
    match (val) {
        case _: Reference => true
        /* 兼容部分场景下Reference无法识别 */
        case _: Int32 => false
        case _: UInt32 => false
        case _: Int64 => false
        case _: UInt64 => false
        case _: Bool => false
        case _: Float32 => false
        case _: Float64 => false
        case _: String => false
        case _: ValuedEnum => false
        case _: Self<Int32> => false
        case _: Self<UInt32> => false
        case _: Self<Int64> => false
        case _: Self<UInt64> => false
        case _: Self<Bool> => false
        case _: Self<Float32> => false
        case _: Self<Float64> => false
        case _: Self<String> => false
        case _ => true
    }
}

/* 调试Any传参类型退化规律 */
func debug(val: Any, id: String): Unit {
    print("debug[${id}]: val(")
    match (val) {
        // case s: Buffer<ToString> => print("${s})") // 没有效果
        case s: ToString => print("${s})")
        case _ => print("Invalid)")
    }
    print("(zeroish: ${zeroish(val)}, reference: ${reference(val)}), val is Reference: ${val is Reference}")
    match (val) {
        case _: Int32 => println("<Int32>")
        case _: UInt32 => println("<UInt32>")
        case _: Int64 => println("<Int64>")
        case _: UInt64 => println("<UInt64>")
        case _: Bool => println("<Bool>")
        case _: Float32 => println("<Float32>")
        case _: Float64 => println("<Float64>")
        case _: String => println("<String>")
        case _: Bytes => println("<Bytes>")
        case _: ValuedEnum => println("<Enum>")
        case _: MessageLite => println("<Message>")
        case _: Self<Int32> => println("<Self<Int32>>")
        case _: Self<UInt32> => println("<Self<UInt32>>")
        case _: Self<Int64> => println("<Self<Int64>>")
        case _: Self<UInt64> => println("<Self<UInt64>>")
        case _: Self<Bool> => println("<Self<Bool>>")
        case _: Self<Float32> => println("<Self<Float32>>")
        case _: Self<Float64> => println("<Self<Float64>>")
        case _: Self<String> => println("<Self<String>>")
        case _ => println("<Others>")
    }
}