import DMUStudent.HW1
using BenchmarkTools
#------------- 
# Problem 4
# mulitply matrix a (2x2) by a list of vectors (2,)
# something something read the pdf
#-------------

# Here is a functional but incorrect answer for the programming question
# neato -> parameterize typing lets julia compile code for every T under Reals
@inline function f_fast(a::Matrix{T}, bs::Vector{Vector{T}})::Vector{T} where T<:Real
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


function f_proper(a::Matrix{T}, bs::Vector{Vector{T}})::Vector{T} where T<:Real

        # println("+++++++++++")
    # println("Dim of a as run by evaluate is: $(size(a, 1))")
    # println("Dim of b as run by evaluate is: $(size(bs, 1))")


    #REALLY SLOW... reduce is slow?? probs just allocation is slow
    b_reduced = reduce(hcat, bs)

    # b is now 2 by N, so a@b is 2 by N, and I can max
    return vec(maximum(a * b_reduced, dims=2))
end


a = rand(2,2)
test_bs = [[rand(2) for _ in 1:2] for _ in 1:100]

@btime for b in $test_bs
    f_fast($a, b)
end

# This is how you create the json file to submit
HW1.evaluate(f_fast, "owen.kranz@colorado.edu")
