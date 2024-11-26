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


func get_parameter(_param:String) -> float:
	var params:Array[Parameter] = []
	var result:float = 0
	var base:float = 0
	var bonus:float = 0
	var percent:float = 1
	if owner_type == Type.PLAYER:
		if not level_datas.is_empty():
			var level_data:SytoLevelData = _get_data_for_level(current_level)
			params.append(level_data.get_parameter(_param))
		else:
			if owner_type == Type.PLAYER: Debug.error("Level data of ", id, " does not have a key for ", _param, " at level ", current_level)

		if Game.selected_leader != null: params.append(Game.selected_leader.get_parameter(_param))

		if Game.player_manager != null: params.append_array(Game.player_manager.get_parameters_from_boosters(_param))

		if Game.save_load != null: params.append_array(Game.save_load.get_parameter_from_permas(_param))
	
		for each in params:
			if each != null:
				match each.type:
					Parameter.Type.FLAT:
						base = each.value
					Parameter.Type.FLAT_BONUS:
						bonus += each.value
					Parameter.Type.PERCENT_BONUS:
						percent += each.value
		
		result = (base + bonus) * percent

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
