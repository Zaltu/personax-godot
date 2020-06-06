extends Control


func display_text(textevent):
	# Set the name of the speaker
	print(textevent)
	get_node("Image/Speaker").set_text(textevent["speaker"])
	# Set the actual text
	# TODO vn-style text fade w/ display %
	get_node("Image/Text").set_text(textevent["text"])
	
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
