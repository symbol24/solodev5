class_name SkillBox extends Control


@onready var texture_bar: TextureProgressBar = %texture_bar
@onready var skill_button: Button = %skill_button
@onready var level: Label = %level

var id:String


func _ready() -> void:
	Signals.UpdateSkillTimer.connect(_update_bar)
	Signals.UntoggleSkillButtons.connect(_untoggle_button)
	Signals.SkillLevelUpdated.connect(_update_level)
	skill_button.pressed.connect(skill_button_pressed)
	skill_button.mouse_entered.connect(_mouse_entered_skill)
	skill_button.mouse_exited.connect(_mouse_exited_skill)


func _update_bar(_id:String, _value:float) -> void:
	if _id == id:
		texture_bar.value = _value


func skill_button_pressed() -> void:
	if not skill_button.button_pressed:
		skill_button.button_pressed = true
	Audio.play_audio(Game.btn_click)
	Signals.ActivateSkill.emit(id)
	Signals.UntoggleSkillButtons.emit(id)


func _untoggle_button(_id:String) -> void:
	if _id != id:
		skill_button.set_pressed_no_signal(false)


func _mouse_entered_skill() -> void:
	Signals.ToggleMouseEnteredNoClickArea.emit(true)


func _mouse_exited_skill() -> void:
	Signals.ToggleMouseEnteredNoClickArea.emit(false)


func _update_level(_id:String, _level:int) -> void:
	if _id == id:
		level.text = str(_level)
		if _level > 0:
			level.show()