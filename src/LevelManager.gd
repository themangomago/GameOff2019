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
	load_main_menu(true)


func _wait_for_anim(anim: String) -> GDScriptFunctionState:
	$AnimationPlayer.play(anim)
	$ColorRect.raise()
	return yield($AnimationPlayer, "animation_finished")


func fade_in():
	# Use with yield(fade_in(), "completed")
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	$ColorRect.release_focus()
	yield(_wait_for_anim("FadeIn"), "completed")
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_PASS
func fade_out():
	# Use with yield(fade_out(), "completed")
	$ColorRect.release_focus()
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	yield(_wait_for_anim("FadeOut"), "completed")


func load_main_menu(instantly=false):
	if not instantly:
		yield(fade_out(), "completed")
	main_menu = MainMenu.instance()
	if level: level.queue_free()
	add_child(main_menu)
	main_menu.connect("change_level", self, "_on_main_menu_change_level")
	if not instantly:
		fade_in()


func change_level(id: int, instantly=false):
	if not instantly:
		yield(fade_out(), "completed")
	if id >= levels.size() and OS.is_debug_build():
		printerr("(LevelManager.gd) Level %d doesn't exist" % id)
		return
	if main_menu:
		main_menu.queue_free()
		main_menu = null
	if level: level.queue_free()
	current_level = id
	level = levels[current_level].scene.instance()
	add_child(level)
	Global.updateLights()
	if not instantly:
		fade_in()


func change_level_to(level: Dictionary):
	change_level(levels.find(level))


func next_level():
	if current_level + 1 >= levels.size():
		return # Already on the last level
	change_level(current_level + 1)


func _on_main_menu_change_level(level: Dictionary):
	change_level_to(level)


func reload_level():
	change_level(current_level)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart") and level and not main_menu:
		reload_level()
