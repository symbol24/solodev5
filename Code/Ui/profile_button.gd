class_name ProfileBtn extends Control


@onready var button: Button = %button

var profile_id:int = -1


func _ready() -> void:
	button.toggled.connect(_toggled)
	Signals.UntoggleProfileButton.connect(_untoggle)


func _toggled(is_toggled:bool) -> void:
	if is_toggled:
		Signals.UntoggleProfileButton.emit(profile_id)
		Signals.ProfileSelected.emit(profile_id)


func set_toggled() -> void:
	if not button.is_node_ready(): await button.ready
	button.set_pressed_no_signal(true)
	button.grab_focus()


func _untoggle(id:int) -> void:
	if profile_id != id: button.set_pressed_no_signal(false)


func set_text(value:String) -> void:
	button.text = value