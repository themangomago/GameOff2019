extends Player


var jump_direction := Vector2()

func _init():
	controls.move_left = "p2_move_left"
	controls.move_right = "p2_move_right"
	controls.move_up = "p2_move_up"
	controls.move_down = "p2_move_down"
	#controls.jump = "jump"


func _physics_process(delta: float):
	
	update_moving() # From Player.gd

	if moving.x != 0:
		if on_floor():
			jump(Vector2(moving.x, 1))
			jump_direction.x = moving.x
	
	apply_gravity(delta)
	move()
	print(on_floor())
	
	if on_floor():
		var f = friction * delta
		if velocity.x + f <= 0: velocity.x += f
		elif velocity.x - f >= 0: velocity.x -= f
		else: velocity.x = 0
	else:
		velocity.x = jump_speed.x * jump_direction.x
