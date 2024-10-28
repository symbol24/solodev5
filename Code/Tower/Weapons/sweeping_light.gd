class_name SweepingLight extends TowerWeapon


@export var rotation_speed:float = 10

@onready var light: Line2D = %light
@onready var attack_area: AttackArea = %AttackArea
@onready var attack_collider: CollisionShape2D = %collider

var starting_length:float

func _ready() -> void:
	attack_area.set_attack_owner(tower)
	attack_area.set_damages(damages.duplicate(true))
	Signals.UpdatePushbackRadius.connect(_reduce_collider_size)
	starting_length = attack_collider.shape.size.x


func _process(delta: float) -> void:
	if tower.is_active and is_active:
		light.points[1].x = tower.pushback_radius

		rotate(rotation_speed * delta)


func _reduce_collider_size(new_length:float) -> void:
	attack_collider.shape.size.x -= new_length
	var x:float = new_length/2
	attack_collider.position.x -= x