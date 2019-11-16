extends Player

export var min_skid_velocity := 50.0

var jump_direction := Vector2(1, 1)


func _init():
	controls.move_left = "p1_move_left"
	controls.move_right = "p1_move_right"
	controls.move_up = "p1_move_up"
	controls.move_down = "p1_move_down"
	#controls.jump = "jump"


func _ready():
	$SkidRay1.position.x = -$CollisionShape2D.shape.extents.x + 1
	$SkidRay2.position.x = $CollisionShape2D.shape.extents.x - 1


func _physics_process(delta: float):
	
	update_moving() # From Player.gd
	
	apply_gravity(delta)
	move()
	
	if moving.x != 0 and on_floor() and $AnimationPlayer.current_animation == "Idle":
		jump_direction.x = moving.x
		face(moving.x)
		$AnimationPlayer.play("Jump")
	
	for ray in [$SkidRay1, $SkidRay2]:
		pass#ray.cast_to.y = velocity.y / 10
	
	if velocity.x != 0:
		pass#$Sprite.flip_h = not velocity.x > 0
	
	#print((($AnimationPlayer.current_animation == "Jump") as String)[0], ((velocity.y > 0) as String)[0], (($SkidRay1.is_colliding() or $SkidRay2.is_colliding()) as String)[0])
	if velocity.y > 0 and abs(velocity.x) > min_skid_velocity and ($SkidRay1.is_colliding() or $SkidRay2.is_colliding()) and not $AnimationPlayer.current_animation == "Skid":
		$AnimationPlayer.play("Skid")
	
	if on_floor():
		if $AnimationPlayer.current_animation == "Skid":
			$AnimationPlayer.play("Idle")
		
		if $AnimationPlayer.current_animation == "":
			$AnimationPlayer.play("Idle")
		
		apply_friction(delta)
	else:
		velocity.x = jump_speed.x * jump_direction.x * (0.5 + min((exp(jump_hold_time * 5) - 1), 0.5))


func anim_jump_callback():
	jump(jump_direction)
