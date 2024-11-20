class_name SpawnManager extends Node2D


@export var use_pool:bool = false
@export var monsters:Dictionary = {}
@export var auto_spawners:Dictionary = {}

var pool:Array[Array] = []


func _ready() -> void:
	Signals.ReturnToPool.connect(_return_to_pool)
	Signals.ManagerReady.emit(self)


func get_thing_to_spawn(_data:SkillData) -> Node2D:
	if use_pool:
		var check = _get_from_pool(_data.id)
		if check:
			add_child(check)
			return check
	
	if (_data is AutoSpawnerSkillData or _data is MonsterSkillData) and _data.to_spawn != null:
		var new = _data.to_spawn.instantiate()
		if new.get_parent() == null:
			add_child(new)
		return new
	else:
		Debug.error("Data sent to spawn Manager does not contain spawnable object.")
		return null


func _get_from_pool(_id:String) -> Node2D:
	for array in pool:
		if not array.is_empty() and array[0].get("id") == _id:
				return array.pop_front()
	return null


func _return_to_pool(_item) -> void:
	if use_pool:
		var added:bool = false

		remove_child.call_deferred(_item)

		for array in pool:
			if not array.is_empty() and array[0].get("id") == _item.get("id"):
				array.append(_item)
				added = true

		if not added:
			pool.append([_item])
	else:
		_item.queue_free.call_deferred()
