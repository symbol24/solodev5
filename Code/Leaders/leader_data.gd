class_name LeaderData extends SytoData


# General
@export var starting_skills:Array[SytoData]
@export var parameters:Dictionary = {}

@export_category("UI")
@export var title:String = ""
@export var text:String = ""
@export var texture_select:CompressedTexture2D


func get_leader_parameter(_param:String) -> Parameter:
	return parameters[_param] if parameters.has(_param) else null