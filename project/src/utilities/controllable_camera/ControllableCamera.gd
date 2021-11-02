class_name ControllableCamera
extends Camera

signal cam_locked
signal cam_freed

const LockedCam = preload("LockedCam.gd")
const FreeCam = preload("FreeCam.gd")

var cam: CameraControllerBase = null
var locked = null

export var offset = Vector3.ZERO
export var interp_speed: int = 5

func _ready():
	free_cam()

func lock_cam(node: Spatial) -> void:
	if ! is_instance_valid(node) || ! node.is_inside_tree():
		return
	cam = LockedCam.new(self, node)
	emit_signal("cam_locked", node)
	locked = node
	if ! node.is_connected("tree_exiting", self, "_on_free"):
		node.connect("tree_exiting", self, "_on_free", [node])


func free_cam() -> void:
	cam = FreeCam.new(self)
	emit_signal("cam_freed")
	if is_instance_valid(locked):
		locked.disconnect("tree_exiting", self, "_on_free")
	locked = null


func set_cam_position(tform: Transform = Transform()) -> void:
	global_transform = tform


func _on_free(node) -> void:
	if node == locked:
		free_cam()

	
func _physics_process(delta):
	global_transform = global_transform.interpolate_with(cam.cam_physics_process(delta), delta*interp_speed)
	
func _unhandled_input(event):
	cam.handle_event(event)	

func _process(delta):
	cam.cam_process(delta)
