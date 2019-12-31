using HW2
using Test

v = [0.81, 0.9, 1.0, 0.0]

@test HW2.bellman_satisfied(HW2.mdp, v)
