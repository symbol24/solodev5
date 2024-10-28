class_name Tower extends Area2D


@export_group("Stats")
@export var starting_level:int = 1
@export var starting_pushback_radius:float = 160
@export var starting_light_radius:float = 24
@export var starting_light_increase_per_tic:int = 1

@export_group("Weapons")
@export var weapons:Array[TowerWeaponData] = []
@export var starter_weapons:Array[TowerWeaponData] = []

@onready var light_area: Area2D = %light_area
@onready var light_area_collider: CollisionShape2D = %light_area_collider
@onready var attack_point: Marker2D = %attack_point
@onready var radius_timer: Timer = %radius_timer
@onready var tower_light_circle: Sprite2D = %tower_light_circle

var current_level:int
var current_increase_per_tic:int
var pushback_radius:float = 160
var light_radius:float = 24
var active_weapons:Array[TowerWeapon] = []
var is_active:bool = false
var is_dead:bool = false


func _ready() -> void:
	Signals.SetupTower.connect(_setup_tower)
	Signals.ActivateTower.connect(_activate)
	Signals.StopRound.connect(_tower_stop)
	Signals.UpdatePushbackRadius.connect(_update_push_back_area)
	radius_timer.timeout.connect(_timer_timeout)
	light_area.mouse_entered.connect(_mouse_entered_light)
	light_area.mouse_exited.connect(_mouse_exited_light)


func receive_damage(received:Array[Damage]) -> void:
	if is_active and not received.is_empty():
		for each in received:
			var amount:int = each.get_damage()
			_update_light_radius(-amount)
			Signals.DamageNumber.emit(amount, global_position, "dark")
			if light_radius == starting_light_radius:
				pushback_radius -= amount 
				Signals.UpdatePushbackRadius.emit(amount)
				Signals.CheckMatchEnd.emit(starting_light_radius, light_radius, pushback_radius)


func _setup_weapon(_data:TowerWeaponData) -> void:
	var new_weapon:TowerWeapon = load(_data.path).instantiate() as TowerWeapon
	add_child(new_weapon)
	if not new_weapon.is_node_ready():
		await new_weapon.ready
	new_weapon.position = attack_point.position
	new_weapon.name = _data.id
	active_weapons.append(new_weapon)


func _activate() -> void:
	is_active = true
	for aw in active_weapons:
		aw.activate()
	radius_timer.start()
	

func _exit_tree() -> void:
	Signals.TowerClear.emit()


func _mouse_entered_light() -> void:
	#print("mouse in")
	Signals.ToggleMouseEnteredNoClickArea.emit(true)


func _mouse_exited_light() -> void:
	#print("mouse out")
	Signals.ToggleMouseEnteredNoClickArea.emit(false)


func _setup_tower() -> void:
	is_active = false
	current_level = starting_level
	pushback_radius = starting_pushback_radius
	light_radius = starting_light_radius
	current_increase_per_tic = starting_light_increase_per_tic
	for each in starter_weapons:
		_setup_weapon(each)
	Signals.TowerReady.emit(self)
		

func _tower_stop() -> void:
	is_active = false
	is_dead = true
	radius_timer.stop()


func _timer_timeout() -> void:
	if is_active:
		_update_light_radius(current_increase_per_tic)


func _update_light_radius(value:float) -> void:
	if is_active:
		light_radius += value
		light_radius = max(starting_light_radius, light_radius)
		Signals.UpdateTowerLightArea.emit(light_radius)

		var scale_value:float = light_radius/starting_light_radius
		tower_light_circle.scale = Vector2(scale_value, scale_value)

		Signals.CheckMatchEnd.emit(starting_light_radius, light_radius, pushback_radius)


func _update_push_back_area(radius:float) -> void:
	light_area_collider.shape.radius -= radius
