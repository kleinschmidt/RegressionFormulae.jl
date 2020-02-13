module RegressionFormula

using StatsModels
using Combinatorics
using Base.Iterators

import StatsModels: apply_schema

const TermTuple = NTuple{N, AbstractTerm} where N
const Schemas = Union{StatsModels.Schema, StatsModels.FullRank}

include("fulldummy.jl")
include("power.jl")

end # module
