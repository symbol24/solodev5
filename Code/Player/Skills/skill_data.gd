class_name SkillData extends SytoData


enum SkillType {
				AUTOSPAWNER = 0,
				MANUALSPAWNER = 1,
				SPELL = 2,
				CURRENCY = 3,
				}


@export var skill_path:String
@export var skill_type:SkillType

@export_group("Level Up")
@export var title:String
@export var description:String
@export var ui_texture:CompressedTexture2D

# general
var use_delay:float:
	get: return get_parameter("use_delay")
