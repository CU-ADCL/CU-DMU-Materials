import DMUStudent.HW1

#------------- 
# Problem 4
#-------------

# Here is a functional but incorrect answer for the programming question
function f(a, bs)
    return a*bs[1]
end

# You can can test it yourself with inputs like this
a = [1.0 2.0; 3.0 4.0]
@show a
bs = [[1.0, 2.0], [3.0, 4.0]]
@show bs
@show f(a, bs)

# This is how you create the json file to submit
HW1.evaluate(f, "your.gradescope.email@colorado.edu")
