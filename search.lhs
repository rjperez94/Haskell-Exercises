Variations on a search

Count the number of times an item occurs in a list

We can do this with simple recursion:

> count :: Eq a => a -> [a] -> Int
> count _ [] = 0
> count x (y:z) | x == y = 1 + count x z
> 	  	| otherwise = count x z

This can be simplified a little by using a local definition to avoid
repeating the recursive call:

> count1 :: Eq a => a -> [a] -> Int
> count1 _ [] = 0
> count1 x (y:z) | x == y = 1 + c
> 	  	 | otherwise = c
> 	 where c = count1 x z

Alternatively, we can use a conditional expression:

> count2 :: Eq a => a -> [a] -> Int
> count2 _ [] = 0
> count2 x (y:z) = (if x == y then 1 else 0) + count1 x z

We can also use a tail recursive form:

> count3 :: Eq a => a -> [a] -> Int
> count3 x l = count3' x 0 l

> count3' :: Eq a => a -> Int -> [a] -> Int
> count3' _ c [] = c
> count3' x c (y:z) | x == y = count3' x (c+1) z
> 	  	    | otherwise = count3' x c z

Finally, using higher order functions, we can use a fold and map:

> count4 :: Eq a => a -> [a] -> Int
> count4 x l = foldr (+) 0 (map (\y -> if x == y then 1 else 0) l)

Or we can use a filter:

> count5 :: Eq a => a -> [a] -> Int
> count5 x l = length (filter (==x) l)

Note that some of these functions can be made into higher order functions by
omitting the last argument (and sometimes a bit of other adjustment).  For
example we can rewrite count 5 as:

> count5' :: Eq a => a -> [a] -> Int
> count5' x = length . (filter (==x))

Note the use of function composition (.) here.


Find all positions at which a given item occurs in a list, in the order
they occur.

This needs to be done using forwards propagation to calculate the positions at
which the given item occurs, so we need an auxilliary function which takes the
current position as an extra argument.  We also need another argument to
collect the positions at which the item occurs.  In order to get the result in
the right order, we need to either append each occurence to the end of the
list, or build it in the opposite order and reverse it before returning the
result.  We'll do the latter as it is more efficient.

> allPos :: Eq a => a -> [a] -> [Int]
> allPos x l = allPos' x l 1 []

> allPos' :: Eq a => a -> [a] -> Int -> [Int] -> [Int]
> allPos' _ [] _ ps = reverse ps
> allPos' x (y:ys) k ps | x == y = allPos' x ys (k+1) (k:ps)
> 	       	       	| otherwise = allPos' x ys (k+1) ps

Alternatively, we can have some fun with higher order functions.
We will describe how this is built from the inside out.

First, we can zip the given list with [1..], to get a list of pairs, where the
second element of each pair is the index of that pair in the list.
E.g. zip ['a','b','a'] [1..] = [('a',1),('b',2),('a',3)]

Next, we can filter out those pairs that have the given item as their first
element.
E.g. filter (\(x,y) -> x=='a') [('a',1),('b',2),('a',3)] = [('a',1),('a',3)]

Finally, we can use map snd to extract the second element of each pair.
E.g. map snd [('a',1),('a',3)] = [1,2]

Putting this all together, we get:

> allPos1 :: Eq a => a -> [a] -> [Int]
> allPos1 x l = map snd (filter (\(u,v) -> u==x) (zip l [1..]))

or, using extra functions to make the structure a bit clearer:

> allPos2 :: Eq a => a -> [a] -> [Int]
> allPos2 x l = map snd pairsWithx
>               where pairsWithx = filter (firstIs x) numPairs
>                                  where firstIs x (y,z) = x == y
>                                        numPairs = zip l [1..]


Find the first and last positions of a given item in a list of items,
returning (i,i) if it occurs just once (at i), and (0,0) if it doesn't occur.

A simple way to do this it to write one function to find the first occurrence
and another to find the last position, and combine their results (assuming
both return 0 if the given item is not found):

> firstLastPos :: Eq a => a -> [a] -> (Int, Int)
> firstLastPos x l = (firstPos x l, lastPos x l)

We can find the first position of an item in a list by using an auxiliary
function which steps down the list, passing the current position until the
given item is found or the end of the list reached.

> firstPos :: Eq a => a -> [a] -> Int
> firstPos x l = firstPos' x 1 l

> firstPos' :: Eq a => a -> Int -> [a] -> Int
> firstPos' _ _ [] = 0
> firstPos' x k (y:z) | x == y = k
>    	      	      | otherwise = firstPos' x (k+1) z

We can find the last position of an item in a list by using an auxiliary
function which steps down the list, passing the current position and the
position of the latest occurrence of the item (or 0 if it hasn't been seen). 

> lastPos :: Eq a => a -> [a] -> Int
> lastPos x l = lastPos' x 1 0 l

> lastPos' :: Eq a => a -> Int -> Int -> [a] -> Int
> lastPos' _ _ p [] = p
> lastPos' x k p (y:z) | x == y = lastPos' x (k+1) k z
> 	       	       | otherwise = lastPos' x (k+1) p z

Or we can reverse the list, find the first occurrence in that list, which will
be the lasst occurrence in the original list, and calculate its position in
the original list.  Details left as an exercise.

Again, we could do both of these using higher order functions.

Alternatively, given that we have just implemented a function to find all 
positions of an item in a list, we can use that:

> firstLastPos1 :: Eq a => a -> [a] -> (Int, Int)
> firstLastPos1 x l | ps == [] = (0, 0)
>                   | otherwise = (head ps, last ps)
>    where ps = allPos x l

allPos is repeated heere to avoid getting into importing and modules!

> allPos :: Eq a => a -> [a] -> [Int]
> allPos x l = map snd (filter (\(u,v) -> u==x) (zip l [1..]))
