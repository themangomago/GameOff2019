extends Node


const MainMenu = preload("res://assets/levels/MainMenu.tscn")

var main_menu: Node

var current_level := 0
var level: Node
var levels := [
	{
		scene = preload("res://assets/levels/Level1.tscn"),
		title = "Cool Level",
	},
	{
		scene = preload("res://assets/levels/Level2.tscn"),
		title = "Radical Level",
	},
]


func _ready() -> void:
	load_main_menu()


func load_main_menu():
	main_menu = MainMenu.instance()
	if level: level.queue_free()
	add_child(main_menu)
	main_menu.connect("change_level", self, "_on_main_menu_change_level")


func change_level(id: int):
	if id >= levels.size() and OS.is_debug_build():
		printerr("(LevelManager.gd) Level %d doesn't exist" % id)
		return
	if main_menu:
		main_menu.queue_free()
		main_menu = null
#	if main_menu \
#	and main_menu is Node \
#	and main_menu in get_children() \
#	and is_instance_valid(main_menu) \
#	and main_menu.is_inside_tree():
#		main_menu.queue_free()
#	else:
#		main_menu = null
	if level: level.queue_free()
	current_level = id
	level = levels[current_level].scene.instance()
	add_child(level)


func change_level_to(level: Dictionary):
	change_level(levels.find(level))


func next_level():
	if current_level + 1 >= levels.size():
		return # Already on the last level
	change_level(current_level + 1)


func _on_main_menu_change_level(level: Dictionary):
	change_level_to(level)
