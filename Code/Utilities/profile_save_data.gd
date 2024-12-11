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


# Settings
# Audio
@export var master_volume:float = 0.5:
	set(_value):
		master_volume = _value
		if master_volume > 1.0: master_volume = 1.0
		elif master_volume < 0.0: master_volume = 0.0
@export var music_volume :float = 0.5:
	set(_value):
		music_volume = _value
		if music_volume > 1.0: music_volume = 1.0
		elif music_volume < 0.0: music_volume = 0.0
@export var sfx_volume :float = 0.5:
	set(_value):
		sfx_volume = _value
		if sfx_volume > 1.0: sfx_volume = 1.0
		elif sfx_volume < 0.0: sfx_volume = 0.0