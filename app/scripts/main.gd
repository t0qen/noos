extends Control

#region CLOCK
var hours 
var min 
var prev_datetime

@onready var clock_label: Label = $"bottom-bar/labels/clock"

func update_clock():
	var datetime = Time.get_datetime_dict_from_system()
	if prev_datetime == datetime:
		return
		
	hours = datetime.hour
	min = datetime.minute
	
	if hours < 10:
		hours = "0" + str(hours)
	if min < 10:
		min = "0" + str(min)
		
	update_clock_label(str(hours) + ":" + str(min))
	
func update_clock_label(value):
	clock_label.text = value
#endregion
	
#region APPS MANAGEMENT
var toggle_menu : bool = false

@onready var menu: Control = $"apps/menu"

func _on_toggle_pressed() -> void:
	print("toggle")
	if toggle_menu:
		menu.show()
		AudioManager.play("button")
		if current_app == APPS.FOCUS:
			apps_label.text = "focus on pomo"
	else:
		menu.hide()
		AudioManager.play("button")
		if current_app == APPS.FOCUS:
			apps_label.text = "x"
			
	toggle_menu = !toggle_menu
# other 

@onready var pomodoro_app: Control = $"apps-container/pomodoro"
@onready var notes_app: Control = $"current-app/notes"
@onready var apps_label: Label = $apps/apps

enum APPS {
	POMO,
	NOTES,
	FOCUS,
	SETTINGS,
	MEMO
}
var current_app : APPS = APPS.NOTES


func update_app_display():
	for child in $"apps-container".get_children():
		child.hide()
	menu.hide()	
	toggle_menu = true
	$"bottom-bar/labels".show()
		
	match current_app:
		APPS.POMO:
			$"apps-container/pomodoro".show()
			apps_label.text = "pomo settings"
		APPS.NOTES:
			$"apps-container/notes".show()
			apps_label.text = "notes"
		APPS.FOCUS:
			$"apps-container/focus".show()
			$"bottom-bar/labels".hide()
			apps_label.text = "x"
		APPS.SETTINGS:
			$"apps-container/settings".show()
			apps_label.text = "settings"
		APPS.MEMO:
			$"apps-container/memo".show()
			apps_label.text = "memo reminder"
			
			
func _on_pomo_settings_btn_pressed() -> void:
	AudioManager.play("button")
	current_app = APPS.POMO
	update_app_display()
	
func _on_notes_btn_pressed() -> void:
	AudioManager.play("button")
	current_app = APPS.NOTES
	update_app_display()
	
func _on_pomo_date_btn_pressed() -> void:
	AudioManager.play("button")
	current_app = APPS.FOCUS
	update_app_display()

func _on_settings_btn_pressed() -> void:
	AudioManager.play("button")
	current_app = APPS.SETTINGS
	update_app_display()
	

func _on_memo_btn_pressed() -> void:
	AudioManager.play("button")
	current_app = APPS.MEMO
	update_app_display()

func _on_quit_btn_pressed() -> void:
	menu.hide()	
	toggle_menu = true
	AudioManager.play("button")
	$quit_dialog.show()


#endregion
			
#region POMODORO
	
@onready var pomo_label: Label = $"bottom-bar/labels/pomo"
@onready var state_label: Label = $"bottom-bar/labels/state"
@onready var pomo_timer: Timer = $Timer

@onready var focus_node: Control = $"apps-container/focus"

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
		break_modulation(false)
		pomo_timer.start(work_value * 60)
		current_pomo_state = POMO_STATE.WORK
	elif current_pomo_state == POMO_STATE.WORK:
		AudioManager.play("work")
		break_modulation(true)
		pomo_timer.start(break_value * 60)
		current_pomo_state = POMO_STATE.BREAK
	
	update_pomo_state_display()


func update_pomo():
	var is_focus : bool = false
	if current_app == APPS.FOCUS:
		is_focus = true
	
	if current_pomo_state == POMO_STATE.NOTLAUNCHED or current_pomo_state == POMO_STATE.STOPPED:
		update_pomo_label(str(work_value) + ":00")
		
	else:
		var pomo_value : int = int(pomo_timer.time_left)

		var format_adj_min : String = ""
		if (pomo_value / 60) < 10: 
			format_adj_min = "0"
			
		var format_adj_sec : String = ""
		if (pomo_value % 60) < 10: 
			format_adj_sec = "0"
		
		update_pomo_label(format_adj_min + str(pomo_value / 60) + ":" + format_adj_sec + str(pomo_value % 60))

func update_pomo_state_display():
	var is_focus : bool = false
	if current_app == APPS.FOCUS:
		is_focus = true

	match current_pomo_state:
		POMO_STATE.NOTLAUNCHED:
			update_pomo_state("not launched")
		POMO_STATE.WORK:
			update_pomo_state("working")
		POMO_STATE.BREAK:
			update_pomo_state("break")
		POMO_STATE.PAUSED:
			update_pomo_state("paused")
		POMO_STATE.STOPPED:
			update_pomo_state("stopped")

func update_pomo_label(value):
	pomo_label.text = value
	focus_node.change_pomo(value)
	
func update_pomo_state(value):
	state_label.text = value


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
		break_modulation(false)
		
	current_pomo_state = POMO_STATE.NOTLAUNCHED
	$pomo_restart_interval.start()
	
func _on_pomo_restart_interval_timeout() -> void:
	start_pomo()

func break_modulation(show : bool):
	$break_modulate.visible = show
	if is_blue_light_filter_enabled:
		$blue_light_filter.visible = !show
#endregion
	
	
	
func _physics_process(delta: float) -> void:
	update_clock()
	update_pomo()
	
	if Input.is_action_just_pressed("close"):
		get_tree().quit()
	#print("CURRENT POMO STT ", current_pomo_state)
	
	
func _ready() -> void:
	SettingsManager.set_main(self)
	update_app_display()
	
	var volume_file = FileAccess.open("user://volume.dat", FileAccess.READ)
	var work_file = FileAccess.open("user://work_duration.dat", FileAccess.READ)
	var break_file = FileAccess.open("user://break_duration.dat", FileAccess.READ)
	if volume_file:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(int(volume_file.get_as_text())))
	if work_file:
		work_value = int(work_file.get_as_text())
		print("WORK ", work_value)
	if break_file:
		break_value = int(break_file.get_as_text())
		print("BREAK ", break_value)

var is_blue_light_filter_enabled : bool = false
func blue_light_filter(toggle : bool):
	print(toggle)
	is_blue_light_filter_enabled = toggle
	$blue_light_filter.visible = toggle
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
