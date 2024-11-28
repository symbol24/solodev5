class_name AutoSpawner extends Node2D


@export var id:String

@onready var spawn_point: Marker2D = %spawn_point
@onready var spawn_progress_bar: TextureProgressBar = %spawn_progress_bar

var data:AutoSpawnerSkillData
var skill_id:String:
	get: return data.id if data else str(self.name)
var is_active:bool = false
var current_delay:float:
	get: return _get_current_spawn_delay()
var spawn_count:int = 0
var timer:float = 0.0:
	set(value):
		timer = value
		if timer >= current_delay:
			timer = 0.0
			_spawn_for_count(data.spawn_count)
		spawn_progress_bar.value = (timer/current_delay)*100
var unique_monster:Monster = null


func _process(delta: float) -> void:
	if is_active: timer += delta


func setup_auto_spawner(_data:SkillData) -> void:
	data = _data
	
	is_active = true
	_spawn_for_count(data.spawn_count)


func _spawn_for_count(_count:int = 1) -> void:
	if not data.to_spawn.is_unique or(data.to_spawn.is_unique and unique_monster == null):
		var x:int = 0
		while x < _count:
			_spawn_one()
			x += 1
			await get_tree().create_timer(0.2).timeout


func _spawn_one() -> Monster:
	var new = Game.spawn_manager.get_thing_to_spawn(data.monster_data)
	if new:
		data.monster_data.current_level = data.current_level
		new.setup_stats(data.monster_data)
		new.global_position = spawn_point.global_position
		new.name = name + "_" + data.monster_data.id + "_0" + str(spawn_count)
		#Debug.log("monster ", new.name, " spawned")
		spawn_count += 1
		Audio.play_audio(Game.audio_list.get_audio_file("monster_spawn"))
		return new
	return null


func _get_current_spawn_delay() -> float:
	if data:
		return data.spawn_delay
	else:
		return 100
