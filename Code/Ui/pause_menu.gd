extends SyPanelContainer


@onready var btn_audio: SyButton = %btn_audio


func toggle_panel(display:bool, _previous:String = "") -> void:
	if display:
		btn_audio.previous = id
		show()
	else:
		hide()