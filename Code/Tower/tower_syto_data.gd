class_name TowerSytoData extends SytoData


@export var stats:Array[Parameter]


func get_parameter(_param:String) -> float:
	var params:Array[Parameter] = []
	var result:float = 0
	var percent:float = 1
	for each in stats:
		if each.id == _param:
			params.append(each)
	
	if Game.active_tower != null:
		params.append(Game.active_tower.data.get_tower_stat_parameter(_param))
	
	for each in params:
		if each != null:
			match each.type:
				Parameter.Type.FLAT:
					result = each.value
				Parameter.Type.FLAT_BONUS:
					result += each.value
				Parameter.Type.PERCENT_BONUS:
					percent += each.value

	result = get_leveled_value(result) * percent

	return result


func get_tower_stat_parameter(_param:String) -> Parameter:
	for each in stats:
		if each.id == _param:
			return each
	return null


func get_leveled_value(value) -> float:
	return value * (current_level * 0.5) if current_level > 1 else value