class_name AutoSpawnerSkillData extends SkillData


@export var monster_data:SkillData


func get_monster_data() -> SkillData:
	var toreturn:SkillData = monster_data.duplicate(true)
	toreturn.level_datas.clear()
	var keys = monster_data.level_datas.keys()
	for k in keys:
		toreturn.level_datas[k] =  monster_data.level_datas[k]
	print("monster data levels: ", toreturn.level_datas)
	return toreturn