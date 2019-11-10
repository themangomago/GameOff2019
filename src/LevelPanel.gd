extends PanelContainer

signal change_level(level, this)

var level: Dictionary setget set_level

func set_level(new_level: Dictionary):
	level = new_level
	$HBoxContainer/VBoxContainer/Label1.text = level.title


func _on_LevelButton_pressed() -> void:
	emit_signal("change_level", level, self)
