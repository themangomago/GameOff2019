extends Node2D

export(Types.Direction) var direction = Types.Direction.Top
export(NodePath) var ButtonNode = null
export(int) var tiles = 3

const SPEED_PER_TILE = 0.5

var tweenValues = [Vector2(), Vector2()] 

func _ready():
	tweenValues[0] = $KinematicBody2D.position
	match direction:
		Types.Direction.Top:
			tweenValues[1] = Vector2($KinematicBody2D.position.x, $KinematicBody2D.position.y - tiles * 16)
		Types.Direction.Down:
			tweenValues[1] = Vector2($KinematicBody2D.position.x, $KinematicBody2D.position.y + tiles * 16)
		Types.Direction.Left:
			tweenValues[1] = Vector2($KinematicBody2D.position.x - tiles * 16, $KinematicBody2D.position.y)
		_:
			tweenValues[1] = Vector2($KinematicBody2D.position.x + tiles * 16, $KinematicBody2D.position.y)
	
	tweenStart()
	if ButtonNode:
		#Button dependand
		$Tween.stop_all()
		


func tweenStart():
	$Tween.interpolate_property($KinematicBody2D, "position", $KinematicBody2D.position, tweenValues[1], SPEED_PER_TILE * tiles, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

#warning-ignore:unused_argument
#warning-ignore:unused_argument
func _on_Tween_tween_completed(object, key):
	tweenValues.invert()
	tweenStart()

