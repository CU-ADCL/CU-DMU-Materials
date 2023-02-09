function randmult(n)
    A = rand(n, n)

    b = Float64[]
    for i in 1:n
        push!(b, randn())
    end

    c = A*b
    return c
end

# using Debugger # Use Debugger if you are in the terminal instead of VSCode

# @enter randmult(10) # This enters the debugger

using BenchmarkTools

@btime randmult(100)

# first run 419 us

# using ProfileView # Use ProfileView if you are in the terminal instead of vscode

@profview randmult(100)

@profview randmult(10000)