package protobuf

/* interface of oneof groups */
public interface OneofGroup <: ToString {
    /* get which case name of oneof group, returns "" if `None`. */
    func which(): String

    /* test which case name of oneof group */
    func which(one: String): Bool {
        which() == one
    }
}