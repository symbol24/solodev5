class_name TowerWeapon extends Node2D


@onready var tower:Tower = get_parent() as Tower

var is_active:bool = false
var weapon_owner:SytoData
var data:TowerWeaponData


func set_data(_data:TowerWeaponData) -> void:
	data = _data.duplicate(true)


func activate() -> void:
	is_active = true
	#Debug.log("Weapon ", name, " is active!")


func setup_attack_area() -> void:
	pass
