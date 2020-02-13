# RegressionFormula

![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://kleinschmidt.github.io/RegressionFormula.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://kleinschmidt.github.io/RegressionFormula.jl/dev)
[![Build Status](https://travis-ci.com/kleinschmidt/RegressionFormula.jl.svg?branch=master)](https://travis-ci.com/kleinschmidt/RegressionFormula.jl)
[![Codecov](https://codecov.io/gh/kleinschmidt/RegressionFormula.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/kleinschmidt/RegressionFormula.jl)

Extended `@formula` syntax for regression modeling.

## Nesting syntax

`a / b` expands to `a + fulldummy(a) & b`.

## Raising terms to a power

Generate all main effects and interactions up to the specified order.  For
instance, `(a+b+c)^2` generates `a + b + c + a&b + a&c + b&c`, but not `a&b&c`.
