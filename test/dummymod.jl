module TestModels

export DummyMod, DummyModNoIntercept

# taken from StatsModels
# https://github.com/JuliaStats/StatsModels.jl/blob/dee41c287033c0e9c18714a8d63bae61302027a6/test/statsmodel.jl
using StatsBase
using StatsModels

# A dummy RegressionModel type
struct DummyMod <: RegressionModel
    beta::Vector{Float64}
    x::Matrix
    y::Vector
end

## dumb fit method: just copy the x and y input over
StatsBase.fit(::Type{DummyMod}, x::Matrix, y::Vector) =
    DummyMod(collect(1:size(x, 2)), x, y)
StatsBase.response(mod::DummyMod) = mod.y
## dumb coeftable: just prints the "beta" values
StatsBase.coeftable(mod::DummyMod) =
    CoefTable(reshape(mod.beta, (size(mod.beta,1), 1)),
              ["'beta' value"],
              ["" for n in 1:size(mod.x,2)],
              0)
# dumb predict: return values predicted by "beta" and dummy confidence bounds
function StatsBase.predict(mod::DummyMod;
                           interval::Union{Nothing,Symbol}=nothing)
    pred = mod.x * mod.beta
    if interval === nothing
        return pred
    elseif interval === :prediction
        return (prediction=pred, lower=pred .- 1, upper=pred .+ 1)
    else
        throw(ArgumentError("value not allowed for interval"))
    end
end
function StatsBase.predict(mod::DummyMod, newX::Matrix;
                           interval::Union{Nothing,Symbol}=nothing)
    pred = newX * mod.beta
    if interval === nothing
        return pred
    elseif interval === :prediction
        return (prediction=pred, lower=pred .- 1, upper=pred .+ 1)
    else
        throw(ArgumentError("value not allowed for interval"))
    end
end
StatsBase.dof(mod::DummyMod) = length(mod.beta)
StatsBase.dof_residual(mod::DummyMod) = length(mod.y) - length(mod.beta)
StatsBase.nobs(mod::DummyMod) = length(mod.y)
StatsBase.deviance(mod::DummyMod) = sum((response(mod) .- predict(mod)).^2)
# Incorrect but simple definition
StatsModels.isnested(mod1::DummyMod, mod2::DummyMod; atol::Real=0.0) =
    dof(mod1) <= dof(mod2)
StatsBase.loglikelihood(mod::DummyMod) = -sum((response(mod) .- predict(mod)).^2)
StatsBase.loglikelihood(mod::DummyMod, ::Colon) = -(response(mod) .- predict(mod)).^2

# A dummy RegressionModel type that does not support intercept
struct DummyModNoIntercept <: RegressionModel
    beta::Vector{Float64}
    x::Matrix
    y::Vector
end

StatsModels.drop_intercept(::Type{DummyModNoIntercept}) = true

## dumb fit method: just copy the x and y input over
StatsBase.fit(::Type{DummyModNoIntercept}, x::Matrix, y::Vector) =
    DummyModNoIntercept(collect(1:size(x, 2)), x, y)
StatsBase.response(mod::DummyModNoIntercept) = mod.y
## dumb coeftable: just prints the "beta" values
StatsBase.coeftable(mod::DummyModNoIntercept) =
    CoefTable(reshape(mod.beta, (size(mod.beta,1), 1)),
              ["'beta' value"],
              ["" for n in 1:size(mod.x,2)],
              0)
# dumb predict: return values predicted by "beta" and dummy confidence bounds
function StatsBase.predict(mod::DummyModNoIntercept;
                           interval::Union{Nothing,Symbol}=nothing)
    pred = mod.x * mod.beta
    if interval === nothing
        return pred
    elseif interval === :prediction
        return (prediction=pred, lower=pred .- 1, upper=pred .+ 1)
    else
        throw(ArgumentError("value not allowed for interval"))
    end
end
function StatsBase.predict(mod::DummyModNoIntercept, newX::Matrix;
                           interval::Union{Nothing,Symbol}=nothing)
    pred = newX * mod.beta
    if interval === nothing
        return pred
    elseif interval === :prediction
        return (prediction=pred, lower=pred .- 1, upper=pred .+ 1)
    else
        throw(ArgumentError("value not allowed for interval"))
    end
end
StatsBase.dof(mod::DummyModNoIntercept) = length(mod.beta)
StatsBase.dof_residual(mod::DummyModNoIntercept) = length(mod.y) - length(mod.beta)
StatsBase.nobs(mod::DummyModNoIntercept) = length(mod.y)
StatsBase.deviance(mod::DummyModNoIntercept) = sum((response(mod) .- predict(mod)).^2)

end # module
