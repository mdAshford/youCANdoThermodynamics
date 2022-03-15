### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ b18da173-12b7-43cf-bcaa-abac32d4390c
using Unitful, CommonMark

# ╔═╡ 8ccd67d7-193e-4a5b-9274-e1386c301c5c
begin
	using Lazy
	
	import MarkdownLiteral: @mdx


	macro css_str(stylesheet_url)
		the_css = open(download(stylesheet_url)) do io
			read(io, String)
		end
		return the_css
	end
	
end

# ╔═╡ 853f2df9-e266-4f4f-91f4-2bb9e844b74c
begin
	using LaTeXStrings, 
		PlutoUI, 
		HypertextLiteral,
		MarkdownLiteral,
		Hyperscript,
		Random
		
	
	
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
		$(css"https://gitlab.com/Good-Trouble/youCAN/doThermodynamics/-/raw/main/styles/mcs.pluto.css")

		$(css"https://gitlab.com/Good-Trouble/youCAN/doThermodynamics/-/raw/main/styles/mcs.title-bloc.css")


		@media (prefers-color-scheme: dark) {
			.invertible svg,
			img:not([class="no-dark-invert"]) {
				filter: invert(1) hue-rotate(180deg) !important;
			}
			h2 {opacity: 0.75;}

		}
	
	</style>

	
	{.appendix-item}
	Load Julia \"infrastructure\" pkgs
	""")
	
end

# ╔═╡ 916c35d9-2007-4a4d-8e54-6c8a60583e7e
title"Problem 3.044"ms9

# ╔═╡ eab9d3c3-79ac-454b-8849-03e2f5ad1b44
# Given

begin

	T1 = -10u"°C"
	x1 =  0.8
	T2 =  40u"°C"
	
	V = 0.01u"m^3"
	
	Volt = 12u"V"
	I = 5u"A"
	t = 5u"minute"
	
end;

# ╔═╡ 83d5fd68-3e02-4fa0-a0a2-9a0876befa82
cm"""

## Given

As shown in **Fig. P3.44**, a closed, rigid tank fitted with a fine‐wire electric resistor is filled with Refrigerant 22, initially at $T1, a quality of $(Int(x1*100))%, and a volume of $V. A $Volt battery provides a current of $I  to the resistor for $(t)s. The final temperature of the refrigerant is $T2. 

{.w-80 .center title="Textbook 'Figure P3.44' " }
$(Resource("https://imgur.com/if7XPCk.png"))	

{.fig_caption }
"Figure P3.44" from the textbook.

"""

# ╔═╡ 3bd8532c-a167-4400-9e98-7e407032a834
cm"""


```math
\begin{gather}
  E_{in} &-& E_{out} &=& \Delta E_{sys} \\[6pt]

  W_{elec,in} &-& Q_{out} &=& U_2 - U_1 \\[6pt]

  (VI)t  &-& Q_{out} &=& m\left( u_2 - u_1 \right) \\[6pt] {}

\end{gather}

```
  

```math
\begin{equation}
   Q_{out} = (VI)t  + m\left( u_1 - u_2 \right) \\


\end{equation}

```
  


"""

# ╔═╡ 2a1d3c88-4381-4690-93c9-e300adaddbdb
cm"""

Take inventory. _Note that ``m`` was replaced with ``\displaystyle\frac{V}{v}`` and the properties we need are marked red._

```math
\begin{gather}
   Q_{out} = (VI)t  + \frac{V}{\color{red}v}\left(\color{red} u_1 - u_2 \right) \\[6pt]{}\\
\end{gather}

```
  
**State ①**. Get ``v, u`` at ``T = \pu{-10 °C}, x = 0.8`` 


