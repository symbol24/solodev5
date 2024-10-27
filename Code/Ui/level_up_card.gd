class_name LevelUpCard extends PanelContainer


@onready var title: RichTextLabel = %title
@onready var description: RichTextLabel = %description
@onready var image: TextureRect = %image
@onready var level_up_btn: Button = %level_up_btn

var skill_data:SkillData


func _ready() -> void:
	level_up_btn.pressed.connect(_level_up_btn_pressed)


func set_data(_data:SkillData) -> void:
	skill_data = _data
	if skill_data:
		title.text = tr(skill_data.title) + " " + str(skill_data.current_level+1)
		description.text = tr(skill_data.description)
		image.texture = skill_data.ui_texture


func _level_up_btn_pressed() -> void:
	Signals.LevelUpSelection.emit(skill_data.id)
	Signals.ToggleUi.emit("player_ui", true)
	get_tree().paused = false