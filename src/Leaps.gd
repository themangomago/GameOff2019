extends Player


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
	
	if Input.is_action_pressed(controls.jump) and $AnimationPlayer.current_animation == "Idle":
		$AnimationPlayer.play("JumpWindup")
	elif not Input.is_action_pressed(controls.jump) and $AnimationPlayer.current_animation == "JumpCharge":
		$AnimationPlayer.play("Jump")
	elif on_floor() and $AnimationPlayer.current_animation == "JumpLoop":
		$AnimationPlayer.play("Idle")
	
	apply_gravity(delta)
	move()


func anim_jump_callback():
	jump(Vector2(1, 1))
