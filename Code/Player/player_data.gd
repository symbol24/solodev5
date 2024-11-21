class_name PlayerData extends Resource


@export var current_currency:int
@export var total_currency:int

@export var score_history:Dictionary = {}
@export var unlocked_permas:Array[PermaData]

# Run specific parameters
var player_level:int = 1
var current_exp:int = 0
var total_exp:int = 0
var current_score:int = 0
var last_run_score:int = 0
var run_currency:int = 0
var last_run_curency:int = 0

var selected_leader:LeaderData


func get_parameter(_param:String):
	if get(_param) != null:
		var result = 0
		if selected_leader != null: result = selected_leader.get_parameter(_param)
		for perma in unlocked_permas:
			result += perma.get_parameter(_param)
		return result
	return 0