### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ 3bf40bbf-539c-45f5-956c-b9650b08c1d5
using Unitful, Statistics

# ╔═╡ 22f27dce-3ed6-41df-92e1-712eb08d5c88
using DataFrames, DataFramesMeta

# ╔═╡ e303bf14-1aa4-4d4f-884a-cd4f43f82186
begin
	using CommonMark, 
		LaTeXStrings, 
		PlutoUI, 
		HypertextLiteral,
		Lazy,
		MarkdownLiteral,
		Hyperscript
		
	import MarkdownLiteral: @markdown

	md"Load Julia \"infrastructure\" pkgs"
end

# ╔═╡ 4d965bb6-567e-4f05-8cb0-ef49349c5f12
cm"""

Given
-----

A piston–cylinder device contains 0.85 kg of refrigerant- 134a at –10°C. The piston that is free to move has a mass of 12 kg and a diameter of 25 cm. The local atmospheric pressure is 88 kPa. Now, heat is transferred to refrigerant-134a until the temperature is 15°C. 
"""

# ╔═╡ 9804b746-3ad2-4b9e-af82-d3adec5eeda3
cm"""

{style="width:35%; margin-inline:auto;"}
![head](https://imgur.com/cXHhjIw.png)

"""


# ╔═╡ 34570e7a-60ad-4851-ac9a-356e866c0146
cm"""

Find
----

1. the final pressure, 
1. the change in the volume of the cylinder, and
1. the change in the enthalpy of the refrigerant-134a.
"""

# ╔═╡ a4b02708-524c-40af-8d94-ab3272c3b81d
cm"""

Get organized
-------------

These things you must notice right away:

{style="list-style-type: lower-greek;"}
1. Volume change ``\Rightarrow`` _boundary work_{.killerorange}.  No other forms of work 
1. "... _piston that is free to move..._" ``\Rightarrow`` _frictionless piston_{.killerorange}
1. No variable forces on piston + frictionless piston ``\Rightarrow`` _isobaric process_{.killerorange}
1. Properties/characteristics away from the norm
	1. Fluid is R-134a, not water.
	1. Atmospheric pressure = 88 kPa

This is a classic before/after scenario. The information we're tasked to find describes what happened to the system in its move from one state to another. All we need to do is resolve both states, then calculate the property changes requested.



"""

# ╔═╡ de2ef376-c065-4244-b455-d91ff78ffcd8
cm"""
We're not overtly given enough information to resolve either state, but we are given what we need to calculate ``P_1``. Moreover, we know that our states are connected by an isobaric process. 

Moreover, we are given enough information Let's help ourselves by clearly expressing our states with respect to the properties we know and the properties we need:

```math
\left.
\begin{aligned}
T_1 &= \pu{-10 °C}  \\
P_1 &= ?
\end{aligned}
\right\} \ce{①->[\quad isobaric \quad]②} 
\left\{
\begin{aligned}
T_2 &= \pu{15 °C}  \\
P_2 &= P_1
\end{aligned}
\right.
```

Checking inventory, we need
1. ``P_1`` : calculate it
1. ``\Delta V = m (v_2 - v_1)`` : ``v`` in tables
1. ``\Delta H = m (h_2 - h_1)`` : ``h`` in tables

"""

# ╔═╡ e01ff0d4-103b-4ca6-aa3f-7bce7a690083
begin
  # given
	m_R134a  = 0.85u"kg"
	m_piston = 12u"kg"
	P_atm    = 88u"kPa"
	D_piston = 25u"cm"

  # calc
	A_piston = π/4 * D_piston^2	
end;

# ╔═╡ 794342fc-96f6-49fa-bfa3-3c3229c49e74
P1 = P_atm + m_piston * 1u"ge" / A_piston |> u"kPa"

# ╔═╡ cd80963f-bdab-406f-bb5c-7fc3b4e849df
cm"""

Now that we have the pressure, we can go to the property tables to resolve our states.

![head](https://imgur.com/VoARkJf.png)
![body](https://imgur.com/KV702G7.png)

As usual, we head to the saturation tables to find our state. There's no break point at our temperature, but we don't need it. Our pressure is lower than the saturation pressures of the temperatures bracketing our temperature; we can safely say that our pressure would be lower than the saturation pressure belonging to our temperature. That tells us to head to the Superheated Vapor tables.

"""


# ╔═╡ 11e873c6-f27c-4251-a9df-a09e59a9267c
cm"""
![body](https://imgur.com/gfy1P9I.png)

In the superheated vapor tables we find the neighborhood in which out states exist, but only one of four properties lands on a breakpoint. We need to interpolate in two directions, affectionately known as _bilinear interpolation._

In bilinear interpolation, we interpolate in one direction, then interpolate that result in the other direction. There are techniques for interpolating both directions simultaneously, but they're rarely needed in undergraduate thermodynamics. 
"""

