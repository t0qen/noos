extends Node

var main_scene_node

func toggle_blue_light_filter(toggle : bool):
	print("yes")
	main_scene_node.blue_light_filter(toggle)
	
	
func set_main(node):
	main_scene_node = node
