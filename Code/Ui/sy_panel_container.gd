class_name SyPanelContainer extends PanelContainer


@export var id:String


func toggle_panel(display:bool) -> void:
	if display:
		show()
	else:
		hide()