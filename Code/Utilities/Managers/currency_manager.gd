class_name CurrencyManager extends Node2D


@export var use_pooling:bool = false
@export var spawn_range:float = 5

var currecy_pool:Array = []


func _ready() -> void:
	Signals.ReturnCurrencyToPool.connect(_return_to_pool)
	Signals.SpawnCurrency.connect(spawn_currency)
	Signals.ManagerReady.emit(self)


func spawn_currency(type:CurrencyObject.Type, amount:int, pos:Vector2) -> void:
	var spawn:bool = true
	var result:Dictionary

	if type == CurrencyObject.Type.COIN:
		result = _get_if_spawn()
		spawn = result["result"]
		if result.has("over"): amount += result["over"]

	if spawn:
		for i in amount:
			var new:CurrencyObject = _get_currency(type)
			if new != null:
				add_child(new)
				if not new.is_node_ready():
					await new.ready
				if type == CurrencyObject.Type.EXP:	new.value = _get_exp_value()
				new.global_position = Vector2(pos.x + randf_range(-spawn_range, spawn_range), pos.y + randf_range(-spawn_range, spawn_range))
				new.start_tween()


func _get_currency(type:CurrencyObject.Type) -> CurrencyObject:
	if use_pooling and not currecy_pool.is_empty():
		var i:int = 0
		var found:bool = false
		while not found and i < currecy_pool.size():
			if currecy_pool[i].type == type:
				found = true
			i += 1
		
		if found:
			return currecy_pool.pop_at(i)
		return null
	else:
		if type == CurrencyObject.Type.EXP:
			return Game.data_manager.experience.instantiate() if Game.data_manager.experience != null else null
		else:
			return Game.data_manager.currency.instantiate() if Game.data_manager.currency != null else null


func _return_to_pool(to_return:CurrencyObject) -> void:
	if use_pooling:
		remove_child.call_deferred(to_return)
		currecy_pool.append(to_return)
	else:
		to_return.queue_free.call_deferred()


func _get_if_spawn() -> Dictionary:
	var chance:float = Game.player_manager.get_value_of("coin_chance")
	var luck:float = Game.player_manager.get_value_of("luck")
	chance += (luck / 100)

	if chance > 1:
		var over:float = floori((chance - 1.0) * 10)
		return {
				"result":true,
				"over":over
				}

	var check:float = randf()
	if check <= chance:
		return {"result":true}
	return {"result":false}


func _get_exp_value() -> float:
	var base:float = 1
	var percent:float = Game.player_manager.get_value_of("exp_value_bonus")
	return base * percent