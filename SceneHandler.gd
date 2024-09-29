extends Node

var mapstart = preload("res://Scenes/MainScenes/Map.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mapstart_instance = mapstart.instance()
	add_child(mapstart_instance)
