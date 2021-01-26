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

# ╔═╡ 15a32d98-5fa3-11eb-13d1-195cbd3007af
begin
	using POMDPs
	using POMDPModels: SimpleGridWorld
	using POMDPPolicies: FunctionPolicy
	using POMDPSimulators: RolloutSimulator, stepthrough
	using QuickPOMDPs
	using Distributions
	using Plots
	using PlutoUI
end

# ╔═╡ 3756e224-5fa3-11eb-10f2-f9adf15c5fb9
lqr = QuickMDP(
	statetype=Float64,
	actiontype=Float64,
	gen = (s, a, rng) -> (sp = s + 0.2*a + 0.1*randn(rng), r = -s^2),
	initialstate = Normal(0.0, 1.0)
)

# ╔═╡ f970d680-600a-11eb-0e43-ad6ccb7c5514
let
	policy = FunctionPolicy(s->-s/4)
	trajs = [collect(stepthrough(lqr, policy, "s", max_steps=100)) for _ in 1:10]
	plot(trajs, ylim=(-2, 2), legend=nothing, title="10 Trajectories with a=-s/4")
end

# ╔═╡ 21fde26a-5fef-11eb-3973-633468304e4a
md"""
# Monte Carlo Evaluation
"""

# ╔═╡ 880bbde6-6000-11eb-1ad8-ebc2cee1b66d
@bind m_exp Slider(2:0.2:4)

# ╔═╡ c224dfd8-6009-11eb-03a7-dd32da47b8c9
m = round(Int, 10^m_exp)

# ╔═╡ fae2a3aa-5fff-11eb-104e-cdeec84fe571
u_is = [simulate(RolloutSimulator(max_steps=100), lqr, FunctionPolicy(s->-s)) for _ in 1:m];

# ╔═╡ 2d4f5568-6000-11eb-2bb8-6d238d49264b
histogram(u_is, xlim=(-50, 0), title="\$\\hat{u}_i\$", label=nothing)

# ╔═╡ 4486be4c-6000-11eb-066f-47d533f8ba5f
u_ms = [mean([simulate(RolloutSimulator(max_steps=100), lqr, FunctionPolicy(s->-s)) for _ in 1:m]) for _ in 1:100];

# ╔═╡ 5878b43c-6000-11eb-2dfd-ab3d6a48b577
histogram(u_ms, xlim = (-6, -5), ylim=(0,50), title="\$\\bar{u}_m\$", label=nothing)

# ╔═╡ 626b4a54-6000-11eb-0ddf-5d25933c8a6e
sem = std(u_is)/sqrt(m)

# ╔═╡ 299e4f52-5fef-11eb-1ff8-4363ed206efe
md"""
# Policy Parameterized by k
$\pi(s) = -k s$
"""

# ╔═╡ 8f8a67de-5fa3-11eb-151e-f1381d768656
@bind k Slider(-1:0.1:11)

# ╔═╡ d9443850-5fa3-11eb-1a8f-3b2a51d915c5
begin
	policy = FunctionPolicy(s->-k*s)
	trajs = [collect(stepthrough(lqr, policy, "s", max_steps=100)) for _ in 1:10]
	plot(trajs, ylim=(-10, 10), legend=nothing, title="k=$k")
end

# ╔═╡ d6e3d606-5fee-11eb-2047-d3e43f022e50
md"""
# Cross-Entropy Method
"""

# ╔═╡ f19c17d2-5fa4-11eb-11ca-c3d4ed014dc0
function mc_evaluate(k, m=10)
	p = FunctionPolicy(s->-k*s)
	rsum = 0.0
	for _ in 1:m
		rsum += simulate(RolloutSimulator(max_steps=100), lqr, p)
	end
	return rsum/m
end

# ╔═╡ 95ea5eb8-5fa8-11eb-081e-939fc0837036
begin
	plots = []
	# initial distribution
	d = Uniform(-1.0, 10.0)
	
	for _ in 1:100		
		# initially sample a population
		pop = rand(d, 100)
		evals = map(mc_evaluate, pop)
		
		# find the best
		best = sortperm(evals, rev=true)[1:10]
		
		# fit the new distribution
		global d = fit(Normal, pop[best])
			
		# (plot)
		p = plot(pop, evals, line=:stem, marker=:circle, ylim=(-10,2), label=nothing, color=:blue)
		plot!(p, pop[best], evals[best], line=:stem, marker=:circle, ylim=(-10,2), xlim=(-1,10), label="Elite", color="red")
		plot!(p, -1:0.01:10, x->2*pdf(d, x), label="Fit")
		push!(plots, p)
	end
end

# ╔═╡ 29626702-5faa-11eb-0d73-c1378d298515
@bind i Slider(1:length(plots))

# ╔═╡ 87b975ac-5faa-11eb-3fae-5d9b5c6d744c
plots[i]

# ╔═╡ Cell order:
# ╠═15a32d98-5fa3-11eb-13d1-195cbd3007af
# ╠═3756e224-5fa3-11eb-10f2-f9adf15c5fb9
# ╠═f970d680-600a-11eb-0e43-ad6ccb7c5514
# ╟─21fde26a-5fef-11eb-3973-633468304e4a
# ╠═880bbde6-6000-11eb-1ad8-ebc2cee1b66d
# ╠═c224dfd8-6009-11eb-03a7-dd32da47b8c9
# ╠═fae2a3aa-5fff-11eb-104e-cdeec84fe571
# ╠═2d4f5568-6000-11eb-2bb8-6d238d49264b
# ╠═4486be4c-6000-11eb-066f-47d533f8ba5f
# ╠═5878b43c-6000-11eb-2dfd-ab3d6a48b577
# ╠═626b4a54-6000-11eb-0ddf-5d25933c8a6e
# ╟─299e4f52-5fef-11eb-1ff8-4363ed206efe
# ╠═8f8a67de-5fa3-11eb-151e-f1381d768656
# ╠═d9443850-5fa3-11eb-1a8f-3b2a51d915c5
# ╟─d6e3d606-5fee-11eb-2047-d3e43f022e50
# ╠═f19c17d2-5fa4-11eb-11ca-c3d4ed014dc0
# ╠═95ea5eb8-5fa8-11eb-081e-939fc0837036
# ╠═29626702-5faa-11eb-0d73-c1378d298515
# ╠═87b975ac-5faa-11eb-3fae-5d9b5c6d744c
