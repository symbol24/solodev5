class_name LevelUpCard extends PanelContainer


@onready var title: RichTextLabel = %title
@onready var description: RichTextLabel = %description
@onready var image: TextureRect = %image
@onready var level_up_btn: Button = %level_up_btn

var card_data:SytoData


func _ready() -> void:
	level_up_btn.disabled = true
	level_up_btn.pressed.connect(_level_up_btn_pressed)
	await get_tree().create_timer(Game.level_up_manager.card_disabled_timer).timeout
	level_up_btn.disabled = false


func set_data(_data:SytoData) -> void:
	#Debug.log("Card data is for ", _data.id)
	card_data = _data
	if card_data:
		title.text = tr(card_data.title) + " " + str(card_data.current_level+1)
		description.text = tr(card_data.description)
		image.texture = card_data.ui_texture


func _level_up_btn_pressed() -> void:
	#Debug.log("Sending signal for level selection of ", card_data.id)
	Signals.LevelUpSelection.emit(card_data)
	Signals.ToggleUi.emit("player_ui", true)
	get_tree().paused = false