class_name Dark extends ColorRect


@export var starting_base_radius:float = 180
@export var starting_band_radius:float = 160


func _ready() -> void:
	Signals.ToggleDark.connect(_toggle_dark)
	Signals.UpdatePushbackRadius.connect(_update_radius)
	Signals.ClearPlayerUi.connect(_reset_members)
	material.set_shader_parameter("band_radius", starting_band_radius)
	material.set_shader_parameter("base_radius", starting_base_radius)


func _process(delta: float) -> void:
	if visible:
		material.set_shader_parameter("number_of_lights", 1)
		material.set_shader_parameter("lights", _get_light_positions())


func _get_light_positions() -> Array:
	return get_tree().get_nodes_in_group("light").map(
			func(light: Node2D):
				var v_pos:Vector2i = light.get_global_transform_with_canvas().origin
				return v_pos
	)


func _toggle_dark(value:bool) -> void:
	if value: show()
	else: hide()


func _update_radius(value:float) -> void:
	var current_base_radius:float = material.get_shader_parameter("base_radius")
	var current_band_radius:float = material.get_shader_parameter("band_radius")
	current_base_radius -= value
	current_band_radius -= value
	material.set_shader_parameter("band_radius", current_band_radius)
	material.set_shader_parameter("base_radius", current_base_radius)


func _reset_members() -> void:
	material.set_shader_parameter("band_radius", starting_band_radius)
	material.set_shader_parameter("base_radius", starting_base_radius)
