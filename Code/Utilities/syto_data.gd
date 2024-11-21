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
	if level_datas.is_empty(): 
		Debug.error("Level data for ", id ," does not contain any level datas")
		return 0

	var level_data:SytoLevelData = _get_data_for_level(current_level)

	if level_data.stld_has(_param):
		var result = level_data.get(_param) if level_data.get(_param) != null else 0
		if owner_type == Type.PLAYER and Game.player_data != null: result += Game.player_data.get_parameter(_param)
		return result
	else:
		if owner_type == Type.PLAYER: Debug.error("Level data of ", id, " does not have a key for ", _param, " at level ", current_level)
		return 0


func get_duplicate_levels() -> Array[SytoLevelData]:
	var result:Array[SytoLevelData] = []
	for each in level_datas:
		result.append(each.duplicate(true))

	return result


func _get_data_for_level(_level:int) -> SkillLevelData:
	for each in level_datas:
		if each.level == _level: return each
	return null
