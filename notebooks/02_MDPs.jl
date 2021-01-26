### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ db9709e2-5ba3-11eb-3133-d7b761e73531
begin
	using POMDPModels: SimpleGridWorld
	using POMDPs
	using POMDPModelTools: render
	using PlutoUI
end

# ╔═╡ f23c77b8-5f9f-11eb-3e11-c57256436bd5
using QuickPOMDPs

# ╔═╡ 5369c9d2-5fa0-11eb-31f4-47ef5e346cfc
using POMDPModelTools: Deterministic; using Distributions: Normal

# ╔═╡ c5e60600-5fa1-11eb-1e5a-dd969ccbe72f
using POMDPSimulators: stepthrough, RolloutSimulator; using POMDPPolicies: RandomPolicy, FunctionPolicy

# ╔═╡ bce555bc-5ba3-11eb-1bbb-23ffa36b1394
md"""
# Markov Decision Processes

## Grid World Example
"""

# ╔═╡ f39aa60c-5ba3-11eb-308e-c393d2e41ef4
m = SimpleGridWorld()

# ╔═╡ 1a1c8d0e-5ba4-11eb-2dcf-0b49be87c4e1
render(m)

# ╔═╡ 1e628436-5ba4-11eb-089d-752f74636f87
md"""
$(@bind a Radio(map(string, collect(actions(m)))))
$(@bind takestep Button("step"))
$(@bind reset Button("reset"))
"""

# ╔═╡ e2b18330-5ba6-11eb-050a-5d47dbaa2c5a
begin reset
	hist = [rand(initialstate(m))]
end

# ╔═╡ 3cb447a2-5ba5-11eb-35b2-abad16d4cbbd
begin takestep
	s = last(hist)
	sp, r = @gen(:sp, :r)(m, s, Symbol(a))
	push!(hist, sp)
	render(m, (s=s, a=Symbol(a), r=r, sp))
end

# ╔═╡ 3e2f9c8e-5bab-11eb-1f27-03af0738b2f6
md"""
# POMDPs.jl
The POMDPs.jl interface allows us to access the (S,A,R,T,$\gamma$,$p_0$) elements of an MDP
"""

# ╔═╡ fe9048b2-5f9c-11eb-380b-2d9f987700e9
# state space (S)
states(m)

# ╔═╡ 0a5b7234-5f9d-11eb-117c-cd289e20146b
# action space (A)
actions(m)

# ╔═╡ 19d34534-5f9d-11eb-38e3-3572155e8e03
# transition(m, s, a) returns the transition distribution for state s and action a
transition(m, [9,2], :up)

# ╔═╡ 37cd5f24-5ba7-11eb-351d-0b95699c4eb5
# reward (R)
reward(m, [9,3], :up)

# ╔═╡ d86fcc78-5f9e-11eb-0708-09cdf257585f
discount(m)

# ╔═╡ c775320c-5f9e-11eb-0200-b774b9c408f9
initialstate(m)

# ╔═╡ 26fcd508-5ba7-11eb-3b2c-03ccd2061650
md"""
### A generative model can be accessed with `@gen`
"""

# ╔═╡ 22626ad4-5f9f-11eb-1760-9dfe33dd4d8a
@gen(:sp, :r)(m, [9,2], :up)

# ╔═╡ b542d726-5f9f-11eb-3a88-215126f33f52
md"""
# QuickMDPs

A QuickMDP can be used to quickly construct an MDP
"""

# ╔═╡ fc16ee08-5f9f-11eb-2d20-9d008ba04797
tm = QuickMDP(
	states = [1,2,3,4],
	actions = [-1, 1],
	transition = (s, a)->Deterministic(clamp(s+a, 1, 4)),
	reward = (s, a)->s^2,
	discount = 0.99,
	initialstate = Deterministic(1)
	)

# ╔═╡ 44b472b6-5fa0-11eb-3ff9-f56e5fb148cf
states(tm)

# ╔═╡ 6b4199d6-5fa0-11eb-23cb-c3d0e00ca1f9
transition(tm, 1, 2)

