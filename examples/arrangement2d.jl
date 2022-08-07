using SparseArrays
using ViewerGL
GL = ViewerGL
using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation
include("../src/arrangement/planar_arrangement.jl")


# input generation
V,EV = Lar.randomcuboids(60, .35)
V = GL.normalize2(V,flag=true)
VV = [[k] for k=1:size(V,2)]
#GL.VIEW( GL.numbering(.05)((V,[VV, EV]),GL.COLORS[1]) )

# subdivision of input edges
W = convert(Lar.Points, V')
cop_EV = Lar.coboundary_0(EV::Lar.Cells)
cop_EW = convert(Lar.ChainOp, cop_EV)
V, copEV, copFE = planar_arrangement(W::Lar.Points, cop_EW::Lar.ChainOp)

# compute containment graph of components
bicon_comps = biconnected_components(copEV)

# visualization of component graphs
EW = Lar.cop2lar(copEV)
W = convert(Lar.Points, V')
comps = [ GL.GLLines(W,EW[comp],GL.COLORS[(k-1)%12+1]) for (k,comp) in enumerate(bicon_comps) ]
#GL.VIEW(comps);