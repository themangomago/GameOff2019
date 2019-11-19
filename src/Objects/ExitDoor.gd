extends Area2D


var active := false setget set_active


func _ready() -> void:
	pass


func _on_ExitDoor_body_entered(body: PhysicsBody2D) -> void:
	if not body: return
	if body.is_in_group("player"):
		# Because of collision shapes changing during animations,
		# this can trigger multiple times per second without
		# the player actually moving
		print("You Win")


func set_active(new_active: bool):
	active = new_active
	# Play an opening animation?
