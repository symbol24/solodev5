class_name AttackArea extends Area2D


@export var damages:Array[Damage]

var attack_owner:SytoData


func set_attack_owner(new_owner) -> void:
	attack_owner = new_owner


func set_damages(new:Array[Damage]) -> void:
	damages = new
	for each in damages:
		each.set_damage_owner(attack_owner)