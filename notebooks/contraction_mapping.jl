using Plots
using LinearAlgebra: norm
plotlyjs()

f(x) = [x[2]/2 + 1, x[1]/2 + 1/2]

d(x, y) = norm(x-y)

x = [1,1]
y = [-1,-1]

f(x)
f(y)

d(x, y)
xp = f(x)
yp = f(y)
d(xp, yp)

p = plot([x[1], y[1]], [x[2], y[2]], markershape=:xcross, label="x, y")
plot!(p, [xp[1], yp[1]], [xp[2], yp[2]], markershape=:circle, label="f(x), f(y)")

start = [1.0, 2.0]
history = [start]
for k in 1:10
    push!(history, f(history[end]))
end
plot!([x[1] for x in history], [x[2] for x in history],
      arrow=true,
      markershape=:circle,
      label=string(start))
