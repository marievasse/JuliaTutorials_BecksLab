## Quarto Mac Setup for Tutorial Editing and Making

# download Quarto


## Create manifest and project for tutorials
import(Pkg)

# activate working directory and project
Pkg.activate(".")

# add packages to generate manifest

# julia packages for tutorials
Pkg.add("Plots")
Pkg.add("Random")
Pkg.add("CSV")
Pkg.add("DataFrames")
Pkg.add("EcologicalNetworks")
Pkg.add("EcologicalNetworksPlots")
Pkg.add("StatsPlots")

# look here for info on setting VS up to run Julia
# it uses jupyter underneath.
# https://quarto.org/docs/computations/julia.html#installation

# things for rendering Julia with Quarto
Pkg.add("IJulia")
Pkg.add("Revise")
Pkg.add("Conda")

# this should install a minimal python/Jupyter install
using IJulia
notebook() # this is what triggers the minimal install?

## the larger install for Jupyter is via (or via any other pip)
## it's ok to do this...  but try above first.
# python3 -m pip install jupyter

# then, create jupyter caching
using Conda
Conda.add("jupyter-cache")


# to make IJulia work with Revise
# Revise.jl is a library that helps you keep your
# Julia sessions running longer, reducing the need to
# restart when you make changes to code.

# # make this file to use Revise with iJulia
# cd ~/.julia # navigate
# mkdir config # make directory
# cd config # move to it
# touch startup_ijulia.jl # to create file

# pico # to edit with this code

# try
#     @eval using Revise
#   catch e
#     @warn "Revise init" exception=(e, catch_backtrace())
#   end

# install local BEFWM2
# The local machine copy of the GitHub Repo is being used
# (e.g. use GitHub Desktop to clone BEFWM2 to local machine)
# (If copy exists, Fetch Origin before doing this)

# Pkg.add(path = "/Users/apb/Documents/GitHubREPOS/BEFWM2/")
Pkg.develop(path = "/Users/apb/Documents/EcologicalNetworksDynamics.jl-main/")

# run this before updating to new dev
# EcologicalNetworksDynamics.jl-ni_usecase
# Pkg.rm("EcologicalNetworksDynamics")
# ] dev ~/Documents/EcologicalNetworksDynamics.jl-ni_usecase
