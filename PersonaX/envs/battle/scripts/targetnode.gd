extends Node


var LOCK_ON = {  # CONST, but funcrefs are apparently not allowed in consts (no true status)
	"All Enemy": funcref(self, "allenemy"),
	"One Enemy": funcref(self, "oneenemy"),
	"All Ally": funcref(self, "allally"),
	"One Ally": funcref(self, "oneally"),
	"Self": funcref(self, "watashi"),
}

var arrows = []
var selectedindex = 0

func allenemy(_allies, enemies):
	for enemymodel in enemies:
		display_arrow(enemymodel)

func oneenemy(_allies, enemies):
	if selectedindex < 0:
		selectedindex = len(enemies)-1
	elif selectedindex >= len(enemies):
		selectedindex = 0
	display_arrow(enemies[selectedindex])
	focus_camera(enemies[selectedindex], null)

func allally(allies, _enemies):
	for allymodel in allies:
		display_arrow(allymodel)

func oneally(allies, _enemies):
	if selectedindex < 0:
		selectedindex = len(allies)-1
	elif selectedindex >= len(allies):
		selectedindex = 0
	display_arrow(allies[selectedindex])
	focus_camera(allies[selectedindex], null)

func watashi(_update):  # self TODO
	display_arrow(get_parent().open)  # Bit meme, might not work

func display_arrow(model):
	arrows.append(model.get_node("Target"))
	arrows[-1].set_visible(true)

func focus_camera(model1, _model2):  # TODO model2
	get_node("../BattleCamera").sift_over_to(
		Transform(Vector3(0,0,0),Vector3(0,0,0),Vector3(0,0,0),Vector3(0,20,0)),
		model1.get_global_transform().origin+Vector3(0, 10, 0)
	)

func free_resources():
	for arrow in arrows:
		arrow.set_visible(false)
	arrows = []
