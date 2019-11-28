extends Player

export var move_speed := 500.0
export var move_max_speed := 500.0
export var jump_min_multiplier := 0.5
export var jump_max_multiplier := 1.0
export var jump_charge_time := 1.0

var _jump_charge_time := 0.0 # Used to keep track of how long the player charged the jump
var released_charge := false # Stops _jump_charge_time from increasing after releasing jump

var last_bounds_x_on_head := 0.0


func _init():
	controls.move_left = "p2_move_left"
	controls.move_right = "p2_move_right"
	#controls.move_up = "p2_move_up"
	#controls.move_down = "p2_move_down"
	controls.jump = "jump"


func _ready():
	$TopRay1.position.x = -$CollisionShape2D.shape.extents.x + 1
	$TopRay2.position.x = $CollisionShape2D.shape.extents.x - 1


func _physics_process(delta: float):
	
	if $AnimationPlayer.current_animation == "Dead":
		return
	
	for ray in [$TopRay1, $TopRay2]:
		ray.position.y = -$CollisionShape2D.shape.extents.y * 2
	
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
	
	
	for i in get_slide_count():
		var c = get_slide_collision(i)
		if c.collider:
			var col = c.get_collider()
			# If we're bumping into Bounds,
			if (col.name == "Bounds"
			# from below,
			and (global_position.y - col.global_position.y) > $CollisionShape2D.shape.extents.y):
				# and we're jumping,
				if $AnimationPlayer.current_animation in ["JumpLoop"] and not col.on_floor():
					# then make Bounds do a double jump
					velocity += c.remainder
					bounce_off_bounds(col)
				# or if we're still on the ground,
				elif $AnimationPlayer.current_animation in ["Jump"]:
					# then just gently push Bounds upwards and don't jump
					velocity = Vector2()
					# Gets Leaps un-stuck from the floor
					#global_position.y -= $CollisionShape2D.shape.extents.y / 2.6
					global_position = global_position - c.travel
					col.global_position.y = global_position.y - $CollisionShape2D.shape.extents.y * 2.1
					col.global_position.x += (global_position.x - col.global_position.x) * delta * 10
					$AnimationPlayer.play("Idle")
	
	if on_floor():
		if Input.is_action_pressed(controls.jump) and $AnimationPlayer.current_animation in ["Idle", "Walk"]:
			$AnimationPlayer.play("JumpWindup")
		elif $AnimationPlayer.current_animation in ["JumpLoop", "Falling", "FallingLoop"]:
			$AnimationPlayer.play("Idle")
	
		if Input.is_action_pressed(controls.jump) and $AnimationPlayer.current_animation in ["JumpWindup", "JumpCharge", "Jump"]:
			_jump_charge_time += delta
		elif (_jump_charge_time > 0
		and not Input.is_action_pressed(controls.jump)
		and $AnimationPlayer.current_animation in ["JumpWindup", "JumpCharge"]
		and not (under_ceiling() and ($BoundsCeilingRay.is_colliding() or player_in_bounce_range()))
		):
			released_charge = true
			$AnimationPlayer.play("Jump")
	
		if moving.x != 0 and $AnimationPlayer.current_animation == "Idle":
			face(moving.x)
			$AnimationPlayer.play("Walk")
		elif moving.x == 0 and $AnimationPlayer.current_animation == "Walk":
			$AnimationPlayer.play("Idle")
		
		if $AnimationPlayer.current_animation == "Walk":
			velocity.x = clamp(velocity.x + move_speed * moving.x * delta, -move_max_speed, move_max_speed)
			if player_on_head():
				var bounds = player_on_head()
				if last_bounds_x_on_head != 0:
					bounds.global_position.x = last_bounds_x_on_head + global_position.x
				else:
					last_bounds_x_on_head = bounds.global_position.x - global_position.x
				#bounds.velocity.x = velocity.x / 2
				#bounds.global_position.y = global_position.y - $CollisionShape2D.shape.extents.y * 2 - 1
				bounds.global_position.y -= 1
				# asynchronous
				move_bounds_down_next_frame(bounds)
			face(moving.x)
		else:
			last_bounds_x_on_head = 0
		
		apply_friction(delta)
	else: # not on_floor()
		match $AnimationPlayer.current_animation:
			"JumpCharge":
				pass#assert(false) # We're charging a jump but not on the ground -- fix this bug later
			"Idle":
				$AnimationPlayer.play("JumpLoop")
			"JumpLoop":
				if velocity.y >= 0 and not $AnimationPlayer.current_animation in ["Falling", "FallingLoop"]:
					$AnimationPlayer.play("Falling")
	
	#apply_gravity(delta)
#	apply_leaps_gravity(delta)
#	move()


func move_bounds_down_next_frame(b):
	yield(get_tree(), "physics_frame")
	b.global_position.y += 1


func bounce_off_bounds(bounds: KinematicBody2D):
	bounds.jump()
	bounds.get_node("AnimationPlayer").play("Fall")
	bounds.gravity_time = 0.0
	#bounds.jump_hold_time = 0.5


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
		"Jump":
			# Fixes a bug where Leaps won't bounce Bounds into the air if he's low to the ground
			if player_in_bounce_range():
				var bounds = player_in_bounce_range()
				if not bounds.on_floor():
					bounce_off_bounds(bounds)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match anim_name:
		"Jump":
			pass


func player_in_bounce_range() -> Node:
	var player: Node
	for ray in [$BounceRay1, $BounceRay2]:
		if ray.is_colliding() and ray.get_collider().is_in_group("player"):
			player = ray.get_collider()
			break
	return player


func under_ceiling() -> bool:
	return $CeilingRay.is_colliding() and not $CeilingRay.get_collider().is_in_group("player")
