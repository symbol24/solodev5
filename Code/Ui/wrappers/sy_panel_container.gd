class_name SyPanelContainer extends PanelContainer


@export var id:String



var previous:String = "":
	set(value):
		previous = value
		#Debug.log("Page ", id, " set previous: ", previous)


func toggle_panel(display:bool, _previous:String = "") -> void:
	if display:
		show()
		previous = _previous
	else:
		hide()