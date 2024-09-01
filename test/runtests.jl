using MDAFiles
using Test
using JSON


@testset "Basic" begin
    X = randn(34,875)
    fname = "test.mda"
    MDAFiles.save(fname, X)
    X2 = MDAFiles.load(fname)
    @test X2 ≈ X
    rm(fname)
end

@testset "Dataset" begin
    X = randn(875, 4)
    pos = fill(0.0, 2, 4)
    pos[:,1] = [0.0, 0.0]
    pos[:,2] = [0.0, 1.0]
    pos[:,3] = [1.0, 1.0]
    pos[:,4] = [1.0, 0.0]
    data = MDAFiles.MDAData(X, 30_000.0,pos)
    MDAFiles.create_dataset("test1", data)
    @test isfile("test1/raw.mda")
    X2 = MDAFiles.load("test1/raw.mda")
    @test X2 ≈ X
    @test isfile("test1/params.json")
    params = open("test1/params.json","r") do fid
        JSON.parse(fid)
    end
    @test params["sampling_rate"] ≈ data.sampling_rate
    @test isfile("test1/geom.csv")
end
