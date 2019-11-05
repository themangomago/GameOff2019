extends KinematicBody2D


export var jump_speed := Vector2(100, 200)
export var gravity := 500.0

var velocity := Vector2()


func _ready():
	assert(name != "Player") # Instance the Leaps or Bounds scenes instead


func _physics_process(delta: float):
	velocity = move_and_slide(velocity, Vector2.UP)


func jump():
	velocity += jump_speed * Vector2(1, -1)
