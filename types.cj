/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file about: types.
 */
package protobuf

/**
 * The interface is Default<T>
 * The language does not support building objects through generic type parameters. Generic objects are built indirectly through this interface
 * @author tutudo
 * @since 0.29.3
 */
public interface Default<T> {
    static func default(): T
}

extend Int32 <: Default<Int32> {
    /**
     * The Function is default
     *
     * @return Type of Int32
     * @since 0.29.3
     */
    public static func default(): Int32 { 0 }
}

extend UInt32 <: Default<UInt32> {
    /**
     * The Function is default
     *
     * @return Type of UInt32
     * @since 0.29.3
     */
    public static func default(): UInt32 { 0 }
}

extend Int64 <: Default<Int64> {
    /**
     * The Function is default
     *
     * @return Type of Int64
     * @since 0.29.3
     */
    public static func default(): Int64 { 0 }
}

extend UInt64 <: Default<UInt64> {
    /**
     * The Function is default
     *
     * @return Type of UInt64
     * @since 0.29.3
     */
    public static func default(): UInt64 { 0 }
}

extend Float32 <: Default<Float32> {
    /**
     * The Function is default
     *
     * @return Type of Float32
     * @since 0.29.3
     */
    public static func default(): Float32 { .0 }
}

extend Float64 <: Default<Float64> {
    /**
     * The Function is default
     *
     * @return Type of Float64
     * @since 0.29.3
     */
    public static func default(): Float64 { .0 }
}

extend Bool <: Default<Bool> {
    /**
     * The Function is default
     *
     * @return Type of Bool
     * @since 0.29.3
     */
    public static func default(): Bool { false }
}

extend String <: Default<String> {
    /**
     * The Function is default
     *
     * @return Type of String
     * @since 0.29.3
     */
    public static func default(): String { "" }
}

extend Buffer<T> <: Default<Buffer<T>> {
    /**
     * The Function is default
     *
     * @return Type of Buffer<T>
     * @since 0.29.3
     */
    public static func default(): Buffer<T> { Buffer() }
}

extend HashMap<K, V> <: Default<HashMap<K, V>> {
    /**
     * The Function is default
     *
     * @return Type of HashMap<K, V>
     * @since 0.29.3
     */
    public static func default(): HashMap<K, V> { HashMap<K, V>() }
}

/* Add() interface to repeated bytes and repeated message */

/**
 * The interface is Reference
 * @author tutudo
 * @since 0.29.3
 */
public interface Reference {}
extend Buffer<T> <: Reference { }
extend MessageLite <: Reference { }
extend HashMap<K, V> <: Reference { }

/* The current extend export rule does not allow this form of export. Addreference<t> is temporarily used for compatibility */
// extend Buffer<T> where T <: Reference & Default<T> {
//     public func add() { let rv = T.default(); this.add(rv); rv }
// }

/**
 * The interface is AddReference<T>
 * @author tutudo
 * @since 0.29.3
 */
public interface AddReference<T> {
    func add(): T
}
extend Buffer<T> <: AddReference<T> where T <: Reference & Default<T> {
    public func add() { let rv = T.default(); this.add(rv); rv }
}

/** 
 * In some scenarios that are compatible with Cangjie 0.28.4, parameters can not be restored through the as operator after being passed through any
 * At present, only the built-in numeric type and string type are found to have this problem, but enum and class have not found this problem
 */
interface Self<T> {
    func self(): T { (this as T).getOrThrow() }
}

extend Int32 <: Self<Int32> {
    /**
     * The Function is self
     *
     * @since 0.29.3
     */
    public func self() { this }
}

extend UInt32 <: Self<UInt32> {
    /**
     * The Function is self
     *
     * @since 0.29.3
     */
    public func self() { this }
}

extend Int64 <: Self<Int64> {
    /**
     * The Function is self
     *
     * @since 0.29.3
     */
    public func self() { this }
}

extend UInt64 <: Self<UInt64> {
    /**
     * The Function is self
     *
     * @since 0.29.3
     */
    public func self() { this }
}

extend Bool <: Self<Bool> {
    /**
     * The Function is self
     *
     * @since 0.29.3
     */
    public func self() { this }
}

extend Float32 <: Self<Float32> {
    /**
     * The Function is self
     *
     * @since 0.29.3
     */
    public func self() { this }
}

extend Float64 <: Self<Float64> {
    /**
     * The Function is self
     *
     * @since 0.29.3
     */
    public func self() { this }
}

extend String <: Self<String> {
    /**
     * The Function is self
     *
     * @since 0.29.3
     */
    public func self() { this }
}

/* Whether it is a '0' value of value type */
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

/* Whether it is a value of reference type */
func reference(val: Any): Bool {
    match (val) {
        case _: Reference => true
        /* Reference is not recognized in some compatible scenarios */
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

/* Debug any parameter transfer type degradation law */
func debug(val: Any, id: String): Unit {
    print("debug[${id}]: val(")
    match (val) {
        // case s: Buffer<ToString> => print("${s})") // No effect
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