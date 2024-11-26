class_name Parameter extends Resource


enum Type {
			FLAT = 0,
			FLAT_BONUS = 1,
			PERCENT_BONUS = 2,
		}


@export var id:String = ""
@export var value:float = 0
@export var type:Type