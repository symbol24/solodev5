class_name BoosterBox extends Control


@onready var texture_rect: TextureRect = %texture_rect
@onready var level: Label = %level

var id:String


func _ready() -> void:
	Signals.SkillLevelUpdated.connect(_update_level)


func _update_level(_id:String, value:int) -> void:
	if _id == id: level.text = str(value)