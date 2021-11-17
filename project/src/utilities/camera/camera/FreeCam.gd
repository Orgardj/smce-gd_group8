#
#  FreeCam.gd
#  Copyright 2021 ItJustWorksTM
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

extends BaseCam

var lookaround_speed = 0.01

export(int, 0, 90) var y_angle_limit = 20 setget set_y_angle_limit
var _y_angle_limit = 0
func set_y_angle_limit(limit: float) -> void:
	_y_angle_limit = range_lerp(limit, 0, 90, 0, PI/2)
	y_angle_limit = y_angle_limit
	_update_pos()

var rot_x = 0
var rot_y = 0
var transform: Transform

func _init(cam: Camera).(cam):
	transform = cam.global_transform

func _ready():
	_update_pos()

func cam_unhandled_input(event) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("mouse_left") and ! FocusOwner.has_focus():
		rot_x -= event.relative.x * lookaround_speed
		rot_y -= event.relative.y * lookaround_speed
		_update_pos()


func _update_pos():
	rot_y = clamp(rot_y, _y_angle_limit - PI/2, PI/2 - _y_angle_limit)
	transform.basis = Basis(Quat(Vector3(rot_y, rot_x, 0)))

func cam_transform() -> Transform:	
	var d = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	var b = Input.get_action_strength("right") - Input.get_action_strength("left")
	var u = Input.get_action_strength("up") - Input.get_action_strength("down")
	var new = Vector3(b, 0, d) / 5
	var up = Vector3(0, u, 0) / 5
	transform.origin += transform.basis * new + up
	return transform
