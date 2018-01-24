class Node {

	int key;
	String name;

	Node leftChild;
	Node rightChild;

	Node(int key, String name) {
		this.key = key;
		this.name = name;
	}

}

/*
Instead of making a tree search, we can use Huffman codes as keys
and just check if the first K numbers of both keys are the same. This
key can be a string of 64 options 0-9 aA-zZ - _
So,
By limiting the number of children, the problem of finding the LCA becomes
much faster: instead of O(h) where h is height, which is between O(n)
(worst case) and O(log(n)) (best case) if the tree is balanced, it becomes
O(min(d1, d1, d3, ... dn)) where dn is the depth of the nth node = O(1).
*/