#
#  CamController.gd
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

class_name CamCtl
extends Camera

signal cam_locked
signal cam_freed

# Desired position of camera, relative to target. (0, 5, 12) would be behind and above.
export (Vector3) var offset = Vector3(0,0,0)
# Controls how fast the camera moves
export var lerp_speed = 3.0 

var camera: BaseCam = null
const LockedCam = preload("camera/LockedCam.gd")
const FreeCam = preload("camera/FreeCam.gd")

var locked = null

func _ready():
	free_cam() #set freecam as the initial camera
	
func free_cam() -> void:
	camera = FreeCam.new(self)
	emit_signal("cam_freed")
	if is_instance_valid(locked):
		locked.disconnect("tree_exiting", self, "_on_free")
	locked = null

func lock_cam(node: Spatial) -> void:
	if ! is_instance_valid(node) || ! node.is_inside_tree():
		return
	camera = LockedCam.new(self, node)
	emit_signal("cam_locked", node)
	locked = node
	if ! node.is_connected("tree_exiting", self, "_on_free"):
		node.connect("tree_exiting", self, "_on_free", [node])

func set_cam_position(transform: Transform = Transform()) -> void:
	global_transform = transform


func _on_free(node) -> void:
	if node == locked:
		free_cam()

	
func _physics_process(delta):
	global_transform = global_transform.interpolate_with(camera.cam_transform(),lerp_speed * delta)

func _unhandled_input(event):
	camera.cam_unhandled_input(event)
