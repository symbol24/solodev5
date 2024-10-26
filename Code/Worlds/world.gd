class_name World extends Node2D


func _ready() -> void:
	Signals.SceneLoadingComplete.connect(_world_load)


func _world_load(scene) -> void:
	if scene is World and scene == self:
		Signals.ToggleDark.emit(true)
		Signals.SetupTower.emit()
