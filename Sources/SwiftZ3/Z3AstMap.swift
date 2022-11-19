import CZ3

/// Map of `Z3AstBase` objects.
public class Z3AstMap: Z3RefCountedObject {
    /// The context this `Z3AstVector` belongs
    public let context: Z3Context
    var astMap: Z3_ast_map

    /// Return the size of this AST map.
    public var size: UInt32 {
        return Z3_ast_map_size(context.context, astMap)
    }

    /// Return the keys stored in this AST map.
    public var keys: Z3AstVector {
        Z3AstVector(
            context: context,
            astVector: Z3_ast_map_keys(context.context, astMap)
        )
    }

    /// Return the value associated with the key `key`.
    ///
    /// If the key is not present in this AST map, `nil` is returned, instead.
    public subscript(key: Z3AstBase) -> Z3AstBase? {
        get {
            if !contains(key) {
                return nil
            }

            return Z3AstBase(
                context: context,
                ast: Z3_ast_map_find(context.context, astMap, key.ast)
            )
        }
        set {
            if let newValue = newValue {
                Z3_ast_map_insert(context.context, astMap, key.ast, newValue.ast)
            } else {
                Z3_ast_map_erase(context.context, astMap, key.ast)
            }
        }
    }

    init(context: Z3Context) {
        self.context = context
        astMap = Z3_mk_ast_map(context.context)
    }

    init(context: Z3Context, astMap: Z3_ast_map) {
        self.context = context
        self.astMap = astMap
    }
    
    override func incRef() {
        Z3_ast_map_inc_ref(context.context, astMap)
    }

    override func decRef() {
        Z3_ast_map_dec_ref(context.context, astMap)
    }

    /// Removes all keys from this map.
    public func removeAll() {
        Z3_ast_map_reset(context.context, astMap)
    }

    public func push(_ ast: Z3AstBase) {
        Z3_ast_vector_push(context.context, astMap, ast.ast)
    }

    /// Return true if this AST map contains the AST key `key`.
    public func contains(_ key: Z3AstBase) -> Bool {
        Z3_ast_map_contains(context.context, astMap, key.ast)
    }

    /// Convert this AST map into a string.
    public func toString() -> String {
        Z3_ast_map_to_string(context.context, astMap).toString()
    }
    
    /// Translate/Copy the AST map `self` from its current context to context
    /// `target`
    public func translate(to newContext: Z3Context) -> Z3AstMap {
        if context === newContext {
            return self
        }

        let newAstVector =
            Z3_ast_vector_translate(context.context,
                                    astMap,
                                    newContext.context)
        
        return Z3AstMap(context: newContext, astMap: newAstVector!)
    }
}

extension Z3AstMap: Sequence {
    public func makeIterator() -> AnyIterator<(key: Z3AstBase, value: Z3AstBase)> {
        var isAtEnd = false
        let keys = self.keys

        let keysIterator = keys.makeIterator()
        
        return AnyIterator<(key: Z3AstBase, value: Z3AstBase)> {
            if isAtEnd {
                return nil
            }
            
            guard let key = keysIterator.next() else {
                // Modified during iteration?
                isAtEnd = true
                return nil
            }
            guard let value = self[key] else {
                // Modified during iteration?
                isAtEnd = true
                return nil
            }

            return (key: key, value: value)
        }
    }
}
