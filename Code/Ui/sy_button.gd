class_name SyButton extends Button

@export var destination:String
@export var display_loading_screen:bool = false


func _pressed() -> void:
	Signals.ToggleLoadingScreen.emit(display_loading_screen)
	Signals.SyButtonPressed.emit(destination)