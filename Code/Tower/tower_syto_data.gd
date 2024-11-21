class_name TowerSytoData extends SytoData


func get_parameter(_param:String):
	if get(_param) != null:
		return get_leveled_value(get(_param))
	return 0


func get_leveled_value(value):
	return floor(value * (current_level * 0.5)) if current_level > 1 else value