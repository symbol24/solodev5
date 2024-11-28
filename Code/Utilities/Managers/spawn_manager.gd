class_name SpawnManager extends Node2D


@export var use_pool:bool = false
@export var auto_spawners:Dictionary = {}

var pool:Array[Array] = []
var monsters:Array[Monster] = []
var tower_monsters:Array[TowerMonster] = []

func _ready() -> void:
	Signals.ReturnToPool.connect(_return_to_pool)
	Signals.ManagerReady.emit(self)


func get_thing_to_spawn(_data:SytoData) -> Node2D:
	if use_pool:
		var check = _get_from_pool(_data.id)
		if check:
			add_child(check)
			if check is Monster:
				monsters.append(check)
			elif check is TowerMonster:
				tower_monsters.append(check)
			return check
	
	if _data != null and _data.get("to_spawn") != null:
		var new = _data.to_spawn.instantiate()
		if new.get_parent() == null:
			add_child(new)
		if new is Monster:
			monsters.append(new)
		elif new is TowerMonster:
			tower_monsters.append(new)
		return new
	else:
		Debug.error("Data sent to spawnable is either null or does not contain spawnable object.")
		return null


func get_closest_to(me) -> Node2D:
	var distance:float = 100000000000000.0
	var closest:Node2D
	var to_check

	if me is Monster:
		to_check = tower_monsters
	elif me is TowerMonster:
		to_check = monsters

	for each in to_check:
		if each != null and me.global_position.distance_squared_to(each.global_position) < distance:
			distance = me.global_position.distance_squared_to(each.global_position)
			closest = each

	return closest


func _get_from_pool(_id:String) -> Node2D:
	for array in pool:
		if not array.is_empty() and array[0].get("id") == _id:
				return array.pop_front()
	return null


func _return_to_pool(_item) -> void:
	if use_pool:
		var added:bool = false

		if monsters.has(_item):
			var pos:int = monsters.find(monsters)
			monsters.remove_at(pos)

		remove_child.call_deferred(_item)

		for array in pool:
			if not array.is_empty() and array[0].get("id") == _item.get("id"):
				array.append(_item)
				added = true

		if not added:
			pool.append([_item])
	else:
		_item.queue_free.call_deferred()
