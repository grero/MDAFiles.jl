module MDAFiles

data_format = Dict(UInt8 => Int32(-2),
                   Float32 => Int32(-3),
                   Int16 => Int32(-4),
                   Int32 => Int32(-5),
                   UInt16 => Int32(-6),
                   Float64 => Int32(-7),
                   UInt32 => Int32(-8))

function load(fname::String)
    open(fname, "r") do fid
        _format = read(fid, Int32)
        T = Any
        for (k,v) in data_format
            if v == _format
                T = k
            end
        end
        if T == Any
            error("Unknown format specifier $_format")
        end
        read(fid, UInt32) 
        ndims = read(fid, UInt32) 
        data_size = fill(0, ndims)
        for i in 1:ndims
            data_size[i] = read(fid, UInt32)
        end
        data = fill(zero(T), data_size...)
        read!(fid, data)
        data
    end
end

function save(fname::String, X::Matrix{T}) where T <: Real
    open(fname, "w") do fid
        write(fid, data_format[T])
        write(fid, UInt32(sizeof(T)))
        write(fid, UInt32(2))
        write(fid, [UInt32.(size(X))...])
        write(fid, X)
    end
end
end # module
