class_name SkillData extends SytoData


@export var skill_path:String

@export_group("Level Up")
@export var title:String
@export var description:String
@export var ui_texture:CompressedTexture2D

# general
var use_delay:float:
	get: return get_parameter("use_delay")
