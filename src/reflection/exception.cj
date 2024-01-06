package reflection

public class BadTypecastException <: Exception {
    public prop message: String { get() { "Bad Typecast" } }
}

public class InvalidArgumentException <: Exception {
}

public class InvalidOperationException <: Exception {
}

public class FullNameConflictException <: Exception {
}

public class DescriptorException <: Exception {
    DescriptorException(let msg: String) { }
    public prop message: String { get() { msg } }
}

public class ConstructionException <: Exception {
    ConstructionException(let msg: String) { }
    public prop message: String { get() { msg } }
}