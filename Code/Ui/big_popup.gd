class_name BigPopup extends PanelContainer


@onready var big_texture: TextureRect = %big_texture
@onready var big_title: Label = %big_title
@onready var big_text: RichTextLabel = %big_text
@onready var timer_rtl: RichTextLabel = %timer_rtl
@onready var popup_cancel_btn: Button = %popup_cancel_btn
@onready var popup_confirm_btn: Button = %popup_confirm_btn

var popup_id:String


func _ready() -> void:
	popup_cancel_btn.pressed.connect(_send_cancel)
	popup_confirm_btn.pressed.connect(_send_confirm)


func set_popup(new_popup_id:String, texture:CompressedTexture2D, title:String, text:String, timer:int) -> void:
	popup_id = new_popup_id
	if texture != null:
		big_texture.texture = texture
		big_texture.show()
	else: big_texture.hide()
	big_title.text = title
	big_text.text = text
	if timer > 0: _update_timer(timer)
	else: timer_rtl.hide()
	popup_cancel_btn.grab_focus()
	show()


func _update_timer(remain:int) -> void:
	timer_rtl.show()
	if remain >= 0:
		timer_rtl.text = "[center]" + str(remain) + "[/center]"
	remain -= 1
	if remain >= -1:
		await get_tree().create_timer(1).timeout
		_update_timer(remain)
	else:
		_send_cancel()


func _send_cancel() -> void:
	get_parent().get_parent().hide()
	hide()
	Signals.PopupResult.emit(popup_id, false)


func _send_confirm() -> void:
	get_parent().get_parent().hide()
	hide()
	Signals.PopupResult.emit(popup_id, true)