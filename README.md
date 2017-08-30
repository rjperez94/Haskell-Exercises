# Haskell-Exercises

## Running the program

To run the Haskell `.lhs` files, I used Haskell Platform from <a href='https://www.haskell.org/platform/'>here</a>. Just install it in your machine and double click a `.lhs` file

## Contents

### Search

- `count` returns the number of times that a given item occurs in a list of items. For example, `count 1 [1,2,1,2,1]` should return 3, while `count 1 []` should return 0
- `allPos` returns a list of all positions at which a given item occurs in a list of items, in the order that they occur. For example, `allPos 1 [1,2,1,2,1]` should return [1,3,5], while `allPos 3 [1,2,1]` should return []
- `firstLastPos` which returns a pair giving the positions of the first and
last occurrences of a given item in a list of items. The function should return (i,i) if the item only occurs once, at position i, and (0,0) if the item does not occur in the list. For example, `firstLastPos 1 [1,2,1,2,1]` should return (1,5), `firstLastPos 2 [1,2,1,2,1]` should return (2,4), `firstLastPos 5 [1,2,5,2,1]` should return (3,3), while `firstLastPos 3 [1,2,1]` should return (0,0)
