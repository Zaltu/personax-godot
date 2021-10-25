extends Node

const TARGET_OVERLAY_PATH = "res://envs/battle/TargetOverlay.tscn"

var LOCK_ON = {  # CONST, but funcrefs are apparently not allowed in consts (no true status)
	"All Enemy": funcref(self, "allenemy"),
	"One Enemy": funcref(self, "oneenemy"),
	"All Ally": funcref(self, "allally"),
	"One Ally": funcref(self, "oneally"),
	"Self": funcref(self, "watashi"),
}

var arrows = []

func allenemy(_allies, enemies):
	for enemymodel in enemies:
		_add_arrow(enemymodel)

func oneenemy(_allies, enemies):
	_add_arrow(enemies[0])

func allally(allies, _enemies):
	for allymodel in allies:
		_add_arrow(allymodel)

func oneally(allies, _enemies):
	_add_arrow(allies[0])

func watashi(update):  # self
	pass

func _add_arrow(model):
	arrows.append(load(TARGET_OVERLAY_PATH).instance())
	add_child(arrows[-1])
	arrows[-1].hoverover(model)

func free_resources():
	for arrow in arrows:
		arrow.queue_free()
	arrows = []
