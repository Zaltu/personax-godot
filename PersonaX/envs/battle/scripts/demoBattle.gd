extends Spatial

const BATTLE_MUSIC = "res://envs/battle/assets/audio/massdestruction.ogg"

# Spacers should be calculated dynamically, TODO
# Char name, char name
const PARTY_RES_PATH = "res://assets/3d/chars/{0}/{1}.glb"
const PARTY_Z_OFFSET = 10
const PARTY_SPACER = 20
# Persona arcana, persona name
const PERSONA_RES_PATH = "res://assets/3d/personas/{0}/{1}/{2}.glb"
# Enemy name, enemy name (TODO)
#const ENEMY_RES_PATH = "res://assets/3d/enemies/{0}/{1}.tscn"
const ENEMY_Z_OFFSET = -10
const ENEMY_SPACER = 20

onready var party_models = []
onready var enemy_models = []
onready var cam = get_node("BattleCamera")

func _ready():
	# We assume that the GSV is already in the battle context when Godot is
	# asked to display it.
	var update = state.getUpdate()
	# Fetch list of participants, both allies and enemies
	var participants = update["participants"]
	var partylen = len(update["iparty"])
	var enemylen = len(update["ienemy"])
	var target
	for ially in update["iparty"]:
		# -1 cause Lua omegalul
		spawn_participant(update["participants"][ially-1], partylen, true)
		if ially == update["open"]:  # Unadjusted indexes
			target = party_models[-1]
	for ienemy in update["ienemy"]:
		# -1 cause Lua omegalul
		spawn_participant(update["participants"][ienemy-1], enemylen, false)
	
	audio.play_music(BATTLE_MUSIC)
	activate_camera(target)
	process_turns(update)

func spawn_participant(participant, listlength, ispartymember):
	# A bit messy since the "real" enemies won't be in the persona list.
	# This will need to be cleaned up when the real enemy resource structure
	# is available
	if ispartymember:
		var partymodel = load(
			PARTY_RES_PATH.format([
				participant["name"].to_lower(),
				participant["name"].to_lower()
			])
		).instance()
		add_child(partymodel)
		var xoffset = (((listlength-1)*PARTY_SPACER)/2)-(PARTY_SPACER*(len(party_models)))
		party_models.append((partymodel))
		partymodel.translate(Vector3(xoffset, 0, PARTY_Z_OFFSET))
		partymodel.scale_object_local(Vector3(0.33, 0.33, 0.33))
		partymodel.look_at(Vector3(0, 0, ENEMY_Z_OFFSET), Vector3(0, 1, 0))
	else:
		var enemymodel = load(
			PERSONA_RES_PATH.format([
				participant["persona"]["arcana"],
				participant["name"].to_lower(),
				participant["name"].to_lower()
			])
		).instance()
		add_child(enemymodel)
		var xoffset = (((listlength-1)*ENEMY_SPACER)/2)-(ENEMY_SPACER*(len(enemy_models)))
		enemy_models.append(enemymodel)
		enemymodel.translate(Vector3(xoffset, 0, ENEMY_Z_OFFSET))
		enemymodel.scale_object_local(Vector3(3, 3, 3))
		enemymodel.look_at(Vector3(0, 0, PARTY_Z_OFFSET), Vector3(0, 1, 0))


func activate_camera(target):
	cam.set_visible(true)
	cam.sift_over_to(target, Vector3(0, 0, ENEMY_Z_OFFSET))
	cam.set_interpolation_enabled(true)
	

func process_turns(full_update):
	pass
