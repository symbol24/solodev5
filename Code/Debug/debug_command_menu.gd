class_name DebugCommandsMenu extends PanelContainer


@export var max_output_height:int = 160
@export var line_output_height:int = 12

@onready var output: RichTextLabel = %output
@onready var input: LineEdit = %input

var command_log:Array[String] = []
var command_log_pos:int = 0

var output_line_count:int = 0


func _ready() -> void:
	Signals.DebugPrint.connect(_debug_print)
	input.text_changed.connect(_check_input)


func _input(event: InputEvent) -> void:
	if Game.active_tower != null and event.is_action_pressed("debug"):
		get_viewport().set_input_as_handled()
		_toggle_debug()
		
	if visible and event.is_action_pressed("debug_enter"):
		Debug.do_command(input.text.split(" ", false))
		command_log.append(input.text)
		input.text = ""
		command_log_pos = 0
	elif visible and event.is_action_pressed("ui_up"):
		_update_input_text_from_command_log(-1)
	elif visible and event.is_action_pressed("ui_down"):
		_update_input_text_from_command_log(1)


func toggle_debug_command_menu() -> void:
	visible = !visible
	if visible:
		input.text = ""
		input.grab_focus()
	command_log_pos = 0


func _debug_print(_text:String) -> void:
	if output_line_count > 0:
		output.text += "\n"
	output.text += _text
	output_line_count += 1
	output.size.y = max_output_height if output_line_count > max_output_height/line_output_height else line_output_height * output_line_count


func _check_input(_new:String) -> void:
	var modified:String = _new
	if not _new.is_empty():
		while "`" in _new:
			_new = _new.erase(_new.find("`"), 1)
		if modified != _new:
			input.text = _new


func _update_input_text_from_command_log(direction:int) -> void:
	if not command_log.is_empty():
		input.text = command_log[command_log_pos]
		command_log_pos += direction
		if command_log_pos < 0: command_log_pos = command_log.size() - 1
		elif command_log_pos >= command_log.size(): command_log_pos = 0


func _toggle_debug() -> void:
	if visible: hide()
	else: 
		show()
		input.grab_focus()