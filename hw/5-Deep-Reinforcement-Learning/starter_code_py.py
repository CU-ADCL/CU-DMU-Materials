# HW 5 Problem 3 starter code

# https://syl1.gitbook.io/julia-language-a-concise-tutorial/language-core/interfacing-julia-with-other-languages

# 1. install PyCall
# https://github.com/JuliaPy/PyCall.jl
# (make sure to specify python path)

# 2. Install PyJulia
# $ python3 -m pip install --user julia
# >>> import julia
# >>> julia.install()

import julia
import numpy as np
import gym

# Interface for Julia code. From the URL on line 3: 
# "The compiled_module=False in the Julia constructor is a workaround to the common 
# situation when the Python interpreter is statically linked to libpython, but it will 
# slow down interactive experience, as it will disable Julia packages pre-compilation,
# and every time we will use a module for the first time, this will need to be compiled first."
jl = julia.Julia(compiled_modules=False) 

# Julia imports
jl.eval("""
using DMUStudent.HW5: mc
using CommonRLInterface: act!, reset!, observe, terminated
""")

# gym environment
# uses a discrete action space (-1.0, -0.5, 0.0, 0.5, 1.0)
# uses a 2 element vector instead of the 100x100 matrix observation
class mcEnv(gym.Env):
    def __init__(self):
        self.env = jl.mc # mc is the mountaincar environment
        self.action_space = gym.spaces.Discrete(5) # discretize the action space
        self.observation_space = gym.spaces.Box(low=-np.inf, high=np.inf, shape=(2,)) # treating the observation as a 2-vector rather than 100x100 matrix

    def observation(self):
        obs = np.array(jl.observe(self.env))
        obs = obs[:2,0] # take first 2 entries: [pos, vel]
        return obs.astype('float32')
    
    def reset(self):
        jl.reset_b(self.env)
        return self.observation()
    
    def step(self, action): 
        action = (action-2)/2 # shifts (0, 1, 2, 3, 4) -> (-1.0, -0.5, 0.0, 0.5, 1.0)
        reward = jl.act_b(self.env, action) 
        obs = self.observation()
        done = jl.terminated(self.env)            
        return obs, reward, done, {}

env = mcEnv()



def policy(obs):
    obs = np.array(obs).astype('float32') # type safety
    obs = obs[:2,0] # only look at first 2 entries in observation matrix

    # Sample heuristic policy
    if obs[1] < 0.0:
        a = -1.0
    else:
        a = 1.0

    return a



# Evaluation code, allows python function to be called in julia
jl.eval("""
using PyCall: pycall
import DMUStudent.HW5: evaluate
evaluate(fun::PyObject, args...) = evaluate(obs->pycall(fun, Float32, obs), args...)
""")

# Generate results.json
# Use your email!
jl.evaluate(policy, "student-email@colorado.edu")