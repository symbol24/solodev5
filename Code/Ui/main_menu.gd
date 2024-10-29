class_name MainMenu extends SyPanelContainer


@export var audio_file:AudioFile

@onready var btn_audio: SyButton = %btn_audio


func toggle_panel(display:bool, _previous:String = "") -> void:
	if display:
		show()
		btn_audio.previous = id
		Audio.play_audio(Game.audio_list.get_audio_file("main_menu"))
	else:
		hide()