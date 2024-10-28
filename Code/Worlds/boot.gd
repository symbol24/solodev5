class_name Boot extends Node2D


@onready var animator: AnimationPlayer = %animator

var current:String = "godot"
var skipped: bool = false

func _ready() -> void:
	Signals.LoadScene.emit("ui")
	animator.animation_finished.connect(_anim_finished)
	animator.play(current)


func _input(event: InputEvent) -> void:
	if not skipped and Input.is_anything_pressed():
		_skip()


func _anim_finished(anim_name) -> void:
	match anim_name:
		"godot":
			current = "rid"
			animator.play(current)
		"rid":
			Signals.ToggleUi.emit("main_menu")
			queue_free.call_deferred()
		_:
			pass


func _skip() -> void:
	animator.stop()
	animator.play("RESET")
	skipped = true
	match current:
		"godot":
			current = "rid"
			animator.play(current)
		"rid":
			Signals.ToggleUi.emit("main_menu")
			queue_free.call_deferred()
		_:
			pass
	await get_tree().create_timer(0.3).timeout
	skipped = false