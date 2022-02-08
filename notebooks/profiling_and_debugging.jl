using Debugger

function randmult(n)
    A = rand(n, n)

    b = Float64[]
    for i in 1:n
        push!(b, randn())
    end

    c = A*b
    return c
end

# @enter randmult(10)

using ProfileView

@profview randmult(10)

@profview randmult(10000)

@time randmult(10000)

# first run 8.8 seconds
# second run 0.5 seconds
