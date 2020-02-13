using Documenter, RegressionFormula

makedocs(;
    modules=[RegressionFormula],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/kleinschmidt/RegressionFormula.jl/blob/{commit}{path}#L{line}",
    sitename="RegressionFormula.jl",
    authors="Dave Kleinschmidt",
    assets=String[],
)

deploydocs(;
    repo="github.com/kleinschmidt/RegressionFormula.jl",
)
