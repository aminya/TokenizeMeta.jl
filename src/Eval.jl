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
