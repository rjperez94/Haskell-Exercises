Graph algorithms

We represent weighted, undirected graphs as lists of edges.

> type Graph a = [(a,Int,a)]

Because the graphs are undirected, an edge (a,b,c) must be considered as
leading from a to c and from c to a.  This means that the edges shown in paths
are sometimes reversed from the ones given in the description of the graph.

Also, we assume that the list does not contain duplicates (so can be
considered as a set), though having duplicates will only given reducdant
results, not incorrect ones.

Finds all paths between two vertices in the graph.

Find all paths from x to y in g, where a path is a list of adjacent edges.

 allPaths :: Eq a => a -> a -> Graph a -> [[(a,Int,a)]]

> allPaths x y _ | x == y = [[]]
> allPaths x y g = [ (u',c,v'):p | (u,c,v) <- g, u == x || v == x,
> 	       	     		   let (u',v') = if u == x then (u,v) else (v,u),
>				   p <- allPaths v' y (rem (u,c,v) g) ]
>    where rem x g = [ x' | x' <- g, x /= x' ]

Note carefully how this checks each edge in both directions, recording the
edge in the direction taken so as to preserve the property of consqecutive
edges in a path, and how the edge is removed from the graph passed in the
recursive call to ensure that we don't traverse the same edge again and end up
in an infitnite loop.

Determine whether there is a path from x to y in g.  THis is now trivial.

 reachable :: Eq a => a -> a -> Graph a -> Bool

> reachable x y g = allPaths x y g /= []

Find a minimal cost path from x to y in g.

We will use auxiliary functions cost, to find the cost of a path, and minf,
which returns whichever of two items has the lower value of a given function.

 minCostPath :: Eq a => a -> a -> Graph a -> [(a,Int,a)]

> minCostPath x y g = foldl1 (minf cost) (allPaths x y g)
>   where minf f x y = if f x < f y then x else y
>   	  cost p = sum (map (\(_,c,_) -> c) p)


Split a graph into a list of maximal connected components, i.e. a list of
subgraphs such that all of the vertices in each component can be reached from
all others, each component contains all of the vertices that can be reached
from any of its vertices, and every edge of the grpah occurs in one of the
components. 

> cliques :: Eq a => Graph a -> [Graph a]

> cliques [] = []

> cliques ((x,c,y):g) = q : cliques g'
>   where q = clique [(x,c,y)] g
>   	  g' = [(u,d,v) | (u,d,v) <- g, not (elem (u,d,v) q || elem (v,d,u) q)]

clique q g finds the greatest connected component that can be constructed by
adding edges from g to q.

> clique :: Eq a => Graph a -> Graph a -> Graph a
> clique q [] = q
> clique q ((x,c,y):g) | touches (x,c,y) q = clique ((x,c,y):q) g
> 	   	       | otherwise = clique q g

An edge touches a subgrah if one of its ends is in the subgraph.
We should never test an edge which has both ends in the subgraph.

> touches :: Eq a => (a,Int,a) -> Graph a -> Bool
> touches (x,_,y) g = elem x w || elem y w
> 	  where w = [u | (u,_,_) <- g] ++ [u | (_,_,u) <- g]

Some graphs for testing:

> g1 = []
> g2 = [(1,1,2)]
> g3 = [(1,1,2),(2,2,3)]
> g4 = [(1,1,2),(2,2,3),(1,4,3)]
> g5 = [(1,1,2),(3,2,2)]
> g6 = [(1,1,2),(2,2,3),(4,4,5)]
> g7 = [(1,1,2),(2,2,3),(4,4,5),(3,1,2)]
