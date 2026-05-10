dat = (; y=zeros(10), a=["u","i","o"], b=["q","w","e"], c=["s","d","f"], x=1:10)

@testset "error checking" begin
    @test_throws ArgumentError fulldummy(term(:a))

    sch = schema(dat)
    @test_throws ArgumentError apply_schema(@formula(y ~ fulldummy(x)), sch, RegressionModel)
end
