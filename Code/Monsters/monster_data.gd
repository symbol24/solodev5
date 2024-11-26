class_name MonsterData extends SytoData


@export_category("Loading Data")
@export var to_spawn:PackedScene

@export_category("Stats")
@export var is_flyer:bool = false

var is_dead:bool = false
var current_hp:int = 0:
	set(value):
		if not is_dead:
			current_hp = value
			if current_hp <= 0: 
				is_dead = true
var starting_hp:int
var speed:float
var armor:int
var hit_shield:int
var attack_area_size:float
var attack_range:float
var attack_delay:float
var projectile_speed:float
var status_effect_delay:float


func setup_data() -> void:
	current_level = 1
	is_dead = false
	starting_hp = get_parameter("hp")
	current_hp = get_parameter("hp")
	armor = get_parameter("armor")
	speed = get_parameter("speed")
	hit_shield = get_parameter("hit_shield")
	attack_area_size = get_parameter("attack_area_size")
	attack_range = get_parameter("attack_range")
	attack_delay = get_parameter("attack_delay")
	projectile_speed = get_parameter("projectile_speed")
	status_effect_delay = get_parameter("status_effect_delay")


func get_damages() -> Array[Damage]:
	var damages:Array[Damage] = []
	var dmg:Damage
	var level:SytoLevelData = _get_data_for_level(current_level)
	if level != null:
		for stat in level.stats:
			dmg = Damage.new()
			dmg.damage_owner = self
			for each in dmg.types:
				var found:bool = false
				if not found and level.get_parameter(each):
					match each:
						"unholy_damage":
							dmg.type = Damage.Type.UNHOLY
							found = true
						"corruption_damage":
							dmg.type = Damage.Type.CORRUPTION
							found = true
						"blight_damage":
							dmg.type = Damage.Type.BLIGHT
							found = true
						"heal":
							dmg.type = Damage.Type.HEAL
							found = true
						_:
							pass
			damages.append(dmg)
	return damages