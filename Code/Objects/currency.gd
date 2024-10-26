class_name CurrencyObject extends Node2D

@export_group("Currency")
@export var value:int = 1

@export_group("Tween")
@export var wait_before_tween:float = 1
@export var tween_time:float = 1
@export var height:int = 8


func set_value(new_value:int) -> void:
	value = new_value


func start_tween() -> void:
	await get_tree().create_timer(wait_before_tween).timeout
	var tween:Tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_STOP)
	tween.finished.connect(_finished)
	tween.tween_property(self, "global_position", Vector2(global_position.x, global_position.y-height), tween_time)


func _finished() -> void:
	Signals.AddCurrency.emit(value)
	Signals.ReturnCurrencyToPool.emit(self)

