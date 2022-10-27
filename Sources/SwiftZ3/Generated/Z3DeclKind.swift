// HEADS UP!: Auto-generated file, changes made directly here will be overwritten by code generators.
// Generated by generate_types.py

import CZ3

/// The different kinds of interpreted function kinds.
/// 
/// - Z3_OP_PR_CLAUSE_TRAIL,
///   Clausal proof trail of additions and deletions
public typealias Z3DeclKind = Z3_decl_kind

public extension Z3DeclKind {
    /// The constant true.
    static let opTrue = Z3_OP_TRUE
    
    /// The constant false.
    static let opFalse = Z3_OP_FALSE
    
    /// The equality predicate.
    static let opEq = Z3_OP_EQ
    
    /// The n-ary distinct predicate (every argument is mutually distinct).
    static let opDistinct = Z3_OP_DISTINCT
    
    /// The ternary if-then-else term.
    static let opIte = Z3_OP_ITE
    
    /// n-ary conjunction.
    static let opAnd = Z3_OP_AND
    
    /// n-ary disjunction.
    static let opOr = Z3_OP_OR
    
    /// equivalence (binary).
    static let opIff = Z3_OP_IFF
    
    /// Exclusive or.
    static let opXor = Z3_OP_XOR
    
    /// Negation.
    static let opNot = Z3_OP_NOT
    
    /// Implication.
    static let opImplies = Z3_OP_IMPLIES
    
    /// Binary equivalence modulo namings. This binary predicate is used in proof terms.
    /// It captures equisatisfiability and equivalence modulo renamings.
    static let opOeq = Z3_OP_OEQ
    
    /// Arithmetic numeral.
    static let opAnum = Z3_OP_ANUM
    
    /// Arithmetic algebraic numeral. Algebraic numbers are used to represent irrational numbers in Z3.
    static let opAgnum = Z3_OP_AGNUM
    
    /// <=.
    static let opLe = Z3_OP_LE
    
    /// >=.
    static let opGe = Z3_OP_GE
    
    /// <.
    static let opLt = Z3_OP_LT
    
    /// >.
    static let opGt = Z3_OP_GT
    
    /// Addition - Binary.
    static let opAdd = Z3_OP_ADD
    
    /// Binary subtraction.
    static let opSub = Z3_OP_SUB
    
    /// Unary minus.
    static let opUminus = Z3_OP_UMINUS
    
    /// Multiplication - Binary.
    static let opMul = Z3_OP_MUL
    
    /// Division - Binary.
    static let opDiv = Z3_OP_DIV
    
    /// Integer division - Binary.
    static let opIdiv = Z3_OP_IDIV
    
    /// Remainder - Binary.
    static let opRem = Z3_OP_REM
    
    /// Modulus - Binary.
    static let opMod = Z3_OP_MOD
    
    /// Coercion of integer to real - Unary.
    static let opToReal = Z3_OP_TO_REAL
    
    /// Coercion of real to integer - Unary.
    static let opToInt = Z3_OP_TO_INT
    
    /// Check if real is also an integer - Unary.
    static let opIsInt = Z3_OP_IS_INT
    
    /// Power operator x^y.
    static let opPower = Z3_OP_POWER
    
    /// Array store. It satisfies select(store(a,i,v),j) = if i = j then v else select(a,j).
    /// Array store takes at least 3 arguments.
    static let opStore = Z3_OP_STORE
    
    /// Array select.
    static let opSelect = Z3_OP_SELECT
    
    /// The constant array. For example, select(const(v),i) = v holds for every v and i. The function is unary.
    static let opConstArray = Z3_OP_CONST_ARRAY
    
    /// Array map operator.
    /// It satisfies map[f](a1,..,a_n)[i] = f(a1[i],...,a_n[i]) for every i.
    static let opArrayMap = Z3_OP_ARRAY_MAP
    
    /// Default value of arrays. For example default(const(v)) = v. The function is unary.
    static let opArrayDefault = Z3_OP_ARRAY_DEFAULT
    
    /// Set union between two Boolean arrays (two arrays whose range type is Boolean). The function is binary.
    static let opSetUnion = Z3_OP_SET_UNION
    
    /// Set intersection between two Boolean arrays. The function is binary.
    static let opSetIntersect = Z3_OP_SET_INTERSECT
    
    /// Set difference between two Boolean arrays. The function is binary.
    static let opSetDifference = Z3_OP_SET_DIFFERENCE
    
    /// Set complement of a Boolean array. The function is unary.
    static let opSetComplement = Z3_OP_SET_COMPLEMENT
    
    /// Subset predicate between two Boolean arrays. The relation is binary.
    static let opSetSubset = Z3_OP_SET_SUBSET
    
    /// An array value that behaves as the function graph of the
    /// function passed as parameter.
    static let opAsArray = Z3_OP_AS_ARRAY
    
    /// Array extensionality function. It takes two arrays as arguments and produces an index, such that the arrays
    /// are different if they are different on the index.
    static let opArrayExt = Z3_OP_ARRAY_EXT
    
    static let opSetHasSize = Z3_OP_SET_HAS_SIZE
    
    static let opSetCard = Z3_OP_SET_CARD
    
    /// Bit-vector numeral.
    static let opBnum = Z3_OP_BNUM
    
    /// One bit bit-vector.
    static let opBit1 = Z3_OP_BIT1
    
    /// Zero bit bit-vector.
    static let opBit0 = Z3_OP_BIT0
    
    /// Unary minus.
    static let opBneg = Z3_OP_BNEG
    
    /// Binary addition.
    static let opBadd = Z3_OP_BADD
    
    /// Binary subtraction.
    static let opBsub = Z3_OP_BSUB
    
    /// Binary multiplication.
    static let opBmul = Z3_OP_BMUL
    
