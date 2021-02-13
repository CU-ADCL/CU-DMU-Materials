using DMUStudent.HW3: HW3, DenseGridWorld, visualize_tree
using POMDPs: actions, @gen, isterminal, discount, statetype, actiontype, simulate, states
using POMDPSimulators: RolloutSimulator
using POMDPPolicies: FunctionPolicy
using D3Trees: inchrome
using StaticArrays: SA
using Statistics: mean

##############
# Instructions
##############
#=

This starter code is here to show examples of how to use the HW3 code that you
can copy and paste into your homework code if you wish. It is not meant to be a
fill-in-the blank skeleton code, so the structure of your final submission may
differ from this considerably.

=#

############
# Question 2
############

m = DenseGridWorld()

S = statetype(m)
A = actiontype(m)

# These would be appropriate containers for your Q, N, and t dictionaries:
n = Dict{Tuple{S, A}, Int}()
q = Dict{Tuple{S, A}, Float64}()
t = Dict{Tuple{S, A, S}, Int}()

# This is an example state - it is a StaticArrays.SVector{2, Int}
s = SA[19,19]
@show typeof(s)
@assert s isa statetype(m)

# Here is an example rollout policy that always goes right. (You will need something more clever to do well in Question 5).
p = FunctionPolicy(s->:right)
# This runs a rollout simulation from state s with policy p. This is an estimate of the value of an always-go-right policy at state s.
@show simulate(RolloutSimulator(max_steps=100), m, p, s)

# here is an example of how to visualize a dummy tree (q, n, and t should actually be filled in your mcts code, but for this we fill it manually)
q[(SA[1,1], :right)] = 0.0
q[(SA[2,1], :right)] = 0.0
n[(SA[1,1], :right)] = 1
n[(SA[2,1], :right)] = 0
t[(SA[1,1], :right, SA[2,1])] = 1

inchrome(visualize_tree(q, n, t, SA[1,1]))

############
# Question 3
############

# A starting point for the select_action function is this:

function select_action(m, s)

    start = time_ns()
    n = Dict{Tuple{statetype(m), actiontype(m)}, Int}()
    q = Dict{Tuple{statetype(m), actiontype(m)}, Float64}()

    while time_ns() < start + 45_000_000 # run for a maximum of 45 ms to leave 5 ms to select an action
        break # replace this with mcts iterations to fill n and q
    end

    # select a good action based on q and/or n

    return rand(actions(m)) # this dummy function returns a random action, but you should return your selected action
end

HW3.evaluate(select_action, "your.gradescope.email@colorado.edu")

# To test out different rollout policies, you may want to try Monte Carlo policy evaluation:
@show mean(simulate(RolloutSimulator(max_steps=100), m, p, rand(states(m))) for _ in 1:10_000)

########
# Extras
########

# With a typical consumer operating system like Windows, OSX, or Linux, it is nearly impossible to ensure that your function *always* returns within 50ms. Do not worry if you get a few warnings about time exceeded.

# You may wish to call select_action once or twice before submitting it to evaluate to make sure that all parts of the function are precompiled.

# Instead of submitting a select_action function, you can alternatively submit a POMDPs.Solver object that will get 50ms of time to run solve(solver, m) to produce a POMDPs.Policy object that will be used for planning for each grid world. You can achieve a score of 50 without doing this, but this may give you an advantage if you want to maximize your score.
