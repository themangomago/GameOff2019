extends Node

signal mouse_button_pressed(pos)

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SettingsMenu.visible = false


func _input(event: InputEvent):
	if (event is InputEventMouseButton
	and event.pressed
	and event.button_index == BUTTON_LEFT):
		emit_signal("mouse_button_pressed", event.global_position)


func _process(delta: float):
	for _l in _ls: snap_label_to_mouse(_l)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

onready var ShowCheckBox = find_node("ShowCheckBox")
onready var SettingsMenu = find_node("SettingsMenu")
func _on_ShowCheckBox_toggled(button_pressed: bool) -> void:
	SettingsMenu.visible = button_pressed


onready var LevelTransitionCheckBox = find_node("LevelTransitionCheckBox")
onready var LevelSpinBox = find_node("LevelSpinBox")
onready var ChangeLevelButton = find_node("ChangeLevelButton")
func _on_ChangeLevelButton_pressed() -> void:
	if not Global.LevelManager: return
	Global.LevelManager.change_level(
		LevelSpinBox.value,
		not LevelTransitionCheckBox.pressed)


func _on_LeapsSBX_value_changed(value: float):
	if not Global.LevelManager or not Global.LevelManager.level: return
	Global.LevelManager.level.find_node("Leaps").position.x = value
func _on_LeapsSBY_value_changed(value: float):
	if not Global.LevelManager or not Global.LevelManager.level: return
	Global.LevelManager.level.find_node("Leaps").position.y = value
func _on_BoundsSBX_value_changed(value: float):
	if not Global.LevelManager or not Global.LevelManager.level: return
	Global.LevelManager.level.find_node("Bounds").position.x = value
func _on_BoundsSBY_value_changed(value: float):
	if not Global.LevelManager or not Global.LevelManager.level: return
	Global.LevelManager.level.find_node("Bounds").position.y = value


onready var FPSCheckBox = find_node("FPSCheckBox")
onready var FPSSpinBox = find_node("FPSSpinBox")
func _on_FPSCheckBox_toggled(button_pressed: bool) -> void:
	Engine.target_fps = FPSSpinBox.value as int if button_pressed else 0
func _on_FPSSpinBox_value_changed(value: float) -> void:
	Engine.target_fps = value as int if FPSCheckBox.pressed else 0


onready var PFPSCheckBox = find_node("PFPSCheckBox")
onready var PFPSSpinBox = find_node("PFPSSpinBox")
func _on_PFPSCheckBox_toggled(button_pressed: bool) -> void:
	Engine.iterations_per_second = PFPSSpinBox.value as int if button_pressed else 60
func _on_PFPSSpinBox_value_changed(value: float) -> void:
	Engine.iterations_per_second = value as int if PFPSCheckBox.pressed else 60


onready var TimescaleCheckBox = find_node("TimescaleCheckBox")
onready var TimescaleSpinBox = find_node("TimescaleSpinBox")
func _on_TimescaleCheckBox_toggled(button_pressed: bool) -> void:
	Engine.time_scale = TimescaleSpinBox.value if button_pressed else 1.0
func _on_TimescaleSpinBox_value_changed(value: float) -> void:
	Engine.time_scale = value if TimescaleCheckBox.pressed else 1.0


func _on_LightBtn_button_up():
	Global.toggleLights()



var _ls = []
func move_player(player_name: String):
	var player = Global.LevelManager.level.find_node(player_name)
	var l = Label.new()
	l.text = "Click to set %s's position" % player_name
	l.rect_scale = Vector2(0.5, 0.5)
	get_tree().get_root().add_child(l)
	_ls.append(l)
	var pos = yield(self, "mouse_button_pressed")
	_ls.erase(l)
	l.queue_free()
	player.global_position = pos
func snap_label_to_mouse(label):
	if not is_instance_valid(label):
		print("gone")
		return
	label.rect_position = get_viewport().get_mouse_position()
func _on_MoveLeapsButton_pressed() -> void:
	if not Global.LevelManager or not Global.LevelManager.level: return
	move_player("Leaps")
func _on_MoveBoundsButton_pressed() -> void:
	if not Global.LevelManager or not Global.LevelManager.level: return
	move_player("Bounds")
