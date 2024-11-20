class_name Monster extends CharacterBody2D


@export var id:String

@export_group("Stats")
@export var starting_hp:int = 10
@export var speed:float = 10

@export_group("Attack and Damage")
@export var damages:Array[Damage] = []
@export var attack_area:AttackArea

@export_group("Other")
@export var target:Vector2 = Vector2(320, 180)
@export var packed_hp_bar:PackedScene

@onready var hp_point: Marker2D = %hp_point
@onready var animator: AnimationPlayer = %animator
@onready var sprite: Sprite2D = %sprite

# Stats
var current_hp:int = 0:
	set(value):
		current_hp = value
		if current_hp <= 0: _death()

var is_dead:bool = false
var data:MonsterSkillData
var hp_bar:TextureProgressBar
var flippables:Array = []
var flipped:bool = false


func _ready() -> void:
	flippables = _get_flippables(self)


func _process(_delta: float) -> void:
	if not is_dead:
		var direction:Vector2 = global_position.direction_to(target)
		_flip(direction)
		velocity = direction * speed

		move_and_slide()


func receive_damage(received:Array[Damage]) -> void:
	if not received.is_empty() and not is_dead:
		Audio.play_audio(Game.audio_list.get_audio_file("hit"))
		for each in received:
			var amount:int = each.get_damage()
			current_hp -= amount
			if hp_bar != null: 
				hp_bar.value = current_hp
			Signals.DamageNumber.emit(amount, global_position, "light")
			#Debug.log("Monster ", name, " received damage: ", amount)


func entered_light_pool() -> void:
	_death()


func setup_stats(_data:SkillData) -> void:
	if not _data is MonsterSkillData:
		Debug.error("Monster has received not Monster Skill Data")
		return
	is_dead = false
	data = _data
	speed = data.speed
	current_hp = data.hp
	if packed_hp_bar:
		hp_bar = packed_hp_bar.instantiate()
		add_child(hp_bar)
		hp_bar.position = hp_point.position
		hp_bar.step = 1
		hp_bar.max_value = data.hp
		hp_bar.value = current_hp
	if attack_area:
		attack_area.set_attack_owner(self)
		attack_area.set_damages(damages.duplicate())
	else:
		Debug.error("Attack area not set in ", name, " monster.")
	animator.play("RESET")
	animator.play("walk")


func _death() -> void:
	Audio.play_audio(Game.audio_list.get_audio_file("death"))
	is_dead = true
	animator.play("death")
	Signals.SpawnCurrency.emit(global_position)
	await animator.animation_finished
	Signals.ReturnToPool.emit(self)


func _flip(_direction:Vector2) -> void:
	var flip:bool = false
	if not flipped and _direction.x < 0:
		flip = true
	elif flipped and _direction.x >= 0:
		flip  =true
	
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