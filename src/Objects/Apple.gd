extends Node2D

var alive = true

func reset():
	self.show()
	$Area/CollisionShape2D.set_deferred("disabled", false)
	alive = true

func remove():
	self.hide()
	$Area/CollisionShape2D.set_deferred("disabled", true)
	alive = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("player") and alive:
		remove()
