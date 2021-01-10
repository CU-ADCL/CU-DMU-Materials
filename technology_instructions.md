# Technology Instructions for Decision Making under Uncertainty

Decision Making under Uncertainty will require programming to complete assignment. The use of *any* programming language is allowed, however [Julia 1.5.3](https://julialang.org/) is the only supported language.

Help for common difficulties and bugs will be posted on this page.

## Getting Started

### 1. Install [Julia](https://julialang.org/)

Download Julia by following the instructions at https://julialang.org/downloads/ (see the note about [JuliaPro](#JuliaPro) below).

### 2. Install DMUStudent.jl

Follow the instructions at https://github.com/zsunberg/DMUStudent.jl to install and test the DMUStudent.jl package.

## Additional Information

### DMUStudent.jl and Leaderboard

DMUStudent.jl is the main package that will provide code for assignments. Documentation can be found at https://github.com/zsunberg/DMUStudent.jl

### Editing Julia Source Files

Unlike MATLAB, but like most other programming languages, Julia does not come bundled with an editor. People looking for a MATLAB-like experience may wish to use the [Julia for VS Code](https://www.julia-vscode.org/) or [Juno](https://junolab.org/) IDES. A list of other editors that have Julia integration can be found by scrolling down on the [Julia webpage](julialang.org).

### JuliaPro

JuliaPro provides a more integrated download of Julia with the Juno IDE included. However since we will be using packages from the [SISL registry](https://github.com/sisl/Registry), some additional configuration may be required (see e.g. https://github.com/JuliaPOMDP/POMDPs.jl/issues/249).

### Jupyter Notebooks

[Pluto notebooks](https://github.com/fonsp/Pluto.jl) can be useful for showing results alongside code - e.g. for homework submissions. Starter code for assignments will be provided in this format.

### Python

Python and Julia are capable of interoperating and it may be possible to complete many of the homework assignments using python, however the course staff cannot guarantee support, and python may be too slow in some instances. Python can call Julia through the [pyjulia package](https://github.com/JuliaPy/pyjulia), and Julia can call python through [PyCall.jl](https://github.com/JuliaPy/PyCall.jl).
