using StatsModels
using RegressionFormulae
using Test

include("dummymod.jl")

dat = (; y=zeros(3), a=["u","i","o"], b=["q","w","e"], c=["s","d","f"], x=1:3)

@testset "error checking" begin
    sch = schema(dat)
    @test_throws ArgumentError apply_schema(@formula(y ~ x / a), sch, RegressionModel)
    @test_throws ArgumentError apply_schema(@formula(y ~ /(a, b, c)), sch, RegressionModel)
    @test !RegressionFormulae._isfulldummy(term(:a))
end

@testset "single nesting level" begin
    m = fit(DummyMod, @formula(y ~ 0 + a / b), dat)
    @test coefnames(m) == ["a: i", "a: o", "a: u",
                           "a: i & b: q", "a: o & b: q", "a: u & b: q",
                           "a: i & b: w", "a: o & b: w", "a: u & b: w"]

    m = fit(DummyMod, @formula(y ~ 0 + a / x), dat)
    @test coefnames(m) == ["a: i", "a: o", "a: u",
                           "a: i & x", "a: o & x", "a: u & x"]

    m = fit(DummyMod, @formula(y ~ 1 + a / b), dat)
    @test coefnames(m) == ["(Intercept)", "a: o", "a: u",
                           "a: i & b: q", "a: o & b: q", "a: u & b: q",
                           "a: i & b: w", "a: o & b: w", "a: u & b: w"]

    m = fit(DummyMod, @formula(y ~ 1 + a / x), dat)
    @test coefnames(m) == ["(Intercept)", "a: o", "a: u",
                           "a: i & x", "a: o & x", "a: u & x"]

    m = fit(DummyMod, @formula(y ~ 0 + a / (b + x)), dat)
    @test coefnames(m) == ["a: i", "a: o", "a: u",
                           "a: i & b: q", "a: o & b: q", "a: u & b: q",
                           "a: i & b: w", "a: o & b: w", "a: u & b: w",
                           "a: i & x", "a: o & x", "a: u & x"]
    m = fit(DummyMod, @formula(y ~ 0 + a / (b * x)), dat)
    @test coefnames(m) == ["a: i", "a: o", "a: u",
                           "a: i & b: q", "a: o & b: q", "a: u & b: q",
                           "a: i & b: w", "a: o & b: w", "a: u & b: w",
                           "a: i & x", "a: o & x", "a: u & x",
                           "a: i & b: q & x", "a: o & b: q & x", "a: u & b: q & x",
                           "a: i & b: w & x", "a: o & b: w & x", "a: u & b: w & x"]
end

@testset "multiple nesting levels" begin
    m = fit(DummyMod, @formula(y ~ 0 + a / b / c), dat)
    @test coefnames(m) == ["a: i", "a: o", "a: u",
                           "a: i & b: q", "a: o & b: q", "a: u & b: q",
                           "a: i & b: w", "a: o & b: w", "a: u & b: w",
                           "a: i & b: q & c: f", "a: o & b: q & c: f",
                           "a: u & b: q & c: f", "a: i & b: w & c: f",
                           "a: o & b: w & c: f", "a: u & b: w & c: f",
                           "a: i & b: q & c: s", "a: o & b: q & c: s",
                           "a: u & b: q & c: s", "a: i & b: w & c: s",
                           "a: o & b: w & c: s", "a: u & b: w & c: s"]
    m = fit(DummyMod, @formula(y ~ 0 + a / b / x), dat)
    @test coefnames(m) == ["a: i", "a: o", "a: u",
                           "a: i & b: q", "a: o & b: q", "a: u & b: q",
                           "a: i & b: w", "a: o & b: w", "a: u & b: w",
                           "a: i & b: q & x", "a: o & b: q & x",
                           "a: u & b: q & x", "a: i & b: w & x",
                           "a: o & b: w & x", "a: u & b: w & x"]
    m = fit(DummyMod, @formula(y ~ 1 + a / b / c), dat)
    @test coefnames(m) == ["(Intercept)", "a: o", "a: u",
                           "a: i & b: q", "a: o & b: q", "a: u & b: q",
                           "a: i & b: w", "a: o & b: w", "a: u & b: w",
                           "a: i & b: q & c: f", "a: o & b: q & c: f",
                           "a: u & b: q & c: f", "a: i & b: w & c: f",
                           "a: o & b: w & c: f", "a: u & b: w & c: f",
                           "a: i & b: q & c: s", "a: o & b: q & c: s",
                           "a: u & b: q & c: s", "a: i & b: w & c: s",
                           "a: o & b: w & c: s", "a: u & b: w & c: s"]
    m = fit(DummyMod, @formula(y ~ 1 + a / b / x), dat)
    @test coefnames(m) == ["(Intercept)", "a: o", "a: u",
                           "a: i & b: q", "a: o & b: q", "a: u & b: q",
                           "a: i & b: w", "a: o & b: w", "a: u & b: w",
                           "a: i & b: q & x", "a: o & b: q & x",
                           "a: u & b: q & x", "a: i & b: w & x",
                           "a: o & b: w & x", "a: u & b: w & x"]

    m = fit(DummyMod, @formula(y ~ 0 + a / b / (c * x)), dat)
    @test coefnames(m) == ["a: i", "a: o", "a: u",
                           "a: i & b: q", "a: o & b: q", "a: u & b: q",
                           "a: i & b: w", "a: o & b: w", "a: u & b: w",
                           "a: i & b: q & c: f", "a: o & b: q & c: f", "a: u & b: q & c: f",
                           "a: i & b: w & c: f", "a: o & b: w & c: f", "a: u & b: w & c: f",
                           "a: i & b: q & c: s", "a: o & b: q & c: s", "a: u & b: q & c: s",
                           "a: i & b: w & c: s", "a: o & b: w & c: s", "a: u & b: w & c: s",
                           "a: i & b: q & x", "a: o & b: q & x", "a: u & b: q & x",
                           "a: i & b: w & x", "a: o & b: w & x", "a: u & b: w & x",
                           "a: i & b: q & c: f & x", "a: o & b: q & c: f & x", "a: u & b: q & c: f & x",
                           "a: i & b: w & c: f & x", "a: o & b: w & c: f & x", "a: u & b: w & c: f & x",
                           "a: i & b: q & c: s & x", "a: o & b: q & c: s & x", "a: u & b: q & c: s & x",
                           "a: i & b: w & c: s & x", "a: o & b: w & c: s & x", "a: u & b: w & c: s & x"]
end
