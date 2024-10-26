class_name Tower extends Area2D


@export_group("Stats")
@export var starting_hp:int = 100
@export var starting_level:int = 1
@export var starting_light_radius:float = 160

@export_group("Weapons")
@export var weapons:Array[TowerWeaponData] = []
@export var starter_weapons:Array[TowerWeaponData] = []

@onready var light_area: Area2D = %light_area
@onready var light_area_collider: CollisionShape2D = %light_area_collider
@onready var attack_point: Marker2D = %attack_point

var current_level:int
var current_hp:int = 100:
	set(value):
		current_hp = value
		clampi(current_hp, 0, starting_hp)
		if current_hp == 0:
			_tower_death()
var light_radius:float = 160
var active_weapons:Array[TowerWeapon] = []
var is_dead:bool = false


func _ready() -> void:
	Signals.SetupTower.connect(_setup_tower)
	Signals.ActivateTower.connect(_activate)
	light_area.mouse_entered.connect(_mouse_entered_light)
	light_area.mouse_exited.connect(_mouse_exited_light)


func receive_damage(received:Array[Damage]) -> void:
	if not received.is_empty():
		for each in received:
			var amount:int = each.get_damage()
			current_hp -= amount
			Signals.DamageNumber.emit(amount, global_position)
			print("Tower received damage: ", amount)


func _setup_weapon(id:String) -> void:
	pass


func _activate() -> void:
	for aw in active_weapons:
		aw.activate()


func _exit_tree() -> void:
	Signals.TowerClear.emit()


func _mouse_entered_light() -> void:
	Signals.ToggleMouseEnteredLight.emit(true)


func _mouse_exited_light() -> void:
	Signals.ToggleMouseEnteredLight.emit(false)


func _setup_tower() -> void:
	current_level = starting_level
	current_hp = starting_hp
	light_radius = starting_light_radius
	for each in starter_weapons:
		var new_weapon:TowerWeapon = load(each.path).instantiate() as TowerWeapon
		add_child(new_weapon)
		if not new_weapon.is_node_ready():
			await new_weapon.ready
		new_weapon.position = attack_point.position
		new_weapon.name = each.id
		active_weapons.append(new_weapon)
	Signals.TowerReady.emit(self)
		

func _tower_death() -> void:
	is_dead = true