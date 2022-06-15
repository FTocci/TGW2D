using Documenter
using LinearAlgebraicRepresentation

makedocs(
    sitename = "TGW2D",
	 pages=[
        "Topological Gift Wrapping 2D" => "index.md",
	]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "https://github.com/FTocci/TGW2D.git"
)
