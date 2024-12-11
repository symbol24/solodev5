class_name ProfilePage extends SyPanelContainer


@export var small_popup_time:int = 3
@export var confirm_timer:int = 15

@onready var profile_grid: GridContainer = %profile_grid
@onready var btn_load: Button = %btn_load
@onready var btn_save: Button = %btn_save
@onready var btn_delete: Button = %btn_delete

var selected_profile:int = -1
var profile_btns:Array = []
var btn_count:int = 1


func _ready() -> void:
	Signals.ProfileSelected.connect(_profile_selected)
	Signals.PopupResult.connect(_result)
	Signals.NewSaveFileCreated.connect(_reload_profiles)
	Signals.DeleteSaveSuccess.connect(_delete_successful)
	Signals.SaveLoadComplete.connect(_load_complete)
	btn_save.pressed.connect(_save_profile)
	btn_delete.pressed.connect(_delete_profile)
	btn_load.pressed.connect(_load_profile)



func toggle_panel(display:bool, _previous:String = "") -> void:
	if display:
		_clear_btns()
		_load_profiles()
		show()
	else:
		hide()


func _profile_selected(new_profile:int) -> void:
	selected_profile = new_profile
	#Debug.log("Selected profile is: ", selected_profile)


func _load_profiles() -> void:
	for each in Game.save_load.all_saves:
		var new_btn = Game.data_manager.profile_button.instantiate()
		new_btn.profile_id = each.id
		profile_grid.add_child(new_btn)
		new_btn.name = "profile_" + str(each.id)
		new_btn.set_text("profile_" + str(each.id))
		btn_count += 1
		if not new_btn.is_node_ready(): await new_btn.ready
		if Game.save_load.active_save != null and Game.save_load.active_save.id == each.id:
			selected_profile = each.id
			new_btn.set_toggled()
	
	var create = Game.data_manager.profile_create_button.instantiate()
	profile_grid.add_child(create)


func _clear_btns() -> void:
	for child in profile_grid.get_children():
		child.queue_free()
	for each in profile_btns:
		if each != null: each.queue_free()
	profile_btns.clear()
	btn_count = 1


func _load_profile() -> void:
	Signals.DisplayBigPopup.emit("profile_load", PopupManager.Level.WARNING, tr("unsaved_warning_title"), tr("unsaved_warning_text"), -1)


func _load_complete(_active_save:ProfileSaveData) -> void:
	Signals.DisplaySmallPopup.emit(PopupManager.Level.NORMAL, tr("profile_loaded") % _active_save.id, small_popup_time)


func _save_profile() -> void:
	if selected_profile == Game.save_load.active_save.id:
		Signals.Save.emit(selected_profile)
		Signals.DisplaySmallPopup.emit(PopupManager.Level.NORMAL, tr("popup_small_save_confirm") % selected_profile, small_popup_time)
		Debug.log("Selected: ", selected_profile, " active: ", Game.save_load.active_save.id)
	else:
		Signals.DisplaySmallPopup.emit(PopupManager.Level.NORMAL, tr("popup_small_save_missmatch") % [selected_profile, Game.save_load.active_save.id], small_popup_time)


func _delete_profile() -> void:
	Signals.DisplayBigPopup.emit("delete_profile_confirm", PopupManager.Level.WARNING, tr("delete_profile_confirm_title"), tr("delete_profile_confirm_text"), confirm_timer)


func _result(_popup_id:String, result:bool) -> void:
	if _popup_id == "create_profile" and result:
		Signals.CreateNewProfile.emit()
	elif _popup_id == "delete_profile_confirm" and result:
		Signals.DeleteSaveFile.emit(selected_profile)
	elif _popup_id == "profile_load" and result:
		Signals.Load.emit(selected_profile)


func _reload_profiles(save_id:int) -> void:
	selected_profile = save_id
	Signals.Load.emit(selected_profile)
	_clear_btns()
	_load_profiles()


func _delete_successful(old_id:int) -> void:
	_reload_profiles(-1)
	Signals.DisplaySmallPopup.emit(PopupManager.Level.NORMAL, tr("profile_delete_successful") % old_id, small_popup_time)