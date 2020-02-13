# TODO: handle nested grouping.  This parses as (a / b) / c instead of
# (/)(a,b,c) so need to do the reduction manually

"""
    group / term

Generate predictors for `term` within each level of `group`.  Implemented as
`group + fulldummy(group) & term`.
"""
function Base.:(/)(args::AbstractTerm...)
    groups = (&)(args[1:end-1]...)
    term = last(args)
    return groups + fulldummy(groups) & term
end

function StatsModels.apply_schema(
    t::FunctionTerm{typeof(/)},
    sch::StatsModels.FullRank,
    Mod::Type{<:RegressionModel},
)
    length(t.args_parsed) == 2 ||
        throw(ArgumentError("malformed nesting term: $t (Exactly two arguments required"))

    args = apply_schema.(t.args_parsed, Ref(sch), Mod)

    map(args[1:end-1]) do arg 
        typeof(arg) <: CategoricalTerm ||
            throw(ArgumentError("nesting terms requires categorical grouping term, got $arg.  "*
                                "Manually specify $first as `CategoricalTerm` in hints/contrasts"))
    end
    
    return (/)(args...)
end
