class_name Projectile extends AttackArea


@onready var sprite: Sprite2D = %sprite


func setup_projectile(_data:SkillData) -> void:
	set_attack_owner(_data)