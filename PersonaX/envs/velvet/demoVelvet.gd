extends Spatial

var timer;
var textbox_scene;
var music_delay = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Dialog").play()
	textbox_scene = load("res://ui/textbox/textbox.tscn").instance()


func on_music_delay_timer_done():
	timer.stop()
	get_node("Camera/AnimationPlayer").play("Fade")

func _on_Dialog_finished():
	set_visible(true)
	get_node("AriaOfTheSoul").play()
	timer = Timer.new()
	timer.set_wait_time(music_delay)
	timer.connect("timeout", self, "on_music_delay_timer_done")
	add_child(timer)
	timer.start()


func _on_AnimationPlayer_animation_finished(_anim_name):
	# Hide the fader mesh so the viewport isn't rendering a fucking 0-alpha
	# shader every god damn frame
	get_node("Camera/AnimationPlayer/Fader").set_visible(false)
	add_child(textbox_scene)
	textbox_scene.display_text({
		"speaker": "Igor",
		"text": "My name is Igor",
		"emotion": "NORMAL",
		"alt": true
	})
