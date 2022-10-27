# JuliaTutorials

This repository provides a tutorial for using Julia - and more specifically the [BioEnergeticFoodWebs](https://github.com/PoisotLab/BioEnergeticFoodWebs.jl) package - in Visual Studio Code by Chris Griffiths, Eva Delmas and Andrew Beckerman. 

The tutorial takes the form of 5 documents with the following aims:
  1. Getting started - instructions on how to install and run Julia in VS Code, includes details on Julia's package manager
  2. Basic Julia commands - covers data manipulation, loops and functions and plotting in Julia 
  3. Differential Equations in Julia - introduces the `DifferentialEquations.jl` package and provides a working food web example
  4. Intro to BioEnergeticFoodWebs - introduces the `BioEnergeticFoodWebs.jl` package and demonstrates how it can be used to simulate biomass dynamics 
  5. Functional responses - introduces how to manipulate the bioenergetic model's parameters in order to change the functional response used.
  6. (🚧) Temperature effects - introduces how to manipulate the model's biological rates as to include an effect of temperature.
  7. (🚧) Enrichment - introduces how to manipulate the model's biological rates as to include an effect of enrichment.

The idea is that user downloads the documents and works through them sequentially. Each tutorial **should** be fully reproducible. While you can work online using Binder, without having to install anything, we recommend that you download this repository and work through the examples directly in VSCode.  

The tutorials are explicitly designed for new Julia users. They cover a range of topics including working with Julia's package manager, manipulating data, functions and loops, plotting and running differential equations. As a group, we use Julia for all of these tasks as well as running the BioEnergetic Food Web model. 

Enjoy!

# Project environment had been set on the 15th of September: 

```julia
file_to_rm = ["Project.toml", "Manifest.toml"]
if any(isfile.(file_to_rm))
  rm.(file_to_rm, force = true)
end

import Pkg
Pkg.activate(".")

] dev /home/alain/Documents/post-these/sheffield/BEFWM2/
#Pkg.add(url="git@github.com:BecksLab/BEFWM2.git", rev="develop")
Pkg.add(["Revise", "Plots", "DataFrames", "Distributions", "Random", "DelimitedFiles", "RDatasets", "Gadfly", "CSV"])
```

