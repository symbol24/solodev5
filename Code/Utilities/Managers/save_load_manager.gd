class_name SaveLoadManager extends Node


const FOLDER:String = "user://saves/"
const PREFIX:String = "save_"
const PREFIXGAME:String = "save"
const SUFFIX:String = ".tres"


@export var icon_time:int = 4

var game_save:GameSaveData = null
var all_saves:Array[ProfileSaveData]
var active_save:ProfileSaveData = null


func _ready() -> void:
	Signals.Save.connect(_save)
	Signals.Load.connect(_load)
	Signals.CreateNewProfile.connect(_create_save_file)
	Signals.DeleteSaveFile.connect(_delete_save_file)
	_load_game_save()
	all_saves = _get_all_save_files()
	_load()
	Signals.SaveLoadManagerReady.emit()


func _get_all_save_files() -> Array[ProfileSaveData]:
	_check_folder()
	var saves:Array[ProfileSaveData] = []
	var dir = _check_folder()
	
	var files = dir.get_files()
	for each in files:
		if each.ends_with(SUFFIX):
			if ResourceLoader.exists(FOLDER + each):
				var to_append = ResourceLoader.load(FOLDER + each)
				if to_append is ProfileSaveData: saves.append(to_append)
	return saves


func _save(_id:int = -1) -> void:
	_check_folder()
	if all_saves.is_empty():
		Debug.log("No active save file, creating new save file")
		_create_save_file()
	else:
		ResourceSaver.save(active_save, active_save.resource_path)
		Signals.DisplaySaveIcon.emit(icon_time)


func _load(_id:int = -1) -> void:
	if all_saves.is_empty():
		Debug.log("No save files loaded.")
		return
	
	# Debug loading of first save file for now
	if _id == -1:
		if game_save.last_profile_saved != -1:
			_load(game_save.last_profile_saved)
		else:
			active_save = all_saves[0]
		return
	
	for each in all_saves:
		if each.id == _id:
			active_save = each
			game_save.last_profile_saved = _id
			_save_game_save()
			Signals.SaveLoadComplete.emit(active_save)
			Debug.log("Loaded save ", active_save.id)
			return
	
	Debug.log("No save file found with id: ", _id)


func _create_save_file() -> void:
	_check_folder()
	
	var save_id:int = hash("syto".join([game_save.total_profiles_created]))
	game_save.total_profiles_created += 1
	_save_game_save()
	var new_save:ProfileSaveData = ProfileSaveData.new()
	new_save.id = save_id
	new_save.save_count += 1
	all_saves.append(new_save)
	#Debug.log(FOLDER + PREFIX + str(save_id) + SUFFIX)
	ResourceSaver.save(new_save, FOLDER + PREFIX + str(save_id) + SUFFIX)
	Signals.NewSaveFileCreated.emit(new_save.id)
	Signals.DisplaySaveIcon.emit(icon_time)


func _end_run_data_update(player_data:PlayerData) -> void:
	active_save.score_history[Time.get_datetime_string_from_system()] = player_data.current_score
	active_save.total_currency += player_data.run_currency


func _delete_save_file(_id:int) -> void:
	_check_folder()
	var to_delete:ProfileSaveData = null
	var to_delete_id:int = -1
	var pos:int = -2
	for each in all_saves:
		if each.id == _id:
			to_delete = each

	to_delete_id = to_delete.id

	var error = DirAccess.remove_absolute(to_delete.resource_path)
	if error != OK:
		Signals.DisplaySmallPopup.emit(PopupManager.Level.ERROR, tr("delete_fail") % to_delete_id)
		Debug.error("Error ", error, " received when trying to delete save file ", to_delete_id)
		all_saves.append(to_delete)
		return
	
	pos = all_saves.find(to_delete)
	if pos != -1:
		all_saves.remove_at(pos)
	Signals.DeleteSaveSuccess.emit(to_delete_id)


func get_parameter_from_permas(_param:String) -> Array[Parameter]:
	if active_save == null:
		Debug.error("No active save to get perma parameter from.")
		return []
	
	if active_save.unlocked_permas.is_empty(): return []

	var result:Array[Parameter] = []
	for perma in active_save.unlocked_permas:
		if perma.get_perma_parameter(_param) != null:
			result.append(perma.get_perma_parameter(_param))
	
	return result


func _load_game_save() -> void:
	_check_folder()

	if ResourceLoader.exists(FOLDER + PREFIXGAME + SUFFIX):
		game_save = ResourceLoader.load(FOLDER + PREFIXGAME + SUFFIX)
	else:
		_save_game_save()


func _save_game_save() -> void:
	_check_folder()
		
	if game_save == null: game_save = GameSaveData.new()
	
	ResourceSaver.save(game_save, FOLDER + PREFIXGAME + SUFFIX)
	Signals.DisplaySaveIcon.emit(icon_time)


func _check_folder() -> DirAccess:
	var dir:DirAccess = DirAccess.open(FOLDER)
	if dir == null:
		var result = DirAccess.make_dir_absolute(FOLDER)
		if result != OK:
			Debug.error("Error ", result, " creating save folder.")
		dir = DirAccess.open(FOLDER)
	return dir