/// A BitVector sort to type-erase `Z3Ast<T>` instances to.
/// Note: You should not pass this bit vector sort to methods that create new AST
/// based on sort, and doing so will result in a runtime error when trying to
/// call `getSort`.
public struct AnyBitVectorSort: NumericalSort {
    public static var isConcrete: Bool { false }
    
    /// Note: Fatal-errors
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        fatalError("Type-erased \(Self.self) cannot be used to create Z3Sorts")
    }

    /// Returns `true` if `sort` represents a bit vector sort of any bit length.
    public static func isAssignableFrom(_ context: Z3Context, _ sort: Z3Sort) -> Bool {
        switch context.getSortKind(sort) {
        case .bvSort:
            return true
        default:
            return false
        }
    }
}
