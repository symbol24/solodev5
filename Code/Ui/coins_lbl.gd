extends Label


func _ready() -> void:
	Signals.UpdatePlayerCurrency.connect(_update_coins)


func _update_coins(value:int) -> void:
	text = str(value)