import Z3

public class Z3Ast<T: SortKind> {
    internal var ast: Z3_ast

    init(ast: Z3_ast) {
        self.ast = ast
    }
}

public protocol SortKind {
    
}

public struct BoolSort: SortKind { }
public struct IntSort: SortKind { }
public struct UIntSort: SortKind { }
public struct Int64Sort: SortKind { }
public struct UInt64Sort: SortKind { }
public struct BitVectorSort: SortKind { }
public struct RealSort: SortKind { }
