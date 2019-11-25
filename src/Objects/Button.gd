extends Node2D

var triggered = false


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		triggered = true
		$Sprite.frame = 1

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		triggered = false
		$Sprite.frame = 0
