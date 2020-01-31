extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the current button to the exit game functionality.
	self.connect("pressed", self, "__TEMP_velvet_demo")


func __TEMP_velvet_demo():
	#self._crash()
	get_tree().change_scene("envs/velvet/velvet.tscn")

# Completely exit the game. Only use for end of session.
func _crash():
	self.set_disabled(true)
	var state = PXLua.new()
	print("Godot State Initialized\n", state)
