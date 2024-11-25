class_name BoosterData extends SytoData


@export var stats:Dictionary = {}


func get_parameter(_param:String):
	if stats.has(_param): return stats[_param]

	return null