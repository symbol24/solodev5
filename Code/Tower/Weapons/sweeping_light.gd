class_name SweepingLight extends TowerWeapon


@export var rotation_speed:float = 10

@onready var light: Line2D = %light
@onready var attack_area: AttackArea = %AttackArea
@onready var attack_collider: CollisionShape2D = %collider


func _ready() -> void:
	attack_area.set_attack_owner(tower)


func _process(delta: float) -> void:
	if is_active:
		light.points[1].x = tower.light_radius

		rotate(rotation_speed * delta)