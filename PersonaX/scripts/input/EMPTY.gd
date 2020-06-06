extends Node


func process_update(_update):
	# Super-temp
	loading.goto_scene("ui/mainmenu/mainmenu.tscn")


func processInput(_event):
	print("Dumping input:")
	print(_event)
