class_name AutoSpawner extends Node2D


@export var id:String

@onready var spawn_point: Marker2D = %spawn_point
@onready var spawn_progress_bar: TextureProgressBar = %spawn_progress_bar

var skill_data:AutoSpawnerSkillData
var skill_id:String:
	get: return skill_data.id if skill_data else str(self.name)
var is_active:bool = false
var current_delay:float:
	get: return _get_current_spawn_delay()
var spawn_count:int = 0
var timer:float = 0.0:
	set(value):
		timer = value
		if timer >= current_delay:
			timer = 0.0
			_spawn_for_count(skill_data.spawn_count)
		spawn_progress_bar.value = (timer/current_delay)*100
var spawned_json:String = skill_data.paresed_json["spawned_json"] if skill_data and not skill_data.is_empty() else ""


func _process(delta: float) -> void:
	if is_active: timer += delta


func setup_auto_spawner(_data:SkillData) -> void:
	skill_data = _data
	is_active = true
	_spawn_for_count(skill_data.spawn_count)


func _spawn_for_count(_count:int = 1) -> void:
	var x:int = 0
	while x < _count:
		_spawn_one()
		x += 1
		await get_tree().create_timer(0.2).timeout


func _spawn_one() -> void:
	var new = Game.spawn_manager.get_thing_to_spawn(skill_data.monster_data)
	if new:
		var monster_skill_data:SkillData = SkillData.new()
		monster_skill_data = skill_data.monster_data.duplicate(true)
		monster_skill_data.current_level = skill_data.current_level
		new.setup_stats(monster_skill_data)
		new.global_position = spawn_point.global_position
		new.name = name + "_" + monster_skill_data.id + "_0" + str(spawn_count)
		#print("monster ", new.name, " spawned")
		spawn_count += 1
		Audio.play_audio(Game.audio_list.get_audio_file("monster_spawn"))


func _get_current_spawn_delay() -> float:
	if skill_data:
		return skill_data.spawn_delay
	else:
		return 100
