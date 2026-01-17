import DMUStudent.HW1
using BenchmarkTools
#------------- 
# Problem 4
# mulitply matrix a (2x2) by a list of vectors (2,)
#
#-------------

# Here is a functional but incorrect answer for the programming question
@inline function f(a::Matrix{T}, bs::Vector{Vector{T}})::Vector{T} where T<:Real
    # println("+++++++++++")
    # println("Dim of a as run by evaluate is: $(size(a, 1))")
    # println("Dim of b as run by evaluate is: $(size(bs, 1))")

    # final method, just hard code it lollll. supa fastttt
    if size(bs, 1) == 2 # most cases
        # @show hcat(a*bs[1], a*bs[2])

        return [max(a[1,1]*bs[1][1] + a[1,2]*bs[1][2], a[1,1]*bs[2][1] + a[1,2]*bs[2][2]),
                max(a[2,1]*bs[1][1] + a[2,2]*bs[1][2], a[2,1]*bs[2][1] + a[2,2]*bs[2][2])]
    else
        return a*bs[1]
    end
end

# REALLY SLOW... reduce is slow?? probs just allocation is slow
#     b_reduced = reduce(hcat, bs)

#     # b is now 2 by N, so a@b is 2 by N, and I can max
#     return vec(maximum(a * b_reduced, dims=2))
# end

# First implementation is actually decently fast :O
#     if size(bs, 1) == 2
#         # @show hcat(a*bs[1], a*bs[2])
#         return vec(maximum(hcat(a*bs[1], a*bs[2]), dims=2))
#     else
#         return maximum(a*bs[1], dims=2)
#     end
# end

# You can can test it yourself with inputs like this
# a = [2.0 0.0; 0.0 1.0]
# @show a
# bs = [[1.0, 2.0], [2.0, 1.0]]
# @show bs
# @show f(a, bs)

a = rand(2,2)
test_bs = [[rand(2) for _ in 1:2] for _ in 1:100]

@btime for b in $test_bs
    f($a, b)
end

# This is how you create the json file to submit
HW1.evaluate(f, "owen.kranz@colorado.edu")
