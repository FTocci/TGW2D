# Situazione iniziale

In questo capitolo viene illustrato l'algoritmo TGW2D nel suo stato iniziale ponendo l'enfasi 
sulle funzioni principali e su come l'algoritmo sostiene le prestazioni. Inoltre, sono stati
utilizzati strumenti di supporto per la profilazione e la misura dei tempi di esecuzione.

La funzione planar_arrangement è costituita da un codice molto minimale, in quanto la parte più importante dell'esecuzione avviene nelle funzioni esterne che sono chiamate all'interno di essa. 
Le funzioni chiamate internamente alla funzione planar_arrangement sono:
1. planar_arrangement_1
2. cleandecomposition
3. biconnected_components
4. planar_arrangement_2

## planar_arrangement

```julia
function planar_arrangement(
        V::Lar.Points,
        copEV::Lar.ChainOp,
        sigma::Lar.Chain=spzeros(Int8, 0),
        return_edge_map::Bool=false,
        multiproc::Bool=false)


#planar_arrangement_1
	V,copEV,sigma,edge_map=Lar.Arrangement.planar_arrangement_1(V,copEV,sigma,return_edge_map,multiproc)

# cleandecomposition
	if sigma.n > 0
		V,copEV=Lar.Arrangement.cleandecomposition(V, copEV, sigma, edge_map)
	end

    bicon_comps = Lar.Arrangement.biconnected_components(copEV)
    # EV = Lar.cop2lar(copEV)
    # V,bicon_comps = Lar.biconnectedComponent((V,EV))

	if isempty(bicon_comps)
    	println("No biconnected components found.")
    	if (return_edge_map)
    	    return (nothing, nothing, nothing, nothing)
    	else
    	    return (nothing, nothing, nothing)
    	end
	end
#Planar_arrangement_2
	V,copEV,FE=Lar.Arrangement.planar_arrangement_2(V,copEV,bicon_comps,edge_map,sigma)
	if (return_edge_map)
	     return V, copEV, FE, edge_map
	else
	     return V, copEV, FE
	end
end
```

L’obiettivo è partizionare un complesso cellulare passato come parametro. Un
complesso cellulare è partizionato quando l'intersezione di ogni possibile coppia di celle
del complesso è vuota e l'unione di tutte le celle è l'intero spazio euclideo.

## biconnected_components

Calcola i componenti biconnessi del grafo “EV”, rappresentati dagli spigoli come coppie 
di vertici.

Il codice è stato omesso per motivi di compattezza.

## cleandecomposition

```julia
function cleandecomposition(V, copEV, sigma, edge_map)
    # Deletes edges outside sigma area
    todel = []
    new_edges = []
    map(i->new_edges=union(new_edges, edge_map[i]), sigma.nzind)
    ev = copEV[new_edges, :]
    for e in 1:copEV.m
        if !(e in new_edges)

            vidxs = copEV[e, :].nzind
            v1, v2 = map(i->V[vidxs[i], :], [1,2])
            centroid = .5*(v1 + v2)

            if ! Lar.point_in_face(centroid, V, ev)
                push!(todel, e)
            end
        end
    end

    for i in reverse(todel)
        for row in edge_map

            filter!(x->x!=i, row)

            for j in 1:length(row)
                if row[j] > i
                    row[j] -= 1
                end
            end
        end
    end

    V, copEV = Lar.delete_edges(todel, V, copEV)
	return V,copEV
end
```

Elimina i bordi al di fuori dell'area sigma.

## merge_vertices

```julia
function merge_vertices!(V::Lar.Points, EV::Lar.ChainOp, edge_map, err=1e-4)
    vertsnum = size(V, 1)
    edgenum = size(EV, 1)
    newverts = zeros(Int, vertsnum)
    # KDTree constructor needs an explicit array of Float64
    V = Array{Float64,2}(V)
    kdtree = KDTree(permutedims(V))

    # merge congruent vertices
    todelete = []
    i = 1
    for vi in 1:vertsnum
        if !(vi in todelete)
            nearvs = Lar.inrange(kdtree, V[vi, :], err)
            newverts[nearvs] .= i
            nearvs = setdiff(nearvs, vi)
            todelete = union(todelete, nearvs)
            i = i + 1
        end
    end
    nV = V[setdiff(collect(1:vertsnum), todelete), :]

    # merge congruent edges
    edges = Array{Tuple{Int, Int}, 1}(undef, edgenum)
    oedges = Array{Tuple{Int, Int}, 1}(undef, edgenum)
    for ei in 1:edgenum
        v1, v2 = EV[ei, :].nzind
        edges[ei] = Tuple{Int, Int}(sort([newverts[v1], newverts[v2]]))
        oedges[ei] = Tuple{Int, Int}(sort([v1, v2]))
    end
    nedges = union(edges)
    nedges = filter(t->t[1]!=t[2], nedges)
    nedgenum = length(nedges)
    nEV = spzeros(Int8, nedgenum, size(nV, 1))
    # maps pairs of vertex indices to edge index
    etuple2idx = Dict{Tuple{Int, Int}, Int}()
    # builds `edge_map`
    for ei in 1:nedgenum
        nEV[ei, collect(nedges[ei])] .= 1
        etuple2idx[nedges[ei]] = ei
    end
    for i in 1:length(edge_map)
        row = edge_map[i]
        row = map(x->edges[x], row)
        row = filter(t->t[1]!=t[2], row)
        row = map(x->etuple2idx[x], row)
        edge_map[i] = row
    end
    # return new vertices and new edges
    return Lar.Points(nV), nEV
end
```

Si occupa di fondere vertici congruenti e bordi congruenti, assegnare a coppie di indici di
vertici indici di bordo e costruire una mappa dei bordi.

## Come migliorare il codice

Analizzando il codice nel dettaglio, è possibile evidenziare che in alcuni passi
dell'algoritmo è stato implementato il calcolo parallelo e distribuito. Infatti, nella
funzione "planar_arrangement_1", la frammentazione dei bordi può essere effettuata
tramite il calcolo asincrono.
Continuando l'analisi del codice ed osservando accuratamente le dipendenze presenti
risulta opportuno implementare modifiche con l'obiettivo di migliorare scalabilità,
modificabilità e prestazioni di porzioni dello stesso, riducendo l'accoppiamento tra i
moduli presenti fattorizzando il codice e continuando ad implementare forme di calcolo
parallelo e distribuito. In particolare, alcune di queste modifiche dovranno coinvolgere il 
codice relativo alla funzione "merge_vertices!", presentata in precedenza. Infatti, ad essa
sono assegnate numerose task che possono essere suddivise in diverse sotto funzioni.