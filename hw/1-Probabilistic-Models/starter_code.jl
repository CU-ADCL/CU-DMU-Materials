#=================
# Question 4 (a)
=================#

# For Q4a, you will need to access the fx and fy functions and plot.

# You can import fx and fy with the following commands:
using DMUStudent.HW1: fx, fy

# To generate a sample of x₃ given that x₁ = 1 and x₂ = 2, use
x1 = 1
x2 = 2

x3 = fx([x1, x2])

# There are a variety of tools for plotting in Julia. For example, some users
# are very fond of packages like VegaLite.jl. I will typically demonstrate with
# Plots.jl because it is widely used (however, it is notorious for having a
# long startup time). To plot a random line of length 10, use
using Plots

x = 1:10
y = rand(10)
plot(x, y, label="Random")

# to add another line, use
p = plot!(x, rand(10), label="Other Random")
display(p) # display is not always needed, for example in Jupyter or Pluto

#=================
# Question 4 (b)
=================#

# For Q4b, the following function may be useful:
"""
    empirical_distribution(f, history)

Return a probability vector indicating the likelihood of outcomes between 1 and
20 of f(history), estimated through sampling.

Example: empirical_distribution(fx, [x1, x2])
"""
function empirical_distribution(f, history; n=100_000)
	counts = zeros(20)
	for _ in 1:n
		counts[f(history)] += 1
	end
	return counts./n
end

#=================
# Question 5
=================#

# Here is a wrong answer for Q5:
import DMUStudent.HW1

f(x, y) = x + y
HW1.evaluate(f, "your.gradescope.email@colorado.edu")
