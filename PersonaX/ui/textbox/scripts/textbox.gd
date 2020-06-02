extends Control


func display_text(textevent):
	# Set the name of the speaker
	get_node("Image/Speaker").set_text(textevent["speaker"])
	# Set the actual text
	# TODO vn-style text fade w/ display %
	get_node("Image/Text").set_text(textevent["text"])
	# Set the sprite of the speaker
	get_node("SpeakerSprite").set_speaker_sprite(
		textevent["speaker"],
		textevent["emotion"]
	)
