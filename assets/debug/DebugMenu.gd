extends Node

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SettingsMenu.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

onready var ShowCheckBox = find_node("ShowCheckBox")
onready var SettingsMenu = find_node("SettingsMenu")
func _on_ShowCheckBox_toggled(button_pressed: bool) -> void:
	SettingsMenu.visible = button_pressed


onready var LevelSpinBox = find_node("LevelSpinBox")
onready var ChangeLevelButton = find_node("ChangeLevelButton")
func _on_ChangeLevelButton_pressed() -> void:
	if not Global.LevelManager: return
	Global.LevelManager.change_level(LevelSpinBox.value)


func _on_LeapsSBX_value_changed(value: float):
	if not Global.LevelManager: return
	Global.LevelManager.level.find_node("Leaps").position.x = value
func _on_LeapsSBY_value_changed(value: float):
	if not Global.LevelManager: return
	Global.LevelManager.level.find_node("Leaps").position.y = value
func _on_BoundsSBX_value_changed(value: float):
	if not Global.LevelManager: return
	Global.LevelManager.level.find_node("Bounds").position.x = value
func _on_BoundsSBY_value_changed(value: float):
	if not Global.LevelManager: return
	Global.LevelManager.level.find_node("Bounds").position.y = value
