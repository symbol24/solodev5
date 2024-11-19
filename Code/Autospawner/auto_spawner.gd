class_name AutoSpawner extends Node2D


@export var id:String

@onready var spawn_point: Marker2D = %spawn_point
@onready var spawn_progress_bar: TextureProgressBar = %spawn_progress_bar

var skill_data:AutoSpawnerSkillData
var skill_id:String:
	get: return skill_data.id if skill_data else str(self.name)
var to_spawn:String
var spawn_type:String
var is_active:bool = false
var current_delay:float:
	get: return _get_current_spawn_delay()
var spawn_count:int = 0
var timer:float = 0.0:
	set(value):
		timer = value
		if timer >= current_delay:
			timer = 0.0
			_spawn_one()
		spawn_progress_bar.value = (timer/current_delay)*100
var spawned_json:String = skill_data.paresed_json["spawned_json"] if skill_data and not skill_data.is_empty() else ""


func _process(delta: float) -> void:
	if is_active: timer += delta


func setup_auto_spawner(_data:SkillData, _to_spawn:String, _type:String = "monster") -> void:
	skill_data = _data
	to_spawn =_to_spawn
	spawn_type = _type
	is_active = true
	_spawn_one()


func _spawn_one() -> void:
	var new = Game.spawn_manager.get_thing_to_spawn(spawn_type, to_spawn)
	if new:
		var monster_skill_data:SkillData = SkillData.new()
		monster_skill_data = skill_data.monster_data.duplicate(true)
		monster_skill_data.current_level = skill_data.current_level
		#print("spawning monster level: ", monster_skill_data.current_level)
		new.setup_stats(monster_skill_data)
		new.global_position = spawn_point.global_position
		new.name = spawn_type + "_0" + str(spawn_count)
		spawn_count += 1
		Audio.play_audio(Game.audio_list.get_audio_file("monster_spawn"))


func _get_current_spawn_delay() -> float:
	if skill_data:
		return skill_data.spawner_spawn_time
	else:
		return 100
