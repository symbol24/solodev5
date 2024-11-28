extends Node


# Debug
signal DebugPrint(text:String)


# Scene Manager
signal LoadScene(id:String)
signal SceneLoadingComplete(scene)
signal ClearActiveScene()


# UI
signal LoadUi()
signal ToggleLoadingScreen(display:bool)
signal ToggleDark(show:bool)
signal DamageNumber(value:int, pos:Vector2, type:String)
signal SyButtonPressed(destination:String)
signal ToggleUi(id:String, previous:String)
signal UpdatePlayerExp(value:float, max:float)
signal UpdatePlayerCurrency(value:float)
signal UpdateSkillTimer(id:String, value:float)
signal ConstructSkillBox(data:SkillData, is_disabled:bool)
signal ConstructBoosterBox(data:BoosterData)
signal PlayerUiReady()
signal ClearPlayerUi()
signal PressFirstSkillButton()
signal UntoggleSkillButtons(id:String)
signal SkillLevelUpdated(id:String, level:int)
signal ReturnDmgNbrToPool(dmg_number:DamageNumber)
signal ToggleSkillFromKey(id:String)


# Game Manager
signal TowerReady(tower:Tower)
signal TowerClear()
signal ManagerReady(manager)
signal CheckMatchEnd(light_radius:float, push_back_radius:float)
signal LoadDataManager()


# Tower / Light area
signal ActivateTower()
signal SetupTower()
signal StopRound()
signal UpdateTowerLightArea(value:float)
signal UpdateDarkRadius(value:float)


# Player
signal PlayerReady()
signal AddExp(value:float)
signal AddCurrency(type:CurrencyObject.Type, value:float)
signal ActivateSkill(id:String)
signal ToggleMouseEnteredNoClickArea(in_area:bool)
signal ActivatePlayer()
signal PlayerlevelUp(level:int)
signal LevelUpComplete()
signal LevelUpSelection(data:SytoData)
signal AddNewSkill(data:SkillData)
signal UpdateActiveSkill(id:String, is_booster:bool)


# Currency
signal SpawnCurrency(type:CurrencyObject.Type, amount:int, pos:Vector2)
signal CMReady()
signal ReturnCurrencyToPool(currency:CurrencyObject)


# Spawn Manager
signal ReturnToPool(item)


# Minions/Boss
signal MonsterDeath(monster_data:MonsterData)


# Save/Load
signal SaveLoadManagerReady()
signal Save(id:int)
signal Load(id:int)


# Tower Monster
signal TowerMonsterDeath(_name:String, is_unique:bool)