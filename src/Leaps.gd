extends Player

export var move_speed := 500.0
export var move_max_speed := 500.0
export var jump_min_multiplier := 0.5
export var jump_max_multiplier := 1.0
export var jump_charge_time := 1.0

var _jump_charge_time := 0.0 # Used to keep track of how long the player charged the jump
var released_charge := false # Stops _jump_charge_time from increasing after releasing jump


func _init():
	controls.move_left = "p2_move_left"
	controls.move_right = "p2_move_right"
	#controls.move_up = "p2_move_up"
	#controls.move_down = "p2_move_down"
	controls.jump = "jump"


func _physics_process(delta: float):
	
	update_moving() # From Player.gd
	
	# Animation flow:
	# JumpWindup -> JumpCharge as long as the jump button is held
	# When the jump button is released, JumpCharge -> Jump
	# Jump will transition to JumpLoop automatically
	
	if Input.is_action_pressed(controls.jump) and $AnimationPlayer.current_animation in ["Idle", "Walk"]:
		$AnimationPlayer.play("JumpWindup")
	elif on_floor() and $AnimationPlayer.current_animation == "JumpLoop":
		$AnimationPlayer.play("Idle")
	
	if on_floor() and Input.is_action_pressed(controls.jump) and $AnimationPlayer.current_animation in ["JumpWindup", "JumpCharge"]:
		_jump_charge_time += delta
	elif _jump_charge_time > 0 and on_floor() and not Input.is_action_pressed(controls.jump) and $AnimationPlayer.current_animation in ["JumpWindup", "JumpCharge"]:
		released_charge = true
		$AnimationPlayer.play("Jump")
	
	if moving.x != 0 and on_floor() and $AnimationPlayer.current_animation == "Idle":
		face(moving.x)
		$AnimationPlayer.play("Walk")
	elif moving.x == 0 and on_floor() and $AnimationPlayer.current_animation == "Walk":
		$AnimationPlayer.play("Idle")
	if $AnimationPlayer.current_animation == "Walk":
		velocity.x = clamp(velocity.x + move_speed * moving.x * delta, -move_max_speed, move_max_speed)
		face(moving.x)
	
	if $AnimationPlayer.current_animation == "JumpCharge" and not on_floor():
		assert false # We're charging a jump but not on the ground -- fix this bug later
	
	if on_floor():
		apply_friction(delta)
	
	#apply_gravity(delta)
	apply_leaps_gravity(delta)
	move()


func apply_leaps_gravity(delta: float):
	# Leaps' gravity is a lot simpler than the Player.gd gravity
	
	if on_floor():
		gravity_time = 0
	else:
		gravity_time += delta
	
	velocity += gravity * delta + gravity * delta * gravity_time * gravity_time_factor


func anim_jump_callback():
	released_charge = false
	var jump_time = min(_jump_charge_time, jump_charge_time) / jump_charge_time
	var jump_power = lerp(jump_min_multiplier, jump_max_multiplier, jump_time)
	jump(Vector2(1, jump_power))
	_jump_charge_time = 0
