class_name Dark extends ColorRect


func _ready() -> void:
	Signals.ToggleDark.connect(_toggle_dark)

func _process(delta: float) -> void:
	if visible:
		var light_positions = _get_light_positions()
		material.set_shader_parameter("number_of_lights", light_positions.size())
		material.set_shader_parameter("lights", light_positions)


func _get_light_positions() -> Array:
	return get_tree().get_nodes_in_group("light").map(
			func(light: Node2D):
				return light.get_global_transform_with_canvas().origin
	)


func _toggle_dark(value:bool) -> void:
	if value: show()
	else: hide()