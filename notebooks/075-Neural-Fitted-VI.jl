using POMDPs
using ContinuumWorld: CWorld, CWorldVis, Vec2
using Flux
using Plots
using ProgressLogging
using Random

m = CWorld()

A = actions(m)
γ = discount(m)

# Encode state as normalized 2-element Float32 vector
function state_features(m, s)
    return Float32[(s[1] - m.xlim[1]) / (m.xlim[2] - m.xlim[1]),
                   (s[2] - m.ylim[1]) / (m.ylim[2] - m.ylim[1])]
end

# MSE loss with L2 regularization
function loss(model, x, y; λ=1f-3)
    mse = sum((model(x) .- y) .^ 2) / length(y)
    l2 = sum(sum(abs2, p) for p in Flux.trainables(model))
    return mse + λ * l2
end

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

function bellman_targets(m, A, γ, V; n_samples, n_mc_sims)
    sampled_states = [rand(initialstate(m)) for _ in 1:n_samples]
    x = hcat([state_features(m, s) for s in sampled_states]...)
    y = zeros(Float32, 1, n_samples)
    for (i, s) in enumerate(sampled_states)
        q_best = -Inf
        for a in A
            q = q_mc(m, s, a, γ, V; n_mc_sims)
            q_best = max(q_best, q)
        end
        y[1, i] = Float32(q_best)
    end
    return x, y
end

function q_mc(m, s, a, γ, V; n_mc_sims)
    if isterminal(m, s)
        return 0.0
    end
    qsum = 0.0
    for i in 1:n_mc_sims
        sp, r = @gen(:sp, :r)(m, s, a)
        qsum += r + γ * only(V(state_features(m, sp)))
    end
    return qsum / n_mc_sims
end


# Neural Fitted Value Iteration
function neural_fitted_vi(m, A, γ;
    n_vi_iters, learning_rate, n_epochs,
    minibatch_size,
    n_samples,
    n_mc_sims,
    save_every=50
)
    V = Chain(
        Dense(2 => 64, tanh),
        Dense(64 => 128, tanh),
        Dense(128 => 128, tanh),
        Dense(128 => 64, tanh),
        Dense(64 => 1)
    )
    opt_state = Flux.setup(Adam(learning_rate), V)

    history = []

    for vi_iter in 1:n_vi_iters
        @info "VI iteration $vi_iter / $n_vi_iters"

        X_sample, Y = bellman_targets(m, A, γ, V; n_samples, n_mc_sims)

        models, losses = train!(V, opt_state, X_sample, Y;
            n_epochs=n_epochs,
            save_every=save_every,
            minibatch_size=minibatch_size,
        )

        push!(history, (V=deepcopy(V), losses=losses))

        p_i = plot(CWorldVis(m; f = s -> only(V(state_features(m, s))), title="VI iter $vi_iter"))
        savefig(p_i, "neural_fitted_vi_grid_$(lpad(vi_iter, 3, '0')).png")
    end

    return history
end

history = neural_fitted_vi(m, A, γ;
    n_vi_iters=30,
    learning_rate=5e-4,
    n_epochs=1000,
    minibatch_size=32,
    n_samples=1000,
    n_mc_sims=50
)

# works reasonably well:
#=
    n_vi_iters=30,
    learning_rate=5e-4,
    n_epochs=100,
    minibatch_size=32,
    n_samples=1000,
    n_mc_sims=50
=#

# Extract final value function
final_V = history[end].V

# Plot loss curves across VI iterations
p_loss = plot(; xlabel="Epoch", ylabel="MSE Loss", yaxis=:log, title="Training Loss per VI Iteration")
for (i, entry) in enumerate(history)
    plot!(p_loss, entry.losses; label="VI iter $i")
end

savefig(p_loss, "neural_fitted_vi_loss.png")
println("Saved loss plot to neural_fitted_vi_loss.png")

p_grid = plot(CWorldVis(m; f = s -> only(final_V(state_features(m, s))), title="Value Function"));
savefig(p_grid, "neural_fitted_vi_grid.png")
println("Saved grid world plot to neural_fitted_vi_grid.png")
