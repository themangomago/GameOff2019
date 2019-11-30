extends Node
class_name MusicPlayer

# Simple component for playing a song on load
# Add one of these in each level with the "Add Node" button

export var song_name := ""

func _ready() -> void:
	yield(get_tree(), "idle_frame") # Fixes a pop effect on load
	Music.play(song_name)
