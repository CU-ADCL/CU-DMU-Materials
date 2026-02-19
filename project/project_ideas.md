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
12. Develop a solver or domain for [Decisions.jl](https://github.com/JuliaDecisionMaking/Decisions.jl), which permits many extensions on (PO)MDPs. You are also encouraged to contribute patches for its [outstanding issues](https://github.com/JuliaDecisionMaking/Decisions.jl/issues). (Contact Mel Krusniak: mel.krusniak@colorado.edu.)

You can also find examples in the [previous/projects directory](https://github.com/zsunberg/CU-DMU-Materials/tree/master/previous/projects) in this repo or here https://aa228.stanford.edu/old-projects/ or here https://github.com/zsunberg/CU-DMUPP-Materials/tree/main/previous/projects.

***************************************************************************************

**NEW Research Project Ideas**

1. Scalable Rollouts for ESP in Crowded Navigation (CPU/GPU Parallel Motion Planning)

Extended Space Planning (ESP) is an effective approach for autonomous navigation to a fixed goal in crowded environments, but it often relies on HJB/PDE-based rollout or reference computations that can be slow and may not scale well as environments get larger or more complex.

In this project, students will replace the HJB/PDE rollout component in an existing ESP-based planner with a fast CPU/GPU-parallelized motion-planning rollout (e.g., massively parallel sampling-based rollouts). The goal is to evaluate whether parallel rollouts can provide sufficiently good guidance to the online planner while significantly reducing computation time.

Students will compare:
- Baseline ESP with HJB/PDE rollouts (provided)
- ESP with parallel motion-planning rollouts (to be implemented)

Evaluation will focus on trade-offs between runtime, success rate, path quality, and safety metrics (e.g., minimum distance to humans / collision rate) across varying crowd densities.

For more details, contact Himanshu Gupta (himanshu.gupta@colorado.edu) to schedule a meeting.

2. Monte Carlo Tree Search with Value Gradients for Continuous Space Problems

Traditional Monte Carlo Tree Search (MCTS) struggles with large or continuous action spaces, limiting its applicability to complex decision-making problems. A promising approach to address this challenge in Markov Decision Processes (MDPs) is to approximate value gradients and use them to guide the search process, improving action selection efficiency.

This project involves implementing an existing value-gradient-enhanced MCTS algorithm from recent research and, if time permits, extending it to Partially Observable MDPs (POMDPs). The goal is to explore how gradient-based adjustments can improve tree search efficiency in high-dimensional decision spaces.

For more details, contact Himanshu Gupta (himanshu.gupta@colorado.edu) to schedule a meeting.

3. Safety-Guided Monte Carlo Tree Search for Continuous Control

Monte Carlo Tree Search (MCTS) is a powerful planning method for Markov Decision Processes (MDPs), but handling continuous action spaces typically requires techniques such as Double Progressive Widening (DPW), which may spend significant computation exploring unsafe or low-quality actions before identifying better ones.

In many stochastic control problems, however, we can compute stochastic safety barriers offline. These barriers estimate the probability that a given state–action pair remains safe under uncertain dynamics. This project explores how such offline safety information can guide online MCTS.

Specifically, we will investigate whether safety barriers can be used to prune unsafe actions during tree expansion or bias action selection within the UCB exploration rule.

The goal is to evaluate how safety-guided MCTS compares to standard MCTS-DPW in terms of convergence speed, safety performance, and overall reward in a simple stochastic navigation or control environment.

For more details, contact Himanshu Gupta (himanshu.gupta@colorado.edu) to schedule a meeting.
