extends Node

var music := {
	"main_menu": {
		"stream": preload("res://assets/music/4222-pixelland-by-kevin-macleod.ogg"),
		"player": AudioStreamPlayer.new(),
	},
	"level_1": {
		"stream": preload("res://assets/music/4222-pixelland-by-kevin-macleod.ogg"),
		"player": AudioStreamPlayer.new(),
	},
}


func _ready() -> void:
	for song in music.values():
		var p = song.player as AudioStreamPlayer
		p.stream = song.stream
		p.bus = "Music"
		add_child(p)


func play(song_name: String):
	# TODO: Use a crossfade system with a tween, and yield for its all_finished signal
	
	for song in music.values():
		song.player.stop()
	
	if music.has(song_name):
		music[song_name].player.play()
	else:
		# Song doesn't exist
		if (song_name != "" # We only care about non-empty song names
		and OS.is_debug_build()):
			printerr("(Music.gd) Song '%s' does not exist" % song_name)
