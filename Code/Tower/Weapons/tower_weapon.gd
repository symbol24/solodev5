class_name TowerWeapon extends Node2D


@export var damages:Array[Damage]

@onready var tower:Tower = get_parent() as Tower

var is_active:bool = false
var weapon_owner


func activate() -> void:
	is_active = true
	#Debug.log("Weapon ", name, " is active!")