# ╔═╡ 7168b952-5fa0-11eb-19ba-4f4245b20331
md"""
#### Sometimes, you might just want a generative model and might not need to explicitly define the state space
"""

# ╔═╡ 014f716e-5fa1-11eb-3821-1b0c56b144f8
cm = QuickMDP(
	statetype=Float64,
	actiontype=Float64,
	gen = (s, a, rng) -> (sp = s + a + randn(rng), r = s^2),
	initialstate = Normal(0.0, 1.0)
)

# ╔═╡ 63ed1344-5fa1-11eb-1992-733b067c8714
@gen(:sp)(cm, 1, -1)

# ╔═╡ 3bd17d38-5fa0-11eb-33a0-61667a98c668
md"""
# Simulations
"""

# ╔═╡ dca04a7c-5fa1-11eb-1afb-0bb328058e2f
# the most transparent way to run a simulation is with the stepthrough iterator
begin
	history = []
	for (s, a, sp, r) in stepthrough(tm, RandomPolicy(tm), "s,a,sp,r", max_steps=10)
		push!(history, (s, a, sp, r))
	end
	history
end

# ╔═╡ 5b9ef198-5fa2-11eb-32ad-57708e9bb0af
# efficient rollout simulations may also be run with a Rollout Simulator
simulate(RolloutSimulator(max_steps=10), cm, FunctionPolicy(s->-s))

# ╔═╡ f55cdda0-5fa1-11eb-1174-cf8bd87afda1


# ╔═╡ Cell order:
# ╟─bce555bc-5ba3-11eb-1bbb-23ffa36b1394
# ╠═db9709e2-5ba3-11eb-3133-d7b761e73531
# ╠═f39aa60c-5ba3-11eb-308e-c393d2e41ef4
# ╠═1a1c8d0e-5ba4-11eb-2dcf-0b49be87c4e1
# ╟─1e628436-5ba4-11eb-089d-752f74636f87
# ╠═e2b18330-5ba6-11eb-050a-5d47dbaa2c5a
# ╠═3cb447a2-5ba5-11eb-35b2-abad16d4cbbd
# ╟─3e2f9c8e-5bab-11eb-1f27-03af0738b2f6
# ╠═fe9048b2-5f9c-11eb-380b-2d9f987700e9
# ╠═0a5b7234-5f9d-11eb-117c-cd289e20146b
# ╠═19d34534-5f9d-11eb-38e3-3572155e8e03
# ╠═37cd5f24-5ba7-11eb-351d-0b95699c4eb5
# ╠═d86fcc78-5f9e-11eb-0708-09cdf257585f
# ╠═c775320c-5f9e-11eb-0200-b774b9c408f9
# ╟─26fcd508-5ba7-11eb-3b2c-03ccd2061650
# ╠═22626ad4-5f9f-11eb-1760-9dfe33dd4d8a
# ╟─b542d726-5f9f-11eb-3a88-215126f33f52
# ╠═f23c77b8-5f9f-11eb-3e11-c57256436bd5
# ╠═5369c9d2-5fa0-11eb-31f4-47ef5e346cfc
# ╠═fc16ee08-5f9f-11eb-2d20-9d008ba04797
# ╠═44b472b6-5fa0-11eb-3ff9-f56e5fb148cf
# ╠═6b4199d6-5fa0-11eb-23cb-c3d0e00ca1f9
# ╟─7168b952-5fa0-11eb-19ba-4f4245b20331
# ╠═014f716e-5fa1-11eb-3821-1b0c56b144f8
# ╠═63ed1344-5fa1-11eb-1992-733b067c8714
# ╟─3bd17d38-5fa0-11eb-33a0-61667a98c668
# ╠═c5e60600-5fa1-11eb-1e5a-dd969ccbe72f
# ╠═dca04a7c-5fa1-11eb-1afb-0bb328058e2f
# ╠═5b9ef198-5fa2-11eb-32ad-57708e9bb0af
# ╠═f55cdda0-5fa1-11eb-1174-cf8bd87afda1
