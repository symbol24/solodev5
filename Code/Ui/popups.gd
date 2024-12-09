class_name PopupManager extends SyPanelContainer


enum Level {
			NORMAL = 0,
			WARNING = 1,
			ERROR = 2,
			}


@onready var big_popup: BigPopup = %big_popup
@onready var small_popup: SmallPopup = %small_popup
@onready var control: Control = %control


func _ready() -> void:
	Signals.DisplayBigPopup.connect(_display_big_popup)
	Signals.DisplaySmallPopup.connect(_display_small_popup)


func _display_small_popup(level:Level, text:String, timer:int) -> void:
	control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	show()
	small_popup.set_popup(_get_level_texture(level), text, timer)


func _display_big_popup(popup_id:String, level:Level, title:String, text:String, timer:int) -> void:
	control.mouse_filter = Control.MOUSE_FILTER_STOP
	show()
	big_popup.set_popup(popup_id, _get_level_texture(level), title, text, timer)


func _get_level_texture(_level:Level) -> CompressedTexture2D:
	match _level:
		Level.WARNING:
			return Game.data_manager.popup_warning_icon
		Level.ERROR:
			return Game.data_manager.popup_error_icon
		_:
			return null