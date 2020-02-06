# overloading Meta.parse to support Tokens
Meta.parse(t::T) where {T <: Union{Token, Array{Token}}} = Meta.parse(untokenize(t))

###############################################################
"""
    @teval(t, check_isdefined::Bool=false)
    teval(modul, t::T, check_isdefined::Bool=false)

Parses and evaluates a `Token` (or an experssion or a string) that represents a `Symbol` or `Expr` in Julia. It dispatches on the fast method based on the parsed Token.

Use `@teval`, if you want the token be evaluated in the called scope.

If you set `check_isdefined` to `true`, and `t` is not defined in the scope it returns `UndefToken` instead of throwing an error.

# Examples
```jldoctest
julia> t = collect(tokenize("Int64"))

julia> @teval(t)
Int64
```
"""
function teval(modul::Module, t::T, check_isdefined::Bool = false) where {T <: Union{Token, Array{Token}, String}}
    pt = Meta.parse(t)
    if check_isdefined && !(tisdefined(modul,pt))
        return UndefToken()
    end
    return evalfast(modul,pt)
end

function teval(modul::Module, t::T, check_isdefined::Bool = false) where {T <: Union{Symbol, Expr}}
    if check_isdefined && !(tisdefined(modul,pt))
        return UndefToken()
    end
    return evalfast(modul,pt)
end

macro teval(t, check_isdefined::Bool = false) # where {T <: Union{Symbol, Array{Token}, String, Symbol, Expr}}
    macroexpand(__module, t)
    return quote
        TokenizeMeta.teval($__module__, $(Expr(:quote,t)), $check_isdefined)
    end
end
#
# macro teval(mod, ex)
#     :(Core.eval($(esc(mod)), $(Expr(:quote,ex))))
# end

################################################################

"""
    @evalfast(x)
    evalfast(modul, x)

Evaluates `x` fast. Uses `getfield` if `x` is a `Symbol`, and uses `eval` if it is an `Expr`
# Examples
```jldoctest
julia> @evalfast(Int64)

julia> @evalfast([5])

```
"""
evalfast(modul::Module, x::Expr)= modul.eval(x)
evalfast(modul::Module, x::Symbol)= getfield(modul,x)
macro evalfast(x::Expr)
    m = __module__
    return :(Core.eval($m, $x))
end
macro evalfast(x::Symbol)
    m = __module__
    return :(getfield($m,$x))
end

################################################################
"""
    @tgetfield(t, check_isdefined::Bool=false)
    tgetfield(modul, t, check_isdefined::Bool=false)

See [`teval`](@ref) for fast Token evaluation.

Parses and evaluates a `Token` (or an experssion or a string) that represents a `Symbol` in Julia. For `Symbol` it is similar to eval, but much faster.

If you set `check_isdefined` to `true`, and `t` is not defined in the scope it returns `UndefToken` instead of throwing an error.

# Examples
```jldoctest
julia> t = collect(tokenize("Int64"))

julia> @tgetfield(t)
Int64
```
"""
function tgetfield(modul::Module, t::T, check_isdefined::Bool = false) where {T <: Union{Token, Array{Token}, String}}
    pt = Meta.parse(t)
    if check_isdefined && !(tisdefined(modul,pt))
        return UndefToken()
    end
    return getfield(modul,pt)
end

function tgetfield(modul::Module, t::T, check_isdefined::Bool = false) where {T <: Union{Symbol, Expr}}
    if check_isdefined && !(tisdefined(modul,pt))
        return UndefToken()
    end
    return getfield(modul,pt)
end

macro tgetfield(t, check_isdefined::Bool = false)
    m = __module__
    return :(tgetfield($m, $t, $check_isdefined))
end
