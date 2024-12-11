class_name ProfileSaveData extends Resource


@export var id:int = -1
@export var save_count:int = 0

@export var current_currency:int
@export var total_currency:float

@export var score_history:Dictionary = {}
@export var unlocked_permas:Array[PermaData]
@export var unlocked_skills:Array[SkillData]
@export var unlocked_boosters:Array[BoosterData]
@export var unlocked_leaders:Array[LeaderData]

@export var last_loaded:bool = false