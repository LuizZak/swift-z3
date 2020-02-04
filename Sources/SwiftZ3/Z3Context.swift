import Z3

public class Z3Context {
    private var cachedFpaRoundingMode: Z3Ast<RoundingMode>?
    internal var context: Z3_context
    
    /// Gets or sets a reference to a rounding mode for floating-point operations
    /// performed on `Z3Ast` instances created by this context.
    ///
    /// Defaults to NearestTiesToEven rounding mode, if not configured.
    public var currentFpaRoundingMode: Z3Ast<RoundingMode> {
        get {
            if let cached = cachedFpaRoundingMode {
                return cached
            }
            let new = makeFpaRoundNearestTiesToEven()
            cachedFpaRoundingMode = new
            return new
        }
        set {
            cachedFpaRoundingMode = newValue
        }
    }

    public init(configuration: Z3Config? = nil) {
        context = Z3_mk_context(configuration?.config)
    }

    deinit {
        Z3_del_context(context)
    }
    
    /// Interrupt the execution of a Z3 procedure.
    /// This procedure can be used to interrupt: solvers, simplifiers and tactics.
    public func interrupt() {
        Z3_interrupt(context)
    }
    
    /// Create a Z3 (empty) parameter set.
    ///
    /// Starting at Z3 4.0, parameter sets are used to configure many components
    /// such as:
    /// simplifiers, tactics, solvers, etc.
    public func makeParams() -> Z3Params {
        let params = Z3_mk_params(context)!
        return Z3Params(context: self, params: params)
    }
    
    public func makeSolver() -> Z3Solver {
        return Z3Solver(context: self, solver: Z3_mk_solver(context))
    }
    
    // MARK: - Sorts
    
    /// Return the sort of an AST node.
    ///
    /// The AST node must be a constant, application, numeral, bound variable,
    /// or quantifier.
    public func getSort(_ ast: AnyZ3Ast) -> Z3Sort {
        return Z3Sort(sort: Z3_get_sort(context, ast.ast))
    }

    // TODO: Add error handling to these methods, testing the current error code
    // before utilizing the returned pointers
    
    /// Create a free (uninterpreted) type using the given name (symbol).
    ///
    /// Two free types are considered the same iff the have the same name.
    public func makeUninterpretedSort(_ symbol: Z3Symbol) -> Z3Sort {
        return Z3Sort(sort: Z3_mk_uninterpreted_sort(context, symbol.symbol))
    }
    
    /// Create the integer type.
    ///
    /// This type is not the int type found in programming languages.
    /// A machine integer can be represented using bit-vectors. The function
    /// `bitVectorSort(size:)` creates a bit-vector type.
    ///
    /// - seealso: `Z3_mk_bv_sort`
    public func intSort() -> Z3Sort {
        return Z3Sort(sort: Z3_mk_int_sort(context))
    }

    /// Create the Boolean type.
    /// This type is used to create propositional variables and predicates.
    public func boolSort() -> Z3Sort {
        return Z3Sort(sort: Z3_mk_bool_sort(context))
    }

    /// Create the real type.
    ///
    /// Note that this type is not a floating point number.
    public func realSort() -> Z3Sort {
        return Z3Sort(sort: Z3_mk_real_sort(context))
    }

    /// Create a bit-vector type of the given size.
    /// This type can also be seen as a machine integer.
    ///
    /// - remark: The size of the bit-vector type must be greater than zero.
    public func bitVectorSort(size: UInt32) -> Z3Sort {
        precondition(size > 0)
        return Z3Sort(sort: Z3_mk_bv_sort(context, size))
    }
    
    /// Create a named finite domain sort.
    ///
    /// To create constants that belong to the finite domain, use the APIs for
    /// creating numerals and pass a numeric constant together with the sort
    /// returned by this call. The numeric constant should be between 0 and
    /// the less than the size of the domain.
    ///
    /// - seealso: `getFiniteDomainSortSize`
    public func makeFiniteDomainSort(name: Z3Symbol, size: UInt64) -> Z3Sort {
        return Z3Sort(sort: Z3_mk_finite_domain_sort(context, name.symbol, size))
    }
    
