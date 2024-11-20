class_name Dark extends ColorRect


@export var starting_base_radius:float = 180
@export var starting_band_radius:float = 160

var current_band_radius:float
var current_base_radius:float

var width:float
var height:float

func _ready() -> void:
	Signals.ToggleDark.connect(_toggle_dark)
	Signals.UpdatePushbackRadius.connect(_update_radius)
	Signals.ClearPlayerUi.connect(_reset_members)
	_reset_members()
	width = ProjectSettings.get_setting("display/window/size/viewport_width")
	height = ProjectSettings.get_setting("display/window/size/viewport_height")


func _process(delta: float) -> void:
	if visible:
		_update_shader_params()
		material.set_shader_parameter("number_of_lights", 1)
		material.set_shader_parameter("lights", _get_light_positions())


func _get_light_positions() -> Array:
	return get_tree().get_nodes_in_group("light").map(
			func(light: Node2D):
				var v_pos:Vector2i = light.get_global_transform_with_canvas().origin
				var offset_pos:Vector2 = _calculate_position()
				v_pos.x += offset_pos.x
				v_pos.y += offset_pos.y
				return v_pos
	)


func _toggle_dark(value:bool) -> void:
	if value: show()
	else: hide()


func _update_radius(value:float) -> void:
	current_base_radius -= value
	current_band_radius -= value


func _reset_members() -> void:
	var ratio:float = _get_ratio()
	current_band_radius = starting_band_radius
	current_base_radius = starting_base_radius
	var band = current_band_radius * ratio
	var base = current_base_radius * ratio
	material.set_shader_parameter("band_radius", band)
	material.set_shader_parameter("base_radius", base)


func _test() -> void:
	Debug.log("Viewport size x,y: ", get_viewport().size)


func _get_border_orientation() -> int:
	var vp = get_viewport().size
	var ideal_w = (vp.y / 9) * 16
	if vp.x > ideal_w:
		return 1 # black bars on side
	elif vp.x < ideal_w:
		return -1 # black bars on top/bottom
	else:
		return 0


func _calc_offset() -> Vector2:
	var aspect:String = ProjectSettings.get_setting("display/window/stretch/aspect")
	var offset:Vector2 = Vector2.ZERO
	var viewport = get_viewport().size
	match _get_border_orientation():
		1:	
			if aspect != "expand":
				offset.x = (viewport.x - (viewport.y / 9) * 16)/2
		-1:
			if aspect != "expand":
				offset.y = (viewport.y - (viewport.x / 16) * 9)/2
		_:
			pass
	return offset


func _get_screen_ratio() -> float:
	var viewport:Vector2 = get_viewport().size
	return viewport.x/viewport.y


func _get_ratio() -> float:
	var viewport = get_viewport().size
	var rx:float = viewport.x / width
	var ry:float = viewport.y / height

	match _get_border_orientation():
		1:
			rx = viewport.x / ((viewport.y / 9) * 16)
		-1:
			ry = viewport.y / ((viewport.x / 16) * 9)
		_:
			pass
	
	return ry if ry > rx else rx


func _update_shader_params() -> void:
	var ratio:float = _get_ratio()
	var band = current_band_radius * ratio
	var base = current_base_radius * ratio
	material.set_shader_parameter("band_radius", band)
	material.set_shader_parameter("base_radius", base)


func _calculate_position() -> Vector2:
	var result:Vector2 = Vector2.ZERO
	var offset_x = (get_viewport().size.x - width)/2
	var offset_y = (get_viewport().size.y - height)/2
	var calced_offset = _calc_offset()
	result.x += (offset_x - calced_offset.x)
	result.y += (offset_y - calced_offset.y)

	return result