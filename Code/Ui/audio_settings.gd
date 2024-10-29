extends SyPanelContainer


@onready var master_slider: HSlider = %master
@onready var music: HSlider = %music
@onready var sfx: HSlider = %sfx
@onready var back_button: Button = %back_button

func _ready() -> void:
	master_slider.value_changed.connect(_update_master)
	music.value_changed.connect(_update_music)
	sfx.value_changed.connect(_update_sfx)
	_set_values()


func toggle_panel(display:bool, _previous:String = "") -> void:
	if display:
		previous = _previous
		back_button.previous = _previous
		show()
	else:
		hide()


func _set_values() -> void:
	master_slider.value = Audio.default.master_volume
	music.value = Audio.default.music_volume
	sfx.value = Audio.default.sfx_volume


func _update_master(value) -> void:
	Audio.BusVolumeUpdate.emit("Master", value)


func _update_music(value) -> void:
	Audio.BusVolumeUpdate.emit("Music", value)


func _update_sfx(value) -> void:
	Audio.BusVolumeUpdate.emit("SFX", value)
