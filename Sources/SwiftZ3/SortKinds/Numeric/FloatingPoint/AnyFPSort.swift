/// A FP sort to type-erase `Z3Ast<T>` instances to.
/// Note: You should not pass this float sort to methods that create new AST
/// based on sort, and doing so will result in a runtime error when trying to
/// call `getSort`
public struct AnyFPSort: FloatingSort {
    /// Note: Fatal-errors
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        fatalError("Type-erased AnyFPSort cannot be used to create Z3Sorts")
    }

    /// Returns `true` if `sort` represents a floating-point sort of any bit length.
    public static func isAssignableFrom(_ context: Z3Context, _ sort: Z3Sort) -> Bool {
        switch context.getSortKind(sort) {
        case .floatingPointSort:
            return true
        default:
            return false
        }
    }
}
