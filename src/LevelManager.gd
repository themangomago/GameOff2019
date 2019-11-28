extends Node


const UPDATE_RESTORE_POINT_INTERVAL = 15 # Frames

const MainMenu = preload("res://assets/levels/MainMenu.tscn")

var main_menu: Node

var current_level := 0
var level: Node
var levels := [
	{
		scene = preload("res://assets/levels/Level4.tscn"),
		title = "Baby Leaps",
		description = "One small leap for man...",
	},
	{
		scene = preload("res://assets/levels/Level1.tscn"),
		title = "Cool Level",
		description = "...one giant bound for mankind",
	},
	{
		scene = preload("res://assets/levels/Level2.tscn"),
		title = "Radical Level",
		description = "",
	},
	
]

var leaps: Node
var bounds: Node

var last_valid_positions = [
	Vector2(),
	Vector2()
]


func _ready() -> void:
	load_main_menu(true)


func _wait_for_anim(anim: String) -> GDScriptFunctionState:
	$CanvasLayer/AnimationPlayer.play(anim)
	$Control.raise()
	return yield($CanvasLayer/AnimationPlayer, "animation_finished")


func fade_in():
	# Use with yield(fade_in(), "completed")
	$Control.release_focus()
	$Control.mouse_filter = Control.MOUSE_FILTER_STOP
	yield(_wait_for_anim("FadeIn"), "completed")
	$Control.mouse_filter = Control.MOUSE_FILTER_PASS
func fade_out():
	# Use with yield(fade_out(), "completed")
	$Control.release_focus()
	$Control.mouse_filter = Control.MOUSE_FILTER_STOP
	yield(_wait_for_anim("FadeOut"), "completed")


func load_main_menu(instantly=false):
	if not instantly:
		yield(fade_out(), "completed")
	clear_level()
	main_menu = MainMenu.instance()
	add_child(main_menu)
	main_menu.connect("change_level", self, "_on_main_menu_change_level")
	if not instantly:
		fade_in()

func clear_level():
	if level:
		level.queue_free()
		level = null
		leaps = null
		bounds = null
	if main_menu:
		main_menu.queue_free()
		main_menu = null


func change_level(id: int, instantly=false):
	if not instantly:
		yield(fade_out(), "completed")
	if id >= levels.size() and OS.is_debug_build():
		printerr("(LevelManager.gd) Level %d doesn't exist" % id)
		return
	clear_level()
	current_level = id
	level = levels[current_level].scene.instance()
	add_child(level)
	leaps = level.find_node("Leaps")
	bounds = level.find_node("Bounds")
	for p in [leaps, bounds]:
		p.connect("death", self, "_on_player_death")
	assert(leaps and bounds)
	Global.updateLights()
	Global.hasKey = false
	if not instantly:
		fade_in()

func _physics_process(delta: float):
	if (leaps and bounds
	and Engine.get_frames_drawn() % UPDATE_RESTORE_POINT_INTERVAL == 0
	and leaps.on_floor()
	and bounds.on_floor()
	# Ensures they're (mostly) not colliding
	and (leaps.global_position - bounds.global_position).length() > 32):
		last_valid_positions = [leaps.global_position, bounds.global_position]

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


func restore_checkpoint():
	if last_valid_positions[0] == Vector2() and last_valid_positions[1] == Vector2():
		return
	for p in [leaps, bounds]:
		p.get_node("AnimationPlayer").play("Idle")
		p.get_node("CollisionShape2D").disabled = false
	leaps.global_position = last_valid_positions[0]
	bounds.global_position = last_valid_positions[1]


func _input(event: InputEvent):
	if not is_inside_tree(): return
	if event.is_action_pressed("restart") and level and not main_menu and not $CanvasLayer/AnimationPlayer.is_playing():
		reload_level()


func _on_player_death(player: Node):
	restore_checkpoint()
