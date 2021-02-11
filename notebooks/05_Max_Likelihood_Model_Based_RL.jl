### A Pluto.jl notebook ###
# v0.12.20

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

# ╔═╡ c09db3ea-611e-11eb-132c-4ff939fb41e7
begin
	using POMDPModels: SimpleGridWorld
	using POMDPModelTools: render
	using POMDPPolicies: FunctionPolicy
	using LinearAlgebra: I
	using PlutoUI: Slider
	using CommonRLInterface: actions, act!, observe, reset!, AbstractEnv, observations, terminated
	using SparseArrays
end

# ╔═╡ a8fe8a5c-611e-11eb-262e-6b0639f4493a
md"""
# Policy Iteration
"""

# ╔═╡ f7bb0fbc-611e-11eb-2f26-75676b6b3ea4
function max_likelihood_model_based_rl!(N, ρ, env, index; ϵ=0.10, γ=0.9)
		
	# calculate MDP model
	A = collect(actions(env))
	sz = length(index) # number of states
	sums = Dict(a => sum(N[a], dims=2).+1e-6 for a in A)
	T = Dict(a => N[a]./sums[a] for a in A)
	R = Dict(a => ρ[a]./sums[a] for a in A)
		
	# solve with VI
	V = zeros(sz)
	oldV = ones(sz)
	
	while maximum(abs, V-oldV) > 0.0001
    	oldV[:] = V
       	V[:] = max.((R[a] .+ γ*T[a]*V for a in A)...)
	end
	
	Q = Dict(a => R[a] .+ γ*T[a]*V for a in A)
	
	policy(s) = A[argmax([Q[a][index[s]] for a in A])]
	
	# setup
	s = observe(env)
	hist = [s]
	
	while !terminated(env)
		if rand() < ϵ
			a = rand(actions(env))
		else
			a = policy(observe(env))
		end
				
		r = act!(env, a)
		sp = observe(env)
		push!(hist, sp)
		N[a][index[s], index[sp]] += 1
		ρ[a][index[s]] += r
		s = sp
	end
		
	return (;hist, V, policy)
end

# ╔═╡ fb20cab4-6125-11eb-3dad-3977534b7bf9
# @bind tprob Slider(0:0.1:1)
tprob = 0.65;

# ╔═╡ d13b6ef6-611e-11eb-0ea3-0550a24b365f
m = SimpleGridWorld(tprob=tprob);

# ╔═╡ 2ef56108-6124-11eb-253d-f792af9f854e
env = convert(AbstractEnv, m);

# ╔═╡ 98630b10-6124-11eb-177e-71c73dffbf49
begin
	sz = length(observations(env))
	n = Dict(a => spzeros(sz, sz) for a in actions(env))
	ρ = Dict(a => spzeros(sz) for a in actions(env))
	index = Dict(s => i for (i, s) in enumerate(observations(env)))
	episodes = []
	n_episodes = 100
end;

# ╔═╡ a4e3885e-6124-11eb-3795-3d9c87a8a858
for i in 1:n_episodes
	reset!(env)
	push!(episodes, max_likelihood_model_based_rl!(n, ρ, env, index; ϵ=max(0.1, 1-i/n_episodes)))
end

# ╔═╡ b9873d0e-6c7e-11eb-0ae0-ab8801ffd70d
md"""
$(@bind ep Slider(1:length(episodes)))
"""

# ╔═╡ b09599a2-6c81-11eb-3642-a94b20b154d9
md"""
$(@bind step Slider(1:length(episodes[ep].hist)))
"""

# ╔═╡ 2e9d428c-6c7f-11eb-248f-0badf27002e9
begin
	episode = episodes[ep]
	i = min(step, length(episode.hist))
	render(m, (s=episode.hist[i],); color=s->episode.V[index[s]], policy=FunctionPolicy(episode.policy))
end

# ╔═╡ Cell order:
# ╟─a8fe8a5c-611e-11eb-262e-6b0639f4493a
# ╠═c09db3ea-611e-11eb-132c-4ff939fb41e7
# ╠═f7bb0fbc-611e-11eb-2f26-75676b6b3ea4
# ╠═fb20cab4-6125-11eb-3dad-3977534b7bf9
# ╠═d13b6ef6-611e-11eb-0ea3-0550a24b365f
# ╠═2ef56108-6124-11eb-253d-f792af9f854e
# ╠═98630b10-6124-11eb-177e-71c73dffbf49
# ╠═a4e3885e-6124-11eb-3795-3d9c87a8a858
# ╠═b9873d0e-6c7e-11eb-0ae0-ab8801ffd70d
# ╠═b09599a2-6c81-11eb-3642-a94b20b154d9
# ╠═2e9d428c-6c7f-11eb-248f-0badf27002e9
