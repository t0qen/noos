extends Control

var from 
var last

#var study_interval = {1 (premiere fois) : 2 (combien jour), 2 : 4} 
#var current_interval = 2 (will be saved)
#
#func (): # avoir le nombre de jours entre from et strudy_interval(current)
#	from + stody_interval(current) = supposed date** 31 ou 30**
#   avoir le nombre de jours entre current date et supposed date
#	.text = "dans {output} jours"
#


func _on_kill_pressed() -> void:
	queue_free()

func set_contents(name : String, from_value : String):
	$name.text = name
	$from.text = from_value
	from = from_value
	
func get_last(): # last time we had to study this
	pass
	
func calculate_next():
	pass
