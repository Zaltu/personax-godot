extends Control

var selectables = []
var selectedindex = 0

var structure


func _selection_hover():
	selectables[selectedindex].get_node("Overlay").set_visible(true)

func wipe_menu():
	# Empty the list of options.
	# Careful with this
	var cont = get_node("VBoxContainer")
	for selector in cont.get_children():
		cont.remove_child(selector)
		selector.get_node("Overlay").set_visible(false)
		#selector.queue_free()
	selectables = []

func setup_menu(items):
	self.structure = items
	self.selectables = []
	self.selectedindex = 0
	var topnodes = []
	for item in structure:
		if not item.getParent():
			topnodes.append(item)
	_update_menu(topnodes)

func _update_menu(items):
	for item in items:
		selectables.append(item)
		item.set_visible(true)
		get_node("VBoxContainer").add_child(selectables[-1])
	selectedindex = 0
	_selection_hover()
	

func selection_up():
	if selectedindex == 0:
		return
	selectables[selectedindex].get_node("Overlay").set_visible(false)
	selectedindex -= 1
	_selection_hover()

func selection_down():
	if selectedindex == len(selectables)-1:
		return
	selectables[selectedindex].get_node("Overlay").set_visible(false)
	selectedindex += 1
	_selection_hover()

func selection_enter():
	var children = selectables[selectedindex].getChildren()
	if not children:
		return
	wipe_menu()
	#if nextlevel[selectedindex] is FuncRef:
	#	nextlevel[selectedindex].call_func()
	_update_menu(children)

func selection_back():
	var old_list = []
	if not selectables[selectedindex].parent:
		# We're on a top node
		return
	for node in self.structure:
		if node.parent == selectables[selectedindex].parent.parent:
			old_list.append(node)
	wipe_menu()
	_update_menu(old_list)
