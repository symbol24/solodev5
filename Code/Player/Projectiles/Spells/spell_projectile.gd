class_name SpellProjectile extends Projectile


@onready var animator: AnimationPlayer = %animator


func _ready() -> void:
	animator.animation_finished.connect(_animation_finished)


func setup_projectile(_data:SkillData) -> void:
	super(_data)
	var texture_size:Vector2 = sprite.texture.get_size()

	var ratio:float = _data.attack_area_size / texture_size.x

	sprite.scale *= ratio
	attack_collider.shape.radius = _data.attack_area_size/2


func _animation_finished(anim_name:String) -> void:
	queue_free()