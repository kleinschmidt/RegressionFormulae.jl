function poly(x, deg; raw=true)
    raw == true && return [el^d for el in x, d in 1:deg]
    length(unique(x)) < deg &&
        error("Degree of orthogonal polynomial must be lower than the " *
              "number of unique points")
    x̄ = mean(x)
    x = x .- mean(x)
    mat = qr!([el^d for el in x, d in 0:deg])
    cols = vcat(Diagonal(mat.R), zeros(length(x) - size(mat.R,1), size(mat.R, 2)))
    cols = mat.Q * cols
    colnorms = sum.(abs2, eachcol(cols))

    for (j, cn) in zip(axes(cols, 2), colnorms)
        cols[:, j] ./= sqrt(cn)
    end

    return cols[:, (begin+1):end]

end

# type of model where syntax applies: here this applies to any model type
const POLY_CONTEXT = RegressionModel

# struct for behavior
struct PolyTerm{T,D} <: AbstractTerm
    term::T
    deg::D
    raw::Bool
end

Base.show(io::IO, p::PolyTerm) = print(io, "poly($(p.term), $(p.deg))")

# for `poly` use at run-time (outside @formula), return a schema-less PolyTerm
poly(t::Symbol, d::Int; raw::Bool=true) = PolyTerm(term(t), term(d), raw)

# for `poly` use inside @formula: create a schemaless PolyTerm and apply_schema
function StatsModels.apply_schema(t::FunctionTerm{typeof(poly)},
                                  sch::StatsModels.Schema,
                                  Mod::Type{<:POLY_CONTEXT})
    apply_schema(PolyTerm(t.args_parsed...), sch, Mod)
end

# apply_schema to internal Terms and check for proper types
function StatsModels.apply_schema(t::PolyTerm,
                                  sch::StatsModels.Schema,
                                  Mod::Type{<:POLY_CONTEXT})
    term = apply_schema(t.term, sch, Mod)
    isa(term, ContinuousTerm) ||
        throw(ArgumentError("PolyTerm only works with continuous terms (got $term)"))
    isa(t.deg, ConstantTerm) ||
        throw(ArgumentError("PolyTerm degree must be a number (got $t.deg)"))
    PolyTerm(term, t.deg.n)
end

function StatsModels.modelcols(p::PolyTerm, d::NamedTuple)
    col = modelcols(p.term, d)
    p.raw && return reduce(hcat, [col.^n for n in 1:p.deg])

    return mapreduce(hcat, 1:p.deg) do n


        # INSERT HERE
    end
end

# the basic terms contained within a PolyTerm (for schema extraction)
StatsModels.terms(p::PolyTerm) = terms(p.term)
# names variables from the data that a PolyTerm relies on
StatsModels.termvars(p::PolyTerm) = StatsModels.termvars(p.term)
# number of columns in the matrix this term produces
StatsModels.width(p::PolyTerm) = p.deg

# highlight the difference between raw and orthogonal in the output
function StatsAPI.coefnames(p::PolyTerm)
    p.raw && return coefnames(p.term) .* "^" .* string.(1:p.deg)

    return "poly(" .* coefnames(p.term) .* ", " .* string.(1:p.deg) .* ")"
end
