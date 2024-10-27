class_name SweepingLight extends TowerWeapon


@export var rotation_speed:float = 10

@onready var light: Line2D = %light
@onready var attack_area: AttackArea = %AttackArea
@onready var attack_collider: CollisionShape2D = %collider


func _ready() -> void:
	attack_area.set_attack_owner(tower)
	attack_area.set_damages(damages.duplicate(true))


func _process(delta: float) -> void:
	if tower.is_active and is_active:
		light.points[1].x = tower.pushback_radius

		rotate(rotation_speed * delta)