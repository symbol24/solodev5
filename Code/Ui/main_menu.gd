class_name MainMenu extends SyPanelContainer


@export var audio_file:AudioFile


func toggle_panel(display:bool) -> void:
	if display:
		show()
		Audio.play_audio(audio_file)
	else:
		hide()