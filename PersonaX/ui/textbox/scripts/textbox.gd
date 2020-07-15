extends Control

const CUTSCENE_AUDIO_PATH = "res://assets/audio/cutscene/{0}/{1}.ogg"
const TEXT_SPEED_VALUE = 10  # Number of characters/second

onready var twext = get_node("DisplayTwext")

func display_text(textevent):
	# Hide boxarrow
	get_node("Image/boxarrow").set_visible(false)

	# Set the name of the speaker
	print(textevent)
	get_node("Image/Speaker").set_text(textevent["speaker"])
	
	# Set the actual text
	# TODO vn-style text fade w/ display %
	var textnode = get_node("Image/Text")
	textnode.set_visible_characters(0)
	textnode.set_text(textevent["text"])
	twext.interpolate_property(
		textnode,
		"visible_characters",
		0, textevent["text"].length(),
		textevent["text"].length()/TEXT_SPEED_VALUE
	)
	twext.start()
	
	var speaker_node = get_node("SpeakerSprite")
	if textevent["speaker"] == null:
		get_node("SpeakerSprite").set_visible(false)
	elif speaker_node.get_current_speaker() != textevent["speaker"]:
		# Set the sprite of the speaker if it's new
		get_node("SpeakerSprite").set_speaker_sprite(
			textevent["speaker"],
			textevent["emotion"],
			textevent.get("alt", false)
		)
	# Since it's often loaded early. A waste maybe?
	if not is_visible():
		set_visible(true)

	# Try to play a voice line
	_try_audio(textevent)

func _try_audio(textevent):
	var path = CUTSCENE_AUDIO_PATH.format(
		[
			textevent.get("cutid"),
			textevent.get("index")
		]
	)
	# WATCH OUT, FOR SOME REASON LUA PASSES NO INDEX ON THE FIRST EVENT OF A CUTSCENE!!!
	# FILE IS CALLED Null.ogg
	if not ResourceLoader.exists(path):
		# No voice file for this line
		return
	var audioplayer = get_node("AudioPlayer")
	audioplayer.set_stream(
		load(path)
	)
	audioplayer.play()



func _on_DisplayTwext_tween_completed(_object, _key):
	# Assert the whole text is visible, display boxarrow.
	get_node("Image/Text").set_visible_characters(-1)
	get_node("Image/boxarrow").set_visible(true)
