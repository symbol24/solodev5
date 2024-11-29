class_name Monster extends CharacterBody2D


@export_group("Attack")
@export var attack_area:AttackArea

@export_group("Other")
@export var target:Vector2 = Vector2(320, 180)

@onready var hp_point: Marker2D = %hp_point
@onready var animator: AnimationPlayer = %animator
@onready var sprite: Sprite2D = %sprite

var data:MonsterData
var hp_bar:TextureProgressBar
var flippables:Array = []
var flipped:bool = false


func _ready() -> void:
	flippables = _get_flippables(self)


func _process(_delta: float) -> void:
	if not data.is_dead:
		var direction:Vector2 = global_position.direction_to(target)
		_flip(direction)
		velocity = direction * data.speed

		move_and_slide()


func receive_damage(received:Array[Damage]) -> void:
	if not received.is_empty() and not data.is_dead:
		Audio.play_audio(Game.audio_list.get_audio_file("hit"))
		for each in received:
			var amount:int = each.get_damage()
			data.current_hp -= amount
			if hp_bar != null: 
				hp_bar.value = data.current_hp
			Signals.DisplayDamageNumber.emit(amount, global_position, each.type)
			if data.is_dead:
				_death()
			#Debug.log("Monster ", name, " received damage: ", amount)


func entered_light_pool() -> void:
	_death()


func setup_stats(_data:MonsterData) -> void:
	data = _data.duplicate()
	data.level_datas.clear()
	data.level_datas = _data.get_duplicate_levels()
	data.setup_data(_data.current_level)
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
	animator.play("RESET")
	animator.play("walk")


func _death() -> void:
	if not data.is_dead: data.is_dead = true
	hp_bar.hide()
	Audio.play_audio(Game.audio_list.get_audio_file("death"))
	animator.play("death")
	Signals.SpawnCurrency.emit(CurrencyObject.Type.EXP, 1, global_position)
	Signals.SpawnCurrency.emit(CurrencyObject.Type.COIN, 1, global_position)
	await animator.animation_finished
	Signals.ReturnToPool.emit(self)


func _flip(_direction:Vector2) -> void:
	var flip:bool = false
	if not flipped and _direction.x < 0:
		flip = true
	elif flipped and _direction.x >= 0:
		flip = true
	
	if flip:
		for each in flippables:
			if each is Sprite2D:
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
