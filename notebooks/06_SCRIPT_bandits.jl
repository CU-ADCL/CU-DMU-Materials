using Printf

struct BernoulliBandit
    theta::Vector{Float64}
    pulls::Vector{Float64}
    wins::Vector{Float64}
end

BernoulliBandit(n) = BernoulliBandit(rand(n), zeros(n), zeros(n))

function pull!(b::BernoulliBandit, i)
    b.pulls[i] += 1
    if rand() < b.theta[i]
        b.wins[i] += 1
        return 1
    end
    return 0
end 

function Base.show(io::IO, ::MIME"text/plain", b::BernoulliBandit)
    for i in 1:length(b.theta)
        @printf(io, "Arm %3d: %5d wins / %5d pulls\n", i, b.wins[i], b.pulls[i])
    end
    println(io, "Total Score: $(sum(b.wins))")
end

function play!(b::BernoulliBandit)
    while true
        print("Pull: ")
        t = readline()
        println()
        i = parse(Int, t)
        pull!(b, i)
        display(b)
    end
end
