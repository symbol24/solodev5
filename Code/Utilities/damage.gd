class_name Damage extends Resource


enum Type {
			UNHOLY = 0,
			CORRUPTION = 1,
			BLIGHT = 2,
			HOLY = 3,
			RIGHTEOUS = 4,
			GRACE = 5,
			HEAL = 6,
			}


@export var base_value:int = 1
@export var type:Type
@export var crit_chance:float = 0
@export var crit_damage:float = 0

var final_value:int = 0
var damage_owner:SytoData


func set_damage_owner(new_owner) -> void:
	damage_owner = new_owner


func get_damage() -> int:
	var start:float = base_value + damage_owner.get_parameter("damage")
	var cc:float = crit_chance + damage_owner.get_parameter("crit_chance")
	var cd:float = crit_damage + damage_owner.get_parameter("crit_damage")
	var prefix:String = ""
	match type:
		Type.UNHOLY:
			prefix = "unholy"
		Type.CORRUPTION:
			prefix = "corruption"
		Type.BLIGHT:
			prefix = "blight"
		Type.HOLY:
			prefix = "holy"
		Type.RIGHTEOUS:
			prefix = "righteous"
		Type.GRACE:
			prefix = "grace"
		Type.HEAL:
			prefix = "heal"
		_:
			pass
	
	var cc_param:String = prefix + "_crit_chance"
	var cd_param:String = prefix + "_crit_damage"
	cc += damage_owner.get_parameter(cc_param)
	cd += damage_owner.get_parameter(cd_param)

	var over:float = (cc - 1) * 0.3 if cc > 1 else 0.0
	cd += over

	var check:float = randf()
	var final_cd:float = 1
	if check <= cc: final_cd += cd
		
	final_value = floori(start * final_cd)
	
	return final_value