    /// Create an array type.
    ///
    /// We usually represent the array type as: `[domain -> range]`.
    /// Arrays are usually used to model the heap/memory in software verification.
    ///
    /// - seealso: `makeSelect`
    /// - seealso: `makeStore`
    public func makeArraySort(domain: Z3Symbol, range: Z3Symbol) -> Z3Sort {
        return Z3Sort(sort: Z3_mk_array_sort(context, domain.symbol, range.symbol))
    }
    
    /// Create an array type with N arguments
    ///
    /// - seealso `makeSelectN`
    /// - seealso `makeStoreN`
    public func makeArraySortN(domains: [Z3Sort], range: Z3Sort) -> Z3Sort {
        let domains = domains.toZ3_sortPointerArray()
        return Z3Sort(sort: Z3_mk_array_sort_n(context, UInt32(domains.count), domains, range.sort))
    }
    
    /// Create a tuple type.
    ///
    /// A tuple with `n` fields has a constructor and `n` projections.
    /// This function will also declare the constructor and projection functions.
    ///
    /// - parameter mkTupleName: name of the constructor function associated
    /// with the tuple type.
    /// - parameter fieldNames: name of the projection functions.
    /// - parameter fieldSorts: type of the tuple fields. Must be at least the
    /// same size as `fieldNames`.
    /// - returns:
    /// A tuple containing:
    ///   - `mkTupleDecl`: output that will contain the constructor declaration.
    ///   - `projDecl`: output that will contain the projection function declarations.
    ///   - `tupleSort`: the proper generated tuple sort
    public func makeTupleSort(mkTupleName: Z3Symbol, fieldNames: [Z3Symbol],
                              fieldSorts: [Z3Sort]) -> (mkTupleDecl: Z3FuncDecl, projDecl: [Z3FuncDecl], tupleSort: Z3Sort) {
        
        let fieldNames = fieldNames.toZ3_symbolPointerArray()
        let fieldSorts = fieldSorts.toZ3_sortPointerArray()
        
        var mkTupleDecl: Z3_func_decl?
        var projDecl: [Z3_func_decl?] = fieldNames.map { _ in nil }
        
        let sort = Z3_mk_tuple_sort(context, mkTupleName.symbol, UInt32(fieldNames.count),
                                    fieldNames, fieldSorts, &mkTupleDecl, &projDecl)
        
        return (
            Z3FuncDecl(funcDecl: mkTupleDecl!),
            projDecl.toZ3FuncDeclArray(),
            Z3Sort(sort: sort!)
        )
    }

    /// Create a enumeration sort.
    ///
    /// An enumeration sort with `n` elements.
    /// This function will also declare the functions corresponding to the enumerations.
    ///
    /// - parameter name: name of the enumeration sort.
    /// - parameter n: number of elements in enumeration sort.
    /// - parameter enumNames: names of the enumerated elements.
    /// - returns:
    /// A tuple containing:
    ///     - `enumConsts`: constants corresponding to the enumerated elements.
    ///     - `parameter`: predicates testing if terms of the enumeration sort
    ///     correspond to an enumeration.
    ///     - `sort`: The resulting sort
    ///
    /// For example, if this function is called with three symbols A, B, C and
    /// the name S, then `s` is a sort whose name is S, and the function returns
    /// three terms corresponding to A, B, C in `enum_consts`. The array
    /// `enum_testers` has three predicates of type `(s -> Bool)`. The first
    /// predicate (corresponding to A) is true when applied to A, and false
    /// otherwise. Similarly for the other predicates.
    public func makeEnumerationSort(name: Z3Symbol, enumNames: [Z3Symbol]) -> (enumConsts: [Z3FuncDecl], enumTesters: [Z3FuncDecl], sort: Z3Sort) {

        let enumNames = enumNames.toZ3_symbolPointerArray()
        var enumConsts: [Z3_func_decl?] = enumNames.map { _ in nil }
        var enumTesters: [Z3_func_decl?] = enumNames.map { _ in nil }

        let sort =
            Z3_mk_enumeration_sort(context, name.symbol, UInt32(enumNames.count),
                                   enumNames, &enumConsts, &enumTesters)

        return (enumConsts.toZ3FuncDeclArray(), enumTesters.toZ3FuncDeclArray(), Z3Sort(sort: sort!))
    }

