class_name Skill extends Node2D


var data:SkillData
var used:bool = false
var current_used_delay:float:
	get: return _get_current_use_delay()
var used_timer:float = 0.0:
	set(value):
		used_timer = value
		Signals.UpdateSkillTimer.emit(data.id, (used_timer/current_used_delay*100))
		if used_timer <= 0.0:
			used_timer = current_used_delay
			used = false
	

func _process(delta: float) -> void:
	if used: used_timer -= delta


func set_data(_new_data:SkillData) -> void:
	data = _new_data
	data.current_level += 1


func trigger_skill(_pos:Vector2, _in_light:bool = true) -> void:
	if not used and not _in_light:
		used = true


func _get_current_use_delay() -> float:
	if data:
		return data.use_delay
	else:
		return 100
