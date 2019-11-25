extends Area2D


export(bool) var requireKey = false

var active := false setget set_active


func _ready() -> void:
	if requireKey:
		$Bars.show()
	else:
		$Bars.hide()

func unlock():
	$Bars.hide()

func _on_ExitDoor_body_entered(body: PhysicsBody2D) -> void:
	if not body: return
	if body.is_in_group("player"):
		if not requireKey or Global.hasKey:
			print("You Win")


func set_active(new_active: bool):
	active = new_active
	# Play an opening animation?
