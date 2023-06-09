package protobuf

/* interface of oneof groups */
public interface OneofGroup <: ToString & Hashable {
    /* get which case name of oneof group, returns "" if `None`. */
    func which(): String

    /* test which case name of oneof group */
    func which(one: String): Bool { which() == one }

    /* return any set mutable message of oneof group */
    func mutableData(): ?Message

    /* return true if no field is set */
    func isEmpty(): Bool
}