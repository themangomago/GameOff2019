extends Node2D

export(int) var height = 4
const SPEED_PER_TILE = 1

var tweenValues = [Vector2(), Vector2()] 

func _ready():
	tweenValues[0] = Vector2(11, 16 + height * 16)
	tweenValues[1] = Vector2(11, 16)
	
	$TextureRect.rect_position = Vector2(11, 16 + float(height) * 16)
	$TextureRect.rect_size = Vector2(10, float(height) * 16)
	$KinematicBody2D/CollisionShape2D.position = Vector2(5, 16 + (float(height) * 16)/2)


func activate():
	$Tween.remove_all()
	tweenValues[0] = $TextureRect.rect_position.y - 16
	tweenValues[1] = 0
	_tweenStart()

func deactivate():
	$Tween.remove_all()
	tweenValues[0] = $TextureRect.rect_position.y - 16
	tweenValues[1] = float(height) * 16
	_tweenStart()

func _tweenStart():
	#TODO: for dynamic button the time has to be adjusted for the remaining track
	$Tween.interpolate_method(self, "_move", tweenValues[0], tweenValues[1], height * SPEED_PER_TILE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
func _move(pos):


	$TextureRect.rect_position = Vector2(11, 16 + pos)
	$TextureRect.rect_size = Vector2(10, pos)
	
	var shape = RectangleShape2D.new()
	#80  48
	shape.extents = Vector2(8 , (pos + 16)/2)
	$KinematicBody2D/CollisionShape2D.set_shape(shape)
	$KinematicBody2D/CollisionShape2D.position = Vector2(5, pos/2 + 16 * pos / (height * 16))

	
	
