class_name Settings extends SyPanelContainer

@export var pages:Array[SyScrollContainer]
@export var popup_timer:int = 15

@onready var btn_settings_save: Button = %btn_settings_save
@onready var btn_settings_back: Button = %btn_settings_back


func _ready() -> void:
	btn_settings_save.pressed.connect(_save_changes)
	btn_settings_back.pressed.connect(_back_out)
	Signals.PopupResult.connect(_popup_result)


func _save_changes() -> void:
	if _check_active_changes():
		_set_all_data_for_settings()
		Signals.Save.emit(Game.save_load.active_save.id)


func _back_out() -> void:
	Audio.play_audio(Game.audio_list.get_audio_file("menu_click"))
	if _check_active_changes():
		Signals.DisplayBigPopup.emit("settings_confirm_changes", PopupManager.Level.WARNING, tr("settings_confirm_changes_title"), tr("settings_confirm_changes_text"), -1)
	else:
		Signals.SyButtonPressed.emit(previous, id)


func _check_active_changes() -> bool:
	var active_changes:bool = false
	for each in pages:
		if each.check_active_changes():
			active_changes = true
	return active_changes


func _set_all_data_for_settings() -> void:
	for each in pages:
		each.set_changes_to_active_save()


func _reset_all_value() -> void:
	for each in pages:
		each.reset_values()


func _popup_result(popup_id:String, result:bool) -> void:
	match popup_id:
		"settings_confirm_changes":
			if result:
				_reset_all_value()
				Signals.SyButtonPressed.emit(previous, id)
		_:
			pass