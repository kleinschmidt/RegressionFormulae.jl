
_isfulldummy(x::AbstractTerm) = false
function _isfulldummy(x::CategoricalTerm)
    return isa(x.contrasts, StatsModels.ContrastsMatrix{StatsModels.FullDummyCoding})
end

function _fulldummycheck(outer::InteractionTerm)
    all(_isfulldummy, outer.terms[1:end-1]) ||
        throw(ArgumentError("Outer interactions in a nesting must consist only " *
                            " of categorical terms with FullDummyCoding, got $outer"))
    return nothing
end

"""
    group / term

Generate predictors for `term` within each level of `group`.  Implemented as
`group + fulldummy(group) & term`.
"""
function Base.:(/)(outer::CategoricalTerm, inner::AbstractTerm)
    return outer + fulldummy(outer) & inner
end

function Base.:(/)(outer::CategoricalTerm, inner::TermTuple)
    fd = fulldummy(outer)
    return mapfoldl(x -> fd & x, +, inner; init=outer)
end

function Base.:(/)(outer::TermTuple, inner::Union{AbstractTerm, TermTuple})
    return outer[1:end-1] + last(outer) / inner
end

function Base.:(/)(outer::InteractionTerm, inner::AbstractTerm)
    # we should only get here via expansion where the interaction term,
    # but who knows what devious things users will try
    _fulldummycheck(outer)
    return outer + outer & inner
end

function Base.:(/)(outer::InteractionTerm, inner::TermTuple)
    # we should only get here via expansion where the interaction term,
    # but who knows what devious things users will try
    _fulldummycheck(outer)
    return mapfoldl(x -> outer & x, +, inner; init=outer)
end

function Base.:(/)(outer::AbstractTerm, inner::AbstractTerm)
    throw(ArgumentError("Nesting terms requires categorical grouping term, got $outer / $inner " *
                        "Manually specify $outer as `CategoricalTerm` in hints/contrasts"))
end

function StatsModels.apply_schema(
    t::FunctionTerm{typeof(/)},
    sch::StatsModels.FullRank,
    Mod::Type{<:RegressionModel},
)
    length(t.args_parsed) == 2 ||
        throw(ArgumentError("malformed nesting term: $t (Exactly two arguments required)"))

    any(x -> isa(x, ConstantTerm), t.args_parsed) && return t

    args = apply_schema.(t.args_parsed, Ref(sch), Mod)

    return first(args) / last(args)
end

