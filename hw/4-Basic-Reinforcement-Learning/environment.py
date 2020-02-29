# On linux, you probably will need this, but on mac things may be faster without it
from julia.api import Julia
jl = Julia(compiled_modules=False)

print("importing from julia...")
from julia.DMUStudent.HW4 import mc, gw
from julia.RLInterface import *
from julia.Base import deepcopy

print("defining env...")
import gym
from gym.spaces import Box, Discrete

class MCEnv(gym.Env):
    def __init__(self, jlenv):
        self.jlenv = jlenv

    def step(self, a):
        # if you use a continuous action space it will come in a vector
        # assert len(a) == 1
        # return step_b(self.jlenv, a[0])

        # decode discrete actions
        jl_act = [-1.0, 0.0, 1.0][a]
        return step_b(self.jlenv, jl_act)

    def reset(self):
        return reset_b(self.jlenv)

    @property
    def observation_space(self):
        return Box(low=-1.0, high=1.0, shape=(2,))

    @property
    def action_space(self):
        # if you want a continuous action space, use a box
        # return Box(low=-1.0, high=1.0, shape=(1,))
        return Discrete(3)
        
from stable_baselines import DQN
from stable_baselines.common.vec_env import DummyVecEnv

dqn = DQN('MlpPolicy',  DummyVecEnv([lambda: MCEnv(deepcopy(mc))]), verbose=1, exploration_fraction=0.1)

print("getting ready to learn...")
dqn.learn(total_timesteps=10)

from julia.DMUStudent import evaluate
from julia.Base import convert, Function

def policy_function(s):
    return 0.0 # replace this with actions that have been learned
    
evaluate(convert(Function, policy_function), "hw4")
