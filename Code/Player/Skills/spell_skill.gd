class_name SpellSkill extends Skill


var spawn_count:int = 0


func trigger_skill(pos:Vector2, _in_light:bool = true) -> void:
	if not used and _in_light:
		used = true
		used_timer = current_used_delay
		_spawn_one(pos)


func _spawn_one(pos:Vector2) -> void:
	var new = Game.spawn_manager.get_thing_to_spawn(data)
	if new:
		new.global_position = pos
		new.name = data.id + "_0" + str(spawn_count)
		new.setup_projectile(data)
		spawn_count += 1
		Audio.play_audio(Game.audio_list.get_audio_file("spawner_placed"))
	else:
		Debug.error("Missing object for id ", data.id , " in data manager.")