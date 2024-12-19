class_name MainMenu extends SyPanelContainer


@export var audio_file:AudioFile

@onready var btn_settings: SyButton = %btn_settings

var leader_buttons:Array = []


func toggle_panel(display:bool, _previous:String = "") -> void:
	if display:
		show()
		btn_settings.previous = id
	else:
		hide()

