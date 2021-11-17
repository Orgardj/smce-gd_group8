class_name BaseCam

var cam: Spatial = null setget set_camera, get_camera

func _init(cam: Spatial):
	set_camera(cam)
	
func set_camera(camera: Camera):
	cam = camera

func get_camera():
	return cam

func cam_transform() -> Transform:
	return cam.global_transform

func cam_unhandled_input(event: InputEvent):
	pass
