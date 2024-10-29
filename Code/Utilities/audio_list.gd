class_name AudioList extends Resource


@export var list:Array[AudioFile]


func get_audio_file(id:String) -> AudioFile:
	for each in list:
		if each.id == id:
			return each
	push_error("No audio file found for ", id)
	return null