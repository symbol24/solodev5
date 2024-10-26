class_name Damage extends Resource


@export var base_value:int = 1


var final_value:int = 0
var damage_owner


func set_damage_owner(new_owner) -> void:
	damage_owner = new_owner


func get_damage() -> int:
	if damage_owner and damage_owner.is_dead: return 0
	final_value = base_value
	return final_value