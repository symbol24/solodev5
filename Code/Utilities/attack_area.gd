class_name AttackArea extends Area2D


@export var damages:Array[Damage]

@onready var attack_collider: CollisionShape2D = %attack_collider

var attack_owner:SytoData


func set_attack_owner(new_owner) -> void:
	attack_owner = new_owner