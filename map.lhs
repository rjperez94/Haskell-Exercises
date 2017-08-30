Implementing a map

Implementing a map as a list of pairs, with keys in arrival order, using a
type synonym.

Note in order to print error messages, we have to declare any type whose value
may be printed as being in type class Show.

> type Map a b = [(a, b)]

emptyMap just returns an empty list

> emptyMap :: Map a b
> emptyMap = []

hasKey x m checks to see if there is a pair with x its first element

> hasKey :: Ord a => a -> Map a b -> Bool
> hasKey _ [] = False
> hasKey x ((y,_):r) | x == y = True
> 	   	     | otherwise = hasKey x r

setVal x v m adds pair (x,v) to the front of m, after removing any pair with
key x

> setVal :: (Ord a, Show a) => a -> b -> Map a b -> Map a b
> setVal x v m = (x,v) : delKey' x m

delKey returns the value associated with key k, and gives an error if there is
none

> getVal :: (Ord a, Show a) => a -> Map a b -> b
> getVal x [] = error ("Key " ++ (show x) ++ " not found")
> getVal x ((y,z):r) | x == y = z
> 	   	     | otherwise = getVal x r

delKey deletes a pair with key k, and gives an error if there is none

> delKey :: (Ord a, Show a) => a -> Map a b -> Map a b 
> delKey x [] = error ("Key " ++ (show x) ++ " not found")
> delKey x ((y,z):r) | x == y = r
> 	   	     | otherwise = (y,z) : delKey x r

Note: We can stop after one occurence has been found and deleted, since we can
show that there is never more than one occurrence of a key.

delKey' deletes a pair with key k, and makes no change if there is none

> delKey' :: (Ord a, Show a) => a -> Map a b -> Map a b 
> delKey' x [] = []
> delKey' x ((y,z):r) | x == y = r
> 	     	      | otherwise = (y,z) : delKey' x r


Building a map

Take a list of items and return a map containing all of the items that occur
in the list as keys, along with the number of times each on occurs (this is
usually known as a bag or multiset).

We repeat the definitions for map type and functions below to avoid needing to
import them from a separate file.

This can be done in a standard recursive way using backwards propagation,
recursing to the of the list and building the map as we unwind from the
recursive calls.


> buildMap :: (Ord a, Show a) => [a] -> Map a Int

> buildMap [] = []
> buildMap (x:xs) | hasKey x m = setVal x (v+1) m
>	 	  | otherwise = setVal x 1 m
>		  where m = buildMap xs
>		      	v = getVal x m

This can also be done using forwards propagation, passing a partial map down
the list adding to it as we go.

> buildMap1 :: (Ord a, Show a) => [a] -> Map a Int
> buildMap1 l = buildMap1' l []

> buildMap1' :: (Ord a, Show a) => [a] -> Map a Int -> Map a Int
> buildMap1' [] m = m
> buildMap1' (x:xs) m | hasKey x m = buildMap1' xs (setVal x (v+1) m)
> 	 	      | otherwise = buildMap1' xs (setVal x 1 m)
>		  where v = getVal x m

This can me expressed a little more elegantly by factoring out the update to
m:

> buildMap2 :: (Ord a, Show a) => [a] -> Map a Int
> buildMap2 l = buildMap2' l []

> buildMap2' :: (Ord a, Show a) => [a] -> Map a Int -> Map a Int
> buildMap2' [] m = m
> buildMap2' (x:xs) m = buildMap2' xs m'
>    where m' | hasKey x m = setVal x (v+1) m
> 	      | otherwise = setVal x 1 m
>	   v = getVal x m

Can we be a bit more clever and do this using higher order functions?  We can
do it like this:

> buildMap3 :: (Ord a, Show a) => [a] -> Map a Int

> buildMap3 [] = []
> buildMap3 l@(x:xs) = (x, count x l) : buildMap3 (filter (/=x) xs)
>   where count x l = length (filter (==x) l)

When its argument is not empty, buildMap3 counts the number of occurrences of
the first element in the list and uses it to construct the first pair in the
resulting map, then deletes all occurrences of that element from the tail and
passing the resulting list as the argment to the recursive call.

While elegant, this is probably not as efficient as the previous versions (try
running them with the timing flag set - i.e. after typing :set +s).  It might
be slightly better to write:

> buildMap4 :: (Ord a, Show a) => [a] -> Map a Int

> buildMap4 [] = []
> buildMap4 l@(x:xs) = (x, count x l) : buildMap4 withoutx
>   where count x l = length withx
>         (withx, withoutx) = split (==x) l

> split :: (a -> Bool) -> [a] -> ([a], [a])
> split _ [] = ([], [])
> split b (x:xs) | b x = (x:with, without)
>                | otherwise = (with, x:without)
>         where (with, without) = split b xs

Note again the way that where is used in split to simplify working with a
function returning a pair.

Also note the use of @ to gave a name to the whole argument matched by a
pattern
