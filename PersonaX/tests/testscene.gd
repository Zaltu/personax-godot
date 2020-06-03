extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#print(get_node("NORMAL").get_position())
	#print(get_node("NORMAL_ALT").get_position())
	get_node("NORMAL").translate(Vector2(300, 300))
	get_node("NORMAL_ALT").translate(Vector2(300, 300))
	#print(get_node("NORMAL").get_position())
	#print(get_node("NORMAL_ALT").get_position())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
