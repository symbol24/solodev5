class_name HitBox extends Area2D


@export var hit_delay:float = 0.1

var monster:Monster
var tower:Tower
var is_active:bool = false
var timer:float = 0.0:
	set(value):
		timer = value
		if timer >= hit_delay:
			is_active = true
			timer = 0.0


func _ready() -> void:
	area_entered.connect(_area_entered)
	name = "hit_box_0"
	var parent = get_parent()
	if parent is Monster:
		monster = parent
		is_active = true
	elif parent is Tower:
		tower = parent
		is_active = true
	else:
		push_error("Parent ", parent.name, " is neither a Monster nor a Tower.")


func _process(delta: float) -> void:
	if not is_active: timer += delta


func _area_entered(area: Area2D ) -> void:
	if area is AttackArea:
		if area.attack_owner is Monster and tower != null:
			tower.receive_damage(area.damages.duplicate())
			area.attack_owner.entered_light_pool()
		elif area.attack_owner is Tower and monster != null:
			monster.receive_damage(area.damages.duplicate())
			is_active = false
