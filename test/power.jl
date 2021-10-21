using StatsModels
using RegressionFormulae
using Test

include("dummymod.jl")

dat = (; y=zeros(10), a=1:10, b=11:20, c=21:30)

m = fit(DummyMod, @formula(y ~ (a + b + c)^2), dat)
