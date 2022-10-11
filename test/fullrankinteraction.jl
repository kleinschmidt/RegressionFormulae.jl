using StatsModels
using RegressionFormulae
using Test

include("dummymod.jl")

# y must not be the multiplicative or additive identity
# otherwise some of the tests will trivially pass
dat = (; y=ones(8),
       # nested, non factorial design
       x=["a", "a", "a", "a", "b", "b", "b", "b"],
       w=["c", "c", "d", "d", "e", "e", "f", "f"],
       z=1:8)

# naive approach could drpo b&d col, but won't create a&d when reference is a&c

# fit(DummyMod, @formula(y ~ x * w), dat)

sch = schema(dat)
f = apply_schema(@formula(y ~ x * w), sch, RegressionModel)
# return updated formula dropping the extra interactions
f, y, X = my_modelcols(f, dat)
coefnames(f)[2]