    /// Create a constructor.
    ///
    /// - parameter name: constructor name.
    /// - parameter recognizer: name of recognizer function.
    /// - parameter fieldNames: names of the constructor fields.
    /// - parameter sorts: field sorts, 0 if the field sort refers to a recursive
    ///  sort.
    /// - parameter sortRefs: reference to datatype sort that is an argument to
    /// the constructor; if the corresponding
    /// sort reference is 0, then the value in sort_refs should be an index
    /// referring to one of the recursive datatypes that is declared.
    /// - seealso: `makeConstructorList`
    /// - seealso: `queryConstructor`
    public func makeConstructor(name: Z3Symbol, recognizer: Z3Symbol,
                                fieldNames: [Z3Symbol], sorts: [Z3Sort],
                                sortRefs: [UInt32]) -> Z3Constructor {

        let fieldNames = fieldNames.toZ3_symbolPointerArray()
        let sorts = sorts.toZ3_sortPointerArray()
        var sortRefs = sortRefs

        let ctor =
            Z3_mk_constructor(context, name.symbol, recognizer.symbol,
                              UInt32(fieldNames.count), fieldNames, sorts,
                              &sortRefs)

        return Z3Constructor(context: self, constructor: ctor!)
    }

    // TODO: Test the validity of this method. It seems like the underlying
    // implementation alters pointer values from within each Z3_constructor pointer

    /// Create datatype, such as lists, trees, records, enumerations or unions
    /// of records.
    /// The datatype may be recursive. Return the datatype sort.
    ///
    /// - parameter name: name of datatype.
    /// - parameter constructors: array of constructor containers.
    /// - seealso: `makeConstructor`
    /// - seealso: `makeConstructorList`
    /// - seealso: `makeDatatypes`
    func makeDatatype(name: Z3Symbol, constructors: inout [Z3Constructor]) -> Z3Sort {

        var constructors = constructors.toZ3_constructorPointerArray()

        let sort =
            Z3_mk_datatype(context, name.symbol, UInt32(constructors.count),
                           &constructors)

        return Z3Sort(sort: sort!)
    }

    /// Create list of constructors.
    ///
    /// - seealso: `makeConstructor`
    public func makeConstructorList(_ constructors: [Z3Constructor]) -> Z3ConstructorList {
        let constructors = constructors.toZ3_constructorPointerArray()

        let ctorList =
            Z3_mk_constructor_list(context, UInt32(constructors.count),
                                   constructors)

        return Z3ConstructorList(context: self, constructorList: ctorList!)
    }

    /// Create mutually recursive datatypes
    ///
    /// - parameter sortNames: names of datatype sorts.
    /// - parameter constructorLists: list of constructors, one list per sort.
    /// - returns: array of datatype sorts
    /// - seealso: `makeConstructor`
    /// - seealso: `makeConstructorList`
    /// - seealso: `makeDatatype`
    public func makeDatatypes(sortNames: [Z3Symbol], constructorLists: [Z3ConstructorList]) -> [Z3Sort] {

        let sortNames = sortNames.toZ3_symbolPointerArray()
        var sorts: [Z3_sort?] = sortNames.map { _ in nil }
        var constructorLists = constructorLists.toZ3_constructor_listPointerArray()

        Z3_mk_datatypes(context, UInt32(sortNames.count), sortNames,
                        &sorts, &constructorLists)

        return sorts.map { Z3Sort(sort: $0!) }
    }