# ╔═╡ b1d33668-3ed0-4ee0-b14a-78d501929cbc
cm"""

Attack
------

We will interpolate pressure first, mainly because of personal preference. We are essentially creating a subtable at our pressure. Then we interpolate the new subtable for temperature. Liberal subscripting makes this manageable. Julia helps with generous latitude in naming variables.

The only thing that goes wrong is losing track of which terms go into what positions in the equations. Unfortunately, it is painfully easy to lose track of the terms.

I **strongly**{.killerorange} recommend you lay everything out algebraically first, don't combine any steps, and use a spreadsheet, dataframes (lean and mean database), or other computational tools to do the actual arithmetic. 

I used subscripting for readability. My tool of choice would be a dataframe. At the end of this problem, I'll show a dataframe inplementation.
"""

# ╔═╡ f81bb289-fd95-442f-8b86-dd59a9df685c
# from R-134a superheated vapor table

begin
	v_60kPa_⁻10°C  = 0.34992u"m^3/kg"
	v_60kPa_10°C   = 0.37861u"m^3/kg"
	v_60kPa_20°C   = 0.39279u"m^3/kg"
	
	v_100kPa_⁻10°C = 0.20686u"m^3/kg"
	v_100kPa_10°C  = 0.22473u"m^3/kg"
	v_100kPa_20°C  = 0.23349u"m^3/kg"
	
	h_60kPa_⁻10°C  = 245.96u"kJ/kg"
	h_60kPa_10°C   = 262.41u"kJ/kg"
	h_60kPa_20°C   = 270.89u"kJ/kg"
	
	h_100kPa_⁻10°C = 244.70u"kJ/kg"
	h_100kPa_10°C  = 261.43u"kJ/kg"
	h_100kPa_20°C  = 270.02u"kJ/kg"
end;

# ╔═╡ 751e9afd-6938-45cd-bd99-2a8aae5f1075


# ╔═╡ a510380b-8791-4339-857f-136e89eaa931
# interpolate across P for all states
# P1 = P2, but labelling them separately helps readability

begin
	𝑓p = (P1 - 60u"kPa")/(100u"kPa" - 60u"kPa")
	
	v_P1_⁻10°C = v_60kPa_⁻10°C + 𝑓p*(v_100kPa_⁻10°C - v_60kPa_⁻10°C) 
	h_P1_⁻10°C = h_60kPa_⁻10°C + 𝑓p*(h_100kPa_⁻10°C - h_60kPa_⁻10°C)

	v_P2_10°C  = v_60kPa_10°C  + 𝑓p*(v_100kPa_10°C  - v_60kPa_10°C) 
	v_P2_20°C  = v_60kPa_20°C  + 𝑓p*(v_100kPa_20°C  - v_60kPa_20°C) 
	
	h_P2_10°C  = h_60kPa_10°C  + 𝑓p*(h_100kPa_10°C  - h_60kPa_10°C) 
	h_P2_20°C  = h_60kPa_20°C  + 𝑓p*(h_100kPa_20°C  - h_60kPa_20°C) 
end;

# ╔═╡ c11e59c2-0c7d-4bde-9d02-c2ae9a2cc80e
# interpolate across T for State 2

begin
	v_P2_15°C  = [v_P2_10°C, v_P2_20°C] |> mean
	h_P2_15°C  = [h_P2_10°C, h_P2_20°C] |> mean
end;

# ╔═╡ b8fd73e6-1408-41d4-9ca2-0406d3a4dc1d
# final property calculations

begin
	v1 = v_P1_⁻10°C
	v2 = v_P2_15°C

	h1 = h_P1_⁻10°C
	h2 = h_P2_15°C
end;

# ╔═╡ 6a60a492-812b-4273-94d9-e9cc744b148c
ΔH = m_R134a * (h2 - h1)

# ╔═╡ dbcdc200-3044-4376-bf0a-4adc103f4681
ΔV = m_R134a * (v2 - v1)

# ╔═╡ 32c816f3-ed9d-485a-8d78-b6f8c2735bf9
cm"""
----

{.message .success}
> _finis_{.success}
"""

# ╔═╡ 04496cd3-ed1a-4a77-bd6b-b3e80780fe16
begin

	P_  = round(P1 |> typeof, P1, digits = 5)
	ΔV_ = round(ΔV |> typeof, ΔV, digits = 5)
	ΔH_ = round(ΔH |> typeof, ΔH, digits = 5)


	L"""
	\begin{align} 
		P &= \pu{%$P_} \\
		\Delta V &= \pu{%$ΔV_} \\
		\Delta H &= \pu{%$ΔH_}
	\end{align}
	"""
