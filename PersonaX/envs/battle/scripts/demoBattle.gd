extends Spatial

const BATTLE_MUSIC = "res://envs/battle/assets/audio/massdestruction.ogg"

const PARTICIPANT_PATH = "res://envs/battle/participant.tscn"
# Spacers should be calculated dynamically, TODO
# Char name, char name
const PARTY_RES_PATH = "res://assets/3d/chars/{0}/{1}.glb"
const PARTY_Z_OFFSET = 10
const PARTY_SPACER = 20

# Enemy name, enemy name (TODO)
const ENEMY_RES_PATH = "res://assets/3d/personas/{0}/{1}/{2}.glb"#"res://assets/3d/enemies/{0}/{1}.tscn"
const ENEMY_Z_OFFSET = -10
const ENEMY_SPACER = 20

const music_delay = 4.22


# Target icon generator
const TARGETMANAGER = preload("targetnode.gd")
onready var TargetManager = TARGETMANAGER.new()


onready var party_models = []
onready var enemy_models = []
onready var persona_models = {}  # name: statdict
var open : Node
onready var cam = get_node("BattleCamera")

var struc = [
		{"Attack": null},#funcref(self, "displaytarget")},  TODO
		{"Skill": null},  # Populated dynamically
		{"Persona": null},  # Populated dynamically
		{"Guard": funcref(self, "guarding")},
		{"Item": null},  # Populated dynamically TODO
		{"Scan": null}  # TODO
	]
var targetting = false

var timer
# meme TODO
var ltimer

var update

func _ready():
	# We assume that the GSV is already in the battle context when Godot is
	# asked to display it.
	update = state.getUpdate()
	
	# The TargetManager has no visible elements itself. Add it here.
	add_child(TargetManager)

	var partylen = len(update["iparty"])
	var enemylen = len(update["ienemy"])

	for ially in update["iparty"]:
		# -1 cause Lua omegalul
		spawn_participant(update["participants"][ially-1], partylen, true, ially)
		if ially == update["open"]:  # Unadjusted indexes
			open = party_models[-1]
	for ienemy in update["ienemy"]:
		# -1 cause Lua omegalul
		spawn_participant(update["participants"][ienemy-1], enemylen, false, ienemy)


	setup_battle_menu()
	audio.play_music(BATTLE_MUSIC)
	activate_camera(open)
	timer = Timer.new()
	timer.set_wait_time(music_delay)
	timer.connect("timeout", self, "_on_music_delay_timer_done")
	add_child(timer)
	timer.start()

func spawn_participant(participant, listlength, ispartymember, pindex):
	# A bit messy since the "real" enemies won't be in the persona list.
	# This will need to be cleaned up when the real enemy resource structure
	# is available
	if ispartymember:
		var partymodel = load(PARTICIPANT_PATH).instance()
		add_child(partymodel)
		partymodel.setup(
			PARTY_RES_PATH.format([
				participant["name"].to_lower(),
				participant["name"].to_lower()
			]),
			participant,
			pindex
		)
		# Signs are reversed here to maintain left-right order...
		var xoffset = -(((listlength-1)*PARTY_SPACER)/2)+(PARTY_SPACER*(len(party_models)))
		party_models.append((partymodel))
		partymodel.translate(Vector3(xoffset, 0, PARTY_Z_OFFSET))
		partymodel.scale_object_local(Vector3(0.33, 0.33, 0.33))
		partymodel.look_at(Vector3(0, 0, ENEMY_Z_OFFSET), Vector3(0, 1, 0))
	else:
		var enemymodel = load(PARTICIPANT_PATH).instance()
		add_child(enemymodel)
		enemymodel.setup(
			ENEMY_RES_PATH.format([
				participant["persona"]["arcana"],
				participant["name"].to_lower(),
				participant["name"].to_lower()
			]),
			participant,
			pindex
		)
		# Signs are reversed here to maintain left-right order...
		var xoffset = -(((listlength-1)*ENEMY_SPACER)/2)+(ENEMY_SPACER*(len(enemy_models)))
		enemy_models.append(enemymodel)
		enemymodel.translate(Vector3(xoffset, 0, ENEMY_Z_OFFSET))
		enemymodel.scale_object_local(Vector3(3, 3, 3))
		enemymodel.look_at(Vector3(0, 0, PARTY_Z_OFFSET), Vector3(0, 1, 0))

func activate_camera(ptarget):
	cam.set_visible(true)
	cam.sift_over_to(ptarget.get_global_transform(), Vector3(0, 0, ENEMY_Z_OFFSET))
	cam.set_interpolation_enabled(true)


