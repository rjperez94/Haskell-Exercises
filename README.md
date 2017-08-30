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
- `buildMap` which takes a list of items and returns a map containing all of the items in the list and the number of times that each one occurs. For example, given the input `[1,2,3,2,1]`, the function would return the map [(1,2), (2,2), (3,1)].