    /// Query constructor for declared functions.
    ///
    /// - parameter constr: constructor container. The container must have been passed in to a `makeDatatype` call.
    /// - parameter numFields: number of accessor fields in the constructor.
    /// - returns:
    /// A tuple containing:
    ///     - `constructor`: constructor function declaration, allocated by user.
    ///     - `tester`: constructor test function declaration, allocated by user.
    ///     - `accessors`: array of accessor function declarations allocated by user. The array must contain num_fields elements.
    /// - seealso: `makeConstructor`
    public func queryConstructor(constructor: Z3Constructor, numFields: UInt32) -> (constructor: Z3FuncDecl, tester: Z3FuncDecl, accessors: [Z3FuncDecl]) {

        var constr: Z3_func_decl?
        var tester: Z3_func_decl?
        var accessors: [Z3_func_decl?] = (0..<numFields).map { _ in nil }

        Z3_query_constructor(context, constructor.constructor, numFields, &constr,
                             &tester, &accessors)

        return (
            Z3FuncDecl(funcDecl: constr!),
            Z3FuncDecl(funcDecl: tester!),
            accessors.map { Z3FuncDecl(funcDecl: $0!) }
        )
    }

    // MARK: -
    
    /// Declare and create a constant.
    ///
    /// This function is a shorthand for:
    /// ```
    /// Z3_func_decl d = Z3_mk_func_decl(c, s, 0, 0, ty);
    /// Z3_ast n       = Z3_mk_app(c, d, 0, 0);
    /// ```
    public func makeConstant<T: SortKind>(name: String, sort: T.Type) -> Z3Ast<T> {
        let symbol = Z3_mk_string_symbol(context, name)

        return Z3Ast(context: self, ast: Z3_mk_const(context, symbol, sort.getSort(self).sort))
    }

    /// \brief Create a numeral of a given sort.
    ///
    /// - seealso: `makeInteger()`
    /// - seealso: `makeUnsignedInteger()`
    /// - Parameter number: A string representing the numeral value in decimal
    /// notation. The string may be of the form `[num]*[.[num]*][E[+|-][num]+]`.
    /// If the given sort is a real, then the numeral can be a rational, that is,
    /// a string of the form `[num]* / [num]*` .
    /// - Parameter sort: The sort of the numeral. In the current implementation,
    /// the given sort can be an int, real, finite-domain, or bit-vectors of
    /// arbitrary size.
    public func makeNumeral<T: NumericalSort>(number: String, sort: T.Type) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_numeral(context, number, sort.getSort(self).sort))
    }

    /// Create a real from a fraction.
    ///
    /// - Parameter num: numerator of rational.
    /// - Parameter den: denominator of rational.
    /// - seealso: `Z3_mk_numeral`
    /// - seealso: `Z3_mk_int`
    /// - seealso: `Z3_mk_unsigned_int`
    /// - precondition: `den != 0`
    public func makeReal(_ num: Int32, _ den: Int32) -> Z3Ast<RealSort> {
        return Z3Ast(context: self, ast: Z3_mk_real(context, num, den))
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeInteger(value: Int32) -> Z3Ast<Int32> {
        return Z3Ast(context: self, ast: Z3_mk_int(context, value, intSort().sort))
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine unsigned
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeUnsignedInteger(value: UInt32) -> Z3Ast<UInt32> {
        return Z3Ast(context: self, ast: Z3_mk_unsigned_int(context, value, intSort().sort))
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine `Int64`
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeInteger64(value: Int64) -> Z3Ast<Int64> {
        return Z3Ast(context: self, ast: Z3_mk_int64(context, value, intSort().sort))
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine `UInt64`
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeUnsignedInteger64(value: UInt64) -> Z3Ast<UInt64> {
        return Z3Ast(context: self, ast: Z3_mk_unsigned_int64(context, value, intSort().sort))
    }
}
