extends SyButton


func _pressed() -> void:
	Audio.play_audio(Game.audio_list.get_audio_file("menu_click"))
	Signals.ToggleLoadingScreen.emit(display_loading_screen)
	Signals.SyButtonPressed.emit(previous)