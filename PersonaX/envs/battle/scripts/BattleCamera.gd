extends Camera

# Based on
# https://github.com/godot-extended-libraries/godot-interpolated-camera3d
# under MIT license

# Offset to the camera relative to the target position
const PULL_BACK = Vector3(0, 30, 20)

# Desired camera look_at for rotation
var looking_at_target = Vector3(0, 0, 0)

# The factor to use for asymptotical translation lerping.
# If 0, the camera will stop moving. If 1, the camera will move instantly.
var translate_speed := 0.1

# The factor to use for asymptotical rotation lerping.
# If 0, the camera will stop rotating. If 1, the camera will rotate instantly.
var rotate_speed := 0.1

# The node to target.
var target: Transform

# Enable/disable interpolation
var enabled = false

func set_interpolation_enabled(enable):
	enabled = enable


func sift_over_to(bullseye, lookat):
	# bullseye is target to move to
	# lookat is location to look at, usually, another target's transform.
	target = bullseye
	looking_at_target = lookat

func zap_over_to(bullseye, lookat):
	target = bullseye
	looking_at_target = lookat
	var target_xform = target
	target_xform = target_xform.looking_at(looking_at_target, Vector3(0, 1, 0))
	set_global_transform(target_xform)


func set_speed(multiplier):
	# Should be a number between 0 and 1.
	rotate_speed = multiplier
	translate_speed = multiplier


func _process(delta: float) -> void:
	if not enabled:
		return

	# TODO: Fix delta calculation so it behaves correctly if the speed is set to 1.0.
	var translate_factor = translate_speed * delta * 10
	var rotate_factor = rotate_speed * delta * 10

	var target_xform = target
	# Adjust to BattleCamera specs
	target_xform = target_xform.translated(PULL_BACK)
	target_xform = target_xform.looking_at(looking_at_target, Vector3(0, 1, 0))
	# Interpolate the origin and basis separately so we can have different translation and rotation
	# interpolation speeds.
	var local_transform_only_origin := Transform(Basis(), get_global_transform().origin)
	var local_transform_only_basis := Transform(get_global_transform().basis, Vector3())
	local_transform_only_origin = local_transform_only_origin.interpolate_with(target_xform, translate_factor)
	local_transform_only_basis = local_transform_only_basis.interpolate_with(target_xform, rotate_factor)
	set_global_transform(Transform(local_transform_only_basis.basis, local_transform_only_origin.origin))
