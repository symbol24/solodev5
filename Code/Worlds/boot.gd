class_name Boot extends Node2D



func _ready() -> void:
	await get_tree().create_timer(1).timeout
	Signals.LoadScene.emit("test")
