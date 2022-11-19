/// Base class for Z3 objects that support reference counting.
public class Z3RefCountedObject {
    init() {
        incRef()
    }

    deinit {
        decRef()
    }

    /// Method that increases the reference count for this object.
    func incRef() {

    }

    /// Method that decreases the reference count for this object.
    func decRef() {

    }
}
