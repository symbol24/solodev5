class_name CurrencyManager extends Node2D


@export var currency:PackedScene

var pool:Array = []


func _ready() -> void:
	Signals.ReturnCurrencyToPool.connect(_return_to_pool)
	Signals.SpawnCurrency.connect(_spawn_currency)
	Signals.ManagerReady.emit(self)


func _spawn_currency(pos:Vector2) -> void:
	var new:CurrencyObject = _get_currency()
	if new != null:
		add_child(new)
		if not new.is_node_ready():
			await new.ready
		new.global_position = pos
		new.start_tween()


func _get_currency() -> CurrencyObject:
	if pool.is_empty():
		if currency:
			return currency.instantiate() as CurrencyObject
		else:
			return null
	else:
		return pool.pop_front()


func _return_to_pool(to_return:CurrencyObject) -> void:
	remove_child.call_deferred(to_return)
	pool.append(to_return)