### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 03266708-5f9a-11eb-198f-63fb998eaf1c
# you can find distributions in two packages
begin
using Distributions
using POMDPModelTools: SparseCat, Deterministic
end

# ╔═╡ 16e5263e-5f9c-11eb-0873-49caa9d73c15
using Random: MersenneTwister

# ╔═╡ 45aed964-5f9a-11eb-0e0a-f9ffd7a1099a
d = Bernoulli(0.7)

# ╔═╡ 55716236-5f9a-11eb-37f2-c91241c2faf2
# sample a random outcome
rand(d)

# ╔═╡ 6428f404-5f9a-11eb-3d41-bd976c753830
# show all the possible outcomes
support(d)

# ╔═╡ 6067b582-5f9a-11eb-235f-1bc9a04df28b
# calculate the probability mass of different values
pdf(d, 1)

# ╔═╡ 989a2d18-5f9a-11eb-3e4c-e56d34263a79
# calculate the mean (or mode)
mean(d)

# ╔═╡ 98fece5a-5f9a-11eb-1555-4ff60ea4af53
md"""
## Distributions can describe continuous random variables
"""

# ╔═╡ 07c4dad0-5f9b-11eb-31ce-fff7c7ae10c9


# ╔═╡ cb34f064-5f9a-11eb-3047-7387fa29541d
n = Normal(1, 0.5)

# ╔═╡ d5a037ca-5f9a-11eb-1715-05968733bf2d
begin
using Plots
plot(x->pdf(n, x), xlim=(-2, 4))
end

# ╔═╡ db625828-5f9a-11eb-3ce7-b7c4db665edb
rand(n)

# ╔═╡ 2d1f0c1a-5f9b-11eb-17d4-1394ae641394
support(n)

# ╔═╡ 310333e2-5f9b-11eb-0929-9193a0999d3c
mean(n)

# ╔═╡ 32d7f948-5f9b-11eb-308b-df701bf11abc
mode(n)

# ╔═╡ 38e66fca-5f9b-11eb-1792-abf1e4faca61
md"""
## Distributions can be multidimensional
"""

# ╔═╡ 44c62c36-5f9b-11eb-0db5-8f5f0ad36975
m = MvNormal([0.0, 0.0], [1 0; 0 1])

# ╔═╡ 5b5e325e-5f9b-11eb-1f4b-4d4acaf8a409
rand(m)

# ╔═╡ 6234fd2e-5f9b-11eb-354b-0d3e28b9c774
md"""
## Distributions (from POMDPModelTools) can have more than numbers
"""

# ╔═╡ 99f6d78c-5f9b-11eb-3507-87f6c8df5b9b
dd = Deterministic("a string")

# ╔═╡ c3dc7e94-5f9b-11eb-2ed5-6515c4631b32
support(dd)

# ╔═╡ c6cfc8ba-5f9b-11eb-2cd8-dd6395089706
rand(dd)

# ╔═╡ d0e231cc-5f9b-11eb-0d02-c9b6ec787c9b
sc = SparseCat(['a', 'b', 'c'], [0.9, 0.05, 0.05])

# ╔═╡ e8ec0d9e-5f9b-11eb-0c53-cb137d84bd34
rand(sc)

# ╔═╡ ef65327e-5f9b-11eb-2fa1-b3d497a70d5d
support(sc)

# ╔═╡ ffa86816-5f9b-11eb-3b3d-f9c031f1035c
md"""
## Random number generators can provide independent streams
"""

# ╔═╡ 31d80f4e-5f9c-11eb-3968-f71778a7b3d2
rng1 = MersenneTwister(1)

# ╔═╡ 3fe8a44a-5f9c-11eb-2c50-617ca10eb981
rng2 = MersenneTwister(1)

# ╔═╡ 4a903480-5f9c-11eb-248e-0790cdc15a3e
rand(rng1, d, 10)

# ╔═╡ 65df2406-5f9c-11eb-0fd0-5dba0726a5eb
rand(rng2, d, 10)

# ╔═╡ Cell order:
# ╠═03266708-5f9a-11eb-198f-63fb998eaf1c
# ╠═45aed964-5f9a-11eb-0e0a-f9ffd7a1099a
# ╠═55716236-5f9a-11eb-37f2-c91241c2faf2
# ╠═6428f404-5f9a-11eb-3d41-bd976c753830
# ╠═6067b582-5f9a-11eb-235f-1bc9a04df28b
# ╠═989a2d18-5f9a-11eb-3e4c-e56d34263a79
# ╟─98fece5a-5f9a-11eb-1555-4ff60ea4af53
# ╠═07c4dad0-5f9b-11eb-31ce-fff7c7ae10c9
# ╠═cb34f064-5f9a-11eb-3047-7387fa29541d
# ╠═d5a037ca-5f9a-11eb-1715-05968733bf2d
# ╠═db625828-5f9a-11eb-3ce7-b7c4db665edb
# ╠═2d1f0c1a-5f9b-11eb-17d4-1394ae641394
# ╠═310333e2-5f9b-11eb-0929-9193a0999d3c
# ╠═32d7f948-5f9b-11eb-308b-df701bf11abc
# ╟─38e66fca-5f9b-11eb-1792-abf1e4faca61
# ╠═44c62c36-5f9b-11eb-0db5-8f5f0ad36975
# ╠═5b5e325e-5f9b-11eb-1f4b-4d4acaf8a409
# ╟─6234fd2e-5f9b-11eb-354b-0d3e28b9c774
# ╠═99f6d78c-5f9b-11eb-3507-87f6c8df5b9b
# ╠═c3dc7e94-5f9b-11eb-2ed5-6515c4631b32
# ╠═c6cfc8ba-5f9b-11eb-2cd8-dd6395089706
# ╠═d0e231cc-5f9b-11eb-0d02-c9b6ec787c9b
# ╠═e8ec0d9e-5f9b-11eb-0c53-cb137d84bd34
# ╠═ef65327e-5f9b-11eb-2fa1-b3d497a70d5d
# ╟─ffa86816-5f9b-11eb-3b3d-f9c031f1035c
# ╠═16e5263e-5f9c-11eb-0873-49caa9d73c15
# ╠═31d80f4e-5f9c-11eb-3968-f71778a7b3d2
# ╠═3fe8a44a-5f9c-11eb-2c50-617ca10eb981
# ╠═4a903480-5f9c-11eb-248e-0790cdc15a3e
# ╠═65df2406-5f9c-11eb-0fd0-5dba0726a5eb
