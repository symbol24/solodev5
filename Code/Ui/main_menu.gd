class_name MainMenu extends SyPanelContainer


@export var audio_file:AudioFile

@onready var btn_settings: SyButton = %btn_settings


func toggle_panel(display:bool, _previous:String = "") -> void:
	if display:
		show()
		btn_settings.previous = id
		Audio.play_audio(Game.audio_list.get_audio_file("main_menu"))
	else:
		hide()
