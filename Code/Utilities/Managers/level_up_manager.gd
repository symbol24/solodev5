class_name LevelUpManager extends Node2D


var levels_to_do:int = 0
var level_up_in_progress:bool = false

func _ready() -> void:
	Signals.PlayerlevelUp.connect(_add_level_up)
	Signals.ManagerReady.emit(self)


func _process(delta: float) -> void:
	if not level_up_in_progress and levels_to_do > 0:
		_display_level_up()


func _display_level_up() -> void:
	levels_to_do -= 1
	get_tree().paused = true
	Signals.ToggleUi.emit("level_up_screen")


func _add_level_up() -> void:
	levels_to_do += 1