extends KinematicBody2D
class_name Player


export var jump_speed := Vector2(100, -200)
export var gravity := Vector2(0, 500)

var velocity := Vector2()
var moving := Vector2()

func _ready():
	assert(name != "Player") # Instance the Leaps or Bounds scenes instead


func jump():
	velocity += jump_speed


func update_moving() -> void:
	assert """
	This makes moving a little more intuitive with the arrow keys
	Shouldn't be needed for unmodified d-pads, but should be used just in case
	Not needed for analog sticks; just get input strength
	"""
	
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var move_up = Input.is_action_pressed("move_up")
	var move_down = Input.is_action_pressed("move_down")
	
	if not (move_left or move_right):
		moving.x = 0
	elif move_left and Input.is_action_just_released("move_right"):
		moving.x = -1
	elif move_right and Input.is_action_just_released("move_left"):
		moving.x = 1
	elif Input.is_action_just_pressed("move_left"):
		moving.x = -1
	elif Input.is_action_just_pressed("move_right"):
		moving.x = 1
	
	if not (move_up or move_down):
		moving.y = 0
	elif move_down and Input.is_action_just_released("move_up"):
		moving.y = -1
	elif move_up and Input.is_action_just_released("move_down"):
		moving.y = 1
	elif Input.is_action_just_pressed("move_down"):
		moving.y = -1
	elif Input.is_action_just_pressed("move_up"):
		moving.y = 1
