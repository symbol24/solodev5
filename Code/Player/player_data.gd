class_name PlayerData extends Resource


const STARTINGLEVELCAP:int = 5


# Run specific parameters
var player_level:int = 1
var current_exp:float = 0
var total_exp:float = 0
var current_score:int = 0
var run_currency:float = 0
var unlocked_permas:Array[PermaData]:
	get: return Game.save_load.active_save.unlocked_permas if Game.save_load.active_save else []


func add_exp(value:float = 0) -> void:
	total_exp += value
	current_exp += value
	if current_exp >= get_level_exp_ceiling():
		current_exp -= get_level_exp_ceiling()
		_level_up()
	Signals.UpdatePlayerExp.emit(current_exp, get_level_exp_ceiling())


func add_currency(value:float = 0) -> void:
	run_currency += value
	Signals.UpdatePlayerCurrency.emit(run_currency)


func get_level_exp_ceiling() -> int:
	return floori(STARTINGLEVELCAP * (player_level * 0.5)) if player_level > 1 else STARTINGLEVELCAP


func _level_up() -> void:
	player_level += 1
	Debug.log("Player Level up! ", player_level)
	Signals.PlayerlevelUp.emit(player_level)