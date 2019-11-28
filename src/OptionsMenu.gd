extends Control

var sound_bus: int = AudioServer.get_bus_index("Sound")
var music_bus: int = AudioServer.get_bus_index("Music")


func _ready() -> void:
	assert(sound_bus != 0)
	assert(music_bus != 0)
	if Global.DebugMenu:
		find_node("DebugCheckBox").pressed = Global.DebugMenu.visible


func get_volume_db(value):
	assert(1 <= value and value <= 10)
	return (10-value) * -6
	#return -3 * linear2db(10-value)
	#return 2*-linear2db(46-value*5)


func _on_SoundSlider_value_changed(value: float) -> void:
	assert(0 <= value and value <= 10)
	AudioServer.set_bus_mute(sound_bus, value == 0)
	if value != 0:
		AudioServer.set_bus_volume_db(sound_bus, get_volume_db(value))
	$SampleSoundEffect.play()


func _on_MusicSlider_value_changed(value: float) -> void:
	assert(0 <= value and value <= 10)
	AudioServer.set_bus_mute(music_bus, value == 0)
	if value != 0:
		AudioServer.set_bus_volume_db(music_bus, get_volume_db(value))


func _on_DebugCheckBox_toggled(button_pressed: bool) -> void:
	if Global.DebugMenu:
		Global.DebugMenu.visible = button_pressed


func _on_CR_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton
	and (event.button_index == BUTTON_LEFT or event.button_index == BUTTON_RIGHT)):
		hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		hide()


func _on_Button_pressed() -> void:
	hide()
