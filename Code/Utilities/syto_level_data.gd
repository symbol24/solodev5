class_name SytoLevelData extends Resource


@export var level:int = 0


func stld_has(_name:String) -> bool:
	var result = get(_name)
	if result == null: return false
	return true