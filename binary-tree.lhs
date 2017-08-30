Functions on Binary Trees.

> data BinTree a = Empty | Node a (BinTree a) (BinTree a)
>      deriving (Eq, Show)

Test whether the tree t contains a node with label x.

> hasbt :: Eq a => a -> BinTree a -> Bool
> hasbt x Empty = False
> hasbt x (Node x' l r) = x == x' || hasbt x l || hasbt x r

Test whether trees t1 and t2 are identical; i.e. are both empty, or have
the same label at the root and the same subtrees.

> equalbt ::  Eq a => BinTree a -> BinTree a -> Bool
> equalbt Empty Empty = True
> equalbt (Node x l r) (Node x' l' r') = x == x' && equalbt l l' && equalbt r r'
> equalbt _ _ = False

Construct a mirror image of tree t.

> reflectbt :: BinTree a -> BinTree a 
> reflectbt Empty = Empty
> reflectbt (Node x l r) = (Node x (reflectbt r) (reflectbt l))

Construct the fringe of tree t; i.e. a list containing the labels on the
leaves of the tree, in the order they would be visited in a left-to-right
depth-first traversal.

We can do this with simple recursion, but this requires multiple uses of the
concanenaation operator (++), which makes it inefficient.

> fringebt :: BinTree a -> [a]
> fringebt Empty = []
> fringebt (Node x Empty Empty) = [x]
> fringebt (Node x l r) = (fringebt l) ++ (fringebt r)

An alternative is to use forward propagation with an additional parameter to
collect the labels as they are visited.  The natural (and most efficient) way
to do this is to put each label on to the front of a list which will collect
them in reverse, so we will need to reverse the final list.

> fringebt1 :: BinTree a -> [a]
> fringebt1 t = reverse (fringebt1' t [])

> fringebt1' :: BinTree a -> [a] -> [a]
> fringebt1' Empty xs = xs
> fringebt1' (Node x Empty Empty) xs = x : xs
> fringebt1' (Node x l r) xs = fringebt1' r (fringebt1' l xs)

Or we can traverse the tree in right to left order so the end up in the
correct order without reversing.  This is left as an exercise.

Check whether tree t is full; i.e. if every node has either 0 or 2
subtrees.

> fullbt :: BinTree a -> Bool
> fullbt Empty = True
> fullbt (Node _ Empty Empty) = True
> fullbt (Node _ Empty _) = False
> fullbt (Node _ _ Empty) = False
> fullbt (Node _ l r) = fullbt l && fullbt r

Example trees for testing:

> t1 = Empty
> t2 = Node 1 Empty Empty
> t3 = Node 2 t2 Empty
> t4 = Node 3 t2 t3
