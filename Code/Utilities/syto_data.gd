class_name SytoData extends Resource


enum Type {
			PLAYER = 0,
			ENEMY = 1,
		}


@export var id:String
@export var owner_type:Type
@export var level_datas:Array[SytoLevelData]

var current_level:int = 0:
	set(value): 
		current_level = min(value, Game.SKILLLEVELCAP)
		Signals.SkillLevelUpdated.emit(id, current_level)


func setup_data() -> void:
	pass


func get_parameter(_param:String):
	#Debug.log("Getting ", _param ," in Syto Data")
	var result = 0
	if owner_type == Type.PLAYER:
		if not level_datas.is_empty():
			var level_data:SytoLevelData = _get_data_for_level(current_level)
			result = level_data.get(_param) if level_data.get(_param) != null else 0
		else:
			if owner_type == Type.PLAYER: Debug.error("Level data of ", id, " does not have a key for ", _param, " at level ", current_level)
	
		result += Game.selected_leader.get_parameter(_param) if Game.selected_leader != null else 0
		result += Game.player_manager.get_parameter_from_boosters(_param) if Game.player_manager != null and Game.player_manager.player_data != null else 0
		result += Game.save_load.get_parameter_from_permas(_param) if Game.save_load != null and Game.save_load.active_save != null else 0
	return result


func get_duplicate_levels() -> Array[SytoLevelData]:
	var result:Array[SytoLevelData] = []
	for each in level_datas:
		result.append(each.duplicate(true))

	return result


func _get_data_for_level(_level:int) -> SkillLevelData:
	for each in level_datas:
		if each.level == _level: return each
	return null
