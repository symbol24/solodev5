class_name TowerAutospawner extends Node2D


var data:TowerAutospawnerData


func set_data(new_data:TowerAutospawnerData) -> void:
	data = new_data.duplicate(true)