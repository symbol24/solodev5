class_name SyPanelContainer extends PanelContainer


@export var id:String



var previous:String = ""


func toggle_panel(display:bool, _previous:String = "") -> void:
	if display:
		show()
	else:
		hide()