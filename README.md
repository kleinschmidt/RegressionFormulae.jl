# RegressionFormulae

![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://kleinschmidt.github.io/RegressionFormulae.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://kleinschmidt.github.io/RegressionFormulae.jl/dev)
[![Codecov](https://codecov.io/gh/kleinschmidt/RegressionFormulae.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/kleinschmidt/RegressionFormulae.jl)

Extended [StatsModels.jl
`@formula`](https://www.github.com/JuliaStats/StatsModels.jl) syntax for
regression modeling.

Note that the functionality in this package is very new: please verify that the resulting schematized formulae and model coefficient (names) are what you were expecting, especially if you are combining multiple "advanced" formula features.

<!--
## Examples

```julia
using RegressionFormulae, StatsModels, GLM, DataFrames

```
-->

## Supported syntax ##

### Nesting syntax ###

`a / b` expands to `a + fulldummy(a) & b`.

Numeric constants are special cased so that `/` performs division, making it possible to e.g. convert time to speed in the formula:
```julia
julia> fit(MyModelType, @formula(time_in_milliseconds / 1000 ~ 1 + x), my_data)
``` 

### Raising terms to a power ###

Generate all main effects and interactions up to the specified order.  For
instance, `(a+b+c)^2` generates `a + b + c + a&b + a&c + b&c`, but not `a&b&c`.

**NB:** The presence of interaction terms within the base will result in redundant terms and is currently unsupported.

## Approach

Extended syntax is supported at two levels.  First, RegressionFormulae.jl
defines `apply_schema` methods that capture calls within a `@formula` to the
special syntax (`^`, `/`, etc.).  Second, we define methods for the
corresponding functions in `Base` (`Base.:(^)`, `Base.:(/)`, etc.) for arguments
that are `<:AbstractTerm` which implement the special behavior, returning the
appropriate terms.  This allows the syntax to be used both within a `@formula`
and for constructing terms programmatically at run-time.

If using `apply_schema` directly, please note that you need to pass an appropriate model type as context. 
Currently, the extensions here are defined for [`StatsAPI.RegressionModel`](https://github.com/JuliaStats/StatsAPI.jl/blob/main/src/regressionmodel.jl) and subtypes:

```julia
 julia apply_schema(f, s, RegressionModel)
```
