extends Player

const MOVE_LEFT = "p2_move_left"
const MOVE_RIGHT = "p2_move_right"
const MOVE_UP = "p2_move_up"
const MOVE_DOWN = "p2_move_down"
const JUMP = "jump"


func _physics_process(delta: float):
	
	update_moving() # From Player.gd
	
	print(moving.x)
	
	velocity += gravity
	velocity = move_and_slide(velocity, Vector2.UP)
