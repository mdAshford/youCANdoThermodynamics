### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ 6cd99333-2b6f-470b-b140-07e4b2693e3e
using Unitful

# ╔═╡ 2ac4937e-7cab-48e3-9c76-8f860d2a2bd1
begin
	using CommonMark, 
		LaTeXStrings, 
		Lazy,
		PlutoUI, 
		HypertextLiteral,
		MarkdownLiteral,
		Hyperscript,
		Random
	
	import MarkdownLiteral: @mdx


	macro css_str(stylesheet_url)
		the_css = open(download(stylesheet_url)) do io
			read(io, String)
		end
		return the_css
	end
	
	cm"Load support macros"
	
end

# ╔═╡ bde82185-3f3e-4633-849f-f1d65f063c11
cm"""
## Given

During steady-state operation, a gearbox receives 60 kW through 
the input shaft and delivers power through the
output shaft.

{style="width: 65%; display:block; margin-inline:auto;"}
![gearbox](https://gitlab.com/tupeux/faire-thermodynamique-pluton/-/raw/main/notebooks/assets/ms6.x02.004.transp.png)

{ .fig_caption }
Funky little gearbox.

<br><br>
For the gearbox as the system, the rate of energy transfer by convection is 

```math
\require{physics}
\begin{equation}
  \dot Q_{convection.out} = hA \qty( T_b - T_\infty ) 
\end{equation}
```

``\qquad`` where

```math
\begin{align}
	h &= \pu{0.171 kW/m2 \cdot K} \textsf{ is the heat transfer coefficient;} \\[3pt]
	A_{\it surface} &= \pu{1.0m2} \textsf{ is the outer surface area of the gearbox,} \\[3pt]
	T_{\it surface} &= \pu{27°C} \textsf{ is the temperature at the outer surface; and} \\[3pt]
	T_\infty &=  \pu{20°C} \textsf{ is the ambient temperature of the air.}
\end{align}
```
"""

# ╔═╡ ed521013-8bc1-485c-8574-fd2a7a9fc918
@mdx("""

## Find

For the gearbox, evaluate the heat transfer rate and the power delivered through the output shaft, each in kW.

""")

# ╔═╡ 58c14931-ff78-4a25-883e-4eb1dff0a15f
cm"""
## Get organized

These things you need to notice right away:
1. We were provided an expression for heat transfer that can be resolved completely from the information in **Given**{.Vollkorn .addblue}.
1. Steady state operation: _all time derivatives collapse to zero._{.killerorange}
2. All of the work is shaft work.
3. Multiple energy flows: check and verify you account for all of them.

Let's attack this problem with a _lazy_ approach. Lazy evaluation is a computer science concept that essentially means we will not calculate any expressions until we must. In other words, put away the calculator until one of these events calls you to action:  
 -  you're terrified by imminent great harm; or
 -  you're intoxicated by the glee of great riches.


Apply your energy balance (1st Law)

 ```math
\begin{gather}
    \dot E_{in} 
&-& \dot E_{out} 
&=& {\color{#db5728}{\cancelto{\rlap{\textsf{ 0 : steady~state}}}{\class{hailmary}{\dv t}}}} E_{sys} 

\\[6pt]

	\underbrace{\dot W_{\textit{input.shaft}}}_{\sf\large given}
&-& \underbrace{\dot W_{\textit{output.shaft}}}_{\sf\large target} - 
    \underbrace{\dot Q_{\textit{convection.out}}}_{\sf\large ready.target}
&=& 0 

\end{gather}
```

See? When you're organized, riches come quickly.

1. Remember, we can calculate ``\dot Q_{out}`` without the Energy Eqn, so we will:

   ```math
   \dot Q_{out} = hA \qty( T_b - T_\infty ); 
   ```

1. Finally, we close out the problem with a reality check, 
   our energy equation, and little arithmetic: 

   ```math
   \dot W_{\it output.shaft} = \dot W_{\it input.shaft} - \dot Q_{out} 
   ```

   Pause for reality check. Our equation for the rate of energy (_power_ ≡ _rate of energy_ : your choice) leaving the generator suggests that the rate of energy brought in by the input shaft is equal to the sum of the rates of energy leaving the generator via heat transfer and the output shaft, respectively.

   Ask yourself often: _Am I making sense?_{.killerorange}
  

"""

