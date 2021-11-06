extends Spatial

# Persona arcana, persona name
const PERSONA_RES_PATH = "res://assets/3d/personas/{0}/{1}/{2}.glb"

var model
var index
var personas = {}

func _ready():
	pass

func setup(modelpath, participant, pindex):  # TODO SP
	self.index = pindex
	self.model = load(modelpath).instance()
	add_child(self.model)
	$Target/Viewport/TextureProgress.max_value = participant["maxhp"]
	$Target/Viewport/TextureProgress.value = participant["hp"]
	$Target.hoverover()
	load_personas(participant.get("personadeck", []))

func load_personas(persona_list):
	for persona in persona_list:
		self.personas[persona] = load(PERSONA_RES_PATH.format([
					persona_list[persona]["arcana"],
					persona_list[persona]["name"].to_lower(),
					persona_list[persona]["name"].to_lower()
		])).instance()
		self.personas[persona].scale_object_local(Vector3(3, 3, 3))
		self.personas[persona].translate(Vector3(0, 7.5, 0))
		self.personas[persona].set_visible(false)
		add_child(self.personas[persona])
