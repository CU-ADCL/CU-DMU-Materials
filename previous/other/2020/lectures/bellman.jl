function bellman(m, v)
    vp = similar(v)
    for (i,s) in enumerate(ordered_states(m))
        if isterminal(m, s)
            vp[i] = 0.0
        else
            maxq = -Inf
            for a in actions(m)
                q = 0.0
                td = transition(m, s, a)
                for (sp, p) in weighted_iterator(td)
                    q += p*(reward(m, s, a, sp) + discount(m)*v[stateindex(m, sp)])
                end
                maxq = max(maxq, q)
            end
            vp[i] = maxq
        end
    end
    return vp
end
