class_name Tower extends Area2D


@export var tower_data:TowerData

@onready var light_area: Area2D = %light_area
@onready var light_area_collider: CollisionShape2D = %light_area_collider
@onready var attack_point: Marker2D = %attack_point
@onready var radius_timer: Timer = %radius_timer
@onready var tower_light_circle: Sprite2D = %tower_light_circle

var data:TowerData
var is_active:bool = false


func _ready() -> void:
	Signals.SetupTower.connect(_setup_tower)
	Signals.ActivateTower.connect(_activate)
	Signals.StopRound.connect(_tower_stop)
	Signals.UpdateDarkRadius.connect(_update_dark_radius)
	radius_timer.timeout.connect(_timer_timeout)
	light_area.mouse_entered.connect(_mouse_entered_light)
	light_area.mouse_exited.connect(_mouse_exited_light)
	data = tower_data.duplicate(true)


func receive_damage(received:Array[Damage]) -> void:
	if is_active and not received.is_empty():
		for each in received:
			if not data.is_dead:
				var amount:int = each.get_damage()
				_update_light_radius(-amount)
				Signals.DamageNumber.emit(amount, global_position, "dark")
				if data.light_radius == data.starting_light_radius:
					data.dark_radius -= amount 
					Signals.UpdateDarkRadius.emit(amount)
					Signals.CheckMatchEnd.emit(data.starting_light_radius, data.light_radius, data.dark_radius)


func _setup_weapon(_data:TowerWeaponData) -> void:
	var new_weapon:TowerWeapon = load(_data.path).instantiate() as TowerWeapon
	add_child(new_weapon)
	if not new_weapon.is_node_ready():
		await new_weapon.ready
	new_weapon.position = attack_point.position
	new_weapon.name = _data.id
	new_weapon.set_data(_data)
	new_weapon.setup_attack_area()
	data.active_weapons.append(new_weapon)


func _activate() -> void:
	is_active = true
	for aw in data.active_weapons:
		aw.activate()
	radius_timer.start()
	

func _exit_tree() -> void:
	Signals.TowerClear.emit()


func _mouse_entered_light() -> void:
	#Debug.log("mouse in")
	Signals.ToggleMouseEnteredNoClickArea.emit(true)


func _mouse_exited_light() -> void:
	#Debug.log("mouse out")
	Signals.ToggleMouseEnteredNoClickArea.emit(false)


func _setup_tower() -> void:
	is_active = false
	data.setup_data()
	for each in data.starter_weapons:
		_setup_weapon(each)
	Signals.TowerReady.emit(self)
		

func _tower_stop() -> void:
	is_active = false
	data.is_dead = true
	radius_timer.stop()


func _timer_timeout() -> void:
	if is_active:
		_update_light_radius(data.current_increase_per_tic)
		data.temp_exp += data.exp_per_tic


func _update_light_radius(value:float) -> void:
	if is_active and not data.is_dead:
		data.light_radius += value
		data.light_radius = max(data.starting_light_radius, data.light_radius)
		Signals.UpdateTowerLightArea.emit(data.light_radius)

		var scale_value:float = data.light_radius/data.starting_light_radius
		tower_light_circle.scale = Vector2(scale_value, scale_value)

		Signals.CheckMatchEnd.emit(data.starting_light_radius, data.light_radius, data.dark_radius)


func _update_dark_radius(radius:float) -> void:
	light_area_collider.shape.radius -= radius
