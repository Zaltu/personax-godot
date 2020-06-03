extends Sprite

const scale_factor = 2.5

onready var screen_size = get_viewport().size
onready var alt_node = get_node("../AltSpeakerSprite")
var base_sprite_path = "res://assets/2d/chars/{0}/{1}.tres"
var current_speaker = null

func get_current_speaker():
	return current_speaker

func set_speaker_sprite(speaker, emotion, eyes=false):
	# Hide when changing to avoid the resize frames maybe
	set_visible(false)
	# Get path to atlastexture resource
	var this_resource = base_sprite_path.format([speaker, emotion.to_upper()])
	set_texture(load(this_resource))

	# Double size
	apply_scale(Vector2(scale_factor, scale_factor))
	# Get offset center of scaled texture from bottom right of screen
	var bottom_corner = get_rect().end
	var newx = screen_size.x - (bottom_corner.x * scale_factor)
	var newy = screen_size.y - (bottom_corner.y * scale_factor)
	# Set position
	set_position(Vector2(newx, newy))

	# TODO
	# error handling (no sprite for speaker/emotion/alt)

	# TODO
	if eyes:
		var alt_texture = load(base_sprite_path.format([speaker, emotion+"_ALT"]))
		alt_node.set_texture(alt_texture)
		alt_node.apply_scale(Vector2(scale_factor, scale_factor))
		alt_node.set_position(Vector2(newx, newy))
		alt_node.set_visible(true)
	elif alt_node.is_visible():
		alt_node.set_visible(false)
	set_visible(true)
