extends Control

signal change_level(level)

const LevelPanel = preload("res://assets/ui/LevelPanel.tscn")


func _ready() -> void:
	if not Global.LevelManager: return
	for level in Global.LevelManager.levels:
		var panel = LevelPanel.instance()
		panel.level = level
		$Levels/VBC.add_child(panel)
		panel.connect("change_level", self, "_on_level_panel_change_level")
	
	$TitleTextureRect.visible = true
	$HBC.visible = true
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
	for button in $HBC.get_children():
		button.disabled = not toggled


func play_forwards(anim: String):
	$AnimationPlayer.play(anim, -1, 1, false)


func play_backwards(anim: String):
	$AnimationPlayer.play(anim, -1, -1, true)


func _on_StartButton_pressed() -> void:
	show_level_select()


func _on_OptionsButton_pressed() -> void:
	$OptionsMenu.show()


func _on_CreditsButton_pressed() -> void:
	var c = $Credits/AnimationPlayer
	if not c.is_playing():
		c.play("FadeInCredits")
		grab_focus()
		release_focus()


func _input(event: InputEvent) -> void:
	if not is_inside_tree(): return
	var c = $Credits/AnimationPlayer
	
	if ($Credits.visible
	and not c.is_playing()
	and   (Input.is_action_just_pressed("ui_cancel")
		or Input.is_action_just_pressed("ui_select")
		or Input.is_action_just_pressed("ui_accept")
		or Input.is_action_just_pressed("ui_click"))
	):
		c.play("FadeOutCredits")
