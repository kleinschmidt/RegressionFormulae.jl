# add some syntax to manually promote to full dummy coding
fulldummy(t::AbstractTerm) =
    throw(ArgumentError("can't promote $t (of type $(typeof(t))) to full dummy " *
                        "coding (only CategoricalTerms)"))

function StatsModels.apply_schema(
    t::FunctionTerm{typeof(fulldummy)},
    sch::StatsModels.FullRank,
    Mod::Type{<:RegressionModel},
)
    fulldummy(apply_schema.(t.args, Ref(sch), Mod)...)
end

function fulldummy(t::CategoricalTerm)
    new_contrasts = StatsModels.ContrastsMatrix(
        StatsModels.FullDummyCoding(),
        t.contrasts.levels,
    )
    t = CategoricalTerm(t.sym, new_contrasts)
end
