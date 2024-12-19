class_name LeaderSelect extends SyPanelContainer


@onready var leader_grid: GridContainer = %leader_grid
@onready var btn_play: Button = %btn_play

var leader_buttons:Array[LeaderButton] = []
var active_button:LeaderButton = null
var active_selection:LeaderData = null


func _input(event: InputEvent) -> void:
	if active_button and event.is_action_pressed("mouse_left"):
		_press()
		get_viewport().set_input_as_handled()


func _ready() -> void:
	Signals.LeaderButtonEntered.connect(_mouse_entered_leader_button)
	Signals.LeaderButtonExited.connect(_mouse_exit_leader_button)
	btn_play.pressed.connect(_play)
	btn_play.disabled = true


func toggle_panel(display:bool, _previous:String = "") -> void:
	if display:
		_clear_leaders()
		_add_leaders()
		show()
	else:
		hide()


func _clear_leaders() -> void:
	var children = leader_grid.get_children()
	for each in children:
		if not each is Label:
			each.queue_free()
	leader_buttons.clear()


func _add_leaders() -> void:
	if Game.data_manager.leader_button.instantiate():
		for each in Game.data_manager.leaders:
			var new:LeaderButton = Game.data_manager.leader_button.instantiate()
			leader_grid.add_child(new)
			var unlocked:bool = Game.save_load.active_save.unlocked_leaders.has(each) or Game.data_manager.starter_leaders.has(each)
			new.set_data(each, unlocked)
			new.name = "leader_box_" + each.id
			leader_buttons.append(new)


func _mouse_entered_leader_button(_button:LeaderButton) -> void:
	active_button = _button


func _mouse_exit_leader_button(_button:LeaderButton) -> void:
	active_button = null


func _press() -> void:
	active_selection = active_button.press()
	if active_selection != null:
		btn_play.disabled = false
	else:
		btn_play.disabled = true


func _play() -> void:
	Signals.SyButtonPressed.emit("play", "main_menu")