    /// Binary signed division.
    static let opBsdiv = Z3_OP_BSDIV
    
    /// Binary unsigned division.
    static let opBudiv = Z3_OP_BUDIV
    
    /// Binary signed remainder.
    static let opBsrem = Z3_OP_BSREM
    
    /// Binary unsigned remainder.
    static let opBurem = Z3_OP_BUREM
    
    /// Binary signed modulus.
    static let opBsmod = Z3_OP_BSMOD
    
    /// Unary function. bsdiv(x,0) is congruent to bsdiv0(x).
    static let opBsdiv0 = Z3_OP_BSDIV0
    
    /// Unary function. budiv(x,0) is congruent to budiv0(x).
    static let opBudiv0 = Z3_OP_BUDIV0
    
    /// Unary function. bsrem(x,0) is congruent to bsrem0(x).
    static let opBsrem0 = Z3_OP_BSREM0
    
    /// Unary function. burem(x,0) is congruent to burem0(x).
    static let opBurem0 = Z3_OP_BUREM0
    
    /// Unary function. bsmod(x,0) is congruent to bsmod0(x).
    static let opBsmod0 = Z3_OP_BSMOD0
    
    /// Unsigned bit-vector <= - Binary relation.
    static let opUleq = Z3_OP_ULEQ
    
    /// Signed bit-vector  <= - Binary relation.
    static let opSleq = Z3_OP_SLEQ
    
    /// Unsigned bit-vector  >= - Binary relation.
    static let opUgeq = Z3_OP_UGEQ
    
    /// Signed bit-vector  >= - Binary relation.
    static let opSgeq = Z3_OP_SGEQ
    
    /// Unsigned bit-vector  < - Binary relation.
    static let opUlt = Z3_OP_ULT
    
    /// Signed bit-vector < - Binary relation.
    static let opSlt = Z3_OP_SLT
    
    /// Unsigned bit-vector > - Binary relation.
    static let opUgt = Z3_OP_UGT
    
    /// Signed bit-vector > - Binary relation.
    static let opSgt = Z3_OP_SGT
    
    /// Bit-wise and - Binary.
    static let opBand = Z3_OP_BAND
    
    /// Bit-wise or - Binary.
    static let opBor = Z3_OP_BOR
    
    /// Bit-wise not - Unary.
    static let opBnot = Z3_OP_BNOT
    
    /// Bit-wise xor - Binary.
    static let opBxor = Z3_OP_BXOR
    
    /// Bit-wise nand - Binary.
    static let opBnand = Z3_OP_BNAND
    
    /// Bit-wise nor - Binary.
    static let opBnor = Z3_OP_BNOR
    
    /// Bit-wise xnor - Binary.
    static let opBxnor = Z3_OP_BXNOR
    
    /// Bit-vector concatenation - Binary.
    static let opConcat = Z3_OP_CONCAT
    
    /// Bit-vector sign extension.
    static let opSignExt = Z3_OP_SIGN_EXT
    
    /// Bit-vector zero extension.
    static let opZeroExt = Z3_OP_ZERO_EXT
    
    /// Bit-vector extraction.
    static let opExtract = Z3_OP_EXTRACT
    
    /// Repeat bit-vector n times.
    static let opRepeat = Z3_OP_REPEAT
    
    /// Bit-vector reduce or - Unary.
    static let opBredor = Z3_OP_BREDOR
    
    /// Bit-vector reduce and - Unary.
    static let opBredand = Z3_OP_BREDAND
    
    /// .
    static let opBcomp = Z3_OP_BCOMP
    
    /// Shift left.
    static let opBshl = Z3_OP_BSHL
    
    /// Logical shift right.
    static let opBlshr = Z3_OP_BLSHR
    
    /// Arithmetical shift right.
    static let opBashr = Z3_OP_BASHR
    
    /// Left rotation.
    static let opRotateLeft = Z3_OP_ROTATE_LEFT
    
    /// Right rotation.
    static let opRotateRight = Z3_OP_ROTATE_RIGHT
    
    /// (extended) Left rotation. Similar to Z3_OP_ROTATE_LEFT, but it is a binary operator instead of a parametric one.
    static let opExtRotateLeft = Z3_OP_EXT_ROTATE_LEFT
    
    /// (extended) Right rotation. Similar to Z3_OP_ROTATE_RIGHT, but it is a binary operator instead of a parametric one.
    static let opExtRotateRight = Z3_OP_EXT_ROTATE_RIGHT
    
    static let opBit2bool = Z3_OP_BIT2BOOL
    
    /// Coerce integer to bit-vector. NB. This function
    /// is not supported by the decision procedures. Only the most
    /// rudimentary simplification rules are applied to this function.
    static let opInt2bv = Z3_OP_INT2BV
    
    /// Coerce bit-vector to integer. NB. This function
    /// is not supported by the decision procedures. Only the most
    /// rudimentary simplification rules are applied to this function.
    static let opBv2int = Z3_OP_BV2INT
    
    /// Compute the carry bit in a full-adder.
    /// The meaning is given by the equivalence
    /// (carry l1 l2 l3) <=> (or (and l1 l2) (and l1 l3) (and l2 l3)))
    static let opCarry = Z3_OP_CARRY
    
    /// Compute ternary XOR.
    /// The meaning is given by the equivalence
    /// (xor3 l1 l2 l3) <=> (xor (xor l1 l2) l3)
    static let opXor3 = Z3_OP_XOR3
    
    /// a predicate to check that bit-wise signed multiplication does not overflow.
    /// Signed multiplication overflows if the operands have the same sign and the result of multiplication
    /// does not fit within the available bits. \sa Z3_mk_bvmul_no_overflow.
    static let opBsmulNoOvfl = Z3_OP_BSMUL_NO_OVFL
    
