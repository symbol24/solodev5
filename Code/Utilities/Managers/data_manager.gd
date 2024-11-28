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