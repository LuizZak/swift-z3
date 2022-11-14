extension Bool: SortKind {
    /// Returns a Bool sort.
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.boolSort()
    }
}
