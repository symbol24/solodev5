class_name SweepingLight extends TowerWeapon


@onready var light: Line2D = %light
@onready var attack_area: AttackArea = %AttackArea
@onready var attack_collider: CollisionShape2D = %collider

var starting_length:float
var rotation_speed:float:
	get: return tower.data.get_leveled_value(data.extra["starting_rotation_speed"]) if data and data.extra.has("starting_rotation_speed") else 0.1


func _ready() -> void:
	Signals.UpdatePushbackRadius.connect(_reduce_collider_size)
	starting_length = attack_collider.shape.size.x


func _process(delta: float) -> void:
	if tower.is_active and is_active:
		light.points[1].x = tower.data.dark_radius
		rotate(rotation_speed * delta)


func setup_attack_area() -> void:
	attack_area.set_attack_owner(data)
	attack_area.set_damages(data.damages)


func _reduce_collider_size(new_length:float) -> void:
	attack_collider.shape.size.x -= new_length
	var x:float = new_length/2
	attack_collider.position.x -= x
