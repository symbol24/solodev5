class_name PlayerUi extends SyPanelContainer


const DMGNBRSUI = preload("res://Scenes/Ui/damage_numbers.tscn")


@export var light_color:Color
@export var dark_color:Color

@onready var exp_bar: TextureProgressBar = %exp_bar
@onready var skills: VBoxContainer = %skills
@onready var boosters: VBoxContainer = %boosters
@onready var control: Control = %control

var skill_boxes:Array = []
var booster_boxes:Array = []
# First time displayed on world loaded
var not_displayed_yet:bool = true
var dmg_nbrs_ui:DamageNumbers


func _ready() -> void:
	Signals.UpdatePlayerExp.connect(_update_exp_bar)
	Signals.ConstructSkillBox.connect(_construct_skill_button)
	Signals.ConstructBoosterBox.connect(_construct_booster_box)
	Signals.ManagerReady.connect(_player_manager_ready)
	Signals.PressFirstSkillButton.connect(_press_first_skill_button)
	Signals.ActivatePlayer.connect(_enable_starter_buttons)
	Signals.ClearPlayerUi.connect(_clear_player_ui)


func _player_manager_ready(manager) -> void:
	if manager is PlayerManager and not_displayed_yet:
		not_displayed_yet = false
		_load_dmg_nbrs_ui()
		Signals.PlayerUiReady.emit()


func _load_dmg_nbrs_ui() -> void:
	var new:DamageNumbers = DMGNBRSUI.instantiate()
	add_child(new)
	dmg_nbrs_ui = new


func _update_exp_bar(value:int, new_max:int) -> void:
	exp_bar.max_value = new_max
	exp_bar.value = value


func _construct_skill_button(_data:SkillData, is_disabled:bool = false) -> void:
	if Game.data_manager.skill_box == null:
		Debug.error("Skill box missing from data manager.")
		return

	if _data:
		var new:SkillBox = Game.data_manager.skill_box.instantiate()
		skills.add_child(new)
		if not new.is_node_ready():
			await new.ready
		new.id = _data.id
		new.texture_bar.texture_under = _data.ui_texture
		new.skill_button.disabled = is_disabled
		skill_boxes.append(new)


func _construct_booster_box(_data:BoosterData) -> void:
	#Debug.log("Construct booster box signal received")
	if Game.data_manager.booster_box == null:
		Debug.error("Booster box missing from data manager.")
		return
	
	if _data:
		var new = Game.data_manager.booster_box.instantiate()
		boosters.add_child(new)
		if not new.is_node_ready():
			await new.ready
		new.id = _data.id
		new.texture_rect.texture = _data.ui_texture
		booster_boxes.append(new)


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
