module HW2

using QuickPOMDPs
using POMDPModelTools

mdp = QuickMDP(states=1:4,
               actions=[-1,1],
               transition=function (s, a)
                   Deterministic(clamp(s+a, 1, 4))
               end,
               reward=(s,a,sp)->sp==4,
               discount=0.9,
               isterminal=s->s==4
              )


# using POMDPs
# using Parameters
# struct ACASState
#     h_ego::Float64
#     h_intruder::Float64
#     d::Float64
# end
# 
# @with_kw struct ACASMDP <: MDP{ACASState, Int}
#     h_ego_std::Float64
#     h_intruder_std::Float64
#     closing_speed::Float64
# end
# 
# @with_kw struct DiscreteACASMDP <: MDP{Int, Int}
#     m::ACASMDP
#     h_limits::Tuple{Float64,Float64}
#     n_h_ego::Int
#     n_h_intruder::Int
# end
# 
# function convert_s(i::Int, s::ACASState, m::DiscreteACASMDP)
#     
# end

using POMDPs

function bellman_satisfied(m::MDP, v::AbstractVector; atol=1e-6)
    disc = discount(m)
    for s in states(m)
        i = stateindex(m, s)
        if isterminal(m, s)
            vmax = 0.0
        else
            vmax = -Inf
            for a in actions(m)
                va = 0.0
                d = transition(m, s, a)
                for (sp, p) in weighted_iterator(d)
                    ip = stateindex(m, sp)
                    va += p*(reward(m, s, a, sp) + disc*v[ip])
                end
                vmax = max(vmax, va)
            end
        end
        if !isapprox(v[i], vmax, atol=atol)
            @warn "Incorrect value for state $s"
            return false
        end
    end
    return true
end

end # module
