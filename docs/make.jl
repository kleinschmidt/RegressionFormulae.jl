using Documenter, RegressionFormulae

makedocs(;
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/kleinschmidt/RegressionFormulae.jl/blob/{commit}{path}#L{line}",
    sitename="RegressionFormulae.jl",
    authors=["Dave Kleinschmidt", "Phillip Alday"],
)

deploydocs(;
    repo="github.com/kleinschmidt/RegressionFormulae.jl",
    devbranch = "main",
    push_preview = true
)
