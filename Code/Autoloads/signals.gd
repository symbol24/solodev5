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
signal UpdatePlayerExp(value:int, max:int)
signal UpdateSkillTimer(id:String, value:float)
signal ConstructSkillBox(data:SkillData)
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


# Tower / Light area
signal ActivateTower()
signal SetupTower()
signal StopRound()
signal UpdateTowerLightArea(value:float)
signal UpdatePushbackRadius(value:float)


# Player
signal PlayerReady()
signal AddCurrency(value:int)
signal ActivateSkill(id:String)
signal ToggleMouseEnteredNoClickArea(in_area:bool)
signal ActivatePlayer()
signal PlayerlevelUp(level:int)
signal LevelUpComplete()
signal LevelUpSelection(id:String)
signal AddNewSkill(data:SkillData)
signal UpdateActiveSkill(id:String)


# Currency
signal SpawnCurrency(pos:Vector2)
signal CMReady()
signal ReturnCurrencyToPool(currency:CurrencyObject)


# Spawn Manager
signal ReturnToPool(item)


# Minions/Boss
signal MonsterDeath(monster_data:MonsterData)