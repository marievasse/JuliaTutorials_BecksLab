### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ c8526f12-8eac-468a-b71c-a4cf743fa782
import Pkg

# ╔═╡ 7f18594b-a47b-4fd8-8eb1-2eea25df1e42
Pkg.activate(".")

# ╔═╡ 1ab3bd81-3b00-4bce-a5e6-9f1830479ac4
using BEFWM2 

# ╔═╡ 06a9a46a-911c-4b63-b7f4-75de242ac241
using Plots, Statistics, DataFrames

# ╔═╡ 65119214-b077-4d7c-b6fe-b0b6f4c59157
using LaTeXStrings #this pkg allows latex strings in plots :)

# ╔═╡ 9825ebcc-42a0-4dde-ae1e-5b7ed33f711c
md"""
# Enrichment in the BEFW model
*Eva Delmas, Chris Griffiths and  Andrew Beckerman*  

Nov. 2021
""" 

# ╔═╡ 593f7844-3090-42f2-94b8-944c841011e3
md"""
This notebook builds on the previous notebooks, especially documents 5 and 6 (using the BEFW model and including temperature effects in the BEFW model). Here we describe how to simulate enrichment in the bio-energetic food-web model. 
"""

# ╔═╡ c8c97734-ef46-4da0-ac56-821c67d3fc1b
md"**Set the environment:**"

# ╔═╡ 6869cbda-7caf-407a-932a-bc47c7084d2b
import Random.seed!

# ╔═╡ d4d2bbd6-c0b4-49fe-a2a1-2529b9b1ccaf
md"""
## Nutrient enrichment: the theory 

Enrichment can have surprising effects on population and community dynamics, as it can both increase the amount of potentially otherwise limiting resources (e.g. nitrogen), favor certain species over other based on their competitive abilities and ultimately destabilize ecosystem dynamics and can lead to non-random loss of species (it's the "paradox of enrichment"). It can also influence the structure of the food webs, leading for example to higher levels of primary production, allowing to support longer food chains. Intensive farming, fertilization and the consequent runoffs are expected to increase in the following decades and understanding the influence of enrichment on ecosystems structure and dynamics is a pressing issue. 

In `BioEnergeticFoodWebs.jl`, nutrient enrichment can be simulated mainly in two different ways: 
- by using the nutrient intake model as a basis for calculating producer net growth rate, and increasing nutrient supply
- by simply changing the system carrying capacity (which can be species specific or not). 

Here we will only describe the latter, as we have not introduced the nutrient intake model yet. 

Producer growth in the context of the BEFWM is defined as a function of: 
- their intrinsic growth rate $r_i$
- a net growth function $G$
- species biomass $B_i$. 

Species net growth rates $G$ can take different forms. In the BEFWM context, it usually describe a logistic growth: 

$G_i = 1 - \frac {\sum_{j = competitors} B_j} {K_i}$

where $K_i$ is the carrying capacity ($K$ if the carrying capacity is defined for the whole system or $K_i$ if it is species specific). 

So in other words, logistic growth here is a function of the sum of the biomasses of all the species the focus producer compete with, divided by the carrying capacity. If $K$ is system specific, all producer compete with the same ability for the global $K$, and if $K_i$ is species specific, then $\sum_{j = competitors} B_j = B_i$ because $i$ only compete with itself for $K_i$. 

*Note*: when setting a system-specific carrying capacity, you can play with species relative competitive abilities by providing the argument $\alpha$ that describes the strength of intra-specific competition relatively to inter-specific competition. If $\alpha < 1$ then intra-specific competition is weaker than inter-specific competition, it's equal if $\alpha = 1$ and stronger if $\alpha > 1$.  

"""

# ╔═╡ 96cdae8c-bca0-4410-bec4-6a1c8d0e67a1
md"""
## Simulating enrichment in `BioEnergeticFoodWebs`

To simulate enrichment, simply change the argument `K` in `ModelParameters()`. Don't forget to change the `productivity` argument to control whether you want a system or species specific carrying capacity. 

*Note*: In the following example, we are setting `h = 2.0` to use the type III functional response and avoid the collapse of the system that happens otherwise.
"""

# ╔═╡ 5c0c8df7-640d-44a6-9a22-992497ce98bf
md"**Changing `K`:**"

# ╔═╡ 008c1fc9-f108-47d2-882f-a19ea1c8b043
A = FoodWeb([0 0 ; 0 0]) #just 2 producers, without any consumer 

# ╔═╡ 3bc23436-ae76-4265-962a-4a06100e0b48
Binit = ones(length(A.species)) #starting biomasses = 1

# ╔═╡ 2d073c66-2663-4393-ab7a-ece02a49212a
p_sys = ModelParameters(A, environment = Environment(A, K = 10.0), functional_response = BioenergeticResponse(A, h = 2.0)) #system specific K = 10

