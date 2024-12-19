class_name LeaderButton extends Control


@onready var image: TextureRect = %image
@onready var outline: Panel = %outline

var data:LeaderData
var unlocked:bool = false
var selected:bool = false
var mouse_in:bool = false


func _ready() -> void:
	mouse_entered.connect(_mouse_enter)
	mouse_exited.connect(_mouse_exit)


func set_data(_data:LeaderData, _unlocked:bool) -> void:
	if _data:
		data = _data.duplicate()
		unlocked = _unlocked
		if data.texture_select:	image.texture = data.texture_select
		if not unlocked and Game.data_manager.leader_style_locked != null:
			outline.add_theme_stylebox_override("panel", Game.data_manager.leader_style_locked)


func press() -> LeaderData:
	if not selected: 
		_select()
		return data
	else: 
		_unselect()
		return null


func _select() -> void:
	selected = true
	if Game.data_manager.leader_style_selected != null:
		outline.add_theme_stylebox_override("panel", Game.data_manager.leader_style_selected)


func _unselect() -> void:
	selected = false
	if Game.data_manager.leader_style_hover != null:
		outline.add_theme_stylebox_override("panel", Game.data_manager.leader_style_hover)


func _mouse_enter() -> void:
	if unlocked and Game.data_manager.leader_style_hover != null:
		mouse_in = true
		outline.add_theme_stylebox_override("panel", Game.data_manager.leader_style_hover)
		Signals.LeaderButtonEntered.emit(self)


func _mouse_exit() -> void:
	if unlocked and Game.data_manager.leader_style_normal != null:
		mouse_in = false
		if not selected and Game.data_manager.leader_style_normal != null:
			outline.add_theme_stylebox_override("panel", Game.data_manager.leader_style_normal)
		elif selected and Game.data_manager.leader_style_selected != null:
			outline.add_theme_stylebox_override("panel", Game.data_manager.leader_style_selected)
		Signals.LeaderButtonExited.emit(self)


