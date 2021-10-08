extends Camera

# Controls how fast the camera moves
export var lerp_speed = 3.0

# Set the target node in the Inspector
export (NodePath) var target_path = null
# Desired position of camera, relative to target. (0, 5, 7), for example, would be behind and above.
export (Vector3) var offset = Vector3(0,5,12)

var target: Spatial = null setget set_target, get_target
func set_target(trgt: Spatial) -> void:	
	if is_instance_valid(target):
		target.queue_free()
		target = null
		set_process(false)
	
	if is_instance_valid(trgt):
		target = Spatial.new()
		trgt.add_child(target)
		set_process(true)


func get_target():
	return target.get_parent() if is_instance_valid(target) else null


func _ready():
	# If a target's been set, get a reference to the node
	if target_path:
		target = get_node(target_path)

func _physics_process(delta):
	# If there's no target, don't do anything
	if !target:
		return
	# Find the destination - target's position + the offset
	var target_pos = target.global_transform.translated(offset)
	# Interpolate the current position with the destination
	global_transform = global_transform.interpolate_with(target_pos, lerp_speed * delta)
	# Always be pointing at the target
	look_at(target.global_transform.origin, Vector3.UP)
