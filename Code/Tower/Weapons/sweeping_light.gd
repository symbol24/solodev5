class_name SweepingLight extends TowerWeapon


@onready var light: Line2D = %light
@onready var attack_area: AttackArea = %AttackArea
@onready var attack_collider: CollisionShape2D = %attack_collider

var starting_length:float
var rotation_speed:float:
	get: return data.get_leveled_value(data.extra["starting_rotation_speed"]) if data and data.extra.has("starting_rotation_speed") else 0.1


func _ready() -> void:
	Signals.UpdateDarkRadius.connect(_reduce_collider_size)
	starting_length = attack_collider.shape.size.x


func _process(delta: float) -> void:
	if tower.is_active and is_active:
		rotation_degrees += (rotation_speed * delta)
		if rotation_degrees >= 360: rotation_degrees = 0


func setup_attack_area() -> void:
	attack_area.set_attack_owner(data)


func _reduce_collider_size(new_length:float) -> void:
	light.points[1].x = new_length
	attack_collider.shape.size.x -= new_length
	var x:float = new_length/2
	attack_collider.position.x -= x
