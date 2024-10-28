class_name SyButton extends Button

@export var destination:String
@export var display_loading_screen:bool = false


func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)


func _pressed() -> void:
	Signals.ToggleLoadingScreen.emit(display_loading_screen)
	Signals.SyButtonPressed.emit(destination)


func _mouse_entered() -> void:
	Signals.ToggleMouseEnteredNoClickArea.emit(true)


func _mouse_exited() -> void:
	Signals.ToggleMouseEnteredNoClickArea.emit(true)