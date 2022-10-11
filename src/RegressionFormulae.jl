module RegressionFormulae

using StatsAPI
using StatsModels
using Combinatorics
using Base.Iterators


using StatsModels: apply_schema
using Tables: ColumnTable

const TermTuple = NTuple{N, AbstractTerm} where N
const Schemas = Union{StatsModels.Schema, StatsModels.FullRank}

include("fulldummy.jl")
include("power.jl")
include("nesting.jl")
include("fullrankinteraction.jl")

end # module