# ╔═╡ 9f79bc19-cc1a-4f46-bb28-8fd9558f2d46
s_sys = simulate(p_sys, Binit, tmax = 500);

# ╔═╡ 84cb9b55-2ed8-4757-8e90-ecd4fd15a6fd
p_sp = ModelParameters(A, environment = Environment(A, K = [10.0, 5.0]), functional_response = BioenergeticResponse(A, h = 2.0)) #species specific K_i = 5 (same for the two producers)

# ╔═╡ e507fcd1-d238-41db-b236-406832bc1c63
s_sp = simulate(p_sp, Binit, stop = 500)

# ╔═╡ ce18e6c0-612a-490e-a987-469bd01f1bf1
md"In the first case (left) the 2 producer share a common K ($K = 10$) so each reaches a biomass of 5 in the absence of consumption (K divided by the number of producers). In the second case (right) the 2 producer each have a specific carrying capacity of 10 and 5 respectively, so they don't have to share and both can reach a biomass of $K_i$ in the absence of consumption. This introduces a hierarchy of competition between producers: it's similar to having a common carrying capacity of 15 not evenly shared (e.g. because of different competitive abilities or access to the shared resource)."

# ╔═╡ f28e1a97-ee4e-4ad6-8fd0-b683135583ad
begin
	p1 = plot(s_sys, legend = :outerright, title = L"K = 10", ylims = (0,10.1), labels = ["p1" "p2"], ylabel = "Species biomass", xlabel = "Time")
	p2 = plot(s_sp, legend = :outerright, title = L"K_i = [10, 5]", ylims = (0,10.1), labels = ["p1" "p2"], ylabel = "Species biomass", xlabel = "Time")
	plt = plot(p1, p2, layout = grid(1,2), size = (750, 350))
end

# ╔═╡ c88d1dcd-e1d5-4389-b527-350568879059
md"**Enrichment:**"

# ╔═╡ 38a8460a-15f8-4d42-add8-a2d51cb92971
md"In this example, we will analyze how a food web of 10 species reacts to increasing carring capacities (we use a weak type III functional response in an attempt to stabilize dynamics and make the results easier to interpret)."

# ╔═╡ 6d73604d-47a7-4b81-81f5-83c1e71b54c2
seed!(123)

# ╔═╡ 088a6a4a-17e6-49c7-9bf3-d9745ad89f5b
K_range = [1.0:1:40.0;] #range for carrying capacity

# ╔═╡ f0e36660-d383-435c-9bc5-c19cd454c633
Aniche = FoodWeb(nichemodel, 10, C = 0.15)

# ╔═╡ e6932bc1-7c53-4eef-b4ef-f9909129b6af
Binit_niche = rand(length(Aniche.species)) #starting biomasses

# ╔═╡ 78ee2505-6d4a-4edd-a5fb-e399cd42f1b8
out_niche = [] #create an empty array to store the results

# ╔═╡ 61817f68-b2bd-49bf-9420-e7c5b5fa2309
for k in K_range
    println(k)
    pniche = ModelParameters(Aniche,
                             environment = Environment(Aniche, K = k),
                             functional_response = BioenergeticResponse(Aniche, h = 2) #, h = 1.2
                            )
    simniche = simulate(pniche, Binit_niche, tmax = 500, verbose = false)
    out = (B = total_biomass(simniche, last = 100)
           , P = species_persistence(simniche, last = 100)
           , G = sum(producer_growth(simniche, last = 100, out_type = :mean).G)
           , K = k)
    push!(out_niche, out)
end

# ╔═╡ 40013ad6-459d-40dc-89d8-5fe6a7759e7f
df_niche = DataFrame(out_niche)

# ╔═╡ 2e57c123-0807-4196-b48c-e00500257a71
begin
    pltB = scatter(df_niche.K, df_niche.B, title = "Total Biomass", xlab = L"K", c = :grey, legend = false, titlefontsize = 8, msw = 0, ms = 3)
    pltG = scatter(df_niche.K, df_niche.G, title = "Total Net Growth G\n(mean over last 100 steps)", xlab = L"K", c = :grey, legend = false, titlefontsize = 8, msw = 0, ms = 3)
    pltP = scatter(df_niche.K, df_niche.P, title = "Persistence", xlab = L"K", c = :grey, legend = false, ylims = (0,1), titlefontsize = 8, msw = 0, ms = 3)

    Plots.plot(pltB, pltG, pltP)
end

# ╔═╡ cff69aff-8456-436b-90ba-d2652a037f18
md"## Mass and temperature dependence of K"