"""

# ╔═╡ 5aa61edf-aada-4303-9598-b18b1df63521
begin
 
  vf_⁻10°C = 0.7606e-3u"m^3/kg"  # A-7
  vg_⁻10°C = 0.0652u"m^3/kg"     # A-7
	
# If you prefer, recall 1 L = 0.001 m³ 
  vf_⁻10°C = 0.7606u"L/kg" 
	
  uf_⁻10°C = 33.27u"kJ/kg"       # A-7
  ug_⁻10°C = 223.02u"kJ/kg"      # A-7

end;

# ╔═╡ 30b360c2-bde1-4f1d-81bd-cf9a4abbaac1


# ╔═╡ fcc88e47-f88e-4151-8ee7-4ba328dbd5e1
v = vf_⁻10°C + x1 * (vg_⁻10°C - vf_⁻10°C)

# ╔═╡ b72069ef-76b2-44b9-9439-6251f8cb3d51


# ╔═╡ 414b5a13-6dc1-4bce-a8b4-85a48ba647cd
u1 = uf_⁻10°C + x1 * (ug_⁻10°C - uf_⁻10°C)

# ╔═╡ 1636d935-0673-4a66-84a1-651542bb420d


# ╔═╡ a20e9fd2-9540-4f15-bfa3-f32c61dd37ba
cm"""

**State ②**. Get ``u`` at ``T = \pu{-10 °C}, v =`` $(round(v |> typeof, v, digits=4) |> ustrip) ``\rm m^3/kg``.


We find that State ② is a superheated vapor, and a quick look shows we'll have to interpolate to resolve our state: 

At 40 °C,

```math
\begin{gather}
   \quad \frac{v - v_{5bar}}{v_{5.5bar} - v_{5bar}} = 
             \frac{u_2 - u_{5bar}}{u_{5.5bar} - u_{5bar}}  \\{}
\end{gather} 
```

"""

# ╔═╡ 6f2db943-228f-4905-b3f0-97462c69e23c
# interpolate superheated vapor table

begin
	
  v_5bar_40°C   = 0.05636u"m^3/kg"  # A-9
  v_5ˌ5bar_40°C = 0.05086u"m^3/kg"  # A-9

  u_5bar_40°C   = 250.70u"kJ/kg"    # A-9
  u_5ˌ5bar_40°C = 250.20u"kJ/kg"    # A-9
	
end;

# ╔═╡ de0e0c33-4239-4050-928a-298510224c29
u2 = u_5bar_40°C + 
       (v - v_5bar_40°C) / (v_5ˌ5bar_40°C - v_5bar_40°C) * 
	   (u_5ˌ5bar_40°C - u_5bar_40°C)

# ╔═╡ 30c658f0-2736-4a87-a7de-bd539f919b37


# ╔═╡ a5bd2cc7-1fc0-4b14-9e86-fe2a0e97b15b

cm"""

Now we have everything we need to solve for the heat transfer, and close out the problem:


```math
\begin{equation}
   Q_{out} = (VI)t  + \frac{V}{v}\left( u_1 - u_2 \right) \\
\end{equation}

```

"""

# ╔═╡ 838a1526-67ef-4d89-84d1-a96af8321041
Q_out = Volt*I*t + V/v * (u1 - u2) |> u"kJ"

# ╔═╡ b0bd133f-7b36-4a8c-9c5c-18e1287e8e63
begin
	Q_out_rounded = round(Q_out |> typeof, Q_out, digits=4)
	
cm"""

## _finis_

{.message .success}
> et voilà
>
>``\qquad Q_{out}`` = $(Q_out_rounded)

"""
end

# ╔═╡ b190af88-07f0-47e6-b534-a4561ab31bb3
cm"""

## Find

Determine the heat transfer, in kJ, from the refrigerant.

{.message .found}
> found
> ``\qquad Q_{out} = `` $Q_out_rounded

"""

# ╔═╡ 11078015-d9e2-4215-a5db-f7f224a62e32


# ╔═╡ 7634fd1d-7c03-4c63-a005-9db29759154e


# ╔═╡ a4d9de7f-edac-4b4d-acda-ca656a83cee0
@mdx """

{style="border-color: var(--mcs-color-appendix); border-width: 0.5px;"}
---

### Appendix

