extends Node

#onready var freeroam = load("scripts/input/EMPTY.gd").instance()
#onready var dungeon = load("scripts/input/EMPTY.gd").instance()
onready var cutscene = load("scripts/input/cutscene.gd").new()
#onready var link = load("scripts/input/EMPTY.gd").instance()
#onready var inline = load("scripts/input/EMPTY.gd").instance()
#onready var shop = load("scripts/input/EMPTY.gd").instance()
#onready var velvet = load("scripts/input/EMPTY.gd").instance()
#onready var battle = load("scripts/input/EMPTY.gd").instance()
#onready var calendar = load("scripts/input/EMPTY.gd").instance()

onready var EMPTY = load("scripts/input/EMPTY.gd").new()

onready var keymap = {
	"cutscene": cutscene
}

onready var active = EMPTY

func _ready():
	# This is all kind of shitty temp. Input handlers should be instanced on
	# context change, which is validated in state.
	add_child(cutscene)
	add_child(EMPTY)

func _input(event):
	#print(get_tree())
	# Globally capture all input events and redirect them to the correct
	# context based on the current runtime
	active.processInput(event)

func set_active(context):
	active = keymap.get(context, EMPTY)

func process_update(update):
	active.process_update(update)
