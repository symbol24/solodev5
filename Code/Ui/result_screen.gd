class_name ResultScreen extends SyPanelContainer


@export var succes_id:String
@export var fail_id:String

@onready var result_title: RichTextLabel = %result_title


func toggle_panel(display:bool) -> void:
	if display:
		result_title.text = tr(succes_id) if Game.last_round_result else tr(fail_id)
		show()
	else:
		hide()