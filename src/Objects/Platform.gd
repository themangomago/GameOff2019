extends Node2D

export(Types.Direction) var direction = Types.Direction.Top
export(bool) var isActivated = true
export(int) var tiles = 3

const SPEED_PER_TILE = 0.5

var tweenValues = [Vector2(), Vector2()] 

func _ready():
	tweenValues[0] = position
	match direction:
		Types.Direction.Top:
			tweenValues[1] = Vector2(position.x, position.y - tiles * 16)
		Types.Direction.Down:
			tweenValues[1] = Vector2(position.x, position.y + tiles * 16)
		Types.Direction.Left:
			tweenValues[1] = Vector2(position.x - tiles * 16, position.y)
		Types.Direction.Right:
			tweenValues[1] = Vector2(position.x + tiles * 16, position.y)
	
	if isActivated:
		tweenStart()

func activate():
	tweenStart()

func deactivate():
	$Tween.remove_all()

func tweenStart():
	#TODO: for dynamic button the time has to be adjusted for the remaining track
	# It can now adjust the time for a vertical platform, horizontal code isn't done yet
	var time: float = SPEED_PER_TILE * tiles
	match direction:
		Types.Direction.Top, Types.Direction.Down:
			time *= (1 - (position.y - tweenValues[0].y) / (tweenValues[1].y - tweenValues[0].y))
		Types.Direction.Left:
			assert(false)
		Types.Direction.Right:
			assert(false)
	$Tween.interpolate_property(
		self,
		"position",
		position,
		tweenValues[1],
		max(time, 0.01),
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT)
	$Tween.start()

#warning-ignore:unused_argument
#warning-ignore:unused_argument
func _on_Tween_tween_completed(object, key):
	tweenValues.invert()
	tweenStart()

