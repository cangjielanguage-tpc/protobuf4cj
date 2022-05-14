package protobuf

public abstract class ProtobufException <: RuntimeException {}

public class InvalidEnumValueException <: ProtobufException {
    public InvalidEnumValueException (let name: String, let value: Int32) {}
    public override func getMessage() {
        "The value `${value}` is illegal for the enum type `${name}`"
    }
}

public class RequiredFieldNotSetException <: ProtobufException {
    public RequiredFieldNotSetException(let name: String) {}
    public override func getMessage() {
        "The field `${name}` without a default value is required to set before serialize."
    }
}

public class GetFieldValueException <: ProtobufException {
    public GetFieldValueException(let name: String) {}
    public override func toString () {
        "The failed `${name}` without a default value is not allow read before set."
    }
}

public class ParseValueExecption <: ProtobufException {
    public ParseValueExecption(let name: String, let reason!: String = "others") {}
    public override func getMessage() {
        "Failed to parse `${name}`. [${reason}]"
    }
}

public class ValueTypeUnmatchException <: ProtobufException {
    public ValueTypeUnmatchException(let name: String, let vtype: String) {}
    public override func getMessage() {
        "Failed to get `${vtype}` value(s) from `${name}`."
    }
}

public class UnrecognizedBytesException <: ProtobufException {
    public UnrecognizedBytesException(let name: String, let left: Int64) {}
    public override func toString() {
        "Failed to unpack `${name}`, unrecognized bytes left `${left}`."
    }
}

public class UnmatchedOneofCaseException <: ProtobufException {
    UnmatchedOneofCaseException(let gname: String, let cname: String) {}
    public override func toString() {
        "Failed to get oneof case `${gname}`, for case `${cname}` is set."
    }
}