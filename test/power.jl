using StatsModels
using RegressionFormulae
using Test

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

    # make sure inner function terms work
    m = fit(DummyMod, @formula(y ~ (a + b + log(a + b))^3), dat)
    @test coefnames(m) ==  ["(Intercept)", "a", "b", "log(a + b)",
                             "a & b", "a & log(a + b)", "b & log(a + b)",
                             "a & b & log(a + b)"]

    # cursed but should technically work
    m = fit(DummyMod, @formula(y ~ (a + b + (c + d)^1)^2), dat)
    @test coefnames(m) == ["(Intercept)", "a", "b", "c", "d",
                           "a & b", "a & c", "a & d",
                           "b & c", "b & d", "c & d"]
    # not actually an InteractionTerm even if it's mathematically equivalent for
    # ContinuousTerms
    # throws an error and is broken
    # https://github.com/JuliaStats/StatsModels.jl/issues/290
    # m = fit(DummyMod, @formula(y ~ (a + protect(c * d))^2), dat)
    # @test coefnames(m) == ["(Intercept)", "a", "c * d", "a & c *d "]
    # to remind us :this: is broken
    @test_broken false
end

@testset "embedded interactions" begin
    @test_throws ArgumentError fit(DummyMod, @formula(y ~ (a + b + c & d)^3), dat)
    @test_throws ArgumentError fit(DummyMod, @formula(y ~ (a + b + c * d)^3), dat)
end
