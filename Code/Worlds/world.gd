class_name World extends Node2D


@export var music:AudioFile

var stream:SAudioStreamPlayer

func _ready() -> void:
	Signals.SceneLoadingComplete.connect(_world_load)


func _world_load(scene) -> void:
	if scene is World and scene == self:
		Signals.ToggleDark.emit(true)
		Signals.SetupTower.emit()
		_play_next_song()


func _play_next_song() -> void:
	stream = Audio.play_audio(music)
	await stream.finished
	_play_next_song()
