### A Pluto.jl notebook ###
# v0.12.19

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
	using POMDPs
	using POMDPModels: SimpleGridWorld
	using POMDPModelTools: render,
						   policy_transition_matrix,
	                       policy_reward_vector,
	                       ordered_states
	using POMDPPolicies: VectorPolicy
	using LinearAlgebra: I
	using PlutoUI: Slider	
end

# ╔═╡ a8fe8a5c-611e-11eb-262e-6b0639f4493a
md"""
# Policy Iteration
"""

# ╔═╡ 57284a38-613c-11eb-3f08-8131182af077
render(SimpleGridWorld())

# ╔═╡ f7bb0fbc-611e-11eb-2f26-75676b6b3ea4
function policy_iteration(m)
	# setup
	A = collect(actions(m))
	γ = discount(m)
	n = length(states(m))
	p = VectorPolicy(m, rand(A, n))
	new_p = VectorPolicy(m, rand(A, n))
	pv_history = []
	
	while any(action(p, s) != action(new_p, s) for s in states(m))
		p = new_p
		
		# evaluate policy
		T = policy_transition_matrix(m, p)
		R = policy_reward_vector(m, p)
		V = (I - γ*T)\R
		
		push!(pv_history, (p=p, v=V))
		
		# extract new policy
		a_vec = Symbol[]
		for s in ordered_states(m)
			
			q = zeros(length(A))
			
			for (j, a) in enumerate(A)
				td = transition(m, s, a)
				for sp in support(td)
					q[j] += pdf(td, sp) * (reward(m,s,a,sp) + γ*V[stateindex(m,sp)])
				end
			end
			
			push!(a_vec, A[argmax(q)])
		end
		new_p = VectorPolicy(m, a_vec)			
	end
	
	return pv_history
end

# ╔═╡ fb20cab4-6125-11eb-3dad-3977534b7bf9
# @bind tprob Slider(0:0.1:1)
tprob = 0.85

# ╔═╡ d13b6ef6-611e-11eb-0ea3-0550a24b365f
m = SimpleGridWorld(tprob=tprob)

# ╔═╡ 2ef56108-6124-11eb-253d-f792af9f854e
pvs = policy_iteration(m);

# ╔═╡ 98630b10-6124-11eb-177e-71c73dffbf49
@bind k Slider(1:length(pvs)-1)
# k = length(pvs)-1

# ╔═╡ 5c8576ac-6125-11eb-0bd8-9789dc4199f8
md"""
### Old Policy and resulting value function.
"""

# ╔═╡ a4e3885e-6124-11eb-3795-3d9c87a8a858
render(m, policy=pvs[k].p, color=pvs[k].v)

# ╔═╡ 6aa77620-6125-11eb-25d3-6d590870836a
md"""
### New Policy calculated from old value function
"""

# ╔═╡ 16d6b8a0-6125-11eb-0d2c-c5f1fabff347
render(m, policy=pvs[k+1].p, color=pvs[k].v)

# ╔═╡ Cell order:
# ╟─a8fe8a5c-611e-11eb-262e-6b0639f4493a
# ╠═c09db3ea-611e-11eb-132c-4ff939fb41e7
# ╠═57284a38-613c-11eb-3f08-8131182af077
# ╠═f7bb0fbc-611e-11eb-2f26-75676b6b3ea4
# ╠═fb20cab4-6125-11eb-3dad-3977534b7bf9
# ╠═d13b6ef6-611e-11eb-0ea3-0550a24b365f
# ╠═2ef56108-6124-11eb-253d-f792af9f854e
# ╠═98630b10-6124-11eb-177e-71c73dffbf49
# ╟─5c8576ac-6125-11eb-0bd8-9789dc4199f8
# ╠═a4e3885e-6124-11eb-3795-3d9c87a8a858
# ╟─6aa77620-6125-11eb-25d3-6d590870836a
# ╠═16d6b8a0-6125-11eb-0d2c-c5f1fabff347
