class_name SpawningSkill extends Skill


@export var to_spawn:String
@export var spawn_type:String = "monster"

@export_group("Autospawner")
@export var spawner_spawns:String = "first"
@export var starting_spawn_delay:float = 10

var spawn_count:int = 0


func trigger_skill(pos:Vector2) -> void:
	if not used:
		used = true
		used_timer = current_used_delay
		_spawn_one(pos)


func _spawn_one(pos:Vector2) -> void:
	var new = Game.spawn_manager.get_thing_to_spawn(skill_data)
	var to_play:String = "monster_spawn"
	if new:
		new.global_position = pos
		new.name = spawn_type + "_0" + str(spawn_count)
		if spawn_type == "monster":
			new.setup_stats(data)
		spawn_count += 1
		Audio.play_audio(Game.audio_list.get_audio_file(to_play))