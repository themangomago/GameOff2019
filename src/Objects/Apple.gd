extends Node2D



func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		#TODO: do something
		$AudioStreamPlayer2D.play()


func _on_AudioStreamPlayer2D_finished():
	queue_free()
