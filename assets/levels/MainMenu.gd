extends Control

signal change_level(level)

const LevelPanel = preload("res://assets/ui/LevelPanel.tscn")


func _ready() -> void:
	if not Global.LevelManager: return
	for level in Global.LevelManager.levels:
		var panel = LevelPanel.instance()
		panel.level = level
		$Levels.add_child(panel)
		panel.connect("change_level", self, "_on_level_panel_change_level")
	
	$TitleTextureRect.visible = true
	$HBoxContainer.visible = true
	$LevelSelectLabel.visible = false
	$Levels.visible = false


func _on_level_panel_change_level(level: Dictionary, panel: Node):
	panel.queue_free()
	emit_signal("change_level", level)


func show_main_menu():
	if $AnimationPlayer.is_playing(): return
	toggle_buttons(false)
	play_backwards("FadeInLevelSelect")
	yield($AnimationPlayer, "animation_finished")
	play_backwards("FadeOutMainMenu")
	yield($AnimationPlayer, "animation_finished")
	toggle_buttons(true)


func show_level_select():
	if $AnimationPlayer.is_playing(): return
	toggle_buttons(false)
	play_forwards("FadeOutMainMenu")
	yield($AnimationPlayer, "animation_finished")
	play_forwards("FadeInLevelSelect")


func toggle_buttons(toggled: bool):
	for button in $HBoxContainer.get_children():
		button.disabled = not toggled


func play_forwards(anim: String):
	$AnimationPlayer.play(anim, -1, 1, false)


func play_backwards(anim: String):
	$AnimationPlayer.play(anim, -1, -1, true)


func _on_StartButton_pressed() -> void:
	show_level_select()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			print("Predelete!")
