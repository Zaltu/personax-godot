extends Spatial

const WELCOME_SOUND = "res://envs/velvet/assets/audio/welcome_clean.ogg"
const ARIA_OF_THE_SOUL = "res://envs/velvet/assets/audio/aria.ogg"

var timer;
var textbox_scene;
var music_delay = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	audio.dialog.connect("finished", self, "_on_Dialog_finished")
	audio.play_dialog(WELCOME_SOUND)
	textbox_scene = load("res://ui/textbox/textbox.tscn").instance()


func _on_music_delay_timer_done():
	timer.stop()
	get_node("Camera/AnimationPlayer").play("Fade")

func _on_Dialog_finished():
	audio.dialog.disconnect("finished", self, "_on_Dialog_finished")
	set_visible(true)
	audio.play_music(ARIA_OF_THE_SOUL)
	# Wait for dramatic effect
	timer = Timer.new()
	timer.set_wait_time(music_delay)
	timer.connect("timeout", self, "_on_music_delay_timer_done")
	add_child(timer)
	timer.start()


func _on_AnimationPlayer_animation_finished(_anim_name):
	# Temp for scene exit
	# Texbox is already in scene. Can't re-add it
	if textbox_scene.is_inside_tree():
		# Wait a few seconds for dramatic effect
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().quit()
		return
	# Hide the fader mesh so the viewport isn't rendering a fucking 0-alpha
	# shader every god damn frame
	get_node("Camera/AnimationPlayer/Fader").set_visible(false)
	
	add_child(textbox_scene)
	textbox_scene.display_text(state.getUpdate())
