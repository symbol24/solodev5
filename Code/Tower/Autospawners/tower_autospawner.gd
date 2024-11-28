class_name TowerAutospawner extends Node2D


@onready var spawn_point:Marker2D = %spawn_point

var data:TowerAutospawnerData
var is_active:bool = false
var spawn_count:int = 0
var current_delay:float:
	get: return data.get_parameter("spawn_delay") if data != null else 100.0
var timer:float = 0.0:
	set(value):
		timer = value
		if timer >= current_delay:
			timer = 0.0
			_spawn_for_count()
var unique_monster:String = ""


func _ready() -> void:
	Signals.TowerMonsterDeath.connect(_tower_monster_death)


func _process(delta: float) -> void:
	if is_active: timer += delta


func set_data(new_data:TowerAutospawnerData) -> void:
	data = new_data.duplicate(true)


func activate() -> void:
	is_active = true


func _spawn_for_count() -> void:
	if data != null and (not data.to_spawn.is_unique or (data.to_spawn.is_unique and unique_monster == "")):
		for i in data.get_parameter("spawn_count"):
			unique_monster = _spawn_one(data.to_spawn).name
			if data.to_spawn.is_unique:
				is_active = false


func _spawn_one(tmd:TowerMonsterData) -> TowerMonster:
	Debug.log("Spawning ", tmd.id)
	var tm:TowerMonster = tmd.to_spawn.instantiate()
	add_child(tm)
	tm.global_position = spawn_point.global_position
	tm.setup_data(tmd)
	return tm


func _tower_monster_death(_name:String, is_unique:bool) -> void:
	if _name == unique_monster and is_unique:
		is_active = true
		unique_monster = ""