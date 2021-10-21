using Documenter, RegressionFormula

makedocs(;
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/kleinschmidt/RegressionFormula.jl/blob/{commit}{path}#L{line}",
    sitename="RegressionFormula.jl",
    authors=["Dave Kleinschmidt", "Phillip Alday"],
)

deploydocs(;
    repo="github.com/kleinschmidt/RegressionFormula.jl",
    devbranch = "main",
    push_preview = true
)
