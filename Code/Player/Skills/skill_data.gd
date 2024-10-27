class_name SkillData extends Resource


@export var id:String
@export var texture:CompressedTexture2D
@export var starting_delay:float
@export var skill_path:String
@export var json_path:String

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
	get: return _get_data("hp") if not paresed_json.is_empty() else 1
var damage:int:
	get: return _get_data("damage") if not paresed_json.is_empty() else 1
var speed:int:
	get: return _get_data("speed") if not paresed_json.is_empty() else 1

# Autospawner
var spawner_spawn_time:int:
	get: return _get_data("spawner_spawn_time") if not paresed_json.is_empty() else 100
var spawned_level:int:
	get: return _get_data("spawned_level") if not paresed_json.is_empty() else 1

var paresed_json:Dictionary


func _get_data(_id:String):
	if paresed_json.has(str(current_level)):
		if paresed_json[str(current_level)].has(_id):
			return paresed_json[str(current_level)][_id]
	else:
		push_error("Level data of ", id, " does not have a key for ", _id, " at level ", current_level)
		return 0
	return 0