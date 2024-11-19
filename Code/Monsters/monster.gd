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
var data:SkillData
var hp_bar:TextureProgressBar


func _process(_delta: float) -> void:
	if not is_dead:
		velocity = global_position.direction_to(target) * speed

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
			#print("Monster ", name, " received damage: ", amount)


func entered_light_pool() -> void:
	_death()


func setup_stats(_data:SkillData) -> void:
	is_dead = false
	data = _data
	speed = data.speed
	print("Monster speed: ", data.speed)
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
		push_error("Attack area not set in ", name, " monster.")
	animator.play("RESET")
	animator.play("walk")
	if global_position.x >= target.x and not sprite.flip_h:
		sprite.position.x = -sprite.position.x
		sprite.flip_h = !sprite.flip_h
	elif global_position.x < target.x and sprite.flip_h:
		sprite.position.x = -sprite.position.x
		sprite.flip_h = !sprite.flip_h


func _death() -> void:
	Audio.play_audio(Game.audio_list.get_audio_file("death"))
	is_dead = true
	animator.play("death")
	Signals.SpawnCurrency.emit(global_position)
	await animator.animation_finished
	Signals.ReturnToPool.emit(self, get_parent())