end

# ╔═╡ c53969f6-5ec7-4448-bdf7-28b7819b6d33
cm"----
**Show/tell:**{.killerorange} Dataframes
"

# ╔═╡ 39d64047-5eba-42a1-a78c-dfc1fb4200a4
R134a = DataFrame(
	P = [     60,      60,      60,     100,     100,     100]u"kPa"    ,
	T = [ 	 -10,      10,      20,     -10,      10,      20]u"°C"     ,
	v = [0.34992, 0.37861, 0.39279, 0.20686, 0.22473, 0.23349]u"m^3/kg" ,
	h = [ 245.96,  262.41,  270.89,  244.70,  261.43,  270.02]u"kJ/kg"
)

# ╔═╡ 92ac28e6-43a6-4e4a-9e52-a065bbb31cde
@subset(R134a, :P .== 60u"kPa")

# ╔═╡ 552fb87a-b1e0-4b74-8be6-25dcb40a1294
@subset(R134a, :P .== 60u"kPa").h

# ╔═╡ 7db6ecdb-c6d3-49ae-85e6-569271c23285
@subset(R134a, :P .== 60u"kPa", :T .== 20u"°C")

# ╔═╡ aadbbc39-6702-4ea2-9167-c35efade6740
@subset(R134a, :P .== 60u"kPa", :T .== 20u"°C").v

# ╔═╡ d9120f9a-d084-471b-8bf7-250674f63b0a
cm"## Appendix"

# ╔═╡ 5dc45506-e5c8-4992-902b-5f8d93f31dcd
macro title_str(title::String, bookID::String="") 

	cm_parser = CommonMark.Parser()
	enable!(cm_parser, AttributeRule)

	bookID == "" && return title |> cm_parser
	
	bib = Dict(
		"ms6" 	=> 	"""
					Moran, MJ & HN Shapiro (2008) 
					Fundamentals of engineering thermodynamics 6e, 
					978-0471787358
					""",
		"ms8" 	=> 	"""
					Moran, MJ Ed (2014) 
					Fundamentals of engineering thermodynamics 8e, 
					978-1118412930
					""",
		"ms9" 	=> 	"""
					Moran, MJ, _et al_ (2018) 
					Fundamentals of engineering thermodynamics 9e, 
					978-1119391388
					""",
		"cb7" 	=> 	"""
					Çengel, YA & MA Boles (2011) 
					Thermodynamics: An engineering approach 7e, 
					978-0073529325
					""",
		"cb8" 	=> 	"""
					Çengel, YA & MA Boles (2015) 
					Thermodynamics: An engineering approach 8e, 
					978-0073398174
					""",
		"cb9" 	=> 	"""
					Çengel, YA, Boles, MA, & M Kanoglu (2019) 
					Thermodynamics: An engineering approach 9e, 
					978-1259822674
					""",
	)

	haskey(bib, bookID) || return KeyError(bookID) 

	the_bibliography = 
		@as xx bib[bookID] begin
			split(xx, '\n', keepempty=false)
			strip.(xx)
			join(xx, " _", "_ ")
		end

	# return the_bibliography

	return @markdown("""
			<div id="title" class="mcs title">
		 
			   # $title
		  
			   {.source}
			   $the_bibliography
		   
			</div>
			""")


end


# ╔═╡ 806d1314-9909-11ec-05f5-c194fa8b2722
title"Problem 3.30"cb9

# ╔═╡ c2a438b9-8be7-42f7-9871-293f8fd19790
begin
	mcs_css_url = "https://gitlab.com/marcucius/mcsBibliotheca/-/raw/main/styles/mcs-pluto.css" 
	
	mcs_css = open(download(mcs_css_url)) do io
	    read(io, String)
	end

	@htl """
	<p>Load stylesheets</p>
	
	<style>$mcs_css</style>
	<style>
		#finis {color: #008800;}
		@media (prefers-color-scheme: dark) {
			img {
				filter: invert(1) hue-rotate(180deg);
			}
		}
	</style>
	
	""" 

end


