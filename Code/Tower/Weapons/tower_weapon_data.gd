class_name TowerWeaponData extends TowerSytoData


@export var path:String
@export var start_damage:int = 1
@export var damages:Array[Damage]
@export var extra:Dictionary = {}

var damage:int:
	get: return start_damage
