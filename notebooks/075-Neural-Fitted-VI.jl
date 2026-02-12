using POMDPs
using POMDPModels: SimpleGridWorld
using POMDPTools: render, ordered_states, VectorPolicy
using Compose: draw, PNG
import Cairo, Fontconfig
using Flux
using Plots
using ProgressLogging
using Random

m = SimpleGridWorld(discount=0.95, tprob=0.7)

S = ordered_states(m)
A = collect(actions(m))
γ = discount(m)
n_states = length(S)

# Encode state (x,y) as normalized 2-element Float32 vector
function state_features(m, s)
    sz = m.size
    return Float32[s[1] / sz[1], s[2] / sz[2]]
end

X = hcat([state_features(m, s) for s in S]...)  # 2 × n_states

# MSE loss
loss(model, x, y) = sum((model(x) .- y) .^ 2) / length(y)

function train!(model, opt_state, x_data, y_data;
    n_epochs=1_000, save_every=50, minibatch_size=16
)
    losses = Float32[]
    models = [deepcopy(model)]

    n_minibatches = max(1, size(y_data, 2) ÷ minibatch_size)

    @progress for epoch in 1:n_epochs
        perm = randperm(size(x_data, 2))
        x_shuf = x_data[:, perm]
        y_shuf = y_data[:, perm]

        batch_loss = zero(Float32)

        for i in 1:n_minibatches
            idxs = (1:minibatch_size) .+ minibatch_size * (i - 1)
            idxs = idxs[idxs .<= size(x_shuf, 2)]
            x_mb = x_shuf[:, idxs]
            y_mb = y_shuf[:, idxs]

            mb_loss, grads = Flux.withgradient(model -> loss(model, x_mb, y_mb), model)
            Flux.update!(opt_state, model, grads[1])
            batch_loss += mb_loss / n_minibatches
        end

        push!(losses, batch_loss)

        if epoch % save_every == 0
            push!(models, deepcopy(model))
        end
    end

    return models, losses
end

function bellman_targets(m, S, A, γ, V)
    y = zeros(Float32, 1, length(S))
    for (i, s) in enumerate(S)
        q_best = -Inf
        for a in A
            # q = q_explicit(m, s, a, γ, V)
            q = q_mc(m, s, a, γ, V)
            q_best = max(q_best, q)
        end
        y[1, i] = Float32(q_best)
    end
    return y
end

function q_explicit(m, s, a, γ, V)
    td = transition(m, s, a)
    return sum(pdf(td, sp) * (reward(m, s, a, sp) + γ * only(V(state_features(m, sp)))) for sp in support(td))
end

function q_mc(m, s, a, γ, V; n=100)
    qsum = 0.0
    for i in 1:n
        sp, r = @gen(:sp, :r)(m, s, a)
        qsum += r + γ * only(V(state_features(m, sp)))
    end
    return qsum / n
end


# Neural Fitted Value Iteration
function neural_fitted_vi(m, S, A, X, γ;
    n_vi_iters=5, learning_rate=1e-3, n_epochs=1_000,
    minibatch_size=32, save_every=50
)
    V = Chain(
        Dense(2 => 64, tanh),
        Dense(64 => 64, tanh),
        Dense(64 => 1)
    )
    opt_state = Flux.setup(Adam(learning_rate), V)

    history = []

    for vi_iter in 1:n_vi_iters
        @info "VI iteration $vi_iter / $n_vi_iters"

        Y = bellman_targets(m, S, A, γ, V)

        models, losses = train!(V, opt_state, X, Y;
            n_epochs=n_epochs,
            save_every=save_every,
            minibatch_size=minibatch_size,
        )

        push!(history, (V=deepcopy(V), losses=losses))
    end

    return history
end

history = neural_fitted_vi(m, S, A, X, γ;
    n_vi_iters=5,
    learning_rate=1e-3,
    n_epochs=1_000,
    minibatch_size=32,
)

# Extract greedy policy from final value function
final_V = history[end].V

greedy_actions = map(S) do s
    argmax(a -> q_explicit(m, s, a, γ, final_V), A)
end
greedy_policy = VectorPolicy(m, greedy_actions)

# Plot loss curves across VI iterations
p_loss = plot(; xlabel="Epoch", ylabel="MSE Loss", yaxis=:log, title="Training Loss per VI Iteration")
for (i, entry) in enumerate(history)
    plot!(p_loss, entry.losses; label="VI iter $i")
end

savefig(p_loss, "neural_fitted_vi_loss.png")
println("Saved loss plot to neural_fitted_vi_loss.png")

V_vec = vec(Float64.(final_V(X)))
p_grid = render(m, color=V_vec, policy=greedy_policy)
draw(PNG("neural_fitted_vi_grid.png"), p_grid)
println("Saved grid world plot to neural_fitted_vi_grid.png")

# Save value function plot for each VI iteration
for (i, entry) in enumerate(history)
    v_i = vec(Float64.(entry.V(X)))
    actions_i = map(s -> argmax(a -> q_explicit(m, s, a, γ, entry.V), A), S)
    policy_i = VectorPolicy(m, actions_i)
    draw(PNG("neural_fitted_vi_grid_$(lpad(i, 3, '0')).png"), render(m, color=v_i, policy=policy_i))
end
println("Saved grid plots")
