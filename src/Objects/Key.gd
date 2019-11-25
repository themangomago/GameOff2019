extends Node2D

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		Global.hasKey = true
		var door = get_tree().get_nodes_in_group("door")
		assert(door !=  null and door.size() > 0 )
		door[0].unlock()
		queue_free()
