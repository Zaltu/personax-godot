extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the current button to the exit game functionality.
	self.connect("pressed", self, "__TEMP_velvet_demo")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func __TEMP_velvet_demo():
	# This simulates new game, so initialize state here
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	state.init()  # luigiburn
	state.start()  # luigiburn
	loading.goto_scene("envs/velvet/velvet.tscn")
