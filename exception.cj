/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file about: define protobuf exception.
 */
package protobuf

/**
 * The class is ProtobufException inherited from RuntimeException
 * @author tutudo
 * @since 0.29.3
 */
public abstract class ProtobufException <: RuntimeException {}

/**
 * The class is InvalidEnumValueException inherited from ProtobufException
 * @author tutudo
 * @since 0.29.3
 */
public class InvalidEnumValueException <: ProtobufException {
    public InvalidEnumValueException (let name: String, let value: Int32) {}
    /**
     * The Function is getMessage
     *
     * @since 0.29.3
     */
    public override func getMessage() {
        "The value `${value}` is illegal for the enum type `${name}`"
    }
}

/**
 * The class is UnmatchedEnumStringException inherited from ProtobufException
 * @author tutudo
 * @since 0.29.3
 */
public class UnmatchedEnumStringException <: ProtobufException {
    public UnmatchedEnumStringException (let name: String, let value: String) {}
    /**
     * The Function is getMessage
     *
     * @since 0.29.3
     */
    public override func getMessage() {
        "Enum type `${name}` match `${value}` failed."
    }
}

/**
 * The class is RequiredFieldNotSetException inherited from ProtobufException
 * @author tutudo
 * @since 0.29.3
 */
public class RequiredFieldNotSetException <: ProtobufException {
    public RequiredFieldNotSetException(let name: String) {}
    /**
     * The Function is getMessage
     *
     * @since 0.29.3
     */
    public override func getMessage() {
        "The field `${name}` without a default value is required to set before serialize."
    }
}

/**
 * The class is GetFieldValueException inherited from ProtobufException
 * @author tutudo
 * @since 0.29.3
 */
public class GetFieldValueException <: ProtobufException {
    public GetFieldValueException(let name: String) {}
    /**
     * The Function is getMessage
     *
     * @since 0.29.3
     */
    public override func getMessage() {
        "The failed `${name}` without a default value is not allow read before set."
    }
}

/**
 * The class is ParseValueExecption inherited from ProtobufException
 * @author tutudo
 * @since 0.29.3
 */
public class ParseValueExecption <: ProtobufException {
    public ParseValueExecption(let name: String, let reason!: String = "others") {}
    /**
     * The Function is getMessage
     *
     * @since 0.29.3
     */
    public override func getMessage() {
        "Failed to parse `${name}`. [${reason}]"
    }
}

/**
 * The class is ValueTypeUnmatchException inherited from ProtobufException
 * @author tutudo
 * @since 0.29.3
 */
public class ValueTypeUnmatchException <: ProtobufException {
    public ValueTypeUnmatchException(let name: String, let vtype: String) {}
    /**
     * The Function is getMessage
     *
     * @since 0.29.3
     */
    public override func getMessage() {
        "Failed to get `${vtype}` value(s) from `${name}`."
    }
}

/**
 * The class is UnrecognizedBytesException inherited from ProtobufException
 * @author tutudo
 * @since 0.29.3
 */
public class UnrecognizedBytesException <: ProtobufException {
    public UnrecognizedBytesException(let name: String, let left: Int64) {}
    /**
     * The Function is getMessage
     *
     * @since 0.29.3
     */
    public override func getMessage() {
        "Failed to unpack `${name}`, unrecognized bytes left `${left}`."
    }
}

/**
 * The class is UnmatchedOneofCaseException inherited from ProtobufException
 * @author tutudo
 * @since 0.29.3
 */
public class UnmatchedOneofCaseException <: ProtobufException {
    UnmatchedOneofCaseException(let gname: String, let cname: String) {}
    /**
     * The Function is getMessage()
     *
     * @since 0.29.3
     */
    public override func getMessage() {
        "Failed to get oneof case `${gname}`, for case `${cname}` is set."
    }
}