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


# Stats
var current_hp:int = 0:
	set(value):
		current_hp = value
		clampi(current_hp, 0, starting_hp)
		if current_hp == 0: _death()
var is_dead:bool = false


func _process(_delta: float) -> void:
	if not is_dead:
		velocity = global_position.direction_to(target) * speed

		move_and_slide()


func receive_damage(received:Array[Damage]) -> void:
	if not received.is_empty() and not is_dead:
		for each in received:
			var amount:int = each.get_damage()
			current_hp -= amount
			Signals.DamageNumber.emit(amount, global_position)
			#print("Monster ", name, " received damage: ", amount)


func entered_light_pool() -> void:
	_death()


func setup_stats() -> void:
	is_dead = false
	current_hp = starting_hp
	if attack_area:
		attack_area.set_attack_owner(self)
		attack_area.set_damages(damages.duplicate())
	else:
		push_error("Attack area not set in ", name, " monster.")


func _death() -> void:
	is_dead = true
	Signals.SpawnCurrency.emit(global_position)
	Signals.ReturnMonsterToPool.emit(self)
