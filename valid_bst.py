class TreeNode:
    def __init__(self, value=0, left=None, right=None):
        self.value = value
        self.left = left
        self.right = right

def is_valid_bst(node, left=float('-inf'), right=float('inf')):
    # An empty tree is a valid BST
    if not node:
        return True
    
    # The current node's value must be between the values of left and right
    if not (left < node.value < right):
        return False
    
    # Recursively check the left and right subtree
    return (is_valid_bst(node.left, left, node.value) and
            is_valid_bst(node.right, node.value, right))

# Example usage:
# Constructing a simple BST
#       2
#      / \
#     1   3
root = TreeNode(2)
root.left = TreeNode(1)
root.right = TreeNode(3)

print(is_valid_bst(root))  # Output: True