class_name SaveLoadManager extends Node


const FOLDER:String = "user://saves/"
const PREFIX:String = "save_"
const SUFFIX:String = ".tres"


var all_saves:Array[SaveData]
var active_save:SaveData


func _ready() -> void:
	Signals.Save.connect(_save)
	Signals.Load.connect(_load)
	all_saves = _get_all_save_files()
	Signals.SaveLoadManagerReady.emit()
	if all_saves.is_empty(): _save()
	else: _load()


func _get_all_save_files() -> Array[SaveData]:
	var saves:Array[SaveData] = []
	var dir = DirAccess.open(FOLDER)
	if dir == null:
		var result = DirAccess.make_dir_absolute(FOLDER)
		if result != OK:
			Debug.error("Error ", result, " creating save folder.")
		dir = DirAccess.open(FOLDER)
	
	var files = dir.get_files()
	for each in files:
		if each.ends_with(SUFFIX):
			if ResourceLoader.exists(FOLDER + each):
				saves.append(ResourceLoader.load(FOLDER + each))

	return saves


func _save(_id:int = -1) -> void:
	if all_saves.is_empty():
		Debug.warning("No active save file, creating new save file")
		_create_save_file()
	else:
		ResourceSaver.save(active_save, active_save.resource_path)


func _load(_id:int = -1) -> void:
	if all_saves.is_empty():
		Debug.warning("No save files loaded.")
	
	# Debug loading of first save file for now
	if _id == -1:
		active_save = all_saves[0]
		Debug.log("First save loaded.")
		return
	
	for each in all_saves:
		if each.id == _id:
			active_save = each
			return
	
	Debug.warning("No save file found with id: ", _id)


func _create_save_file() -> void:
	var dir = DirAccess.open(FOLDER)
	if dir == null:
		var result = DirAccess.make_dir_absolute(FOLDER)
		if result != OK:
			Debug.error("Error ", result, " creating save folder.")
		dir = DirAccess.open(FOLDER)
	
	
	var save_id:int = hash("syto".join([all_saves.size()]))
	var new_save:SaveData = SaveData.new()
	new_save.id = save_id
	new_save.save_count += 1
	Debug.log(FOLDER + PREFIX + str(save_id) + SUFFIX)
	ResourceSaver.save(new_save, FOLDER + PREFIX + str(save_id) + SUFFIX)


func _end_run_data_update(player_data:PlayerData) -> void:
	active_save.score_history[Time.get_datetime_string_from_system()] = player_data.current_score
	active_save.total_currency += player_data.run_currency


func get_parameter_from_permas(_param:String):
	if active_save == null:
		Debug.error("No active save to get perma parameter from.")
		return 0
	
	if active_save.unlocked_permas.is_empty(): return 0

	var result = 0
	for perma in active_save.unlocked_permas:
		result += perma.get_parameter(_param)
	
	return result