Sorting

n^2 sorting

Insertion sort

This can be done using ordinary recursion with backwards propagation, which
means we sort the list from right to left.

> isort :: Ord a => [a] -> [a]
> isort [] = []
> isort (x:xs) = insert x (isort xs)

> insert :: Ord a => a -> [a] -> [a]
> insert x [] = [x]
> insert x (y:ys) | x < y = x:y:ys
> 	   	  | otherwise = y : (insert x ys)

Or we can use tail recursion and forwards propagation, sorting the list from
left to right.

> isort1 :: Ord a => [a] -> [a]
> isort1 l = isort1' l []

> isort1' :: Ord a => [a] -> [a] -> [a]
> isort1' [] l = l
> isort1' (x:xs) l = isort1' xs (insert x l)

Note that in the backwards propagating version, we can treat the unit list as
a base case by adding isort [x] = [x] as an extra case.  This applies to
several other algorithms as well.

Selection sort

The obvious approach is to repeatedly find the smallest element in the
remaining list and bring it to the front - which means deleting it and consing
it onto the front of the result of sorting the rest of the list.  Again, this
sorts the list from right to left.

> ssort :: Ord a => [a] -> [a]
> ssort [] = []
> ssort l = m : ssort (del m l)
> 	    where m = minimum l

Delete the first occurrence of an item from a list (if there is one).

> del :: Eq a => a -> [a] -> [a]
> del _ [] = []
> del x (y:ys) | x == y = ys
>     	       | otherwise = y : (del x ys)

This requires two passes of the lists to find the smallest element and delete
it.  We can avoid this by combining these into one function which returns the
smallest element and the result of deleting it - left as an exercise.

Alternatively, we can use tail recursion and forward propagation to sort the
list from left to right.

> ssort1 :: Ord a => [a] -> [a]
> ssort1 l = ssort1' l []

> ssort1' :: Ord a => [a] -> [a] -> [a]
> ssort1' [] l = l
> ssort1' l r = ssort1' (del m l) (m : r)
> 	      	where m = minimum l

Bubble sort

Bubble sort doesn't lend itself to a simple recursive formulation in the way
that insertion sort and selection sort do because a standard bubble sort,
which bubbles the largest element to the end on each pass doesn't just remove
an element from the front of the list on each pass.  We can get around this by
either counting the number of passes using an extra parameter, or by dropping
the last element from the end of the list on each pass, since we know that it
is now the largest remaining element.  This means that we need to build the
result by appending that element to the end of the result of the recursive
call.  We will do the latter.

> bsort :: Ord a => [a] -> [a]
> bsort [] = []
> bsort [x] = [x]
> bsort l = (bsort $ reverse l') ++ [y]
>           where y:l' = reverse (bubble l)

> bubble :: Ord a => [a] -> [a]
> bubble [] = []
> bubble [x] = [x]
> bubble (x:y:z) | x <= y = x : bubble (y:z)
>                | otherwise = y : bubble (x:z)

Note that we use pattern matching in the where clause to extract the head and
tail of the list - which we know is non-emptu because of the previous cases.

Also note we can omit the first call on reverse without affecting the
correctness of the algorithm, though it is then not quite a standard bubble
sort.

A common improvement on bubble sort is to stop as soon as a bubble pass
performs no swaps.  To do this we need to pass an extra parameter recording
whether a swap has occurred - and now we need to pass the partial result as an
extra parameter as well

> bsort1 :: Ord a => [a] -> [a]
> bsort1 [] = []
> bsort1 [x] = [x]
> bsort1 l | b == False = l'
>          | otherwise = (bsort1 $ reverse l'') ++ [y]
>            where (b, l') = bubble1 l False
>                  y:l'' = reverse l'

> bubble1 :: Ord a => [a] -> Bool -> (Bool, [a])
> bubble1 [] b = (b, [])
> bubble1 [x] b = (b, [x])
> bubble1 (x:y:z) b | x <= y = (b', x : l')
>                   | otherwise = (b'', y : l'')
>             where (b', l') = bubble1 (y:z) b
>                   (b'', l'') = bubble1 (x:z) True

Note how pattern matching in there where clauses is used to unpack the results
of functions returning pairs.

A simpler approach is to do a version of bubble sort which bubbles the
smallest element to the front on each pass.  In this case, we get a much nicer
kind of recursion.

> bsort2 :: Ord a => [a] -> [a]
> bsort2 [] = []
> bsort2 [x] = [x]
> bsort2 xs = y : bsort2 ys
>             where y:ys = bubble2 xs

bubble2 bubbles the smallest element to the front

> bubble2 :: Ord a => [a] -> [a]
> bubble2 [] = []
> bubble2 [x] = [x]
> bubble2 (x:xs) | x <= y = x:y:z
>       	 | otherwise = y:x:z
>                where y:z = bubble2 xs

n log n sort

Quick sort

You can write a naive version of quicksort very easily in Haskell:

> qsort :: Ord a => [a] -> [a]
> qsort [] = []
> qsort (x:xs) = (qsort [y | y <- xs, y < x]) ++ [x] ++ (qsort [y | y <- xs, y >= x])

But is this n log n?

I'll leave it to you to write a better one.

Merge sort

For merge sort, we need to split the list into two parts of roughly equal
length, sort them and them merge the results.  We can do the split in several
different ways.

One way, which is close to the way you do it on arrays, is to split on length:

> msort :: Ord a => [a] -> [a]
> msort [] = []
> msort [a] = [a]
> msort l = merge (msort u) (msort v)
> 	    where u = take n l
>	    	  v = drop n l
>		  n = (length l) `div` 2

> merge :: Ord a => [a] -> [a] -> [a]
> merge [] y = y
> merge x [] = x
> merge u@(x:xs) v@(y:ys) | x <= y = x : merge xs v
> 		 	  | otherwise = y : merge u ys

Note that the calls on take and drop here can be combined into a single
function so this doesn't require two passes.

An alternative, which avoids calculating the length, is to split into add and
even indexes.

> msort1 :: Ord a => [a] -> [a]
> msort1 [] = []
> msort1 [a] = [a]
> msort1 l = merge (msort1 u) (msort1 v)
> 	    where (u, v) = split l

> split :: [a] -> ([a], [a])
> split [] = ([], [])
> split [x] = ([x], [])
> split (x:y:z) = (x:u, y:v)
> 		  where (u, v) = split z


