struct SparseArray{T,N} <: AbstractArray{T,N}
          data::Dict{NTuple{N,Int}, T}
          dims::NTuple{N,Int}
end
SparseArray(::Type{T}, dims::Int...) where {T} = SparseArray(T, dims)
SparseArray(::Type{T}, dims::NTuple{N,Int}) where {T,N} = SparseArray{T,N}(Dict{NTuple{N,Int}, T}(), dims)
Base.size(A::SparseArray) = A.dims
Base.similar(A::SparseArray, ::Type{T}, dims::Dims) where {T} = SparseArray(T, dims)
Base.getindex(A::SparseArray{T,N}, I::Vararg{Int,N}) where {T,N} = get(A.data, I, zero(T))
Base.setindex!(A::SparseArray{T,N}, v, I::Vararg{Int,N}) where {T,N} = (A.data[I] = v)
Base.zero(Ind::Type{Individual}) = missing
struct MapElites
    feature_dimension::Int64
    grid_mesh::Int64
    solutions::SparseArray{Union{Missing,Individual},Int64}
    performances::SparseArray{Union{Missing,Array{Float64}},Int64}
end

function MapElites(f_dim::Int64,g_size::Int64)
    solutions = SparseArray(Union{Missing,Individual},1)
    fill!(solutions,missing)
    performances = SparseArray(Union{Missing,Array{Float64}},1)
    fill!(performances,missing)
    MapElites(f_dim,g_size,solutions,performances)
end

a = SparseArray(Union{Float64,Missing}, (3,3,3))
