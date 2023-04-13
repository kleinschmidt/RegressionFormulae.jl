using StatsModels
using RegressionFormulae
using Test

using RegressionFormulae: combinations_upto

include("dummymod.jl")

dat = (; y=zeros(3), a=1:3, b=11:13, c=21:23, d=31:33, e=["u", "i", "o"])


@testset "error checking" begin
    @test_throws ArgumentError (term(:b),) ^ term(:a)
    @test_throws ArgumentError (term(:b),) ^ term(2.5)
    @test_throws ArgumentError (term(:b),) ^ term(-2)

    sch = schema(dat)
    @test_throws ArgumentError apply_schema(@formula(y ~ ^(a, b, c)), sch, RegressionModel)
    @test_throws ArgumentError apply_schema(@formula(y ~ (a+b)^2.5), sch, RegressionModel)
end

@testset "powers of sums" begin
    m = fit(DummyMod, @formula(y ~ (a + b + c + d)^3), dat)
    @test coefnames(m) == ["(Intercept)", "a", "b", "c", "d",
                           "a & b", "a & c", "a & d", "b & c", "b & d", "c & d",
                           "a & b & c", "a & b & d", "a & c & d", "b & c & d"]

    m = fit(DummyMod, @formula(y ~ (1 + a + b + c + d)^3), dat)
    @test_broken coefnames(m) == ["(Intercept)", "a", "b", "c", "d",
                                  "a & b", "a & c", "a & d", "b & c", "b & d", "c & d",
                                  "a & b & c", "a & b & d", "a & c & d", "b & c & d"]

    m = fit(DummyMod, @formula(y ~ (a + b + e)^2), dat)
    @test coefnames(m) == ["(Intercept)", "a", "b", "e: o", "e: u",
                           "a & b", "a & e: o", "a & e: u", "b & e: o", "b & e: u"]
end

@testset "embedded interactions" begin
    m = fit(DummyMod, @formula(y ~ (a + b + c & d)^3), dat)
    cn = coefnames(m)
    @test cn == unique(cn)
    
    m = fit(DummyMod, @formula(y ~ (a + b + c * d)^3), dat)
    cn = coefnames(m)
    n_components = 5 # not quite right, but it's a, b, c, c&d
    # +1 because intercept
    expected_coefs = 1 + length(collect(combinations_upto(1:n_components, 3)))
    # @test_broken !("a & c & d" in cn) && !("a & c & d & c" in cn)
    @test_broken cn == unique(cn)
end