    /// check that bit-wise unsigned multiplication does not overflow.
    /// Unsigned multiplication overflows if the result does not fit within the available bits.
    /// \sa Z3_mk_bvmul_no_overflow.
    static let opBumulNoOvfl = Z3_OP_BUMUL_NO_OVFL
    
    /// check that bit-wise signed multiplication does not underflow.
    /// Signed multiplication underflows if the operands have opposite signs and the result of multiplication
    /// does not fit within the available bits. Z3_mk_bvmul_no_underflow.
    static let opBsmulNoUdfl = Z3_OP_BSMUL_NO_UDFL
    
    /// Binary signed division.
    /// It has the same semantics as Z3_OP_BSDIV, but created in a context where the second operand can be assumed to be non-zero.
    static let opBsdivI = Z3_OP_BSDIV_I
    
    /// Binary unsigned division.
    /// It has the same semantics as Z3_OP_BUDIV, but created in a context where the second operand can be assumed to be non-zero.
    static let opBudivI = Z3_OP_BUDIV_I
    
    /// Binary signed remainder.
    /// It has the same semantics as Z3_OP_BSREM, but created in a context where the second operand can be assumed to be non-zero.
    static let opBsremI = Z3_OP_BSREM_I
    
    /// Binary unsigned remainder.
    /// It has the same semantics as Z3_OP_BUREM, but created in a context where the second operand can be assumed to be non-zero.
    static let opBuremI = Z3_OP_BUREM_I
    
    /// Binary signed modulus.
    /// It has the same semantics as Z3_OP_BSMOD, but created in a context where the second operand can be assumed to be non-zero.
    static let opBsmodI = Z3_OP_BSMOD_I
    
    /// Undef/Null proof object.
    static let opPrUndef = Z3_OP_PR_UNDEF
    
    /// Proof for the expression 'true'.
    static let opPrTrue = Z3_OP_PR_TRUE
    
    /// Proof for a fact asserted by the user.
    static let opPrAsserted = Z3_OP_PR_ASSERTED
    
    /// Proof for a fact (tagged as goal) asserted by the user.
    static let opPrGoal = Z3_OP_PR_GOAL
    
    /// Given a proof for p and a proof for (implies p q), produces a proof for q.
    /// 
    ///      T1: p
    ///      T2: (implies p q)
    ///      [mp T1 T2]: q
    /// 
    /// The second antecedents may also be a proof for (iff p q).
    static let opPrModusPonens = Z3_OP_PR_MODUS_PONENS
    
    /// A proof for (R t t), where R is a reflexive relation. This proof object has no antecedents.
    /// The only reflexive relations that are used are
    /// equivalence modulo namings, equality and equivalence.
    /// That is, R is either '~', '=' or 'iff'.
    static let opPrReflexivity = Z3_OP_PR_REFLEXIVITY
    
    /// Given an symmetric relation R and a proof for (R t s), produces a proof for (R s t).
    /// \nicebox{
    /// T1: (R t s)
    /// [symmetry T1]: (R s t)
    /// }
    /// T1 is the antecedent of this proof object.
    static let opPrSymmetry = Z3_OP_PR_SYMMETRY
    
    /// Given a transitive relation R, and proofs for (R t s) and (R s u), produces a proof
    /// for (R t u).
    /// \nicebox{
    /// T1: (R t s)
    /// T2: (R s u)
    /// [trans T1 T2]: (R t u)
    /// }
    static let opPrTransitivity = Z3_OP_PR_TRANSITIVITY
    
    /// Condensed transitivity proof. 
    /// It combines several symmetry and transitivity proofs. Example:
    ///      \nicebox{
    ///      T1: (R a b)
    ///      T2: (R c b)
    ///      T3: (R c d)
    ///      [trans* T1 T2 T3]: (R a d)
    ///      }
    ///      R must be a symmetric and transitive relation.
    /// 
    ///      Assuming that this proof object is a proof for (R s t), then
    ///      a proof checker must check if it is possible to prove (R s t)
    ///      using the antecedents, symmetry and transitivity.  That is,
    ///      if there is a path from s to t, if we view every
    ///      antecedent (R a b) as an edge between a and b.
    static let opPrTransitivityStar = Z3_OP_PR_TRANSITIVITY_STAR
    
    /// Monotonicity proof object.
    /// 
    ///      T1: (R t_1 s_1)
    ///      ...
    ///      Tn: (R t_n s_n)
    ///      [monotonicity T1 ... Tn]: (R (f t_1 ... t_n) (f s_1 ... s_n))
    /// 
    /// Remark: if t_i == s_i, then the antecedent Ti is suppressed.
    /// That is, reflexivity proofs are suppressed to save space.
    static let opPrMonotonicity = Z3_OP_PR_MONOTONICITY
    
    /// Given a proof for (~ p q), produces a proof for (~ (forall (x) p) (forall (x) q)).
    /// 
    ///  T1: (~ p q)
    /// [quant-intro T1]: (~ (forall (x) p) (forall (x) q))
    static let opPrQuantIntro = Z3_OP_PR_QUANT_INTRO
    
    /// Given a proof p, produces a proof of lambda x . p, where x are free variables in p.
    /// 
    ///  T1: f
    /// [proof-bind T1] forall (x) f
    static let opPrBind = Z3_OP_PR_BIND
    
    /// Distributivity proof object.
    /// Given that f (= or) distributes over g (= and), produces a proof for
    /// \nicebox{
    /// (= (f a (g c d))
    ///    (g (f a c) (f a d)))
    /// }
    /// If f and g are associative, this proof also justifies the following equality:
    /// \nicebox{
    /// (= (f (g a b) (g c d))
    ///    (g (f a c) (f a d) (f b c) (f b d)))
    /// }
    /// where each f and g can have arbitrary number of arguments.
    /// 
    /// This proof object has no antecedents.
    /// Remark. This rule is used by the CNF conversion pass and
    /// instantiated by f = or, and g = and.
    static let opPrDistributivity = Z3_OP_PR_DISTRIBUTIVITY
    
