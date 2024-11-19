class_name SkillLevelData extends Resource


@export var level:int = 0
@export var use_delay:float = 3


func sld_has(_name:String) -> bool:
	var result = get(_name)
	if result == null: return false
	return true