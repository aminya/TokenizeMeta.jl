using TokenizeMeta
using Test

@testset "TokenizeMeta.jl" begin

    t1 = collect(tokenize("Int64"))[1]
    @test Tokenize.Tokens.tevalfast(t1) == Int64
    @test Tokenize.Tokens.tgetfield(t1) == Int64
    @test Tokenize.Tokens.teval(t1) == Int64
    @test Tokenize.Tokens.ttypeof(t1) == DataType
    @test Tokenize.Tokens.tisa(t1, DataType) == true

    t2 = collect(tokenize("[5]"))
    @test Tokenize.Tokens.tevalfast(t2) == [5]
    @test Tokenize.Tokens.teval(t2) == [5]
    @test Tokenize.Tokens.ttypeof(t2) == Array{Int64,1}
    @test Tokenize.Tokens.tisa(t2, Array{Int64}) == true

end
