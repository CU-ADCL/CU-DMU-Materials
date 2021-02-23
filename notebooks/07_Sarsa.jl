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
# Sarsa
"""

# ╔═╡ fb20cab4-6125-11eb-3dad-3977534b7bf9
# @bind tprob Slider(0:0.1:1)
tprob = 0.65;

# ╔═╡ d13b6ef6-611e-11eb-0ea3-0550a24b365f
m = SimpleGridWorld(tprob=tprob);

# ╔═╡ 2ef56108-6124-11eb-253d-f792af9f854e
env = convert(AbstractEnv, m);

# ╔═╡ 32fe138c-75a2-11eb-176d-c1f53369bbd4
function sarsa!(Q, env; ϵ=0.10, γ=0.9, α=0.1)
		
	A = collect(actions(env))
	function policy(s)
		if rand() < ϵ
			return rand(actions(env))
		else
			return A[argmax([Q[(s, a)] for a in A])]
		end
	end		
	
	s = observe(env)
	a = policy(s)
	r = act!(env, a)
	sp = observe(env)
	hist = [s]
	
	while !terminated(env)
		ap = policy(sp)
				
		Q[(s,a)] += α*(r + γ*Q[(sp, ap)] - Q[(s, a)])
		
		s = sp
		a = ap
		r = act!(env, a)
		sp = observe(env)
		push!(hist, sp)
	end
	
	Q[(s,a)] += α*(r - Q[(s, a)])
		
	return (hist=hist, Q = copy(Q))
end

# ╔═╡ 98630b10-6124-11eb-177e-71c73dffbf49
begin
	Q = Dict((s, a) => 0.0 for s in observations(env), a in actions(env))
	episodes = []
	n_episodes = 100
end;

# ╔═╡ a4e3885e-6124-11eb-3795-3d9c87a8a858
@time for i in 1:n_episodes
	reset!(env)
	push!(episodes, sarsa!(Q, env; ϵ=max(0.1, 1-i/n_episodes)))
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
	render(m, (s=episode.hist[i],); color=s->maximum(episode.Q[(s, a)] for a in actions(env)))
end

# ╔═╡ 5284dc24-75ed-11eb-39af-f94f6ac22211
function sarsa_lambda!(Q, env; ϵ=0.10, γ=0.9, α=0.1, λ=0.9)
		
	A = collect(actions(env))
	function policy(s)
		if rand() < ϵ
			return rand(actions(env))
		else
			return A[argmax([Q[(s, a)] for a in A])]
		end
	end
		
	s = observe(env)
	a = policy(s)
	r = act!(env, a)
	sp = observe(env)
	hist = [s]
	N = Dict((s, a) => 0.0)
	
	while !terminated(env)
		ap = policy(sp)
		
		N[(s, a)] = get(N, (s, a), 0.0) + 1
		
		δ = r + γ*Q[(sp, ap)] - Q[(s, a)]
		
		for ((s, a), n) in N
			Q[(s, a)] += α*δ*n
			N[(s, a)] *= γ*λ
		end
		
		s = sp
		a = ap
		r = act!(env, a)
		sp = observe(env)
		push!(hist, sp)
	end
	
	N[(s, a)] = get(N, (s, a), 0.0) + 1
	δ = r - Q[(s, a)]
	
	for ((s, a), n) in N
		Q[(s, a)] += α*δ*n
		N[(s, a)] *= γ*λ
	end
	
	return (hist=hist, Q = copy(Q))
end

# ╔═╡ 01cb3f74-75ef-11eb-361d-439fffeb0c7a
begin
	Qλ = Dict((s, a) => 0.0 for s in observations(env), a in actions(env))
	episodes_λ = []
	n_episodes_λ = 100
end;

# ╔═╡ 320f67c8-75ef-11eb-0459-7b463ade3786
@time for i in 1:n_episodes_λ
	reset!(env)
	push!(episodes_λ, sarsa_lambda!(Qλ, env; ϵ=max(0.1, 1-i/n_episodes_λ)))
end

# ╔═╡ 3210a5a2-75ef-11eb-074a-6b0dba59f574
md"""
$(@bind epl Slider(1:length(episodes_λ)))
"""

# ╔═╡ 32222e62-75ef-11eb-2763-75db1d89f8d1
md"""
$(@bind stepl Slider(1:length(episodes_λ[epl].hist)))
"""

# ╔═╡ 99a01f72-75ef-11eb-2a49-efd696ac1fc6
begin
	episode_λ = episodes_λ[epl]
	ii = min(stepl, length(episode_λ.hist))
	render(m, (s=episode_λ.hist[ii],); color=s->maximum(episode_λ.Q[(s, a)] for a in actions(env)))
end

# ╔═╡ Cell order:
# ╠═a8fe8a5c-611e-11eb-262e-6b0639f4493a
# ╠═c09db3ea-611e-11eb-132c-4ff939fb41e7
# ╠═fb20cab4-6125-11eb-3dad-3977534b7bf9
# ╠═d13b6ef6-611e-11eb-0ea3-0550a24b365f
# ╠═2ef56108-6124-11eb-253d-f792af9f854e
# ╠═32fe138c-75a2-11eb-176d-c1f53369bbd4
# ╠═98630b10-6124-11eb-177e-71c73dffbf49
# ╠═a4e3885e-6124-11eb-3795-3d9c87a8a858
# ╠═b9873d0e-6c7e-11eb-0ae0-ab8801ffd70d
# ╠═b09599a2-6c81-11eb-3642-a94b20b154d9
# ╠═2e9d428c-6c7f-11eb-248f-0badf27002e9
# ╠═5284dc24-75ed-11eb-39af-f94f6ac22211
# ╠═01cb3f74-75ef-11eb-361d-439fffeb0c7a
# ╠═320f67c8-75ef-11eb-0459-7b463ade3786
# ╠═3210a5a2-75ef-11eb-074a-6b0dba59f574
# ╠═32222e62-75ef-11eb-2763-75db1d89f8d1
# ╠═99a01f72-75ef-11eb-2a49-efd696ac1fc6
