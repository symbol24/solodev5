class_name UI extends CanvasLayer


const LSPATH:String = "res://Scenes/Ui/loading_screen.tscn"


@export var uis:LevelData

var ui_panels:Array[SyPanelContainer] = []
var loading_screen:LoadingScreen
var debug_ui:DebugUi

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.SyButtonPressed.connect(_button_dispatcher)
	Signals.ToggleUi.connect(_toggle_ui)
	Signals.ToggleLoadingScreen.connect(_toggle_loading_screen)
	if Debug.active:
		debug_ui = _add_debug_ui()


func _toggle_loading_screen(display:bool) -> void:
	if loading_screen:
		loading_screen.visible = display
	else:
		loading_screen = load(LSPATH).instantiate() as LoadingScreen
		add_child(loading_screen)
		loading_screen.visible = display


func _toggle_ui(id:String, display:bool = true, _previous:String = "") -> void:
	var found:bool = false
	for each in ui_panels:
		if each.id == id: 
			each.toggle_panel(display, _previous)
			found = true
		else: each.toggle_panel(false, _previous)
	
	if not found and display:
		var to_load:String = uis.get_level_path(id)
		if to_load != "":
			var new_ui:SyPanelContainer = load(to_load).instantiate()
			add_child(new_ui)
			if not new_ui.is_node_ready:
				await new_ui.ready
			ui_panels.append(new_ui)
			new_ui.toggle_panel(display, _previous)


func _button_dispatcher(destination:String, _previous:String = "") -> void:
	match destination:
		"play":
			Signals.LoadScene.emit("test")
			_toggle_ui("main_menu", false)
		"credits":
			_toggle_ui("credits", true)
		"main_menu":
			Signals.ClearActiveScene.emit()
			if loading_screen and loading_screen.visible:
				if SM.levels.extra_loading_time > 0: 
					await get_tree().create_timer(SM.levels.extra_loading_time).timeout
					loading_screen.hide()
			_toggle_ui("main_menu", true)
		"close_pause":
			_toggle_ui("player_ui", true)
			get_tree().paused = false
		"pause_menu":
			_toggle_ui("pause_menu", true, _previous)
			get_tree().paused = true
		"audio_settings":
			_toggle_ui("audio_settings", true, _previous)
		_:
			pass


func _add_debug_ui() -> DebugUi:
	var to_load:String = uis.get_level_path("debug_ui")
	if to_load != "":
		var new_ui:DebugUi = load(to_load).instantiate()
		add_child(new_ui)
		return new_ui
	return null