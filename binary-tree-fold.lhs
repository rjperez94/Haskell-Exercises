Binary tree folds

Binary trees are defined as:

> data BinTree a = Empty | Node a (BinTree a) (BinTree a)
>      	       	   deriving (Show, Eq)

Defining binary tree fold

A binary tree fold takes as arguments a function, a unit and a binary tree.
The function takes the value at the root of a non-empty tree, along with the
results of applying the fold to the two subtrees, and returns a value of the
same type as the unit, which is returned when the given tree is empty.

Thus, the type of btfold is:

> btfold :: (a -> b -> b -> b) -> b -> (BinTree a) -> b

and the function is defined as:

> btfold _ u Empty = u

> btfold f u (Node r lt rt) = f r (btfold f u lt) (btfold f u rt)

Using binary tree fold

Test whether the tree t contains a node with label x.

> bthas :: Eq a => a -> (BinTree a) -> Bool
> bthas x t = btfold (\u v w -> x == u || v || w) False t

Test whether trees t1 and t2 are identical.

We can't implement equatlbt using a fold because it needs to traverse two
trees at once.

Construct a mirror image of tree t.

> btreflect :: Show a => (BinTree a) -> (BinTree a)
> btreflect t = btfold (\u v w -> Node u w v) Empty t

Construct the fringe of tree t.

> btfringe :: BinTree a -> [a]
> btfringe t = btfold (\u  v w -> v ++ [u] ++ w) [] t

We can't implement the forward progation versions with a fold.

Check whether tree t is full.

We can't implement the "full" test using a fold, because we need to inspect
the subtrees (to see whether they are empty ir not) as well as applying the
function to them.


Some test case

> t1 = Empty

> t2 = Node 1 Empty Empty

> t3 = Node 1 (Node 2 Empty Empty) Empty

Note that all of these functions can be defined in a point-free fashion, for
example we can define btsize as:

> btsize' :: (BinTree a) -> Int
> btsize' = btfold (\_ v w -> 1 + v + w) 0

