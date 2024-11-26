class_name PermaData extends SytoData


func get_perma_parameter(_param:String) -> Parameter:
	var level_data:SytoLevelData = _get_data_for_level(current_level)
	if level_data != null:
		return level_data.get_parameter(_param)

	return null