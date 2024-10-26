class_name Skill extends Node2D


@export var skill_data:SkillData

var skill_level:int = 1
var data:SkillData
var used:bool = false
var current_used_delay:float
var used_timer:float = 0.0:
	set(value):
		used_timer = value
		Signals.UpdateSkillTimer.emit(data.id, used_timer/current_used_delay)
		if used_timer <= 0.0:
			used_timer = current_used_delay
			used = false


func _ready() -> void:
	data = skill_data.duplicate(true)
	current_used_delay = data.starting_delay
	used_timer = current_used_delay


func _process(delta: float) -> void:
	if used: used_timer += delta


func trigger_skill() -> void:
	if not used:
		used = true
