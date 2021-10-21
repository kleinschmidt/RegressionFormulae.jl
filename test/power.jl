using StatsModels
using RegressionFormulae
using Test

include("dummymod.jl")

dat = (; y=zeros(10), a=1:10, b=11:20, c=21:30, d=31:40, e=41:50)


@testset "error checking" begin
    @test_throws ArgumentError (term(:b),) ^ term(:a)

    sch = schema(dat)
    @test_throws ArgumentError apply_schema(@formula(y ~ ^(a, b, c)), sch, RegressionModel)
    @test_throws ArgumentError apply_schema(@formula(y ~ (a+b)^2.5), sch, RegressionModel)
end

@testset "powers of sums" begin
    m = fit(DummyMod, @formula(y ~ (a + b + c + d)^3), dat)
    @test coefnames(m) == ["(Intercept)", "a", "b", "c", "d",
                           "a & b", "a & c", "a & d", "b & c", "b & d", "c & d",
                           "a & b & c", "a & b & d", "a & c & d", "b & c & d"]
end

@testset "embedded interactions" begin
    m = fit(DummyMod, @formula(y ~ (a + b + c * d)^3), dat)
    cn = coefnames(m)
    @test_broken !("a & c & c & d" in cn)
    @test_broken length(cn) == length(Set(cn))
end
