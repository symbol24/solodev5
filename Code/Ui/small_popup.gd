class_name SmallPopup extends PanelContainer


@onready var small_texture: TextureRect = %small_texture
@onready var small_text: RichTextLabel = %small_text


func set_popup(texture:CompressedTexture2D, text:String, timer:int) -> void:
	if texture != null:
		small_texture.texture = texture
		small_texture.show()
	else: small_texture.hide()
	small_text.text = text
	get_tree().create_timer(timer).timeout.connect(_hide)
	show()


func _hide() -> void:
	hide()
	get_parent().get_parent().hide()