class_name TowerWeapon extends Node2D


@onready var tower:Tower = get_parent() as Tower

var is_active:bool = false


func activate() -> void:
	is_active = true
	#print("Weapon ", name, " is active!")