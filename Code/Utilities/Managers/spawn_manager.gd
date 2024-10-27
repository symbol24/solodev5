class_name SpawnManager extends Node2D


@export var monsters:Dictionary = {}
@export var auto_spawners:Dictionary = {}

var pool:Array[Array] = []


func _ready() -> void:
	Signals.ReturnToPool.connect(_return_to_pool)
	Signals.ManagerReady.emit(self)


func get_thing_to_spawn(_type:String, _id:String) -> Node2D:
	var check = _get_from_pool(_id)
	if check: 
		add_child(check)
		return check

	var path:String
	match _type:
		"monster":
			if monsters.has(_id):
				path = monsters[_id]
		"auto_spawner":
			if auto_spawners.has(_id):
				path = auto_spawners[_id]
		_:
			pass
	
	if path:
		var new = load(path).instantiate()
		add_child(new)
		return new
	else:
		push_error("No ", _type, " with id ", _id, " was found.")
		return null


func _get_from_pool(_id:String) -> Node2D:
	for array in pool:
		if not array.is_empty() and array[0].get("id") == _id:
				return array.pop_front()
	return null


func _return_to_pool(_item, _parent) -> void:
	var added:bool = false

	_parent.remove_child.call_deferred(_item)

	for array in pool:
		if not array.is_empty() and array[0].get("id") == _item.get("id"):
			array.append(_item)
			added = true

	if not added:
		pool.append([_item])
