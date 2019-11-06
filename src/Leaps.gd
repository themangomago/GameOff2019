extends Player


func _init():
	#controls.move_left = "p2_move_left"
	#controls.move_right = "p2_move_right"
	#controls.move_up = "p2_move_up"
	#controls.move_down = "p2_move_down"
	controls.jump = "jump"


func _physics_process(delta: float):
	
	apply_gravity(delta)
	move()