    /// Given a proof for (and l_1 ... l_n), produces a proof for l_i
    /// 
    /// T1: (and l_1 ... l_n)
    /// [and-elim T1]: l_i
    static let opPrAndElim = Z3_OP_PR_AND_ELIM
    
    /// Given a proof for (not (or l_1 ... l_n)), produces a proof for (not l_i).
    /// 
    /// T1: (not (or l_1 ... l_n))
    /// [not-or-elim T1]: (not l_i)
    static let opPrNotOrElim = Z3_OP_PR_NOT_OR_ELIM
    
    /// A proof for a local rewriting step (= t s).
    /// The head function symbol of t is interpreted.
    /// 
    /// This proof object has no antecedents.
    /// The conclusion of a rewrite rule is either an equality (= t s),
    /// an equivalence (iff t s), or equi-satisfiability (~ t s).
    /// Remark: if f is bool, then = is iff.
    /// Examples:
    /// \nicebox{
    /// (= (+ x 0) x)
    /// (= (+ x 1 2) (+ 3 x))
    /// (iff (or x false) x)
    /// }
    static let opPrRewrite = Z3_OP_PR_REWRITE
    
    /// A proof for rewriting an expression t into an expression s.
    /// This proof object can have n antecedents.
    /// The antecedents are proofs for equalities used as substitution rules.
    /// The proof rule is used in a few cases. The cases are:
    ///   - When applying contextual simplification (CONTEXT_SIMPLIFIER=true)
    ///   - When converting bit-vectors to Booleans (BIT2BOOL=true)
    static let opPrRewriteStar = Z3_OP_PR_REWRITE_STAR
    
    /// A proof for (iff (f (forall (x) q(x)) r) (forall (x) (f (q x) r))). This proof object has no antecedents.
    static let opPrPullQuant = Z3_OP_PR_PULL_QUANT
    
    /// A proof for:
    /// \nicebox{
    ///    (iff (forall (x_1 ... x_m) (and p_1[x_1 ... x_m] ... p_n[x_1 ... x_m]))
    ///         (and (forall (x_1 ... x_m) p_1[x_1 ... x_m])
    ///           ...
    ///         (forall (x_1 ... x_m) p_n[x_1 ... x_m])))
    ///         }
    ///   This proof object has no antecedents.
    static let opPrPushQuant = Z3_OP_PR_PUSH_QUANT
    
    /// A proof for (iff (forall (x_1 ... x_n y_1 ... y_m) p[x_1 ... x_n])
    ///                  (forall (x_1 ... x_n) p[x_1 ... x_n]))
    /// 
    /// It is used to justify the elimination of unused variables.
    /// This proof object has no antecedents.
    static let opPrElimUnusedVars = Z3_OP_PR_ELIM_UNUSED_VARS
    
    /// A proof for destructive equality resolution:
    /// (iff (forall (x) (or (not (= x t)) P[x])) P[t])
    /// if x does not occur in t.
    /// 
    /// This proof object has no antecedents.
    /// 
    /// Several variables can be eliminated simultaneously.
    static let opPrDer = Z3_OP_PR_DER
    
    /// A proof of (or (not (forall (x) (P x))) (P a))
    static let opPrQuantInst = Z3_OP_PR_QUANT_INST
    
    /// Mark a hypothesis in a natural deduction style proof.
    static let opPrHypothesis = Z3_OP_PR_HYPOTHESIS
    
    ///     T1: false
    ///     [lemma T1]: (or (not l_1) ... (not l_n))
    /// 
    /// This proof object has one antecedent: a hypothetical proof for false.
    /// It converts the proof in a proof for (or (not l_1) ... (not l_n)),
    /// when T1 contains the open hypotheses: l_1, ..., l_n.
    /// The hypotheses are closed after an application of a lemma.
    /// Furthermore, there are no other open hypotheses in the subtree covered by
    /// the lemma.
    static let opPrLemma = Z3_OP_PR_LEMMA
    
    /// \nicebox{
    ///    T1:      (or l_1 ... l_n l_1' ... l_m')
    ///    T2:      (not l_1)
    ///    ...
    ///    T(n+1):  (not l_n)
    ///    [unit-resolution T1 ... T(n+1)]: (or l_1' ... l_m')
    ///    }
    static let opPrUnitResolution = Z3_OP_PR_UNIT_RESOLUTION
    
    /// \nicebox{
    ///  T1: p
    ///  [iff-true T1]: (iff p true)
    ///  }
    static let opPrIffTrue = Z3_OP_PR_IFF_TRUE
    
    /// \nicebox{
    ///  T1: (not p)
    ///  [iff-false T1]: (iff p false)
    ///  }
    static let opPrIffFalse = Z3_OP_PR_IFF_FALSE
    
    /// [comm]: (= (f a b) (f b a))
    /// 
    /// f is a commutative operator.
    /// 
    /// This proof object has no antecedents.
    /// Remark: if f is bool, then = is iff.
    static let opPrCommutativity = Z3_OP_PR_COMMUTATIVITY
    