# ╔═╡ 78f3f73c-b4fe-4492-9fc4-f74d083458da
cm"""
## Attack

It's all up to you (and Julia) now."""

# ╔═╡ 643b1d7d-2e4f-4a5d-9737-38111c07aa3a
# given

begin
	Ẇ_input_shaft_in = 60u"kW"
	h = 0.171u"kW/(m^2*K)"
	A_surface = 1.0u"m^2" 
	T_surface = 27u"°C" 
	T∞ = 20u"°C" 
end;

# ╔═╡ becdc317-dd8f-47de-9804-70b695f3752e
Q̇_convection_out = h * A_surface * (T_surface - T∞)

# ╔═╡ ed727ea8-645f-4a9f-a3a9-dd428ad70563
Ẇ_output_shaft_out = Ẇ_input_shaft_in - Q̇_convection_out

# ╔═╡ 8348343b-ca7f-4663-9135-12c687689502
cm"## _finis_"

# ╔═╡ 3ded8340-bffe-421a-b6d1-777a4a907d88
L"""
\class{theanswer}{\begin{align}
\dot Q_{\it convection.out} &= \pu{%$Q̇_convection_out}   \\
\dot W_{\it output.shaft}   &= \pu{%$Ẇ_output_shaft_out}
\end{align}
}
""" 

# ╔═╡ 4de68ffe-265f-4823-8cd9-df7b6ad20de6
cm"<br><br><br><br><br>"

# ╔═╡ c8ab6e9f-7c34-4ec4-a799-861741b18def
cm"

----

## Appendix"

# ╔═╡ 9270fc98-4ada-4e0a-ab45-255afe01c0e2
# TableOfContents()

# ╔═╡ 075e6adf-f818-47fa-aac1-60666df2f7d5
begin
	
	macro title_str(title::String, bookID::String="") 
		cm_parser = CommonMark.Parser()
		enable!(cm_parser, AttributeRule)
	
		bookID == "" && return title |> cm_parser
		
		bib = Dict(
			"ms6" 	=> 	"""
						Moran, MJ & HN Shapiro (2008) 
						Fundamentals of engineering thermodynamics 6e, 
						978-0471787358
						https://gitlab.com/Good-Trouble/youCAN/doThermodynamics/-/raw/main/images/ms6cover.jpg
						""",
			"ms8" 	=> 	"""
						Moran, MJ Ed (2014) 
						Fundamentals of engineering thermodynamics 8e, 
						978-1118412930
						https://gitlab.com/Good-Trouble/youCAN/doThermodynamics/-/raw/main/images/ms8cover.jpg
						""",
			"ms9" 	=> 	"""
						Moran, MJ, _et al_ (2018) 
						Fundamentals of engineering thermodynamics 9e, 
						978-1119391388
						https://gitlab.com/Good-Trouble/youCAN/doThermodynamics/-/raw/main/images/ms9cover47x60.png
						""",
			"cb7" 	=> 	"""
						Çengel, YA & MA Boles (2011) 
						Thermodynamics: An engineering approach 7e, 
						978-0073529325
						https://gitlab.com/Good-Trouble/youCAN/doThermodynamics/-/raw/main/images/cb7cover.jpg
						""",
			"cb8" 	=> 	"""
						Çengel, YA & MA Boles (2015) 
						Thermodynamics: An engineering approach 8e, 
						978-0073398174
						https://gitlab.com/Good-Trouble/youCAN/doThermodynamics/-/raw/main/images/cb8cover.jpg
						""",
			"cb9" 	=> 	"""
						Çengel, YA, Boles, MA, & M Kanoglu (2019) 
						Thermodynamics: An engineering approach 9e, 
						978-1259822674
						https://gitlab.com/Good-Trouble/youCAN/doThermodynamics/-/raw/main/images/cb9cover48x60.jpg
						""",
		)
	
		haskey(bib, bookID) || return KeyError(bookID) 
	
		the_bibliography, the_thumb = 
			@as bb bib[bookID] begin
				split(bb, '\n', keepempty=false)
				strip.(bb)
				(
					join(bb[1:3], " _", "_ "),
					m("img", class="no-dark-invert", src=bb[4], title=join(bb[2:3]," "))
	
				)
			end
		
		out = @mdx("""
			<div class="mcs title-bloc">
			<div id="title" class="mcs title">\n\n
			\n\n# $title\n\n{.source}\n$the_bibliography\n
			</div>
			$the_thumb
			</div>
			""")
	
		return out
	
	end


	  # ═══ load css ════════════════════════════════════════════*═
	

	@mdx("""
	<p>Load stylesheets</p>
	
	<style>
		$(css"https://gitlab.com/Good-Trouble/youCAN/doThermodynamics/-/raw/main/styles/mcs-pluto.css")

		$(css"https://gitlab.com/Good-Trouble/youCAN/doThermodynamics/-/raw/main/styles/mcs.title-bloc.css")


		@media (prefers-color-scheme: dark) {
			img:not([class="no-dark-invert"]) {
			filter: grayscale(40%) invert(1) hue-rotate(180deg) brightness(0.85) contrast(2) saturate(3);
			}
		}
	</style>

	
	{.appendix-item}
	Load Julia \"infrastructure\" pkgs
	""")
	