func setup_battle_menu():
	# Get current persona's spells
	var currentparticipant = update["participants"][update["open"]-1]  # -1 cause lua omegalul
	var spell_list = currentparticipant["persona"]["spellDeck"]
	while "" in spell_list:  # Oof
		spell_list.erase("")
	var spell_use_list = []
	for spell in spell_list:
		spell_use_list.append({spell: funcref(self, "displaytarget")})
	# For persona swapping
	var persona_list = currentparticipant.get("personadeck", null)
	var persona_use_list = []
	if persona_list and len(persona_list) > 1:  # Can't change personas if you only have one
		for personaname in persona_list:
			if personaname == currentparticipant["persona"]["name"]:  # Can select current persona
				persona_use_list.append({personaname: null})
			else:
				persona_use_list.append({personaname: funcref(self, "change_persona")})
	struc[1]["Skill"] = spell_use_list  # hard-coded index
	struc[2]["Persona"] = persona_use_list if persona_use_list else null  # hard-coded index
	var menunode = get_node("BattleMenu")
	menunode.setup_menu(_nodify(struc))


func _nodify(pstruc, parent=null):
	if not pstruc:
		return []
	if pstruc is FuncRef:
		if parent:
			parent.addChild(pstruc)
		return []
	var newnodes = []
	for entry in pstruc:
		newnodes.append(load("res://ui/textbox/elements/selectable.tscn").instance())
		if parent:
			parent.addChild(newnodes[-1])
		newnodes[-1].initialize(entry.keys()[-1], parent)
		newnodes += _nodify(entry.values()[-1], newnodes[-1])
	return newnodes

func _on_music_delay_timer_done():
	timer.stop()
	get_node("BattleMenu").set_visible(true)
	process_turns(state.getUpdate())


func displaytarget(spellname):  # Spellname is sent to model to determine target types
	get_node("BattleMenu").set_visible(false)
	var spellinfo = state.sendStateEvent(_fetchSpellDataEvent(spellname))
	#self.open.set_visible(false)
	#TargetManager.LOCK_ON[spellinfo["target"]].call_func(party_models, enemy_models)
	self.targetting = TargetManager.LOCK_ON[spellinfo["target"]]
	self.targetting.call_func(party_models, enemy_models)

func _fetchSpellDataEvent(spellname):
	return {
		"key": "battle.spellrequest",
		"spellDataRequest": spellname
	}

func revert_targetting():
	TargetManager.free_resources()
	get_node("BattleMenu").set_visible(true)
	self.targetting = false
	get_node("BattleCamera").sift_over_to(
		open.get_global_transform(),
		Vector3(0, 0, ENEMY_Z_OFFSET)
	)

func change_target(indexupdate):
	TargetManager.selectedindex += indexupdate
	TargetManager.free_resources()
	self.targetting.call_func(party_models, enemy_models)


func guarding(_text):  # TODO
	pass


func change_persona(persona):
	# Hide and empty menu
	$BattleMenu.set_visible(false)
	$BattleMenu.wipe_menu()
	
	# Let the model know we have a new persona.
	# Somewhat risky deferred call, but the animation length should cover it easily...
	call_deferred("_update_persona_change_registry", persona)
	# Move camera to center
	# TODO
	# Follow persona
	$BattleCamera.zap_over_to(
		Transform(Vector3(0,0,0),Vector3(0,0,0),Vector3(0,0,0),Vector3(0,10,0)),
		self.open.personas[persona].get_global_transform().origin
	)
	# Display new persona model
	self.open.personas[persona].set_visible(true)
	# Trigger spawn animation
	# TODO
	ltimer = Timer.new()
	ltimer.set_wait_time(music_delay)
	ltimer.connect("timeout", self, "_on_spawn_anim_complete", [persona])
	add_child(ltimer)
	ltimer.start()
	# On animation complete, revert camera
	# connect... TODO


func _update_persona_change_registry(persona):
	update = state.sendStateEvent(
		{
			"key": "battle.personachange",
			"personachangeIndex": update["open"],  # Do not adjust
			"personachangeNewPersona": persona
		}
	)
	# hacky, but prevents player from changing personas more than once.
	# update will get renewed by the next playable turn
	update["participants"][update["open"]-1].erase("personadeck")  # Adjust from lua
	setup_battle_menu()

func _on_spawn_anim_complete(persona):
	# stop the damn timer
	ltimer.stop()
	# Revert camera
	$BattleCamera.sift_over_to(
		self.open.get_global_transform(), Vector3(0, 0, ENEMY_Z_OFFSET)
	)
	# Hide persona model
	open.personas[persona].set_visible(false)
	$BattleMenu.set_visible(true)


func fire_the_cannons():
	pass


func process_turns(_full_update):
	pass
