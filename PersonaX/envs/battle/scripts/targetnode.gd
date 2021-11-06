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
var selectedpindex = -1  # Convention for all-target

func allenemy(participants, update):
	for enemyindex in update["ienemy"]:
		display_arrow(participants[enemyindex-1])  # Adjust from Lua

func oneenemy(participants, update):
	if selectedindex < 0:
		selectedindex = len(update["ienemy"])-1
	elif selectedindex >= len(update["ienemy"]):
		selectedindex = 0
	display_arrow(participants[update["ienemy"][selectedindex]-1])  # Lua adjust
	focus_camera(participants[update["ienemy"][selectedindex]-1], null)  # Lua adjust
	selectedpindex = update["ienemy"][selectedindex]  # No Lua adjust

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
	selectedpindex = allies[selectedindex].index

func watashi(_update):  # self TODO
	display_arrow(get_parent().open)  # Bit meme, might not work
	selectedpindex = get_parent().open

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
	selectedpindex = -1
