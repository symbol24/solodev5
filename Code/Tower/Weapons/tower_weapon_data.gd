class_name TowerWeaponData extends TowerSytoData


@export var path:String
@export var start_damage:int = 1
@export var damages:Array[Damage]
@export var damage_type:Damage.Type
@export var extra:Dictionary = {}

var damage:int:
	get: return start_damage


func get_damages() -> Array[Damage]:
	for each in damages:
		each.damage_owner = self
		each.type = damage_type
	return damages