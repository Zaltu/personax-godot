extends Node

#onready var freeroam = load("scripts/input/EMPTY.gd").new()
#onready var dungeon = load("scripts/input/EMPTY.gd").new()
onready var cutsceneinput = load("scripts/input/cutscene.gd").new()
#onready var link = load("scripts/input/EMPTY.gd").new()
#onready var inline = load("scripts/input/EMPTY.gd").new()
#onready var shop = load("scripts/input/EMPTY.gd").new()
#onready var velvet = load("scripts/input/EMPTY.gd").new()
onready var battleinput = load("scripts/input/battle.gd").new()
#onready var calendar = load("scripts/input/EMPTY.gd").new()

onready var EMPTYinput = load("scripts/input/EMPTY.gd").new()

onready var keymap = {
	"cutscene": cutsceneinput,
	"battle": battleinput
}

onready var active = EMPTYinput

func _ready():
	# This is all kind of shitty temp. Input handlers should be instanced on
	# context change, which is validated in state.
	add_child(cutsceneinput)
	add_child(battleinput)
	add_child(EMPTYinput)

func _input(event):
	#print(get_tree())
	# Globally capture all input events and redirect them to the correct
	# context based on the current runtime
	active.processInput(event)

func set_active(context):
	active = keymap.get(context, EMPTYinput)

func process_update(update):
	active.process_update(update)
