extends Player


func _physics_process(delta: float):
	
	update_moving() # From Player.gd
	
	velocity += gravity
	velocity = move_and_slide(velocity, Vector2.UP)
