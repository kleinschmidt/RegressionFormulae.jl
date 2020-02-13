combinations_upto(x, n) = Iterators.flatten(combinations(x, i) for i in 1:n)

"""
    (term1, term2, ...) ^ n

Generate all interactions of terms up to order ``n``.
"""
function Base.:(^)(args::TermTuple, deg::ConstantTerm)
    tuple(((&)(terms...) for terms in combinations_upto(args, deg.n))...)
end

function StatsModels.apply_schema(
    t::FunctionTerm{typeof(^)},
    sch::StatsModels.FullRank,
    ctx::Type{RegressionModel}
)
    length(t.args_parsed) == 2 ||
        throw(ArgumentError("invalid term $t: should have exactly two arguments"))
    first, second = t.args_parsed
    second isa ConstantTerm ||
        throw(ArgumentError("invalid term $t: power should be a number (got $second)"))
    apply_schema.(first^second, Ref(sch), ctx)
end
