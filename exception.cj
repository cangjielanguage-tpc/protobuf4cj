/*
 * Copyright (c) Cangjie Library Team 2022-2022. All rights resvered.
 */

/**
 * @file
 * This file about: define protobuf exception.
 */
package protobuf

/**
 * The class is ProtobufException inherited from Exception
 * @author tutudo
 * @since 0.29.3
 */
public abstract class ProtobufException <: Exception {}

/**
 * The class is InvalidEnumValueException inherited from ProtobufException
 * @author tutudo
 * @since 0.29.3
 */
public class InvalidEnumValueException <: ProtobufException {
    public InvalidEnumValueException (let name: String, let value: Int32) {}

    public prop let message: String {
        get() { "The value `${value}` is illegal for the enum type `${name}`" }
    }
}

/**
 * The class is UnmatchedEnumStringException inherited from ProtobufException
 * @author tutudo
 * @since 0.29.3
 */
public class UnmatchedEnumStringException <: ProtobufException {
    public UnmatchedEnumStringException (let name: String, let value: String) {}

    public prop let message: String {
        get() { "Enum type `${name}` match `${value}` failed." }
    }
}

/**
 * The class is RequiredFieldNotSetException inherited from ProtobufException
 * @author tutudo
 * @since 0.29.3
 */
public class RequiredFieldNotSetException <: ProtobufException {
    public RequiredFieldNotSetException(let name: String) {}

    public prop let message: String {
        get() { "The field `${name}` without a default value is required to set before serialize." }
    }
}

/**
 * The class is GetFieldValueException inherited from ProtobufException
 * @author tutudo
 * @since 0.29.3
 */
public class GetFieldValueException <: ProtobufException {
    public GetFieldValueException(let name: String) {}

    public prop let message: String {
        get() { "The failed `${name}` without a default value is not allow read before set." }
    }
}

/**
 * The class is ParseValueExecption inherited from ProtobufException
 * @author tutudo
 * @since 0.29.3
 */
public class ParseValueExecption <: ProtobufException {
    public ParseValueExecption(let name: String, let reason!: String = "others") {}

    public prop let message: String {
        get() { "Failed to parse `${name}`. [${reason}]" }
    }
}

/**
 * The class is UnmatchedOneofCaseException inherited from ProtobufException
 * @author tutudo
 * @since 0.29.3
 */
public class UnmatchedOneofCaseException <: ProtobufException {
    UnmatchedOneofCaseException(let gname: String, let cname: String) {}

    public prop let message: String {
        get() { "Failed to get oneof case `${gname}`, for case `${cname}` is set." }
    }
}

class PBInternalException <: ProtobufException{
    public prop let message: String {
        get() { "Protobuf Internal exception" }
    }
}