    /// Proof object used to justify Tseitin's like axioms:
    /// \nicebox{
    /// (or (not (and p q)) p)
    /// (or (not (and p q)) q)
    /// (or (not (and p q r)) p)
    /// (or (not (and p q r)) q)
    /// (or (not (and p q r)) r)
    /// ...
    /// (or (and p q) (not p) (not q))
    /// (or (not (or p q)) p q)
    /// (or (or p q) (not p))
    /// (or (or p q) (not q))
    /// (or (not (iff p q)) (not p) q)
    /// (or (not (iff p q)) p (not q))
    /// (or (iff p q) (not p) (not q))
    /// (or (iff p q) p q)
    /// (or (not (ite a b c)) (not a) b)
    /// (or (not (ite a b c)) a c)
    /// (or (ite a b c) (not a) (not b))
    /// (or (ite a b c) a (not c))
    /// (or (not (not a)) (not a))
    /// (or (not a) a)
    /// }
    /// This proof object has no antecedents.
    /// Note: all axioms are propositional tautologies.
    /// Note also that 'and' and 'or' can take multiple arguments.
    /// You can recover the propositional tautologies by
    /// unfolding the Boolean connectives in the axioms a small
    /// bounded number of steps (=3).
    static let opPrDefAxiom = Z3_OP_PR_DEF_AXIOM
    
    /// Clausal proof adding axiom
    static let opPrAssumptionAdd = Z3_OP_PR_ASSUMPTION_ADD
    
    /// Clausal proof lemma addition
    static let opPrLemmaAdd = Z3_OP_PR_LEMMA_ADD
    
    /// Clausal proof lemma deletion
    static let opPrRedundantDel = Z3_OP_PR_REDUNDANT_DEL
    
    static let opPrClauseTrail = Z3_OP_PR_CLAUSE_TRAIL
    
    /// Introduces a name for a formula/term.
    /// Suppose e is an expression with free variables x, and def-intro
    /// introduces the name n(x). The possible cases are:
    /// 
    /// When e is of Boolean type:
    /// [def-intro]: (and (or n (not e)) (or (not n) e))
    /// 
    /// or:
    /// [def-intro]: (or (not n) e)
    /// when e only occurs positively.
    /// 
    /// When e is of the form (ite cond th el):
    /// [def-intro]: (and (or (not cond) (= n th)) (or cond (= n el)))
    /// 
    /// Otherwise:
    /// [def-intro]: (= n e)
    static let opPrDefIntro = Z3_OP_PR_DEF_INTRO
    
    ///    [apply-def T1]: F ~ n
    /// 
    /// F is 'equivalent' to n, given that T1 is a proof that
    /// n is a name for F.
    static let opPrApplyDef = Z3_OP_PR_APPLY_DEF
    
    /// T1: (iff p q)
    /// [iff~ T1]: (~ p q)
    static let opPrIffOeq = Z3_OP_PR_IFF_OEQ
    
    /// Proof for a (positive) NNF step. Example:
    /// 
    ///    T1: (not s_1) ~ r_1
    ///    T2: (not s_2) ~ r_2
    ///    T3: s_1 ~ r_1'
    ///    T4: s_2 ~ r_2'
    ///    [nnf-pos T1 T2 T3 T4]: (~ (iff s_1 s_2) (and (or r_1 r_2') (or r_1' r_2)))
    /// 
    /// The negation normal form steps NNF_POS and NNF_NEG are used in the following cases:
    /// (a) When creating the NNF of a positive force quantifier.
    /// The quantifier is retained (unless the bound variables are eliminated).
    /// Example
    /// 
    ///      T1: q ~ q_new
    ///      [nnf-pos T1]: (~ (forall (x T) q) (forall (x T) q_new))
    /// 
    /// (b) When recursively creating NNF over Boolean formulas, where the top-level
    /// connective is changed during NNF conversion. The relevant Boolean connectives
    /// for NNF_POS are 'implies', 'iff', 'xor', 'ite'.
    /// NNF_NEG furthermore handles the case where negation is pushed
    /// over Boolean connectives 'and' and 'or'.
    static let opPrNnfPos = Z3_OP_PR_NNF_POS
    
    /// Proof for a (negative) NNF step. Examples:
    /// 
    /// T1: (not s_1) ~ r_1
    /// ...
    /// Tn: (not s_n) ~ r_n
    /// [nnf-neg T1 ... Tn]: (not (and s_1 ... s_n)) ~ (or r_1 ... r_n)
    /// 
    /// and
    /// 
    /// T1: (not s_1) ~ r_1
    /// ...
    /// Tn: (not s_n) ~ r_n
    /// [nnf-neg T1 ... Tn]: (not (or s_1 ... s_n)) ~ (and r_1 ... r_n)
    /// 
    /// and
    /// 
    /// T1: (not s_1) ~ r_1
    /// T2: (not s_2) ~ r_2
    /// T3: s_1 ~ r_1'
    /// T4: s_2 ~ r_2'
    /// [nnf-neg T1 T2 T3 T4]: (~ (not (iff s_1 s_2))
    ///                          (and (or r_1 r_2) (or r_1' r_2')))
    static let opPrNnfNeg = Z3_OP_PR_NNF_NEG
    
    /// Proof for:
    /// 
    ///      [sk]: (~ (not (forall x (p x y))) (not (p (sk y) y)))
    ///      [sk]: (~ (exists x (p x y)) (p (sk y) y))
    /// 
    /// This proof object has no antecedents.
    static let opPrSkolemize = Z3_OP_PR_SKOLEMIZE
    
    /// Modus ponens style rule for equi-satisfiability.
    /// 
    /// T1: p
    /// T2: (~ p q)
    /// [mp~ T1 T2]: q
    static let opPrModusPonensOeq = Z3_OP_PR_MODUS_PONENS_OEQ
    
    /// Generic proof for theory lemmas.
    /// The theory lemma function comes with one or more parameters.
    /// The first parameter indicates the name of the theory.
    /// For the theory of arithmetic, additional parameters provide hints for
    /// checking the theory lemma.
    /// The hints for arithmetic are:
    /// 
    ///     - farkas - followed by rational coefficients. Multiply the coefficients to the
    ///       inequalities in the lemma, add the (negated) inequalities and obtain a contradiction.
    /// 
    ///     - triangle-eq - Indicates a lemma related to the equivalence:
    /// 
    ///        (iff (= t1 t2) (and (<= t1 t2) (<= t2 t1)))
    /// 
    ///     - gcd-test - Indicates an integer linear arithmetic lemma that uses a gcd test.
    static let opPrThLemma = Z3_OP_PR_TH_LEMMA
    
