extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(OS.get_executable_path().get_base_dir().replace("\\", "/"))
	# Connect the current button to the exit game functionality.
	self.connect("pressed", self, "__TEMP_velvet_demo")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func __TEMP_velvet_demo():
	# This simulates new game, so initialize state here
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	state.init()  # luigiburn
	state.start()  # luigiburn
	loading.goto_scene("envs/velvet/velvet.tscn")


#func list_files_in_directory(path):
#	var files = []
#	var dir = Directory.new()
#	dir.change_dir(path)
#	dir.list_dir_begin()
#	while true:
#		var file = dir.get_next()
#		if file == "":
#			break
#		elif not file.begins_with("."):
#			files.append(file)
#	dir.list_dir_end()
#	return files
