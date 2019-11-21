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
	
#	if velocity.y < 0 and $AnimationPlayer.current_animation in ["Jump", "JumpLoop"]:
#		var bounds = get_tree().get_nodes_in_group("bounds")[0]
#
#		for i in bounds.get_slide_count():
#			var c = bounds.get_slide_collision(i)
#			if c.collider and c.collider.is_in_group("player") and c.collider.name == name:
#				print("test")
#				bounds.velocity += velocity
	
	apply_leaps_gravity(delta)
	move()
	
	if on_floor():
		if Input.is_action_pressed(controls.jump) and $AnimationPlayer.current_animation in ["Idle", "Walk"]:
			$AnimationPlayer.play("JumpWindup")
		elif $AnimationPlayer.current_animation == "JumpLoop":
			$AnimationPlayer.play("Idle")
	
		if Input.is_action_pressed(controls.jump) and $AnimationPlayer.current_animation in ["JumpWindup", "JumpCharge", "Jump"]:
			_jump_charge_time += delta
		elif _jump_charge_time > 0 and not Input.is_action_pressed(controls.jump) and $AnimationPlayer.current_animation in ["JumpWindup", "JumpCharge"]:
			released_charge = true
			$AnimationPlayer.play("Jump")
	
		if moving.x != 0 and $AnimationPlayer.current_animation == "Idle" and not $AnimationPlayer.current_animation in ["JumpWindup", "JumpCharge", "Jump"]:
			face(moving.x)
			$AnimationPlayer.play("Walk")
		elif moving.x == 0 and $AnimationPlayer.current_animation == "Walk":
			$AnimationPlayer.play("Idle")
		
		if $AnimationPlayer.current_animation == "Walk":
			velocity.x = clamp(velocity.x + move_speed * moving.x * delta, -move_max_speed, move_max_speed)
			face(moving.x)
		
		apply_friction(delta)
	else: # not on_floor()
		if $AnimationPlayer.current_animation == "JumpCharge":
			pass#assert(false) # We're charging a jump but not on the ground -- fix this bug later
		if $AnimationPlayer.current_animation == "Idle":
			$AnimationPlayer.play("JumpLoop")
	
	#apply_gravity(delta)
#	apply_leaps_gravity(delta)
#	move()


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


func _on_AnimationPlayer_animation_changed(old_name: String, new_name: String) -> void:
	match [old_name, new_name]:_:pass


func _on_AnimationPlayer_animation_started(anim_name: String) -> void:
	match anim_name:
		"JumpLoop":
			pass


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match anim_name:
		"Jump":
			pass



