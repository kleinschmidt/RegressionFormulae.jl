module RegressionFormulae

using LinearAlgebra
using Statistics
using StatsAPI
using StatsModels
using Combinatorics
using Base.Iterators

using StatsModels: apply_schema, TupleTerm

const Schemas = Union{StatsModels.Schema, StatsModels.FullRank}

include("fulldummy.jl")
include("power.jl")
include("nesting.jl")

include("poly.jl")
export poly

end # module
