# two options here: either special-case ColumnTable (named tuple of vectors)
# vs. vanilla NamedTuple, or reshape and use normal broadcasting
function StatsModels.modelcols(t::InteractionTerm, d::NamedTuple)
    @info "named tuple"
    StatsModels.kron_insideout(*, (modelcols(term, d) for term in t.terms)...)
end

function StatsModels.modelcols(t::InteractionTerm, d::ColumnTable)
    @info "column table"
    # mc = [modelcols(term, d) for term in t.terms]
    # @info length(mc)
    # @info count(all(==(first(eachrow(col)), eachrow(col))) for col in mc)
    # for col in mc
    #     @info col
    # end
    # StatsModels.row_kron_insideout(*, (col for col in mc if !all(==(first(eachrow(col)), eachrow(col))))...)
    mc_lower_order = (modelcols(term, d) for term in t.terms)
    mc = StatsModels.row_kron_insideout(*, mc_lower_order...)

    idx = map(eachcol(mc)) do col
        return any(==(col), mc_lower_order)
    end

    return mc[:, idx]
end
