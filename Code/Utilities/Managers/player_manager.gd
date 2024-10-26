class_name PlayerManager extends Node2D


const MONSTER = preload("res://Scenes/Monsters/monster.tscn")


@export var starting_level_cap:int = 5
@export var starting_skill:Array[SkillData]

# Stats
var player_level:int = 1
var current_exp:int = 0
var total_exp:int = 0

# Skills
var active_skill:Skill
var all_skills:Array[Skill] = []

var pool:Array[Monster] = []
var spawn_count:int = 0
var can_spawn:bool = true
var delay_active:bool = false
var delay:float = 0.3
var timer:float = 0.0:
	set(value):
		timer = value
		if timer >= delay:
			timer = 0.0
			delay_active = false
			can_spawn = true

var mouse_in_light:bool = false


# if area breaks again, maybe change to check if mouse distance from the center  is larger than radius of light
func _input(event: InputEvent) -> void:
	if not get_tree().paused:
		if can_spawn and not mouse_in_light and event.is_action_pressed("mouse_left"):
			can_spawn = false
			delay_active = true
			_spawn_a_monster(event.position)

		if event.is_action_pressed("pause"):
			get_tree().paused = true
			Signals.ToggleUi.emit("pause_menu")


func _ready() -> void:
	Signals.ToggleMouseEnteredLight.connect(_toggle_mouse_entered)
	Signals.ReturnMonsterToPool.connect(_return_monster_to_pool)
	Signals.AddCurrency.connect(_add_currency)
	Signals.UpdatePlayerExp.emit(current_exp, _get_level_exp_ceiling())
	Signals.ManagerReady.emit(self)


func _process(delta: float) -> void:
	if delay_active: timer += delta


func _toggle_mouse_entered(value:bool) -> void:
	mouse_in_light = value
	#print("Mouse in light: ", mouse_in_light)


func _add_currency(value:int) -> void:
	total_exp += value
	current_exp += value
	if current_exp >= _get_level_exp_ceiling():
		current_exp -= _get_level_exp_ceiling()
		_level_up()
	Signals.UpdatePlayerExp.emit(current_exp, _get_level_exp_ceiling())


func _get_level_exp_ceiling() -> int:
	return floori(starting_level_cap * (player_level * 0.5)) if player_level > 1 else starting_level_cap


func _level_up() -> void:
	player_level += 1
	print("Player Level up! ", player_level)
	Signals.PlayerlevelUp.emit()

	
func _get_monster() -> Monster:
	if pool.is_empty():
		return MONSTER.instantiate() as Monster
	else:
		return pool.pop_front()
	

func _return_monster_to_pool(to_return:Monster) -> void:
	remove_child.call_deferred(to_return)
	pool.append(to_return)


func _spawn_a_monster(pos:Vector2) -> void:
	var new:Monster = _get_monster()
	add_child(new)
	if not new.is_node_ready():
		await new.ready
	new.setup_stats()
	new.global_position = pos
	new.name = "monster_0" + str(spawn_count)
	spawn_count += 1
