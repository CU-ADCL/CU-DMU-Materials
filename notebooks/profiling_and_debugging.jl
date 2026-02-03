function randmult(n)
    A = rand(n, n)

    b = []
    for i in 1:n
        push!(b, randn())
    end

    c = A*b
    return c
end
# @show randmult(100)

# using Debugger # Use Debugger if you are in the terminal instead of VSCode
# @enter randmult(10) # This enters the debugger if you are in the terminal

using BenchmarkTools

@benchmark randmult(100)

# 350 us initial run

# using ProfileView # Use ProfileView if you are in the terminal instead of vscode

# @profview randmult(1000)

# @profview randmult(10000)

# @code_warntype randmult(100)