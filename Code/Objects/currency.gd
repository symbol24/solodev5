class_name CurrencyObject extends Node2D


enum Type {
			EXP = 0,
			COIN = 1,
		}

@export_group("Currency")
@export var value:float = 1.0
@export var type:Type

@export_group("Tween")
@export var wait_before_tween:float = 1
@export var tween_time:float = 1
@export var height:int = 8

@onready var animated: AnimatedSprite2D = %animated


func start_tween() -> void:
	await get_tree().create_timer(wait_before_tween).timeout
	var tween:Tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_STOP)
	tween.finished.connect(_finished)
	tween.tween_property(self, "global_position", Vector2(global_position.x, global_position.y-height), tween_time)
	Audio.play_audio(Game.audio_list.get_audio_file("currency"))


func _finished() -> void:
	Signals.AddCurrency.emit(type, value)
	Signals.ReturnCurrencyToPool.emit(self)

