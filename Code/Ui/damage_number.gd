class_name DamageNumber extends Label


@export var tween_time:float = 2
@export var height:int = 8


func start(value:int, color:Color, pos:Vector2) -> void:
	global_position = Vector2(pos.x - (size.x/2), pos.y - (size.y/2))
	text = str(value)
	modulate = color
	var tween:Tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_STOP)
	tween.finished.connect(_finished)
	var end_pos:Vector2 = Vector2(global_position.x, global_position.y-height)
	tween.tween_property(self, "global_position", end_pos, tween_time)


func _finished() -> void:
	Signals.ReturnDmgNbrToPool.emit(self)