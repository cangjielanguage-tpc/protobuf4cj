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

extend ArrayList<T> <: Default<ArrayList<T>> {
    /**
     * The Function is default
     *
     * @return Type of ArrayList<T>
     * @since 0.29.3
     */
    public static func default(): ArrayList<T> { ArrayList() }
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
extend ArrayList<T> <: Reference { }
extend MessageLite <: Reference { }
extend HashMap<K, V> <: Reference { }

/* The current extend export rule does not allow this form of export. Addreference<t> is temporarily used for compatibility */
// extend ArrayList<T> where T <: Reference & Default<T> {
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
extend ArrayList<T> <: AddReference<T> where T <: Reference & Default<T> {
    public func add() { let rv = T.default(); this.append(rv); rv }
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
        case _ => true // reference type is still unrecognized, cangjie 0.29.3
    }
}
