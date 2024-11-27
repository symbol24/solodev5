extends Node


@export var commands:Array[DebugCommand] = []
@export var active:bool = true
@export var null_text:String = "<null>"


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func stringify(_value1 = "", _value2 = "", _value3 = "", _value4 = "", _value5 = "", _value6 = "", _value7 = "", _value8 = "", _value9 = "", _value10 = "", _value11 = "", _value12 = "", _value13 = "", _value14 = "", _value15 = "", _value16 = "", _value17 = "", _value18 = "", _value19 = "", _value20 = "") -> String:
	var total := ""
	total += str(_value1) if _value1 != null else null_text
	total += str(_value2) if _value2 != null else null_text
	total += str(_value3) if _value3 != null else null_text
	total += str(_value4) if _value4 != null else null_text
	total += str(_value5) if _value5 != null else null_text
	total += str(_value6) if _value6 != null else null_text
	total += str(_value7) if _value7 != null else null_text
	total += str(_value8) if _value8 != null else null_text
	total += str(_value9) if _value9 != null else null_text
	total += str(_value10) if _value10 != null else null_text
	total += str(_value11) if _value11 != null else null_text
	total += str(_value12) if _value12 != null else null_text
	total += str(_value13) if _value13 != null else null_text
	total += str(_value14) if _value14 != null else null_text
	total += str(_value15) if _value15 != null else null_text
	total += str(_value16) if _value16 != null else null_text
	total += str(_value17) if _value17 != null else null_text
	total += str(_value18) if _value18 != null else null_text
	total += str(_value19) if _value19 != null else null_text
	total += str(_value20) if _value20 != null else null_text
	return total


func log(_value1 = "", _value2 = "", _value3 = "", _value4 = "", _value5 = "", _value6 = "", _value7 = "", _value8 = "", _value9 = "", _value10 = "", _value11 = "", _value12 = "", _value13 = "", _value14 = "", _value15 = "", _value16 = "", _value17 = "", _value18 = "", _value19 = "", _value20 = ""):
	var text = stringify(_value1, _value2, _value3, _value4, _value5, _value6, _value7, _value8, _value9, _value10, _value11, _value12, _value13, _value14, _value15, _value16, _value17, _value18, _value19, _value20)
	print(text)
	Signals.DebugPrint.emit(text)


func error(_value1 = "", _value2 = "", _value3 = "", _value4 = "", _value5 = "", _value6 = "", _value7 = "", _value8 = "", _value9 = "", _value10 = "", _value11 = "", _value12 = "", _value13 = "", _value14 = "", _value15 = "", _value16 = "", _value17 = "", _value18 = "", _value19 = "", _value20 = ""):
	var text = stringify(_value1, _value2, _value3, _value4, _value5, _value6, _value7, _value8, _value9, _value10, _value11, _value12, _value13, _value14, _value15, _value16, _value17, _value18, _value19, _value20)
	Signals.DebugPrint.emit("[color=red]" + text + "[/color]")
	push_error(text)
	

func warning(_value1 = "", _value2 = "", _value3 = "", _value4 = "", _value5 = "", _value6 = "", _value7 = "", _value8 = "", _value9 = "", _value10 = "", _value11 = "", _value12 = "", _value13 = "", _value14 = "", _value15 = "", _value16 = "", _value17 = "", _value18 = "", _value19 = "", _value20 = ""):
	var text = stringify(_value1, _value2, _value3, _value4, _value5, _value6, _value7, _value8, _value9, _value10, _value11, _value12, _value13, _value14, _value15, _value16, _value17, _value18, _value19, _value20)
	Signals.DebugPrint.emit("[color=yellow]" + text + "[/color]")
	push_warning(text)


func do_command(_inputs:Array[String] = []):
	var command:String = _inputs.pop_front()
	match command:
		"commands":
			var text:=""
			if commands.is_empty(): text = "No commands available."
			for each in commands:
				text += each.id + " "
			Debug.log(text)
		_:
			var to_do:DebugCommand = _get_command(command)
			if to_do != null:
				if  _inputs.size() != to_do.value_count:
					Debug.warning(to_do.error_message)
					return

				var to_parse:String = "" + to_do.signal_name + ".emit("
				if _inputs.size() > 0:
					var x:int = 0
					for each in _inputs:
						to_parse += each
						x += 1
						if x < _inputs.size():
							to_parse += ", "
				to_parse += ")"
				
				var exp:Expression = Expression.new()
				var _error = exp.parse(to_parse)
				if _error != OK:
					error("Error ", exp.get_error_text(), " while parsing debug command.")
					return
				
				var result = exp.execute([], Signals)
				if exp.has_execute_failed():
					error(exp.get_error_text())


func _get_command(input:String) -> DebugCommand:
	for each in commands:
		if each.id == input: return each
	return null