class_name Boot extends Node2D


func _ready() -> void:
	Signals.LoadScene.emit("ui")
	await get_tree().create_timer(1).timeout
	Signals.ToggleUi.emit("main_menu")
	queue_free.call_deferred()
