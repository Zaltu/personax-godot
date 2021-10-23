extends Control

var topx = 0
var width

var selectables = []

func _ready():
	width = get_rect().size.x
	var childnodes = self.get_children()
	var i = 0
	for childnode in childnodes:
		print(childnode)
		_adjust(childnode, i)
		i += 1

func _adjust(node, index):
	# Set element start position to follow previous element
	# Or if it's the first element, set it to this node's start
	var topy
	if index == 0:
		# The container's start position
		topy = 0
	else:
		# The previous element's end position (start + size) + 1 pixel
		topy = self.get_children()[index-1].get_rect().position.y+self.get_children()[index-1].get_rect().size.y

	# Set position of new element to established location
	print("Setting position to:")
	print(topx, ", ", topy)
	node.set_position(Vector2(topx, topy))

	# Generate the element's new height based on the container's width
	var height = 0
	if not node.get_rect().size.x == 0:
		height = node.get_rect().size.y * get_rect().size.y / node.get_rect().size.x
	# Set the new size, width scaled to the container's
	print("Setting size to:")
	print(width, ", ", height)
	if node is TextureRect:
		node.expand = true
	node.set_size(Vector2(width, height))

func append(node):
	self.add_child(node)
	_adjust(node, get_child_count()-1)
