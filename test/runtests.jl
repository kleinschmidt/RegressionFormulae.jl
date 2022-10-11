using RegressionFormulae
using StatsModels
using Test

@testset "fulldummy" begin
    include("fulldummy.jl")
end

@testset "nesting" begin
    include("nesting.jl")
end

@testset "powers of terms" begin
    include("power.jl")
end

@testset "full rank interactions" begin
    include("fullrankinteraction.jl")
end
