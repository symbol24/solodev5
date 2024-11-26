class_name SytoLevelData extends Resource


@export var level:int = 0
@export var stats:Array[Parameter]


func get_parameter(_param:String) -> Parameter:
	for each in stats:
		if each.id == _param:
			return each
	return null
