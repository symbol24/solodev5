class_name TowerWeapon extends Node2D


@onready var tower:Tower = get_parent() as Tower

var is_active:bool = false
var weapon_owner:SytoData
var data:TowerWeaponData


func set_data(_data:TowerWeaponData) -> void:
	data = _data.duplicate()
	data.level_datas.clear()
	for each in _data.level_datas:
		data.level_datas.append(each.duplicate(true))
	data.damages.clear()
	for each in _data.damages:
		var new:Damage = each.duplicate(true)
		new.damage_owner = data
		data.damages.append(new)
	data.extra.clear()
	for k in _data.extra.keys():
		data.extra[k] = _data.extra[k]


func activate() -> void:
	is_active = true
	#Debug.log("Weapon ", name, " is active!")


func setup_attack_area() -> void:
	pass