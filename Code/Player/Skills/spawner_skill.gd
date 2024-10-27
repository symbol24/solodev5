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
		_spawn_one(pos)


func _spawn_one(pos:Vector2) -> void:
	var new = Game.spawn_manager.get_thing_to_spawn(spawn_type, to_spawn)
	if new:
		new.global_position = pos
		new.name = spawn_type + "_0" + str(spawn_count)
		if spawn_type == "monster":
			new.setup_stats(data)
		elif spawn_type == "auto_spawner":
			new.setup_auto_spawner(data, spawner_spawns)
		spawn_count += 1