_One of the major benefits of reactive notebooks_{.newthought} like Pluto is that allow large, unwieldy chunks of code to be placed outside the reading flow without removing them from their proper place in the computation flow. Their results can be used in calculations or spliced (interpolated) into the narrative. 

For interpolation examples, see the 
$(Resource("https://raw.githubusercontent.com/jupyterhub/binderhub/43ee103410b0ee9e5761171b37580281c3936eb5/binderhub/static/images/markdown-icon.svg", :height => 24))  markup throughout the notebook, perhaps even here 😉. In particular, the values in the problem statement are actually sourced in the `Julia` code under the image. Play with the values and check the results.

"""

# ╔═╡ a3a8cc93-6812-4b2e-acb6-30627a3c0c2f


# ╔═╡ 23270456-5512-4b87-9345-62f6e6ba9fb1
isochoric_process_svg = """
	<svg width="400px" viewBox="0 0 265 166" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
	    <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
	        <g id="Mobile" transform="translate(-16.000000, -98.000000)">
	            <g id="Group" transform="translate(16.000000, 100.000000)">
	                <line x1="131.5" y1="63.5" x2="131.5" y2="128.5" id="Line-3" stroke="#979797" stroke-width="0.5" stroke-linecap="square" stroke-dasharray="3,1"></line>
	                <path id="Line" d="M254,140 L263,144.5 L254,149 L254,145 L13,145 L13,144 L254,144 L254,140 Z" fill="#2A2D38" fill-rule="nonzero"></path>
	                <path id="Line" d="M13.5,-0.128205128 L18,8.87179487 L14,8.871 L14,145.128205 L13,145.128205 L13,8.871 L9,8.87179487 L13.5,-0.128205128 Z" fill="#2A2D38" fill-rule="nonzero"></path>
	                <path d="M29,126 C40.2466732,83.6345528 58.9681265,0 82.4098041,0 C105.851482,0 165.01311,126 263,126" id="Path" stroke="#F2590C"></path>
	                <text id="v" font-family="CMUClassicalSerif-Italic, CMU Classical Serif" font-size="12" font-style="italic" font-weight="normal" fill="#000000">
	                    <tspan x="247" y="161">v</tspan>
	                </text>
	                <text id="P" font-family="CMUClassicalSerif-Italic, CMU Classical Serif" font-size="12" font-style="italic" font-weight="normal" fill="#000000">
	                    <tspan x="0" y="17">P</tspan>
	                </text>
	                <text id="1" font-family="Helvetica-Light, Helvetica" font-size="9" font-weight="300" fill="#000000">
	                    <tspan x="123" y="74">1</tspan>
	                </text>
	                <path id="Line-2" d="M132,71.8714286 L132,108 L136,108 L131.5,117 L127,108 L131,108 L131,71.8714286 L132,71.8714286 Z" fill="#0000FF" fill-rule="nonzero"></path>
	            </g>
	        </g>
	    </g>
	</svg>
	""";

# ╔═╡ 27d9d932-e3b4-4917-b3f1-7a819af310c7
cm"""

## Get Organized

These things you should see:

1. "...closed, rigid tank..." means we have an 
   _isochoric process_{.addblue}. Our system 
   is also  constant mass; thus, we have 
   _constant specific volume_{.killerorange}.


1. We're losing heat. Now we should have an idea of our process's flow.

   {.center .invertible .dimmer}
   $isochoric_process_svg


   {.fig_caption }
   Our process.

   _Get in the habit of sketching your processes._{.newthought} A sketch 
   always tells a great story. This one tells us 
   **no boundary work**{.killerorange} 
   without us having to think about anything.

1. We have one work interaction, in the form of electricity.

1. We have enough information to resolve State ①.

1. Our technique for State ② is straightforward, one you'll repeat many, 
   many times: resolve a state using a known adjacent state and the process
   connecting them.  

   ```math
   \left.
   \begin{align}
     T_1 &= \pu{-10 °C} \\
     x_1 &= 0.8
   \end{align}
   \right\}
   ~\ce{① ->[~{\rm d}V = 0~~] ②}~
   \left\{
   \begin{aligned}
     T_2 &= \pu{40 °C} \\
     v_2 &= v_1
   \end{aligned}
   \right.
   ```

