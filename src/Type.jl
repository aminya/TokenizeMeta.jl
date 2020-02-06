
"""
    UndefToken

A type that shows if the an evaluated `Token` is defined.
"""
struct UndefToken end

################################################################

"""
    @tisdefined(t)
    tisdefined(modul, t)

Check if a `Token` that represent a `Symbol` is defined. Throws error if the `Token` is representing an `Expr`.

# Examples
```jldoctest
julia> t = collect(tokenize("Int64"))

julia> tisdefined(t)
true
```
"""
function tisdefined(modul, t::T) where {T <: Union{Token, Array{Token}, String}}
    pt = Meta.parse(t)
    return isdefined(modul,pt)
end

tisdefined(modul::Module, t::T) where {T <: Union{Symbol, Expr}} = isdefined(modul, t)

macro tisdefined(t)
    m = __module__
    return :(tisdefined($m, $t))
end

