Binary search trees

Binary trees are defined as:

> data BinTree a = Empty | Node a (BinTree a) (BinTree a)
>      	       	   deriving (Show, Eq)

Construct an empty BST

> empty :: Eq a => BinTree a
> empty = Empty

Insert an item into a BST (no change if already there).

> insert :: (Eq a, Ord a) => a -> BinTree a -> BinTree a
> insert x Empty = Node x Empty Empty
> insert x t@(Node y l r) | x == y = t
>                         | x < y = Node y (insert x l) r
>                         | x > y = Node y l (insert x r)

Check whether a given item occurs in a BST.

> has :: (Eq a, Ord a) => a -> BinTree a -> Bool
> has x Empty = False
> has x (Node y l r) | x == y = True
>                     | x < y = has x l
>                     | x > y = has x r

Delete a given item from a BST (no change if not there).

> delete :: (Eq a, Ord a) => a -> BinTree a -> BinTree a
> delete _ Empty = Empty
> delete x (Node y Empty r) | x == y = r
> delete x (Node y l Empty) | x == y = l
> delete x (Node y l r) | x < y = (Node y (delete x l) r)
> 	   	     	| x > y = (Node y l (delete x r))
>			| x == y = (Node y' l t')
>			where y' = minbt r
>			      t' = delete y' r

Find the smallest (left-most) element in a BST

> minbt :: BinTree a -> a
> minbt Empty = error "Can't find min of empty tree"
> minbt (Node x Empty _) = x
> minbt (Node x l _) = minbt l

Return a list of the items in a BST.

This can be done with simple recursion:

> flattenbt :: Eq a => BinTree a -> [a]
> flattenbt Empty = []
> flattenbt (Node x l r) = (flattenbt l) ++ [x] ++ (flattenbt r)

But this requires multiple uses of the concatenation operator (++), which
makes it inefficient.

Determine whether two BSTs contain the same items.

To do this, we just need to flatten the two trees, and then compare two
lists.

> equals :: Eq a => BinTree a -> BinTree a -> Bool
> equals t1 t2 = (flattenbt t1) == (flattenbt t2)


Example trees for testing:

> t1 = Empty
> t2 = Node 1 Empty Empty
> t3 = Node 2 t2 Empty
> t4 = Node 3 t2 t3
