extends KinematicBody2D
class_name Player


export var collision_width := 8.0
export var jump_speed := Vector2(200, -200)
export var gravity := Vector2(0, 500)
export var friction := 2000.0
export var gravity_time_factor := 1.0

# Increases the longer we're in the air
var gravity_time := 0.0
# Increases the longer the jump button is held, and stays there until touching the ground
var jump_hold_time := 0.0

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
	
	# More accurate on_floor() tracking
	$FloorRay1.position.x = -collision_width + 1
	$FloorRay2.position.x = 0
	$FloorRay3.position.x = collision_width - 1


func jump(direction: Vector2):
	velocity = jump_speed * direction


func apply_gravity(delta: float):
	if on_floor():
		gravity_time = 0
	else:
		# Either jumping and holding the jump button, or we're falling, apply normal gravity
		gravity_time += delta
	
	# Decide whether to apply normal or heavy gravity
	if velocity.y < 0 and (moving.x == 0 if controls.jump == "" else moving.x == 0 or not Input.is_action_pressed(controls.jump)):
		# Jumping but not holding the jump button -- apply more gravity
		velocity += gravity * delta * 5 + gravity * delta * gravity_time * gravity_time_factor
	else:
		if velocity.y < 0:
			jump_hold_time += delta
		velocity += gravity * delta + gravity * delta * gravity_time * gravity_time_factor
	
	if on_floor():
		jump_hold_time = 0


func move():
	velocity = move_and_slide(velocity, Vector2.UP)
	# Didn't work great, leaving the code here for future reference
#	for i in get_slide_count():
#		var c = get_slide_collision(i) as KinematicCollision2D
#		if c.collider and c.collider.is_in_group("player") and c.collider.name != name:
#			assert("velocity" in c.collider)
#			c.get_collider().velocity += c.remainder


func on_floor() -> bool:
	
#	var touched_floor := false
#	for i in get_slide_count():
#		if get_slide_collision(i).normal.y <= -PI/4: # Default floor_max_angle for move_and_slide
#			touched_floor = true
#			break
#	return touched_floor
	
	return is_on_floor()
	#return $FloorRay1.is_colliding() or $FloorRay2.is_colliding() or $FloorRay3.is_colliding()


func face(dir: float):
	# Updates $Sprite.flip_h based on dir
	$Sprite.flip_h = dir < 0


func apply_friction(delta):
	# TODO: Fix this having different behavior at different physics_fps
	var f = friction * delta
	if velocity.x + f <= 0: velocity.x += f
	elif velocity.x - f >= 0: velocity.x -= f
	else: velocity.x = 0


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
