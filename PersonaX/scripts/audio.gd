extends Node

const VOLUME_LOWER_EFFECT = -10
const TWEEN_TRANSITION_DURATION = 1

onready var music = AudioStreamPlayer.new()
onready var dialog = AudioStreamPlayer.new()
onready var sfx = AudioStreamPlayer.new()
onready var tween_in = Tween.new()

func _ready():
	# Set busses
	music.bus = "Music"
	dialog.bus = "Voice"
	sfx.bus = "SFX"

	# Set all to all surround channels
	music.set_mix_target(1)
	dialog.set_mix_target(1)
	sfx.set_mix_target(1)
	
	# Connection for OST volume handling based on dialog being played
	dialog.connect("finished", self, "_on_dialog_finished")

	# Add all to base scene
	#get_node("/root").call_deferred("add_child", music)
	get_node("/root").call_deferred("add_child", dialog)
	get_node("/root").call_deferred("add_child", sfx)
	get_node("/root").call_deferred("add_child", tween_in)


func play_music(ogg_path):
	music.stop()
	music.stream = load(ogg_path)
	music.play()


func play_dialog(ogg_path):
	if tween_in.is_active():
		tween_in.stop_all()
	if music.is_playing():
		# Lower music volume a bit
		music.set_volume_db(VOLUME_LOWER_EFFECT)
	dialog.stop()
	dialog.stream = load(ogg_path)
	dialog.play()


func play_sfx(ogg_path):
	sfx.stop()
	sfx.stream = load(ogg_path)
	sfx.play()


func _on_dialog_finished():
	if music.is_playing():
		# Return volume to full on music
		tween_in.interpolate_property(
			music,
			"volume_db",
			VOLUME_LOWER_EFFECT,
			0,
			TWEEN_TRANSITION_DURATION
		)
		tween_in.start()
