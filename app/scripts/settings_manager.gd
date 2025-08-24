extends Node

var main_scene_node

signal blue_light_filter(toggle : bool)



func toggle_blue_light_filter(toggle : bool):
	blue_light_filter.emit(toggle)
	
	
func set_main(node):
	main_scene_node = node
