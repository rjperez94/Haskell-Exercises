# Haskell-Exercises

## Running the program

To run the Haskell `.lhs` files, I used Haskell Platform from <a href='https://www.haskell.org/platform/'>here</a>. Just install it in your machine and double click a `.lhs` file to run

## Contents

### Search

- `count` returns the number of times that a given item occurs in a list of items. For example, `count 1 [1,2,1,2,1]` should return 3, while `count 1 []` should return 0
- `allPos` returns a list of all positions at which a given item occurs in a list of items, in the order that they occur. For example, `allPos 1 [1,2,1,2,1]` should return [1,3,5], while `allPos 3 [1,2,1]` should return []
- `firstLastPos` which returns a pair giving the positions of the first and
last occurrences of a given item in a list of items. The function should return (i,i) if the item only occurs once, at position i, and (0,0) if the item does not occur in the list. For example, `firstLastPos 1 [1,2,1,2,1]` should return (1,5), `firstLastPos 2 [1,2,1,2,1]` should return (2,4), `firstLastPos 5 [1,2,5,2,1]` should return (3,3), while `firstLastPos 3 [1,2,1]` should return (0,0)

### Sort

2 kinds of sorting in terms of O(n)
1. implements an n<sup>2</sup> sorting algorithm, e.g. insertion sort, selection sort or bubble sort.
2. implements an n log n sorting algorithm, e.g. quicksort or merge sort

### Map

- `emptyMap` returns an empty map
- `hasKey` checks if a given key is dened in a map
- `setVal` sets the value for a key in the map
- `getVal` gets the value of a given key in a map
- `delKey` deletes a key (and its value) from a map
- `buildMap` takes a list of items and returns a map containing all of the items in the list and the number of times that each one occurs. For example, given the input `[1,2,3,2,1]`, the function would return the map [(1,2), (2,2), (3,1)].

### Binary Tree

- `hasbt` tests whether the tree t contains a node with label x
- `equalbt` tests whether trees t1 and t2 are identical; i.e. are both empty, or have the same label at the root and the same subtrees
- `reflectbt` constructs a mirror image of tree t
- `fringebt` constructs a list containing the labels on the leaves of the tree t, in the order they would be visited in a left-to-right depth-first traversal
- `fullbt` checks whether tree t is full i.e. if every node has either 0 or 2 subtrees

### Binary Tree Fold

- `btfold` takes as arguments a function, a "unit" value and a binary tree

If the tree is empty, the fold function should return the unit value.
If not, it should apply the fold recursively to both subtrees, then apply the given function to the values returned and the value at the root. 

For example, to count the number of nodes in a tree, we would call `btfold` with the function `\u v w -> 1 + v + w` and `unit value 0`; to sum the labels on a tree (assuming they are numerical labels), we would call `btfold` with the function `\u v w -> u + v + w` and `unit value 0`

### Binary Search Tree (BST)

- `empty` returns an empty BST
- `insert` inserts an item into a BST (no change, if already there)
- `has` checks whether a given item occurs in a BST
- `delete` deletes a given item from a BST (no change, if not there)
- `flatten` returns a list of the items in a BST
- `equals` determines whether two BSTs contain the same items

### Graph

We represent a weighted undirected graph as a list of edges, where each edge is represented by a triple `(u,c,v)`, where u and v are the vertices at the ends of the edge and c is the weight on that edge.

This assumes that weights are positive integers, and allow a self-loop (an edge with the same start and end vertex) with a weight of zero in order to allow a vertex with no inward or outward edges to be represented

- `reachable` determines whether there is a path from vertex x to vertex y in graph g
- `minCostPath` finds a minimal cost path from x to y in g
- `cliques` splits a graph g into a list of subgraphs, such that each graph is a maximal connected component of g (i.e. all of the vertices in the component can be reached from all others, and the components contains all of the vertices that can be reached from any of its vertices; and every edge of g occurs in one of the components of the result)
