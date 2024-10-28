class_name SAudioStreamPlayer3D 
extends AudioStreamPlayer3D

signal AudioExiting(audioStream:Node)

var audio_file:AudioFile

func _ready() -> void:
	tree_exiting.connect(exit_tree)
	finished.connect(exit_tree)
	
func exit_tree() -> void:
	AudioExiting.emit(self)