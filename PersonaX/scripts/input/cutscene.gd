extends Node

var _index = 0

func process_update(textevent):
	# Textbox node shoudl exist if we're getting cutscene context events.
	# The "Spatial" here is :monkaS: ngl
	get_node("/root/Spatial/Textbox").display_text(textevent)
	

func processInput(event):
	if event.is_action_pressed("ui_accept"):
		var update = state.sendStateEvent({"key": "cutscene", "index": _index})
		inputhandler.process_update(update)
	elif event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
		# check if possible to toggle UI index
		# toggle UI index and var index here
		pass  # Tried to change answer selection

# TODO handling of index should be done purely in the UI or here, but this is
# much easier to manage probably, since the concept of "0" options in the UI is
# difficult to represent in a non-unique fashion.
