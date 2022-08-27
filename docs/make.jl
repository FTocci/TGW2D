using Documenter
using DocumenterTools: Themes
using LinearAlgebraicRepresentation

makedocs(
	format = Documenter.HTML(),
    	sitename = "TGW2D",
	 pages=[
	"Informazioni Generali" => "index.md",
	"Introduzione" => "intro.md",
	"Grafo delle Dipendenze" => "grafodipendenze.md",
	"Sviluppo" => "sviluppo.md",
	"Analisi delle prestazioni" => "prestazioni.md",
	"Conclusione" => "conclusioni.md"
	]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "https://github.com/FTocci/TGW2D.git"
)
