extends Node


var current_level := 0
var level: Node
var levels := [
	preload("res://assets/levels/Level1.tscn"),
	preload("res://assets/levels/Level2.tscn")
]


func _ready() -> void:
	change_level(current_level)


func change_level(id: int):
	if level: level.queue_free()
	current_level = id
	level = levels[current_level].instance()
	add_child(level)


func next_level():
	if current_level + 1 >= levels.size():
		return # Already on the last level
	change_level(current_level + 1)

