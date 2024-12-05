class_name ProfilePage extends SyPanelContainer


const PROFILEBTN = preload("res://Scenes/Ui/profile_button.tscn")


@onready var profile_grid: GridContainer = %profile_grid

var selected_profile:int = -1
var profile_btns:Array = []
var btn_count:int = 1

func _ready() -> void:
	Signals.ProfileSelected.connect(_profile_selected)


func toggle_panel(display:bool, _previous:String = "") -> void:
	if display:
		_clear_btns()
		_load_profiles()
		show()
	else:
		hide()


func _profile_selected(new_profile:int) -> void:
	selected_profile = new_profile
	Debug.log("Selected profile is: ", selected_profile)


func _load_profiles() -> void:
	for each in Game.save_load.all_saves:
		var new_btn = Game.data_manager.profile_button.instantiate()
		new_btn.profile_id = each.id
		profile_grid.add_child(new_btn)
		new_btn.name = "profile_0" + str(each.id)
		new_btn.set_text(str(btn_count))
		btn_count += 1
		if not new_btn.is_node_ready(): await new_btn.ready
		if Game.save_load.active_save.id == each.id:
			new_btn.set_toggled()
	
	var create = Game.data_manager.profile_create_button.instantiate()
	profile_grid.add_child(create)



func _clear_btns() -> void:
	for each in profile_btns:
		each.queue_free()
	profile_btns.clear()
	btn_count = 1


func _load_profile() -> void:
	Signals.Load.emit(selected_profile)


func _save_profile() -> void:
	Signals.Save.emit(selected_profile)