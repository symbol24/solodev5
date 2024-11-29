class_name Damage extends Resource


var type:DamageType
var final_value:int = 0
var damage_owner:SytoData


func get_damage() -> int:
	var damage_param:String = type.prefix + "_damage"
	#Debug.log("Attacker Level:", damage_owner.current_level, " Damage: ", damage_owner.get_parameter("damage"), " ", damage_param, ": ", damage_owner.get_parameter(damage_param))
	var start:float = damage_owner.get_parameter("damage") + damage_owner.get_parameter(damage_param)
	var cc:float = damage_owner.get_parameter("crit_chance")
	var cd:float = damage_owner.get_parameter("crit_damage")
	
	var cc_param:String = type.prefix + "_crit_chance"
	var cd_param:String = type.prefix + "_crit_damage"
	cc += damage_owner.get_parameter(cc_param)
	cd += damage_owner.get_parameter(cd_param)

	var over:float = (cc - 1) * 0.3 if cc > 1 else 0.0
	cd += over

	var check:float = randf()
	var final_cd:float = 1
	if check <= cc: final_cd += cd
		
	final_value = floori(start * final_cd)
	
	return final_value
