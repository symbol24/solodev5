class_name SkillUiBar extends Control


@onready var texture_bar: TextureProgressBar = %texture_bar

var id:String


func _ready() -> void:
	Signals.UpdateSkillTimer.connect(_update_bar)


func _update_bar(_id:String, _value:float) -> void:
	if _id == id:
		texture_bar.value = _value