    /// Hyper-resolution rule.
    /// 
    /// The premises of the rules is a sequence of clauses.
    /// The first clause argument is the main clause of the rule.
    /// with a literal from the first (main) clause.
    /// 
    /// Premises of the rules are of the form
    /// \nicebox{
    ///         (or l0 l1 l2 .. ln)
    /// }
    /// or
    /// \nicebox{
    ///      (=> (and l1 l2 .. ln) l0)
    /// }
    /// or in the most general (ground) form:
    /// \nicebox{
    ///      (=> (and ln+1 ln+2 .. ln+m) (or l0 l1 .. ln))
    /// }
    /// In other words we use the following (Prolog style) convention for Horn
    /// implications:
    /// The head of a Horn implication is position 0,
    /// the first conjunct in the body of an implication is position 1
    /// the second conjunct in the body of an implication is position 2
    /// 
    /// For general implications where the head is a disjunction, the
    /// first n positions correspond to the n disjuncts in the head.
    /// The next m positions correspond to the m conjuncts in the body.
    /// 
    /// The premises can be universally quantified so that the most
    /// general non-ground form is:
    /// 
    /// \nicebox{
    ///      (forall (vars) (=> (and ln+1 ln+2 .. ln+m) (or l0 l1 .. ln)))
    /// }
    /// 
    /// The hyper-resolution rule takes a sequence of parameters.
    /// The parameters are substitutions of bound variables separated by pairs
    /// of literal positions from the main clause and side clause.
    static let opPrHyperResolve = Z3_OP_PR_HYPER_RESOLVE
    
    /// Insert a record into a relation.
    /// The function takes `n`+1 arguments, where the first argument is the relation and the remaining `n` elements
    /// correspond to the `n` columns of the relation.
    static let opRaStore = Z3_OP_RA_STORE
    
    /// Creates the empty relation.
    static let opRaEmpty = Z3_OP_RA_EMPTY
    
    /// Tests if the relation is empty.
    static let opRaIsEmpty = Z3_OP_RA_IS_EMPTY
    
    /// Create the relational join.
    static let opRaJoin = Z3_OP_RA_JOIN
    
    /// Create the union or convex hull of two relations.
    /// The function takes two arguments.
    static let opRaUnion = Z3_OP_RA_UNION
    
    /// Widen two relations.
    /// The function takes two arguments.
    static let opRaWiden = Z3_OP_RA_WIDEN
    
    /// Project the columns (provided as numbers in the parameters).
    /// The function takes one argument.
    static let opRaProject = Z3_OP_RA_PROJECT
    
    /// Filter (restrict) a relation with respect to a predicate.
    /// The first argument is a relation.
    /// The second argument is a predicate with free de-Bruijn indices
    /// corresponding to the columns of the relation.
    /// So the first column in the relation has index 0.
    static let opRaFilter = Z3_OP_RA_FILTER
    
    /// Intersect the first relation with respect to negation
    /// of the second relation (the function takes two arguments).
    /// Logically, the specification can be described by a function
    /// 
    ///    target = filter_by_negation(pos, neg, columns)
    /// 
    /// where columns are pairs c1, d1, .., cN, dN of columns from pos and neg, such that
    /// target are elements in x in pos, such that there is no y in neg that agrees with
    /// x on the columns c1, d1, .., cN, dN.
    static let opRaNegationFilter = Z3_OP_RA_NEGATION_FILTER
    
    /// rename columns in the relation.
    /// The function takes one argument.
    /// The parameters contain the renaming as a cycle.
    static let opRaRename = Z3_OP_RA_RENAME
    
    /// Complement the relation.
    static let opRaComplement = Z3_OP_RA_COMPLEMENT
    
    /// Check if a record is an element of the relation.
    /// The function takes `n`+1 arguments, where the first argument is a relation,
    /// and the remaining `n` arguments correspond to a record.
    static let opRaSelect = Z3_OP_RA_SELECT
    
    /// Create a fresh copy (clone) of a relation.
    /// The function is logically the identity, but
    /// in the context of a register machine allows
    /// for #Z3_OP_RA_UNION to perform destructive updates to the first argument.
    static let opRaClone = Z3_OP_RA_CLONE
    
    static let opFdConstant = Z3_OP_FD_CONSTANT
    
    /// A less than predicate over the finite domain Z3_FINITE_DOMAIN_SORT.
    static let opFdLt = Z3_OP_FD_LT
    
    static let opSeqUnit = Z3_OP_SEQ_UNIT
    
    static let opSeqEmpty = Z3_OP_SEQ_EMPTY
    
    static let opSeqConcat = Z3_OP_SEQ_CONCAT
    
    static let opSeqPrefix = Z3_OP_SEQ_PREFIX
    
    static let opSeqSuffix = Z3_OP_SEQ_SUFFIX
    
    static let opSeqContains = Z3_OP_SEQ_CONTAINS
    
    static let opSeqExtract = Z3_OP_SEQ_EXTRACT
    
    static let opSeqReplace = Z3_OP_SEQ_REPLACE
    
    static let opSeqReplaceRe = Z3_OP_SEQ_REPLACE_RE
    
    static let opSeqReplaceReAll = Z3_OP_SEQ_REPLACE_RE_ALL
    
    static let opSeqReplaceAll = Z3_OP_SEQ_REPLACE_ALL
    
    static let opSeqAt = Z3_OP_SEQ_AT
    
    static let opSeqNth = Z3_OP_SEQ_NTH
    
