extends Label

const NULLCOLOR = Color(0.5, 0.5, 0.5, 1)
const NORMALCOLOR = Color(0, 0, 0, 1)

var parent = null
var children = []

func _ready():
	set("custom_colors/font_color", NULLCOLOR)

func initialize(text, pparent):
	set_text(text)
	self.parent = pparent

func addChild(newChild):
	if newChild.parent:
		return false
	self.children.append(newChild)
	newChild.parent = self
	self.self_modulate = NORMALCOLOR
	#set("custom_colors/font_color", NORMALCOLOR)
	return true

func getChildren():
	return self.children

func getParent():
	return self.parent
