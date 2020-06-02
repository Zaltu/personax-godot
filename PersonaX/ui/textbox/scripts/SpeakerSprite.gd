extends Sprite

var base_sprite_path = "res://assets/2d/chars/{0}/{1}.png"

func set_speaker_sprite(speaker, emotion, eyes=false):
	# Get path to atlastexture resource
	var this_resource = base_sprite_path.format([speaker, emotion])
	set_texture(load(this_resource))

	# TODO
	# error handling (no sprite for speaker/emotion/alt)

	# TODO
	# if eyes
	# display _ALT texture superimposed
