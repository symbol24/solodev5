class_name PlayerUi extends SyPanelContainer


@export var skill_box:PackedScene
@export var dmg_number:PackedScene
@export var light_color:Color
@export var dark_color:Color

@onready var exp_bar: TextureProgressBar = %exp_bar
@onready var skills: VBoxContainer = %skills
@onready var control: Control = %control

var skill_boxes:Array = []
# First time displayed on world loaded
var not_displayed_yet:bool = true
var dmg_nbr_pool:Array[DamageNumber] = []


func _ready() -> void:
	Signals.UpdatePlayerExp.connect(_update_exp_bar)
	Signals.ConstructSkillBox.connect(_construct_skill_button)
	Signals.ManagerReady.connect(_player_manager_ready)
	Signals.PressFirstSkillButton.connect(_press_first_skill_button)
	Signals.ActivatePlayer.connect(_enable_starter_buttons)
	Signals.ClearPlayerUi.connect(_clear_player_ui)
	Signals.DamageNumber.connect(_display_damage_number)
	Signals.ReturnDmgNbrToPool.connect(_return_to_pool)


func _player_manager_ready(manager) -> void:
	if manager is PlayerManager and not_displayed_yet:
		not_displayed_yet = false
		Signals.PlayerUiReady.emit()


func _update_exp_bar(value:int, new_max:int) -> void:
	exp_bar.max_value = new_max
	exp_bar.value = value


func _construct_skill_button(_data:SkillData, is_disabled:bool = false) -> void:
	if skill_box and _data:
		var new:SkillBox = skill_box.instantiate()
		skills.add_child(new)
		if not new.is_node_ready():
			await new.ready
		new.id = _data.id
		new.texture_bar.texture_under = _data.ui_texture
		new.skill_button.disabled = is_disabled
		skill_boxes.append(new)


func _clear_player_ui() -> void:
	for each in skill_boxes:
		skills.remove_child.call_deferred(each)
		each.queue_free.call_deferred()
	skill_boxes.clear()
	exp_bar.value = 0
	not_displayed_yet = true


func _press_first_skill_button() -> void:
	if not skill_boxes.is_empty():
		skill_boxes[0].skill_button_pressed()


func _enable_starter_buttons() -> void:
	for each in skill_boxes:
		each.skill_button.disabled = false


func _display_damage_number(value:int, pos:Vector2, type:String) -> void:
	var new:DamageNumber = _get_dmg_number()
	control.add_child(new)
	var color:Color = light_color if type == "light" else dark_color
	new.start(value, color, pos)


func _get_dmg_number() -> DamageNumber:
	if dmg_nbr_pool.is_empty():
		return dmg_number.instantiate() as DamageNumber
	else:
		return dmg_nbr_pool.pop_front()


func _return_to_pool(_dmg_nbr:DamageNumber) -> void:
	control.remove_child(_dmg_nbr)
	dmg_nbr_pool.append(_dmg_nbr)