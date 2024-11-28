class_name TowerMonster extends CharacterBody2D


@export var attack_area:AttackArea

@onready var animated_sprite: AnimatedSprite2D = %animated_sprite
@onready var attack_collider: CollisionShape2D = %attack_collider
@onready var hp_point: Marker2D = %hp_point

var data:TowerMonsterData
var hp_bar:TextureProgressBar
var flippables:Array = []
var flipped:bool = false
var close:bool = false
var close_distance:float:
	get: return data.get_parameter("close_distance") if data.get_parameter("close_distance") != null else 500.0


func _ready() -> void:
	flippables = _get_flippables(self)


func _process(delta: float) -> void:
	if not data.is_dead:
		
		var direction:Vector2 = _behaviour()
		
		_flip(direction)
		_idle_check(direction)
		velocity = direction * data.speed

		move_and_slide()


func setup_data(new_data:TowerMonsterData) -> void:
	data = new_data.duplicate(true)
	data.setup_data()
	if Game.data_manager.packed_hp_bar:
		hp_bar = Game.data_manager.packed_hp_bar.instantiate()
		add_child(hp_bar)
		hp_bar.position = hp_point.position
		hp_bar.step = 1
		hp_bar.max_value = data.starting_hp
		hp_bar.value = data.current_hp
	if attack_area:
		attack_area.set_attack_owner(data)
	else:
		Debug.error("Attack area not set in ", name, " monster.")


func receive_damage(received:Array[Damage]) -> void:
	if not received.is_empty() and not data.is_dead:
		Audio.play_audio(Game.audio_list.get_audio_file("hit"))
		for each in received:
			var amount:int = each.get_damage()
			data.current_hp -= amount
			if hp_bar != null: 
				hp_bar.value = data.current_hp
			Signals.DamageNumber.emit(amount, global_position, "dark")
			if data.is_dead:
				_death()


func _behaviour() -> Vector2:
	var result: Vector2 = Vector2.ZERO
	var target = Game.spawn_manager.get_closest_to(self)
	if target:
		if not close and global_position.distance_squared_to(target.global_position) > close_distance:
			result = _get_close(target)
		elif not close and global_position.distance_squared_to(target.global_position) <= close_distance:
			result = _get_close(target)
			close = true
		elif close and global_position.distance_squared_to(target.global_position) <= close_distance:
			pass # do attack
		elif close and global_position.distance_squared_to(target.global_position) > close_distance:
			close = false
			result = _get_close(target)

	return result





func _get_close(target:Node2D) -> Vector2:
	var result:Vector2 = Vector2.ZERO
	if target != null: result = global_position.direction_to(target.global_position)
	return result


func _idle_check(_direction:Vector2 = Vector2.ZERO) -> void:
	if _direction != Vector2.ZERO and animated_sprite.animation != "walk":
		animated_sprite.play("walk")
	elif _direction == Vector2.ZERO and animated_sprite.animation != "idle":
		animated_sprite.play("idle")


func _death() -> void:
	if not data.is_dead: data.is_dead = true
	animated_sprite.play("death")
	hp_bar.hide()
	await animated_sprite.animation_finished
	Signals.TowerMonsterDeath.emit(name, data.is_unique)
	queue_free.call_deferred()


func _flip(_direction:Vector2) -> void:
	var flip:bool = false
	if not flipped and _direction.x < 0:
		flip = true
	elif flipped and _direction.x >= 0:
		flip = true
	
	if flip:
		for each in flippables:
			if each is AnimatedSprite2D:
				each.flip_h = !each.flip_h
			each.position.x = -each.position.x
		flipped = !flipped


func _get_flippables(_parent) -> Array:
	var result:Array = []

	var children = _parent.get_children()
	for child in children:
		if child.is_in_group("flippable"):
			result.append(child)

		result.append_array(_get_flippables(child))

	return result