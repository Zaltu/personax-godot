extends Node


func process_update(_update):
	# Super-temp
	get_node("/root/Spatial/Camera/AnimationPlayer/Fader").set_visible(true)

	get_node("/root/Spatial/Textbox").set_visible(false)
	get_node("/root/Spatial/Camera/AnimationPlayer").play_backwards("Fade")
	# Exit somehow
	#loading.goto_scene("ui/mainmenu/mainmenu.tscn")


func processInput(_event):
	#print("Dumping input:")
	#print(_event)
	pass
