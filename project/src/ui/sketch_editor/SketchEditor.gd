#
#  SketchEditor.gd
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

extends MarginContainer

signal exited

onready var close_btn = $Panel/MarginContainer/VBoxContainer/Control/CloseButton
onready var save_btn = $Panel/MarginContainer/VBoxContainer/Control/SaveButton

onready var text_editor = $Panel/MarginContainer/VBoxContainer/TextAttach/TextEditor

var sketch_path = ""

func _gui_input(event: InputEvent):
	if event.is_action_pressed("mouse_left"):
		_on_close()

func _ready() -> void:
	if(sketch_path):
		_on_select_sketch(sketch_path)
	close_btn.connect("pressed", self, "_on_close")
	save_btn.connect("pressed", self, "_on_save")

func _on_select_sketch(path):
	var sketch = File.new()
	sketch.open(path, File.READ)
	text_editor.text = sketch.get_as_text()

func _on_save() -> void:
	$Panel/SaveDialogPopUp.popup()

func _on_save_sketch_confirmed(path):
	var sketch = File.new()
	sketch.open(path, File.WRITE)
	sketch.store_string(text_editor.text)

func _on_close() -> void:
	
	emit_signal("exited")
	
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "rect_scale:y", 1, 0, 0.3, Tween.TRANS_CUBIC)
	tween.interpolate_property(self, "modulate:a", 1, 0, 0.15)
	
	tween.start()
	yield(tween,"tween_all_completed")
	queue_free()


func _enter_tree() -> void:
	FocusOwner.release_focus()
	var tween: Tween = TempTween.new()
	add_child(tween)
	tween.interpolate_property(self, "rect_scale:y", 0.5, 1, 0.15, Tween.TRANS_CUBIC)
	tween.interpolate_property(self, "modulate:a", 0, 1, 0.15)
	tween.start()
	
