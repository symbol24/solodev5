class_name PlayerUi extends SyPanelContainer


@export var skill_box:PackedScene

@onready var exp_bar: TextureProgressBar = %exp_bar
@onready var monsters: VBoxContainer = %monsters


func _ready() -> void:
	Signals.UpdatePlayerExp.connect(_update_exp_bar)


func _update_exp_bar(value:int, new_max:int) -> void:
	exp_bar.max_value = new_max
	exp_bar.value = value