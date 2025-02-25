# Ideas for the final project

1. Apply a method from this class to a research problem that you are working on.
2. Create a long-horizon billiards shot engine https://youtu.be/vsTTXYxydOE (a previous student started a codebase here: https://github.com/donceykong/billiards-rl)
3. Create a (PO)MDP model of a skiing robot and find a decent descent solution.
4. Re-produce some of the results from a reinforcement learning paper and run at least one extra experiment that is not in the paper.
5. Build a DESPOT solver without determinization and compare it to the determinized version to quantify the value of determinization
6. Contribute a solver to POMDPs.jl (a submission of this type should be able to reliably solve simple problems, conform to the interface, and have tests that pass)
7. Laser Tag Belief MDP (contact Himanshu Gupta)
8. Create a Julia or Python package that enumerates all equilibria of a bimatrix game using the lrsNash algorithm [Enumeration of Nash equilibria for two-player games (2009; Avis, Rosenberg, Savani, von Stengel)]
9. Use [BSK-RL](https://github.com/AVSLab/bsk_rl) to do some satellite reinforcement learning
10. Imitation learning or multiplayer RL on Atari with/against a real human player
11. Develop POMDPs.jl domains with Kyle Wray.

You can also find examples in the [previous/projects directory](https://github.com/zsunberg/CU-DMU-Materials/tree/master/previous/projects) in this repo or here https://aa228.stanford.edu/old-projects/ or here https://github.com/zsunberg/CU-DMUPP-Materials/tree/main/previous/projects .

***************************************************************************************

**NEW Research Project Ideas**

1. Target Tracking in Human Crowds Using Online Tree Search for POMDPs

Tracking a moving target in dynamic environments is a critical challenge in robotics, with applications ranging from security surveillance to search-and-rescue operations. Most existing approaches assume a static environment, but real-world scenarios—such as locating a lost child in a crowded shopping mall—require agents to navigate safely and efficiently through unpredictable human movement.

This project formulates target tracking as a Partially Observable Markov Decision Process (POMDP) and tackles it using an online tree search strategy over a dynamically sampled graph representation of the environment. The goal is to enable a robotic agent to make rapid, informed decisions while balancing exploration and exploitation in a highly uncertain setting.

If you're interested in contributing to this research, the starter code and further details are available. Contact Himanshu Gupta (himanshu.gupta@colorado.edu) to schedule a meeting.

2. Autonomous Navigation in Crowded Environments Using Online Tree Search for POMDPs

Navigating autonomously in crowded environments is a fundamental challenge in robotics, with applications in urban mobility, assistive robotics, and warehouse automation. This problem is often modeled as a Partially Observable Markov Decision Process (POMDP), where human intentions and movements are hidden state variables, adding uncertainty to the agent’s decision-making.

While online tree search methods have shown promise in solving such POMDPs, scaling them to long-horizon and high-dimensional spaces remains a challenge. This project explores neural network-guided tree search techniques, inspired by AlphaZero, to enhance decision-making efficiency and improve upon state-of-the-art autonomous navigation methods. By leveraging learned approximations for value and policy functions, the goal is to achieve robust, real-time navigation in complex, dynamic settings.

Interested participants can access the starter code and get further details by contacting Himanshu Gupta (himanshu.gupta@colorado.edu) to schedule a meeting.

3. Monte Carlo Tree Search with Value Gradients for Continuous Space Problems

Traditional Monte Carlo Tree Search (MCTS) struggles with large or continuous action spaces, limiting its applicability to complex decision-making problems. A promising approach to address this challenge in Markov Decision Processes (MDPs) is to approximate value gradients and use them to guide the search process, improving action selection efficiency.

This project involves implementing an existing value-gradient-enhanced MCTS algorithm from recent research and, if time permits, extending it to Partially Observable MDPs (POMDPs). The goal is to explore how gradient-based adjustments can improve tree search efficiency in high-dimensional decision spaces.

For more details, contact Himanshu Gupta (himanshu.gupta@colorado.edu) to schedule a meeting.