# ╔═╡ 592a917a-7b3b-4ae8-85dd-14726efdc373
# TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CommonMark = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
DataFramesMeta = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
Hyperscript = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Lazy = "50d2b5c4-7a5e-59d5-8109-a42b560f39c0"
MarkdownLiteral = "736d6165-7244-6769-4267-6b50796e6954"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[compat]
CommonMark = "~0.8.6"
DataFrames = "~1.3.2"
DataFramesMeta = "~0.10.0"
Hyperscript = "~0.0.4"
HypertextLiteral = "~0.9.3"
LaTeXStrings = "~1.3.0"
Lazy = "~0.15.1"
MarkdownLiteral = "~0.1.1"
PlutoUI = "~0.7.35"
Unitful = "~1.11.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Chain]]
git-tree-sha1 = "339237319ef4712e6e5df7758d0bccddf5c237d9"
uuid = "8be319e6-bccf-4806-a6f7-6fae938471bc"
version = "0.4.10"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.CommonMark]]
deps = ["Crayons", "JSON", "URIs"]
git-tree-sha1 = "4cd7063c9bdebdbd55ede1af70f3c2f48fab4215"
uuid = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
version = "0.8.6"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "44c37b4636bc54afac5c574d2d02b625349d6582"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.41.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "ae02104e835f219b8930c7664b8012c93475c340"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.2"

[[deps.DataFramesMeta]]
deps = ["Chain", "DataFrames", "MacroTools", "OrderedCollections", "Reexport"]
git-tree-sha1 = "ab4768d2cc6ab000cd0cec78e8e1ea6b03c7c3e2"
uuid = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
version = "0.10.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Lazy]]
deps = ["MacroTools"]
git-tree-sha1 = "1370f8202dac30758f3c345f9909b97f53d87d3f"
uuid = "50d2b5c4-7a5e-59d5-8109-a42b560f39c0"
version = "0.15.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MarkdownLiteral]]
deps = ["CommonMark", "HypertextLiteral"]
git-tree-sha1 = "0d3fa2dd374934b62ee16a4721fe68c418b92899"
uuid = "736d6165-7244-6769-4267-6b50796e6954"
version = "0.1.1"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "13468f237353112a01b2d6b32f3d0f80219944aa"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "85bf3e4bd279e405f91489ce518dedb1e32119cb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.35"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "db3a23166af8aebf4db5ef87ac5b00d36eb771e2"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.0"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "dfb54c4e414caa595a1f2ed759b160f5a3ddcba5"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "bb1064c9a84c52e277f1096cf41434b675cd368b"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "b649200e887a487468b71821e2644382699f1b0f"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─806d1314-9909-11ec-05f5-c194fa8b2722
# ╟─4d965bb6-567e-4f05-8cb0-ef49349c5f12
# ╠═9804b746-3ad2-4b9e-af82-d3adec5eeda3
# ╟─34570e7a-60ad-4851-ac9a-356e866c0146
# ╟─a4b02708-524c-40af-8d94-ab3272c3b81d
# ╟─de2ef376-c065-4244-b455-d91ff78ffcd8
# ╠═3bf40bbf-539c-45f5-956c-b9650b08c1d5
# ╠═e01ff0d4-103b-4ca6-aa3f-7bce7a690083
# ╠═794342fc-96f6-49fa-bfa3-3c3229c49e74
# ╟─cd80963f-bdab-406f-bb5c-7fc3b4e849df
# ╟─11e873c6-f27c-4251-a9df-a09e59a9267c
# ╟─b1d33668-3ed0-4ee0-b14a-78d501929cbc
# ╠═f81bb289-fd95-442f-8b86-dd59a9df685c
# ╠═751e9afd-6938-45cd-bd99-2a8aae5f1075
# ╠═a510380b-8791-4339-857f-136e89eaa931
# ╠═c11e59c2-0c7d-4bde-9d02-c2ae9a2cc80e
# ╠═b8fd73e6-1408-41d4-9ca2-0406d3a4dc1d
# ╠═6a60a492-812b-4273-94d9-e9cc744b148c
# ╠═dbcdc200-3044-4376-bf0a-4adc103f4681
# ╟─32c816f3-ed9d-485a-8d78-b6f8c2735bf9
# ╟─04496cd3-ed1a-4a77-bd6b-b3e80780fe16
# ╟─c53969f6-5ec7-4448-bdf7-28b7819b6d33
# ╠═22f27dce-3ed6-41df-92e1-712eb08d5c88
# ╠═39d64047-5eba-42a1-a78c-dfc1fb4200a4
# ╠═92ac28e6-43a6-4e4a-9e52-a065bbb31cde
# ╠═552fb87a-b1e0-4b74-8be6-25dcb40a1294
# ╠═7db6ecdb-c6d3-49ae-85e6-569271c23285
# ╠═aadbbc39-6702-4ea2-9167-c35efade6740
# ╟─d9120f9a-d084-471b-8bf7-250674f63b0a
# ╟─e303bf14-1aa4-4d4f-884a-cd4f43f82186
# ╟─5dc45506-e5c8-4992-902b-5f8d93f31dcd
# ╟─c2a438b9-8be7-42f7-9871-293f8fd19790
# ╠═592a917a-7b3b-4ae8-85dd-14726efdc373
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