    static let opSeqLength = Z3_OP_SEQ_LENGTH
    
    static let opSeqIndex = Z3_OP_SEQ_INDEX
    
    static let opSeqLastIndex = Z3_OP_SEQ_LAST_INDEX
    
    static let opSeqToRe = Z3_OP_SEQ_TO_RE
    
    static let opSeqInRe = Z3_OP_SEQ_IN_RE
    
    static let opStrToInt = Z3_OP_STR_TO_INT
    
    static let opIntToStr = Z3_OP_INT_TO_STR
    
    static let opUbvToStr = Z3_OP_UBV_TO_STR
    
    static let opSbvToStr = Z3_OP_SBV_TO_STR
    
    static let opStrToCode = Z3_OP_STR_TO_CODE
    
    static let opStrFromCode = Z3_OP_STR_FROM_CODE
    
    static let opStringLt = Z3_OP_STRING_LT
    
    static let opStringLe = Z3_OP_STRING_LE
    
    static let opRePlus = Z3_OP_RE_PLUS
    
    static let opReStar = Z3_OP_RE_STAR
    
    static let opReOption = Z3_OP_RE_OPTION
    
    static let opReConcat = Z3_OP_RE_CONCAT
    
    static let opReUnion = Z3_OP_RE_UNION
    
    static let opReRange = Z3_OP_RE_RANGE
    
    static let opReDiff = Z3_OP_RE_DIFF
    
    static let opReIntersect = Z3_OP_RE_INTERSECT
    
    static let opReLoop = Z3_OP_RE_LOOP
    
    static let opRePower = Z3_OP_RE_POWER
    
    static let opReComplement = Z3_OP_RE_COMPLEMENT
    
    static let opReEmptySet = Z3_OP_RE_EMPTY_SET
    
    static let opReFullSet = Z3_OP_RE_FULL_SET
    
    static let opReFullCharSet = Z3_OP_RE_FULL_CHAR_SET
    
    static let opReOfPred = Z3_OP_RE_OF_PRED
    
    static let opReReverse = Z3_OP_RE_REVERSE
    
    static let opReDerivative = Z3_OP_RE_DERIVATIVE
    
    static let opCharConst = Z3_OP_CHAR_CONST
    
    static let opCharLe = Z3_OP_CHAR_LE
    
    static let opCharToInt = Z3_OP_CHAR_TO_INT
    
    static let opCharToBv = Z3_OP_CHAR_TO_BV
    
    static let opCharFromBv = Z3_OP_CHAR_FROM_BV
    
    static let opCharIsDigit = Z3_OP_CHAR_IS_DIGIT
    
    /// A label (used by the Boogie Verification condition generator).
    /// The label has two parameters, a string and a Boolean polarity.
    /// It takes one argument, a formula.
    static let opLabel = Z3_OP_LABEL
    
    /// A label literal (used by the Boogie Verification condition generator).
    /// A label literal has a set of string parameters. It takes no arguments.
    static let opLabelLit = Z3_OP_LABEL_LIT
    
    /// datatype constructor.
    static let opDtConstructor = Z3_OP_DT_CONSTRUCTOR
    
    /// datatype recognizer.
    static let opDtRecogniser = Z3_OP_DT_RECOGNISER
    
    /// datatype recognizer.
    static let opDtIs = Z3_OP_DT_IS
    
    /// datatype accessor.
    static let opDtAccessor = Z3_OP_DT_ACCESSOR
    
    /// datatype field update.
    static let opDtUpdateField = Z3_OP_DT_UPDATE_FIELD
    
    /// Cardinality constraint.
    /// E.g., x + y + z <= 2
    static let opPbAtMost = Z3_OP_PB_AT_MOST
    
    /// Cardinality constraint.
    /// E.g., x + y + z >= 2
    static let opPbAtLeast = Z3_OP_PB_AT_LEAST
    
    /// Generalized Pseudo-Boolean cardinality constraint.
    /// Example  2*x + 3*y <= 4
    static let opPbLe = Z3_OP_PB_LE
    
    /// Generalized Pseudo-Boolean cardinality constraint.
    /// Example  2*x + 3*y + 2*z >= 4
    static let opPbGe = Z3_OP_PB_GE
    
    /// Generalized Pseudo-Boolean equality constraint.
    /// Example  2*x + 1*y + 2*z + 1*u = 4
    static let opPbEq = Z3_OP_PB_EQ
    
    /// A relation that is a total linear order
    static let opSpecialRelationLo = Z3_OP_SPECIAL_RELATION_LO
    
    /// A relation that is a partial order
    static let opSpecialRelationPo = Z3_OP_SPECIAL_RELATION_PO
    
    /// A relation that is a piecewise linear order
    static let opSpecialRelationPlo = Z3_OP_SPECIAL_RELATION_PLO
    
    /// A relation that is a tree order
    static let opSpecialRelationTo = Z3_OP_SPECIAL_RELATION_TO
    
    /// Transitive closure of a relation
    static let opSpecialRelationTc = Z3_OP_SPECIAL_RELATION_TC
    
    /// Transitive reflexive closure of a relation
    static let opSpecialRelationTrc = Z3_OP_SPECIAL_RELATION_TRC
    
    /// Floating-point rounding mode RNE
    static let opFpaRmNearestTiesToEven = Z3_OP_FPA_RM_NEAREST_TIES_TO_EVEN
    
    /// Floating-point rounding mode RNA
    static let opFpaRmNearestTiesToAway = Z3_OP_FPA_RM_NEAREST_TIES_TO_AWAY
    
    /// Floating-point rounding mode RTP
    static let opFpaRmTowardPositive = Z3_OP_FPA_RM_TOWARD_POSITIVE
    
    /// Floating-point rounding mode RTN
    static let opFpaRmTowardNegative = Z3_OP_FPA_RM_TOWARD_NEGATIVE
    
