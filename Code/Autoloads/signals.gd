extends Node


# Scene Manager
signal LoadScene(id:String)
signal SceneLoadingComplete(scene)
signal ClearActiveScene()


# UI
signal LoadUi()
signal ToggleLoadingScreen(display:bool)
signal ToggleDark(show:bool)
signal DamageNumber(value:int, pos:Vector2)
signal SyButtonPressed(destination:String)
signal ToggleUi(id:String)
signal UpdatePlayerExp(value:int, max:int)
signal PlayerlevelUp()
signal UpdateSkillTimer(id:String, value:float)


# Game Manager
signal TowerReady(tower:Tower)
signal TowerClear()
signal ManagerReady(manager)


# Tower / Light area
signal ToggleMouseEnteredLight(in_area:bool)
signal ActivateTower()
signal SetupTower()


# Monsters
signal ReturnMonsterToPool(monster:Monster)


# Player
signal PlayerReady()
signal AddCurrency(value:int)


# Objects
signal ReturnCurrencyToPool(currency:CurrencyObject)


# Currency
signal SpawnCurrency(pos:Vector2)
signal CMReady()