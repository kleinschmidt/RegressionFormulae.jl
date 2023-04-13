combinations_upto(x, n) = Iterators.flatten(combinations(x, i) for i in 1:n)

"""
    (term1, term2, ...) ^ n

Generate all interactions of terms up to order ``n``.

!!! warning
    If any term is an `InteractionTerm`, then nonsensical interactions may
    arise, e.g. `a & a & b`.
"""
function Base.:(^)(args::TupleTerm, deg::ConstantTerm{<:Integer})
    deg.n > 0 || throw(ArgumentError("power should be greater than zero (got $deg)"))
    any(t isa InteractionTerm for t in args) &&
        throw(ArgumentError("powers of interaction terms not currently supported"))
    tuple(((&)(terms...) for terms in combinations_upto(args, deg.n))...)
end

function Base.:(^)(::TupleTerm, deg::AbstractTerm)
    throw(ArgumentError("power should be an integer constant (got $deg)"))
end

function StatsModels.apply_schema(
    t::FunctionTerm{typeof(^)},
    sch::StatsModels.FullRank,
    ctx::Type{<:RegressionModel}
)
    length(t.args) == 2 ||
        throw(ArgumentError("invalid term $t: should have exactly two arguments"))
    first, second = t.args

    base = apply_schema(first, sch, ctx)
    return base^second
end

# StatsModels