# ╔═╡ 9a8bdeaa-13d3-48d1-8e5f-3ebf27907ad5
md"""
The ability of different species to capture and use the shared resources can be dependent on many factors. Among such factors, size and temperature can play an important role. To simulate this joint effect, we can use the same type of allometric Boltzmann equations that we used for species biological rates to estimate producers specific carrying capacities: 

$K_i(M,T) = exp(k_0) * M_i^{\beta} * exp(E_k) * \frac{T_0 - T}{kT_0T})$

Where 
- species $i$'s carrying capacity $K_i$ is expressed in $[g.m^{-2}]$,
- the intercept of the relationship $exp(k_0)$ is dimensionless,
- species $i$'s mass $M_i$ is in $[g]$, 
- the activation energy of the relationship $E_k$ is in $[eV]$, 
- the Boltzmann constant $k$ is converted to $[eV.K^{-1}]$ 
- and the reference temperature $T_0$ and the system's temperature $T$ are expressed in $[K]$.
""" 

# ╔═╡ 6086ddcd-ffe9-4fd6-afd4-ccc3e7a8d1b8
md"We can translate that to the function below, which takes parameter values from [Binzer et al. (2015)](https://onlinelibrary.wiley.com/doi/abs/10.1111/gcb.13086)."

# ╔═╡ 1b8ce091-3b75-4f74-8970-0984d196dde8
function carrying(m, k0, T)
    βk = 0.28
    Ek = 0.71 
	T0 = 293.15 #20C in K
	k = 8.617e-5
    return k0 .* (m .^ βk) .* exp.(Ek .* (T0 .- T) ./ (k .* T .* T0))
end

# ╔═╡ bb164905-6da1-46d1-b3c6-f755ebf3d0dd
md"""
This makes it possible to analyze the joint effect of temperature and enrichment on a system (see example below). Note that to simulate enrichment, we only need to manipulate $k_0$.   
"""


# ╔═╡ Cell order:
# ╟─9825ebcc-42a0-4dde-ae1e-5b7ed33f711c
# ╟─593f7844-3090-42f2-94b8-944c841011e3
# ╟─c8c97734-ef46-4da0-ac56-821c67d3fc1b
# ╠═c8526f12-8eac-468a-b71c-a4cf743fa782
# ╠═7f18594b-a47b-4fd8-8eb1-2eea25df1e42
# ╠═1ab3bd81-3b00-4bce-a5e6-9f1830479ac4
# ╠═06a9a46a-911c-4b63-b7f4-75de242ac241
# ╠═65119214-b077-4d7c-b6fe-b0b6f4c59157
# ╠═6869cbda-7caf-407a-932a-bc47c7084d2b
# ╟─d4d2bbd6-c0b4-49fe-a2a1-2529b9b1ccaf
# ╟─96cdae8c-bca0-4410-bec4-6a1c8d0e67a1
# ╟─5c0c8df7-640d-44a6-9a22-992497ce98bf
# ╠═008c1fc9-f108-47d2-882f-a19ea1c8b043
# ╠═3bc23436-ae76-4265-962a-4a06100e0b48
# ╠═2d073c66-2663-4393-ab7a-ece02a49212a
# ╠═9f79bc19-cc1a-4f46-bb28-8fd9558f2d46
# ╠═84cb9b55-2ed8-4757-8e90-ecd4fd15a6fd
# ╠═e507fcd1-d238-41db-b236-406832bc1c63
# ╟─ce18e6c0-612a-490e-a987-469bd01f1bf1
# ╠═f28e1a97-ee4e-4ad6-8fd0-b683135583ad
# ╟─c88d1dcd-e1d5-4389-b527-350568879059
# ╟─38a8460a-15f8-4d42-add8-a2d51cb92971
# ╠═6d73604d-47a7-4b81-81f5-83c1e71b54c2
# ╠═088a6a4a-17e6-49c7-9bf3-d9745ad89f5b
# ╠═f0e36660-d383-435c-9bc5-c19cd454c633
# ╠═e6932bc1-7c53-4eef-b4ef-f9909129b6af
# ╠═78ee2505-6d4a-4edd-a5fb-e399cd42f1b8
# ╠═61817f68-b2bd-49bf-9420-e7c5b5fa2309
# ╠═40013ad6-459d-40dc-89d8-5fe6a7759e7f
# ╠═2e57c123-0807-4196-b48c-e00500257a71
# ╟─cff69aff-8456-436b-90ba-d2652a037f18
# ╟─9a8bdeaa-13d3-48d1-8e5f-3ebf27907ad5
# ╟─6086ddcd-ffe9-4fd6-afd4-ccc3e7a8d1b8
# ╠═1b8ce091-3b75-4f74-8970-0984d196dde8
# ╟─bb164905-6da1-46d1-b3c6-f755ebf3d0dd
