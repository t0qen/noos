extends Control

#region CLOCK
var hours 
var min 

@onready var clock_label: Label = $"bottom-bar/labels/clock"

func update_clock():
	var datetime = Time.get_datetime_dict_from_system()
	hours = datetime.hour
	min = datetime.minute
	
	if hours < 10:
		hours = "0" + str(hours)
	if min < 10:
		min = "0" + str(min)
		
	clock_label.text = str(hours) + ":" + str(min)
#endregion
	
#region APPS MANAGEMENT
var toggle_menu : bool = false

@onready var menu: Control = $"apps/menu"

func _on_toggle_pressed() -> void:
	print("toggle")
	if toggle_menu:
		menu.show()
		AudioManager.play("menu")
	else:
		menu.hide()
		AudioManager.play("menu")
	toggle_menu = !toggle_menu
# other 

@onready var pomodoro_app: Control = $"apps-container/pomodoro"
@onready var notes_app: Control = $"current-app/notes"
@onready var apps_label: Label = $apps/apps

enum APPS {
	POMO,
	NOTES
}
var current_app : APPS = APPS.NOTES

func update_app_display():
	for child in $"apps-container".get_children():
		child.hide()
	menu.hide()	
	toggle_menu = true
	match current_app:
		APPS.POMO:
			$"apps-container/pomodoro".show()
			apps_label.text = "pomo settings"
		APPS.NOTES:
			$"apps-container/notes".show()
			apps_label.text = "notes"
			
func _on_pomo_settings_btn_pressed() -> void:
	AudioManager.play("button")
	current_app = APPS.POMO
	update_app_display()
	
func _on_notes_btn_pressed() -> void:
	AudioManager.play("button")
	current_app = APPS.NOTES
	update_app_display()
#endregion
			
#region POMODORO
	
@onready var pomo_label: Label = $"bottom-bar/labels/pomo"
@onready var state_label: Label = $"bottom-bar/labels/state"
@onready var pomo_timer: Timer = $Timer

enum POMO_STATE {
	WORK,
	BREAK,
	STOPPED,
	NOTLAUNCHED,
	PAUSED
}
var current_pomo_state : POMO_STATE = POMO_STATE.NOTLAUNCHED
	
var is_paused : bool = false	
var prev_pomo_state : POMO_STATE = current_pomo_state
	
var work_value : int = 25
var break_value : int = 5
	
func stop_pomo():
	pomo_timer.stop()
	current_pomo_state = POMO_STATE.STOPPED
	update_pomo_state_display()
		
func start_pomo():
	if current_pomo_state in [POMO_STATE.STOPPED, POMO_STATE.BREAK, POMO_STATE.NOTLAUNCHED]:
		pomo_timer.start(work_value * 60)
		current_pomo_state = POMO_STATE.WORK
	elif current_pomo_state == POMO_STATE.WORK:
		AudioManager.play("work")
		pomo_timer.start(break_value * 60)
		current_pomo_state = POMO_STATE.BREAK
	
	update_pomo_state_display()

func update_pomo():
	if current_pomo_state == POMO_STATE.NOTLAUNCHED or current_pomo_state == POMO_STATE.STOPPED:
		pomo_label.text = str(work_value) + ":00"
	else:
		var pomo_value : int = int(pomo_timer.time_left)

		var format_adj_min : String = ""
		if (pomo_value / 60) < 10: 
			format_adj_min = "0"
			
		var format_adj_sec : String = ""
		if (pomo_value % 60) < 10: 
			format_adj_sec = "0"
		
		pomo_label.text = format_adj_min + str(pomo_value / 60) + ":" + format_adj_sec + str(pomo_value % 60)

func update_pomo_state_display():
	print("UPDATE DISPLAY")
	match current_pomo_state:
		POMO_STATE.NOTLAUNCHED:
			state_label.text = "NOT LAUNCHED"
		POMO_STATE.WORK:
			state_label.text = "WORKING"
			print("WORK")
		POMO_STATE.BREAK:
			state_label.text = "BREAK"
		POMO_STATE.PAUSED:
			state_label.text = "PAUSED"
		POMO_STATE.STOPPED:
			state_label.text = "STOPPED"

func _on_pomodoro_start_pomo() -> void:
	start_pomo()
	print("POMO STARTED")
	


func _on_pomodoro_stop_pomo() -> void:
	stop_pomo()


func _on_pomodoro_toggle_pomo() -> void:
	if current_pomo_state != POMO_STATE.STOPPED:
		
		if is_paused:
			pomo_timer.paused = false
			current_pomo_state = prev_pomo_state
		else:
			pomo_timer.paused = true
			prev_pomo_state = current_pomo_state
			current_pomo_state = POMO_STATE.PAUSED
			
		is_paused = !is_paused
		update_pomo_state_display()


func _on_pomodoro_work_duration_changed(new_value: int) -> void:
	work_value = new_value
	stop_pomo()

func _on_pomodoro_break_duration_changed(new_value: int) -> void:
	break_value = new_value
	stop_pomo()
	
func _on_timer_timeout() -> void:
	if current_pomo_state == POMO_STATE.BREAK:
		AudioManager.play("break")
	start_pomo()
#endregion
	
	
	
func _physics_process(delta: float) -> void:
	update_clock()
	update_pomo()
	
	if Input.is_action_just_pressed("close"):
		get_tree().quit()
	#print("CURRENT POMO STT ", current_pomo_state)
	
	
func _ready() -> void:
	update_app_display()
	
	var work_file = FileAccess.open("user://work_duration.dat", FileAccess.READ)
	var break_file = FileAccess.open("user://break_duration.dat", FileAccess.READ)
	if work_file:
		work_value = int(work_file.get_as_text())
		print("WORK ", work_value)
	if break_file:
		break_value = int(break_file.get_as_text())
		print("BREAK ", break_value)
