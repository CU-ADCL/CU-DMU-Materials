# Technology Instructions for Decision Making under Uncertainty

Decision Making under Uncertainty will require programming to complete assignment. The use of *any* programming language is allowed, however [Julia 1.7](https://julialang.org/) is the only fully-supported language.

Help for common difficulties and bugs will be posted on this page.

## Getting Started

### 1. Install [Julia](https://julialang.org/)

Download Julia by following the instructions at https://julialang.org/downloads/ .

Note: for Windows, [julia is also available on the windows store](https://www.microsoft.com/en-us/p/julia/9njnww8pvkmn#activetab=pivot:overviewtab).

### 2. Install DMUStudent.jl

Follow the instructions at https://github.com/zsunberg/DMUStudent.jl to install and test the DMUStudent.jl package.

## Additional Information/FAQs

### How do I edit Julia source files?

Unlike MATLAB, but like most other programming languages, Julia does not come bundled with an editor. People looking for a MATLAB-like experience may wish to use the [Julia for VS Code](https://www.julia-vscode.org/) IDE. A list of other editors that have Julia integration can be found by scrolling down on the [Julia webpage](julialang.org).

### What are the differences between Julia and MATLAB/Python?

A list of differences can be found [here](https://docs.julialang.org/en/v1/manual/noteworthy-differences/).

### How do I make my Julia code fast?

You can find performance tips [here](https://docs.julialang.org/en/v1/manual/performance-tips/).

### Can I use Python code with Julia?

Python and Julia are capable of interoperating and it may be possible to complete many of the homework assignments using python, however the course staff cannot guarantee support, and python may be too slow in some instances. Python can call Julia through the [pyjulia package](https://github.com/JuliaPy/pyjulia), and Julia can call python through [PyCall.jl](https://github.com/JuliaPy/PyCall.jl).
