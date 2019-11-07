extends KinematicBody2D
class_name Player


export var jump_speed := Vector2(200, -200)
export var gravity := Vector2(0, 500)
export var friction := 500.0
export var gravity_time_factor := 1.0

var gravity_time := 0.0

var controls := {
	move_left = "",
	move_right = "",
	move_up = "",
	move_down = "",
	jump = ""
}

var velocity := Vector2()
var moving := Vector2()

func _ready():
	assert(name != "Player") # Instance the Leaps or Bounds scenes instead


func jump(direction: Vector2):
	velocity = jump_speed * direction


func apply_gravity(delta: float):
	if on_floor():
		gravity_time = 0
	else:
		gravity_time += delta
	velocity += gravity * delta + gravity * delta * gravity_time * gravity_time_factor


func move():
	velocity = move_and_slide(velocity, Vector2.UP)


func on_floor() -> bool:
	return $FloorRay.is_colliding()


func face(dir: int):
	# Updates $Sprite.flip_h based on dir
	assert dir != 0
	$Sprite.flip_h = dir < 0
	


func update_moving():
	assert("""
	This makes moving a little more intuitive with the arrow keys
	Shouldn't be needed for unmodified d-pads, but should be used just in case
	Not needed for analog sticks; just get input strength
	""")
	
	var move_left = Input.is_action_pressed(controls.move_left)
	var move_right = Input.is_action_pressed(controls.move_right)
	var move_up = Input.is_action_pressed(controls.move_up)
	var move_down = Input.is_action_pressed(controls.move_down)
	
	if not (move_left or move_right):
		moving.x = 0
	elif move_left and Input.is_action_just_released(controls.move_right):
		moving.x = -1
	elif move_right and Input.is_action_just_released(controls.move_left):
		moving.x = 1
	elif Input.is_action_just_pressed(controls.move_left):
		moving.x = -1
	elif Input.is_action_just_pressed(controls.move_right):
		moving.x = 1
	
	if not (move_up or move_down):
		moving.y = 0
	elif move_down and Input.is_action_just_released(controls.move_up):
		moving.y = -1
	elif move_up and Input.is_action_just_released(controls.move_down):
		moving.y = 1
	elif Input.is_action_just_pressed(controls.move_down):
		moving.y = -1
	elif Input.is_action_just_pressed(controls.move_up):
		moving.y = 1
