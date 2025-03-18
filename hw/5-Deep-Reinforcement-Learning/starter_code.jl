using DMUStudent.HW5: HW5, mc
using QuickPOMDPs: QuickPOMDP
using POMDPTools: Deterministic, Uniform, SparseCat, FunctionPolicy, RolloutSimulator
using Statistics: mean
import POMDPs

##############
# Instructions
##############
#=

This starter code is here to show examples of how to use the HW5 code that you
can copy and paste into your homework code if you wish. It is not meant to be a
fill-in-the blank skeleton code, so the structure of your final submission may
differ from this considerably.

=#

############
# Question 1
############

# The tiger problem from http://www.sciencedirect.com/science/article/pii/S000437029800023X can be expressed with:

tiger = QuickPOMDP(
    states = [:TL, :TR],
    actions = [:OL, :OR, :L],
    observations = [:TL, :TR],

    # transition should be a function that takes in s and a and returns the distribution of s'
    transition = function (s, a)
        if a == :L
            return Deterministic(s)
        else
            return Uniform([:TL, :TR])
        end
    end,

    # observation should be a function that takes in s, a, and sp, and returns the distribution of o
    observation = function (s, a, sp)
        if a == :L
            if sp == :TL
                return SparseCat([:TL, :TR], [0.85, 0.15])
            else
                return SparseCat([:TR, :TL], [0.85, 0.15])
            end
        else
            return Uniform([:TL, :TR])
        end
    end,

    reward = function (s, a)
        if a == :L
            return -1.0
        elseif a == :OL
            if s == :TR
                return 10.0
            else
                return -100.0
            end
        else # a = :OR
            if s == :TL
                return 10.0
            else
                return -100.0
            end
        end
    end,

    initialstate = Uniform([:TL, :TR]),

    discount = 0.95
)

# evaluate with a random policy
policy = FunctionPolicy(o->rand(POMDPs.actions(tiger)))
sim = RolloutSimulator(max_steps=100)
@show @time mean(POMDPs.simulate(sim, tiger, policy) for _ in 1:10_000)

############
# Question 2
############

# The notebook at https://github.com/zsunberg/CU-DMU-Materials/blob/master/notebooks/110-Neural-Networks.ipynb can serve as a starting point for this problem.

############
# Question 3
############

using CommonRLInterface
using Flux
using CommonRLInterface.Wrappers: QuickWrapper

# The following are some basic components needed for DQN

# Override to a discrete action space, and position and velocity observations rather than the matrix.
env = QuickWrapper(HW5.mc,
                   actions=[-1.0, -0.5, 0.0, 0.5, 1.0],
                   observe=mc->observe(mc)[1:2]
                  )

# create your loss function for Q training here
function loss(Q, Q_target, s, a_ind, r, sp, done)
    return (Q(s)[a_ind] - Q_target(s)[a_ind])^2 # this is not correct! you need to replace it with the true Q-learning loss function
    # make sure to take care of cases when the problem has terminated correctly
end

function dqn(env)
    # This network should work for the Q function - an input is a state; the output is a vector containing the Q-values for each action 
    Q = Chain(Dense(2, 128, relu),
              Dense(128, length(actions(env))))

    opt = Flux.setup(ADAM(0.0005), Q)


    # We can create 1 tuple of experience like this
    s = observe(env)
    a_ind = 1 # action index - the index, rather than the actual action itself, will be needed in the loss function
    r = act!(env, actions(env)[a_ind])
    sp = observe(env)
    done = terminated(env)

    experience_tuple = (s, a_ind, r, sp, done)

    # this container should work well for the experience buffer:
    buffer = [experience_tuple]
    # you will need to push more experience into it and randomly select data for training
    
    reset!(env) # NOTE: after each time the environment reaches a terminal state, you need to reset it

    # this is the fixed target Q network
    Q_target = deepcopy(Q)

    # select some data from the buffer and train (you may have to adjust some things, and you will have to do this many times):
    for data in rand(buffer, 10)
        # this runs a forward and backward pass to calculate the loss and gradient
        loss_value, grads = Flux.withgradient(loss, Q, Q_target, data...)

        # this will take a gradient step
        Flux.update!(opt, Q, grads[1])
    end

    # Make sure to evaluate, print, and plot often! You will want to save your best policy.
    
    return Q
end

Q = dqn(env)

HW5.evaluate(s->actions(env)[argmax(Q(s[1:2]))], n_episodes=100) # you will need to remove the n_episodes=100 keyword argument and add your email as a positional argument to create a json file; evaluate needs to run 10_000 episodes to produce a json

#----------
# Rendering
#----------

# You can show an image of the environment like this (use ElectronDisplay if running from REPL):
display(render(env))

# The following code allows you to render the value function
using Plots
xs = -3.0f0:0.1f0:3.0f0
vs = -0.3f0:0.01f0:0.3f0
heatmap(xs, vs, (x, v) -> maximum(Q([x, v])), xlabel="Position (x)", ylabel="Velocity (v)", title="Max Q Value")
