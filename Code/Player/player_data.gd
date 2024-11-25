class_name PlayerData extends Resource


const STARTINGLEVELCAP:int = 5


# Run specific parameters
var player_level:int = 1
var current_exp:int = 0
var total_exp:int = 0
var current_score:int = 0
var run_currency:int = 0
var selected_leader:LeaderData
var unlocked_permas:Array[PermaData]:
	get: return Game.save_load.active_save.unlocked_permas if Game.save_load.active_save else []


func add_exp(value:int = 0) -> void:
	total_exp += value
	current_exp += value
	if current_exp >= get_level_exp_ceiling():
		current_exp -= get_level_exp_ceiling()
		_level_up()
	Signals.UpdatePlayerExp.emit(current_exp, get_level_exp_ceiling())


func get_level_exp_ceiling() -> int:
	return floori(STARTINGLEVELCAP * (player_level * 0.5)) if player_level > 1 else STARTINGLEVELCAP


func get_parameter(_param:String):
	#Debug.log("Getting ", _param ," from Player Data")
	var result = 0
	if get(_param) != null:
		if selected_leader != null: result = selected_leader.get_parameter(_param)
		for perma in unlocked_permas:
			result += perma.get_parameter(_param)
	if selected_leader != null and selected_leader.get(_param) != null: 
		result += selected_leader.get_parameter(_param)
	return result


func _level_up() -> void:
	player_level += 1
	Debug.log("Player Level up! ", player_level)
	Signals.PlayerlevelUp.emit(player_level)