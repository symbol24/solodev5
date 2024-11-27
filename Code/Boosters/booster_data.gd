class_name BoosterData extends SytoData


@export_group("Level Up")
@export var title:String
@export var description:String
@export var ui_texture:CompressedTexture2D


func get_booster_parameter(_param:String) -> Parameter:
	if level_datas.is_empty():
		Debug.warning("Booster ", id, " does not have any level datas.")
		return null
	
	var level_data:BoosterSLD = _get_data_for_level(current_level)
	if level_data != null:
		return level_data.get_parameter(_param)

	return null
