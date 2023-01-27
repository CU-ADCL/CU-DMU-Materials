using DMUStudent.HW2
using POMDPs: states, actions
using POMDPTools: ordered_states

##############
# Instructions
##############
#=

This starter code is here to show examples of how to use the HW2 code that you
can copy and paste into your homework code if you wish. It is not meant to be a
fill-in-the blank skeleton code, so the structure of your final submission may
differ from this considerably.

=#

############
# Question 3
############

@show actions(grid_world) # prints the actions. In this case each action is a Symbol. Use ?Symbol to find out more.

T = transition_matrices(grid_world)
display(T) # this is a Dict that contains a transition matrix for each action

@show T[:left][1, 2] # the probability of transitioning between states with indices 1 and 2 when taking action :left

R = reward_vectors(grid_world)
display(R) # this is a Dict that contains a reward vector for each action

@show R[:right][1] # the reward for taking action :right in the state with index 1

function value_iteration(m)
    # It is good to put performance-critical code in a function: https://docs.julialang.org/en/v1/manual/performance-tips/

    V = rand(length(states(m))) # this would be a good container to use for your value function

    # put your value iteration code here

    return V
end

# You can use the following commented code to display the value. If you are in an environment with multimedia capability (e.g. Jupyter, Pluto, VSCode, Juno), you can display the environment with the following commented code. From the REPL, you can use the ElectronDisplay package.
# display(render(grid_world, color=V))

############
# Question 4
############

# You can create an mdp object representing the problem with the following:
m = UnresponsiveACASMDP(2)

# transition_matrices and reward_vectors work the same as for grid_world, however this problem is much larger, so you will have to exploit the structure of the problem. In particular, you may find the docstring of transition_matrices helpful:
display(@doc(transition_matrices))

V = value_iteration(m)

@show HW2.evaluate(V)

########
# Extras
########

# The comments below are not needed for the homework, but may be helpful for interpreting the problems or getting a high score on the leaderboard.

# Both UnresponsiveACASMDP and grid_world implement the POMDPs.jl interface. You can find complete documentation here: https://juliapomdp.github.io/POMDPs.jl/stable/api/#Model-Functions

# To convert from physical states to indices in the transition function, use the stateindex function
# IMPORTANT NOTE: YOU ONLY NEED TO USE STATE INDICES FOR THIS ASSIGNMENT, using the states may help you make faster specialized code for the ACAS problem, but it is not required
using POMDPs: states, stateindex

s = first(states(m))
@show si = stateindex(m, s)

# To convert from a state index to a physical state in the ACAS MDP, use convert_s:
using POMDPs: convert_s

@show s = convert_s(ACASState, si, m)

# To visualize a state in the ACAS MDP, use
render(m, (s=s,))
