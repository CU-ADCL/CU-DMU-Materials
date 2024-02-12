function evaluate(submission, email=nothing; fname="results.json")
    if !(submission isa Union{Solver,Function})
        error("The submission is not a POMDPs.Solver or Function")
    end

    rng = MersenneTwister(rand(RandomDevice(), UInt32))

    N = 100
    nsteps = 0
    regret = 0.0
    @showprogress for i in 1:N
        m = DenseGridWorld(size=(100,100), seed=rand(rnt, UInt32))
        Q = Dict(a=>zeros(length(states(m))) for a in actions(m))
        V = zeros(length(states(m)))

        if submission isa Function
            p = FunctionPolicy(s->submission(m, s))
        else
            solvestart = time_ns()
            p = solve(submission, m)
            if time_ns() - solvestart > 50_000_000
                @warn("""Wall clock time limit of 0.05 seconds exceeded for solve(solver, m); using a random policy.

                      Try running POMDPs.solve(solver, DenseGridWorld()) before submitting the solver for evaluation to make sure Julia precompiles everything.""")
                p = solve(RandomSolver(), m)
            end
        end

        for (s, a) in stepthrough(m, p, "s, a", rng=rng, max_steps=50)
            v = V[stateindex(m, s)]
            q = Q[a][stateindex(m, s)]
            regret += v-q
        end
    end
    score = 100.0 - regret/N

    return (score=score,)
end
