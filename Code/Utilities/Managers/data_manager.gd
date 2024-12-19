class_name DataManager extends Node


@export_category("Player Starters")
@export var starter_skills:Array[SkillData]
@export var starter_boosters:Array[BoosterData]
@export var starter_permas:Array[PermaData]
@export var starter_leaders:Array[LeaderData]

@export_category("Player Remainders")
@export var skills:Array[SkillData]
@export var boosters:Array[BoosterData]
@export var permas:Array[PermaData]
@export var leaders:Array[LeaderData]

@export_category("UI")
@export var skill_box:PackedScene
@export var booster_box:PackedScene
@export var damage_number:PackedScene
@export var packed_hp_bar:PackedScene
@export var profile_button:PackedScene
@export var profile_create_button:PackedScene
@export var popup_warning_icon:CompressedTexture2D
@export var popup_error_icon:CompressedTexture2D
@export var leader_style_normal:StyleBox
@export var leader_style_hover:StyleBox
@export var leader_style_locked:StyleBox
@export var leader_style_selected:StyleBox
@export var leader_button:PackedScene

@export_category("Currencies")
@export var currency:PackedScene
@export var experience:PackedScene