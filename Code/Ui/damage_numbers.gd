class_name DamageNumbers extends Control


var dmg_nbr_pool:Array[DamageNumber] = []
var spawn_count:int = 0

func _ready() -> void:
	Signals.DisplayDamageNumber.connect(_display_damage_number)
	Signals.ReturnDmgNbrToPool.connect(_return_to_pool)


func _display_damage_number(value:int, pos:Vector2, type:DamageType) -> void:
	var new:DamageNumber = _get_dmg_number()
	add_child(new)
	new.name = "dmg_number_0" + str(spawn_count)
	new.start(value, type.damage_color, pos)
	spawn_count += 1


func _get_dmg_number() -> DamageNumber:
	if dmg_nbr_pool.is_empty():
		return Game.data_manager.damage_number.instantiate() as DamageNumber
	else:
		return dmg_nbr_pool.pop_front()


func _return_to_pool(_dmg_nbr:DamageNumber) -> void:
	if Game.use_pooling:
		remove_child(_dmg_nbr)
		dmg_nbr_pool.append(_dmg_nbr)
	else:
		_dmg_nbr.queue_free()