<style>

h2,
.dimmer {opacity: 0.75;}

</style>
"""

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
CommonMark = "~0.8.3"
Hyperscript = "~0.0.4"
HypertextLiteral = "~0.9.3"
LaTeXStrings = "~1.3.0"
Lazy = "~0.15.1"
MarkdownLiteral = "~0.1.1"
PlutoUI = "~0.7.16"
Unitful = "~1.9.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[CommonMark]]
deps = ["Crayons", "JSON", "URIs"]
git-tree-sha1 = "393ac9df4eb085c2ab12005fc496dae2e1da344e"
uuid = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
version = "0.8.3"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[Lazy]]
deps = ["MacroTools"]
git-tree-sha1 = "1370f8202dac30758f3c345f9909b97f53d87d3f"
uuid = "50d2b5c4-7a5e-59d5-8109-a42b560f39c0"
version = "0.15.1"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MarkdownLiteral]]
deps = ["CommonMark", "HypertextLiteral"]
git-tree-sha1 = "0d3fa2dd374934b62ee16a4721fe68c418b92899"
uuid = "736d6165-7244-6769-4267-6b50796e6954"
version = "0.1.1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "d911b6a12ba974dabe2291c6d450094a7226b372"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.1"

[[PlutoUI]]
deps = ["Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "4c8a7d080daca18545c56f1cac28710c362478f3"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.16"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "a981a8ef8714cba2fd9780b22fd7a469e7aaf56d"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.9.0"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
"""

# ╔═╡ Cell order:
# ╟─916c35d9-2007-4a4d-8e54-6c8a60583e7e
# ╟─83d5fd68-3e02-4fa0-a0a2-9a0876befa82
# ╠═b18da173-12b7-43cf-bcaa-abac32d4390c
# ╠═eab9d3c3-79ac-454b-8849-03e2f5ad1b44
# ╟─b190af88-07f0-47e6-b534-a4561ab31bb3
# ╟─27d9d932-e3b4-4917-b3f1-7a819af310c7
# ╟─3bd8532c-a167-4400-9e98-7e407032a834
# ╟─2a1d3c88-4381-4690-93c9-e300adaddbdb
# ╠═5aa61edf-aada-4303-9598-b18b1df63521
# ╟─30b360c2-bde1-4f1d-81bd-cf9a4abbaac1
# ╠═fcc88e47-f88e-4151-8ee7-4ba328dbd5e1
# ╟─b72069ef-76b2-44b9-9439-6251f8cb3d51
# ╠═414b5a13-6dc1-4bce-a8b4-85a48ba647cd
# ╟─1636d935-0673-4a66-84a1-651542bb420d
# ╟─a20e9fd2-9540-4f15-bfa3-f32c61dd37ba
# ╠═6f2db943-228f-4905-b3f0-97462c69e23c
# ╠═de0e0c33-4239-4050-928a-298510224c29
# ╟─30c658f0-2736-4a87-a7de-bd539f919b37
# ╟─a5bd2cc7-1fc0-4b14-9e86-fe2a0e97b15b
# ╠═838a1526-67ef-4d89-84d1-a96af8321041
# ╟─b0bd133f-7b36-4a8c-9c5c-18e1287e8e63
# ╟─11078015-d9e2-4215-a5db-f7f224a62e32
# ╟─7634fd1d-7c03-4c63-a005-9db29759154e
# ╟─a4d9de7f-edac-4b4d-acda-ca656a83cee0
# ╟─a3a8cc93-6812-4b2e-acb6-30627a3c0c2f
# ╟─23270456-5512-4b87-9345-62f6e6ba9fb1
# ╟─8ccd67d7-193e-4a5b-9274-e1386c301c5c
# ╟─853f2df9-e266-4f4f-91f4-2bb9e844b74c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
