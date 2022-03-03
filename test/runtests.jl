using MDAFiles
using Test


@testset "Basic" begin
    X = randn(34,875)
    fname = "test.mda"
    MDAFiles.save(fname, X)
    X2 = MDAFiles.load(fname)
    @test X2 ≈ X
    rm(fname)
end
