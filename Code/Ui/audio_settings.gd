class_name AudioSetting extends SyScrollContainer


@onready var master_slider: HSlider = %master
@onready var music_slider: HSlider = %music
@onready var sfx_volume: HSlider = %sfx


func _ready() -> void:
	master_slider.value_changed.connect(_update_master)
	music_slider.value_changed.connect(_update_music)
	sfx_volume.value_changed.connect(_update_sfx)
	_set_values()


func check_active_changes() -> bool:
	if Game.save_load.active_save != null:
		if master_slider.value != Game.save_load.active_save.master_volume: return true
		if music_slider.value != Game.save_load.active_save.music_volume: return true
		if sfx_volume.value != Game.save_load.active_save.sfx_volume: return true
	return false


func set_changes_to_active_save() -> void:
	Game.save_load.active_save.master_volume = master_slider.value
	Game.save_load.active_save.music_volume = music_slider.value
	Game.save_load.active_save.sfx_volume = sfx_volume.value


func reset_values() -> void:
	master_slider.value = Game.save_load.active_save.master_volume
	music_slider.value = Game.save_load.active_save.music_volume
	sfx_volume.value = Game.save_load.active_save.sfx_volume


func _set_values() -> void:
	if Game.save_load.active_save != null:
		master_slider.value = Game.save_load.active_save.master_volume
		music_slider.value = Game.save_load.active_save.music_volume
		sfx_volume.value = Game.save_load.active_save.sfx_volume
	else:
		master_slider.value = Audio.default.master_volume
		music_slider.value = Audio.default.music_volume
		sfx_volume.value = Audio.default.sfx_volume


func _update_master(value) -> void:
	Audio.BusVolumeUpdate.emit("Master", value)


func _update_music(value) -> void:
	Audio.BusVolumeUpdate.emit("Music", value)


func _update_sfx(value) -> void:
	Audio.BusVolumeUpdate.emit("SFX", value)