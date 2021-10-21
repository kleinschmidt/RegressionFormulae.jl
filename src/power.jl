combinations_upto(x, n) = Iterators.flatten(combinations(x, i) for i in 1:n)

"""
    (term1, term2, ...) ^ n

Generate all interactions of terms up to order ``n``.

!!! warning
    If any term is an `InteractionTerm`, then nonsensical interactions may
    arise, e.g. `a & a & b`.
"""
function Base.:(^)(args::TermTuple, deg::ConstantTerm{<:Integer})
    tuple(((&)(terms...) for terms in combinations_upto(args, deg.n))...)
end

function Base.:(^)(::TermTuple, deg::AbstractTerm)
    throw(ArgumentError("power should be an integer constant (got $deg)"))
end

function StatsModels.apply_schema(
    t::FunctionTerm{typeof(^)},
    sch::StatsModels.FullRank,
    ctx::Type{<:RegressionModel}
)
    length(t.args_parsed) == 2 ||
        throw(ArgumentError("invalid term $t: should have exactly two arguments"))
    first, second = t.args_parsed
    second isa ConstantTerm{<:Integer} ||
        throw(ArgumentError("invalid term $t: power should be an integer (got $second)"))
    apply_schema.(first^second, Ref(sch), ctx)
end
