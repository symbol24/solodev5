class_name CreateProfileBtn extends Button



func _pressed() -> void:
	grab_focus()
	Signals.DisplayBigPopup.emit("create_profile", PopupManager.Level.NORMAL, tr("create_profile_title"), tr("create_profile_text"), -1)