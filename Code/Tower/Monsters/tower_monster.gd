class_name TowerMonster extends CharacterBody2D


@onready var animated_sprite: AnimatedSprite2D = %animated_sprite
@onready var attack_collider: CollisionShape2D = %attack_collider
@onready var hp_point: Marker2D = %hp_point

var data:TowerMonsterData
