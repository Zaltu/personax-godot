extends Spatial

# Spacers should be calculated dynamically, TODO
# Char name, char name
const PARTY_RES_PATH = "res://assets/3d/chars/{0}/{1}.tscn"
const PARTY_Z_OFFSET = 15
const PARTY_SPACER = 20
# Persona arcana, persona name
const PERSONA_RES_PATH = "res://assets/3d/personas/{0}/{1}/{2}.glb"
# Enemy name, enemy name (TODO)
#const ENEMY_RES_PATH = "res://assets/3d/enemies/{0}/{1}.tscn"
const ENEMY_Z_OFFSET = -15
const ENEMY_SPACER = 20

onready var party_models = []
onready var enemy_models = []

func _ready():
	# We assume that the GSV is already in the battle context when Godot is
	# asked to display it.
	var update = state.getUpdate()
	# Fetch list of participants, both allies and enemies
	var participants = update["participants"]
	var partylen = len(update["iparty"])
	var enemylen = len(update["ienemy"])
	for ially in update["iparty"]:
		# -1 cause Lua omegalul
		spawn_participant(update["participants"][ially-1], partylen, true)
	for ienemy in update["ienemy"]:
		# -1 cause Lua omegalul
		spawn_participant(update["participants"][ienemy-1], enemylen, false)
	
	activate_camera()
	process_turns(update)

func spawn_participant(participant, listlength, partymember):
	# A bit messy since the "real" enemies won't be in the persona list.
	# This will need to be cleaned up when the real enemy resource structure
	# is available
	if partymember:
		print("Loading " + PARTY_RES_PATH.format([participant["name"], participant["name"]]))
		party_models.append(load(
			PARTY_RES_PATH.format([
				participant["name"],
				participant["name"]
			])
		).instance())
		add_child(party_models[-1])
		var xoffset = (((listlength-1)*PARTY_SPACER)/2)-(PARTY_SPACER*(len(party_models)-1))
		party_models[-1].translate(Vector3(xoffset, 0, PARTY_Z_OFFSET))
		party_models[-1].scale_object_local(Vector3(0.5, 0.5, 0.5))
		party_models[-1].look_at(Vector3(0, 0, 0), Vector3(0, 1, 0))
		party_models[-1].rotate_object_local(Vector3(0, 1, 0), PI)
	else:
		print("Loading " + PERSONA_RES_PATH.format([
				participant["persona"]["arcana"],
				participant["name"].to_lower(),
				participant["name"].to_lower()
			]))
		var enemymodel = load(
			PERSONA_RES_PATH.format([
				participant["persona"]["arcana"],
				participant["name"].to_lower(),
				participant["name"].to_lower()
			])
		).instance()
		enemy_models.append(enemymodel)
		add_child(enemymodel)
		var xoffset = (((listlength-1)*ENEMY_SPACER)/2)-(ENEMY_SPACER*(len(enemy_models)-1))
		enemymodel.translate(Vector3(xoffset, 0, ENEMY_Z_OFFSET))
		enemymodel.scale_object_local(Vector3(4, 4, 4))


func activate_camera():
	get_node("InterpolatedCamera").set_visible(true)

func process_turns(full_update):
	pass
