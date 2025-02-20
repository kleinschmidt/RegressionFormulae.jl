include("set_up_tests.jl")

@testset ExtendedTestSet "RegressionFormulae.jl" begin
    @testset "fulldummy" begin
        include("fulldummy.jl")
    end

    @testset "nesting" begin
        include("nesting.jl")
    end

    @testset "powers of terms" begin
        include("power.jl")
    end
end
