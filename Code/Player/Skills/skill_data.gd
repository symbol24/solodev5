class_name SkillData extends Resource


@export var id:String
@export var skill_path:String
@export var level_datas:Array[SkillLevelData]

@export_group("Level Up")
@export var title:String
@export var description:String
@export var ui_texture:CompressedTexture2D

# general
var current_level:int = 0:
	set(value): 
		current_level = min(value, Game.SKILLLEVELCAP)
		Signals.SkillLevelUpdated.emit(id, current_level)
var use_delay:float:
	get: return _get_data("use_delay")


func _get_data(_id:String):
	if level_datas.is_empty(): 
		push_error("Level data for ", id ," does not contain any level datas")
		return null

	var level_data:SkillLevelData = _get_data_for_level(current_level)

	if level_data.sld_has(_id):
		return level_data.get(_id)
	else:
		push_error("Level data of ", id, " does not have a key for ", _id, " at level ", current_level)
		return 0


func _get_data_for_level(_level:int) -> SkillLevelData:
	for each in level_datas:
		if each.level == _level: return each
	return null