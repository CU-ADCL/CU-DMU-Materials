# Ideas for the final project

1. Apply a method from this class to a research problem that you are working on.
2. Create a long-horizon billiards shot engine https://youtu.be/vsTTXYxydOE (a previous student started a codebase here: https://github.com/donceykong/billiards-rl)
3. Create a (PO)MDP model of a skiing robot and find a decent descent solution.
4. Re-produce some of the results from a reinforcement learning paper and run at least one extra experiment that is not in the paper.
5. Build a DESPOT solver without determinization and compare it to the determinized version to quantify the value of determinization
6. Contribute a solver to POMDPs.jl (a submission of this type should be able to reliably solve simple problems, conform to the interface, and have tests that pass). One good idea might be a neural fitted value iteration solver.
7. Laser Tag Belief MDP (contact Himanshu Gupta)
8. Create a Julia or Python package that enumerates all equilibria of a bimatrix game using the lrsNash algorithm [Enumeration of Nash equilibria for two-player games (2009; Avis, Rosenberg, Savani, von Stengel)]
9. Use [BSK-RL](https://github.com/AVSLab/bsk_rl) to do some satellite reinforcement learning
10. Imitation learning or multiplayer RL on Atari with/against a real human player
11. Develop POMDPs.jl domains.

You can also find examples in the [previous/projects directory](https://github.com/zsunberg/CU-DMU-Materials/tree/master/previous/projects) in this repo or here https://aa228.stanford.edu/old-projects/ or here https://github.com/zsunberg/CU-DMUPP-Materials/tree/main/previous/projects .

***************************************************************************************

**NEW Research Project Ideas**

1. Monte Carlo Tree Search with Value Gradients for Continuous Space Problems

Traditional Monte Carlo Tree Search (MCTS) struggles with large or continuous action spaces, limiting its applicability to complex decision-making problems. A promising approach to address this challenge in Markov Decision Processes (MDPs) is to approximate value gradients and use them to guide the search process, improving action selection efficiency.

This project involves implementing an existing value-gradient-enhanced MCTS algorithm from recent research and, if time permits, extending it to Partially Observable MDPs (POMDPs). The goal is to explore how gradient-based adjustments can improve tree search efficiency in high-dimensional decision spaces.

For more details, contact Himanshu Gupta (himanshu.gupta@colorado.edu) to schedule a meeting.