end

# ╔═╡ d5694646-e439-43ee-b2ef-29ef9741bb5a
title"Example 2.4"ms6

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CommonMark = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
Hyperscript = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Lazy = "50d2b5c4-7a5e-59d5-8109-a42b560f39c0"
MarkdownLiteral = "736d6165-7244-6769-4267-6b50796e6954"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[compat]
CommonMark = "~0.8.6"
Hyperscript = "~0.0.4"
HypertextLiteral = "~0.9.3"
LaTeXStrings = "~1.3.0"
Lazy = "~0.15.1"
MarkdownLiteral = "~0.1.1"
PlutoUI = "~0.7.37"
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

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "85b5da0fa43588c75bb1ff986493443f821c70b7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "bf0a1121af131d9974241ba53f601211e9303a9e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.37"

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

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

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
# ╟─d5694646-e439-43ee-b2ef-29ef9741bb5a
# ╠═bde82185-3f3e-4633-849f-f1d65f063c11
# ╟─ed521013-8bc1-485c-8574-fd2a7a9fc918
# ╟─58c14931-ff78-4a25-883e-4eb1dff0a15f
# ╟─78f3f73c-b4fe-4492-9fc4-f74d083458da
# ╠═6cd99333-2b6f-470b-b140-07e4b2693e3e
# ╠═643b1d7d-2e4f-4a5d-9737-38111c07aa3a
# ╠═becdc317-dd8f-47de-9804-70b695f3752e
# ╠═ed727ea8-645f-4a9f-a3a9-dd428ad70563
# ╟─8348343b-ca7f-4663-9135-12c687689502
# ╟─3ded8340-bffe-421a-b6d1-777a4a907d88
# ╟─4de68ffe-265f-4823-8cd9-df7b6ad20de6
# ╠═c8ab6e9f-7c34-4ec4-a799-861741b18def
# ╠═9270fc98-4ada-4e0a-ab45-255afe01c0e2
# ╟─2ac4937e-7cab-48e3-9c76-8f860d2a2bd1
# ╠═075e6adf-f818-47fa-aac1-60666df2f7d5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