    /// Floating-point rounding mode RTZ
    static let opFpaRmTowardZero = Z3_OP_FPA_RM_TOWARD_ZERO
    
    /// Floating-point value
    static let opFpaNum = Z3_OP_FPA_NUM
    
    /// Floating-point +oo
    static let opFpaPlusInf = Z3_OP_FPA_PLUS_INF
    
    /// Floating-point -oo
    static let opFpaMinusInf = Z3_OP_FPA_MINUS_INF
    
    /// Floating-point NaN
    static let opFpaNan = Z3_OP_FPA_NAN
    
    /// Floating-point +zero
    static let opFpaPlusZero = Z3_OP_FPA_PLUS_ZERO
    
    /// Floating-point -zero
    static let opFpaMinusZero = Z3_OP_FPA_MINUS_ZERO
    
    /// Floating-point addition
    static let opFpaAdd = Z3_OP_FPA_ADD
    
    /// Floating-point subtraction
    static let opFpaSub = Z3_OP_FPA_SUB
    
    /// Floating-point negation
    static let opFpaNeg = Z3_OP_FPA_NEG
    
    /// Floating-point multiplication
    static let opFpaMul = Z3_OP_FPA_MUL
    
    /// Floating-point division
    static let opFpaDiv = Z3_OP_FPA_DIV
    
    /// Floating-point remainder
    static let opFpaRem = Z3_OP_FPA_REM
    
    /// Floating-point absolute value
    static let opFpaAbs = Z3_OP_FPA_ABS
    
    /// Floating-point minimum
    static let opFpaMin = Z3_OP_FPA_MIN
    
    /// Floating-point maximum
    static let opFpaMax = Z3_OP_FPA_MAX
    
    /// Floating-point fused multiply-add
    static let opFpaFma = Z3_OP_FPA_FMA
    
    /// Floating-point square root
    static let opFpaSqrt = Z3_OP_FPA_SQRT
    
    /// Floating-point round to integral
    static let opFpaRoundToIntegral = Z3_OP_FPA_ROUND_TO_INTEGRAL
    
    /// Floating-point equality
    static let opFpaEq = Z3_OP_FPA_EQ
    
    /// Floating-point less than
    static let opFpaLt = Z3_OP_FPA_LT
    
    /// Floating-point greater than
    static let opFpaGt = Z3_OP_FPA_GT
    
    /// Floating-point less than or equal
    static let opFpaLe = Z3_OP_FPA_LE
    
    /// Floating-point greater than or equal
    static let opFpaGe = Z3_OP_FPA_GE
    
    /// Floating-point isNaN
    static let opFpaIsNan = Z3_OP_FPA_IS_NAN
    
    /// Floating-point isInfinite
    static let opFpaIsInf = Z3_OP_FPA_IS_INF
    
    /// Floating-point isZero
    static let opFpaIsZero = Z3_OP_FPA_IS_ZERO
    
    /// Floating-point isNormal
    static let opFpaIsNormal = Z3_OP_FPA_IS_NORMAL
    
    /// Floating-point isSubnormal
    static let opFpaIsSubnormal = Z3_OP_FPA_IS_SUBNORMAL
    
    /// Floating-point isNegative
    static let opFpaIsNegative = Z3_OP_FPA_IS_NEGATIVE
    
    /// Floating-point isPositive
    static let opFpaIsPositive = Z3_OP_FPA_IS_POSITIVE
    
    /// Floating-point constructor from 3 bit-vectors
    static let opFpaFp = Z3_OP_FPA_FP
    
    /// Floating-point conversion (various)
    static let opFpaToFp = Z3_OP_FPA_TO_FP
    
    /// Floating-point conversion from unsigned bit-vector
    static let opFpaToFpUnsigned = Z3_OP_FPA_TO_FP_UNSIGNED
    
    /// Floating-point conversion to unsigned bit-vector
    static let opFpaToUbv = Z3_OP_FPA_TO_UBV
    
    /// Floating-point conversion to signed bit-vector
    static let opFpaToSbv = Z3_OP_FPA_TO_SBV
    
    /// Floating-point conversion to real number
    static let opFpaToReal = Z3_OP_FPA_TO_REAL
    
    /// Floating-point conversion to IEEE-754 bit-vector
    static let opFpaToIeeeBv = Z3_OP_FPA_TO_IEEE_BV
    
    /// (Implicitly) represents the internal bitvector-
    /// representation of a floating-point term (used for the lazy encoding
    /// of non-relevant terms in theory_fpa)
    static let opFpaBvwrap = Z3_OP_FPA_BVWRAP
    
    /// Conversion of a 3-bit bit-vector term to a
    /// floating-point rounding-mode term
    /// 
    /// The conversion uses the following values:
    ///     0 = 000 = Z3_OP_FPA_RM_NEAREST_TIES_TO_EVEN,
    ///     1 = 001 = Z3_OP_FPA_RM_NEAREST_TIES_TO_AWAY,
    ///     2 = 010 = Z3_OP_FPA_RM_TOWARD_POSITIVE,
    ///     3 = 011 = Z3_OP_FPA_RM_TOWARD_NEGATIVE,
    ///     4 = 100 = Z3_OP_FPA_RM_TOWARD_ZERO.
    static let opFpaBv2rm = Z3_OP_FPA_BV2RM
    
    /// internal (often interpreted) symbol, but no additional
    /// information is exposed. Tools may use the string representation of the
    /// function declaration to obtain more information.
    static let opInternal = Z3_OP_INTERNAL
    
    /// function declared as recursive
    static let opRecursive = Z3_OP_RECURSIVE
    
    /// kind used for uninterpreted symbols.
    static let opUninterpreted = Z3_OP_UNINTERPRETED
}
