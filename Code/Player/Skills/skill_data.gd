class_name SkillData extends Resource


@export var id:String
@export var skill_path:String
@export var level_datas:Dictionary

@export_group("Level Up")
@export var title:String
@export var description:String
@export var ui_texture:CompressedTexture2D

# general
var current_level:int = 0:
	set(value): 
		current_level = min(value, Game.SKILLLEVELCAP)
		Signals.SkillLevelUpdated.emit(id, current_level)
var used_delay:float:
	get: return _get_data("used_delay")

# Monster
var hp:int:
	get: return _get_data("hp") if not level_datas.is_empty() else 1
var damage:int:
	get: return _get_data("damage") if not level_datas.is_empty() else 1
var speed:int:
	get: return _get_data("speed") if not level_datas.is_empty() else 1

# Autospawner
var spawner_spawn_time:int:
	get: return _get_data("spawner_spawn_time") if not level_datas.is_empty() else 100
var spawned_level:int:
	get: return _get_data("spawned_level") if not level_datas.is_empty() else 1


func _get_data(_id:String):
	if level_datas.has(current_level):
		if level_datas[current_level].has(_id):
			return level_datas[current_level][_id]
	else:
		push_error("Level data of ", id, " does not have a key for ", _id, " at level ", current_level)
		return 0
	return 0