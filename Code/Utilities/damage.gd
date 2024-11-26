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

var types:Array[String] = [
							"unholy_damage",
							"corruption_damage",
							"blight_damage",
							"holy_damage",
							"righteous_damage",
							"grace_damage",
							"heal",
							]

var type:Type
var final_value:int = 0
var damage_owner:SytoData


func set_damage_owner(new_owner) -> void:
	damage_owner = new_owner


func get_damage() -> int:
	var prefix:String = ""
	match type:
		Type.UNHOLY:
			prefix = "unholy_"
		Type.CORRUPTION:
			prefix = "corruption_"
		Type.BLIGHT:
			prefix = "blight_"
		Type.HOLY:
			prefix = "holy_"
		Type.RIGHTEOUS:
			prefix = "righteous_"
		Type.GRACE:
			prefix = "grace_"
		Type.HEAL:
			prefix = "heal_"
		_:
			pass
	
	var damage_param:String = prefix + "damage"
	#Debug.log("Damage: ", damage_owner.get_parameter("damage"), " ", damage_param, ": ", damage_owner.get_parameter(damage_param))
	var start:float = damage_owner.get_parameter("damage") + damage_owner.get_parameter(damage_param)
	var cc:float = damage_owner.get_parameter("crit_chance")
	var cd:float = damage_owner.get_parameter("crit_damage")
	
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
