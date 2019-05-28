
function implementations(T::Type)
    return mapreduce(t -> isabstracttype(t) ? implementations(t) : t, vcat, subtypes(T), init=[])
end

issame(v1::AbstractVertex, v2::AbstractVertex, visited=AbstractVertex[]) = false
function issame(v1::T, v2::T, visited=AbstractVertex[]) where T<:AbstractVertex
    v1 in visited && return true
    v2 in visited && return true
    push!(visited, v1,v2)
    for n in fieldnames(typeof(v1))
        issame(getfield(v1, n), getfield(v2, n), visited) || return false
    end
    return true
end
function issame(a1::AbstractArray{T,1}, a2::AbstractArray{T,1}, visited=AbstractVertex[]) where T<:AbstractVertex
    length(a1) != length(a2) && return false
    return all(map(vs -> issame(vs..., visited), zip(a1,a2)))
end
issame(g1::CompGraph, g2::CompGraph, visited=AbstractVertex[]) = issame(g1.outputs, g2.outputs, visited)
issame(d1, d2, visited=AbstractVertex[]) = d1 == d2

issame(s1::MutationOp, s2::MutationOp, visited=AbstractVertex[]) = false
function issame(s1::T, s2::T, visited=AbstractVertex[]) where T<:MutationOp
    for n in fieldnames(typeof(s1))
        issame(getfield(s1, n), getfield(s2, n), visited) || return false
    end
    return true
end
