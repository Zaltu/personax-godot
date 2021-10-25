extends Node

var _index = 0


func process_update(textevent):
	# The "Spatial" here is :monkaS: ngl
	get_node("/root/Spatial/Textbox").display_text(textevent)
	

func processInput(event):
	if get_node("/root/battle/BattleMenu").visible:
		if event.is_action_pressed("ui_down"):
			get_node("/root/battle/BattleMenu").selection_down()
		elif event.is_action_pressed("ui_up"):
			get_node("/root/battle/BattleMenu").selection_up()
		elif event.is_action_pressed("ui_accept"):
			get_node("/root/battle/BattleMenu").selection_enter()
		elif event.is_action_pressed("ui_back"):
			get_node("/root/battle/BattleMenu").selection_back()
	elif get_node("/root/battle").targetting:
		if event.is_action_pressed("ui_back"):
			get_node("/root/battle").revert_targetting()
