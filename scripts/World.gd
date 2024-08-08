extends Node2D
class_name World

#External References
#const OBSTACLE = preload("res://scenes/obstacle.tscn")
const GHOST = preload("res://scenes/ghost.tscn")
const BAT = preload("res://scenes/bat.tscn")
const WORK = preload("res://scenes/work.tscn")
const CAT_OBSTACLE = preload("res://scenes/cat_obstacle.tscn")
const REAPER = preload("res://scenes/reaper.tscn")

#Internal References
@onready var spawn_timer: Timer = $Spawner/SpawnTimer
@onready var spawn_area: ColorRect = $Spawner/SpawnArea

@onready var level_timer: Timer = $UI/LevelTimer
@onready var level_timer_label: Label = $UI/LevelTimerLabel
@onready var uianimation: AnimationPlayer = $UI/uianimation
@onready var level_indicators : Array[Node] = $UI/LevelIndicators.get_children()

var current_level : int = 0
@export var levels : Array[ParallaxLayer]
@onready var backgrounds: ParallaxBackground = $Backgrounds/Backgrounds
@onready var transitionplayer: AnimationPlayer = $TransitionScreen/transitionplayer

@onready var tutorial: Node2D = $UI/Tutorial

#Background

#SFX
@onready var spawn_sfx: AudioStreamPlayer = $SFX/SpawnSFX
@onready var boss_sfx: AudioStreamPlayer = $SFX/BossSFX

#BGM
@onready var bgm_1: AudioStreamPlayer = $BGM/BGM1

func _ready() -> void:
	if Globals.is_music_on:
		bgm_1.play()
	current_level = 0
	level_timer.start()
	
	if Globals.is_cheating:
		spawn_timer.wait_time = 5
	
	spawn_timer.start()
	uianimation.play("show_level_indicator")

func _process(delta: float) -> void:
	#UPDATE UI TIMER
	level_timer_label.text = str(int(level_timer.time_left))
	
	# BACKGROUND SCROLLING
	backgrounds.offset.x -= delta


#region SPAWN_OBSTACLES
func spawn_obstacle() -> void:
	var rect : Rect2 = spawn_area.get_rect()
	var randx : float = randf_range(rect.position.x, rect.end.x)
	var randy  : float = randf_range(rect.position.y, rect.end.y)
	
	var new_obstacle : Obstacle = null
	
	match current_level:
		0: new_obstacle = GHOST.instantiate()
		1: new_obstacle = BAT.instantiate()
		2: new_obstacle = WORK.instantiate()
		3: new_obstacle = CAT_OBSTACLE.instantiate()
		4: 
			spawn_timer.stop()
			spawn_boss()
			return
		_: return
	
	new_obstacle.global_position = Vector2(randx, randy)
	self.add_child(new_obstacle)
	spawn_sfx.play()
	
func _on_spawn_timer_timeout() -> void:
	spawn_obstacle()

func spawn_boss() -> void:
	var boss : Reaper = REAPER.instantiate()
	
	boss.global_position = get_viewport_rect().size / 2
	self.add_child(boss)
	boss_sfx.play()
	
	return

func clear_all_obstacles() -> void:
	get_tree().call_group("obstacle", "destroy")
#endregion
	
#region LEVEL CHANGE
func _on_level_timer_timeout() -> void:
	
	current_level += 1
	if current_level == 4:
		fade_bgm()
	if current_level > 4:
		show_end_screen()
		return
		
	Globals.unlock_image(current_level - 1)
	transitionplayer.play("shutter_on")
	get_tree().paused = true
	
		
func _on_transitionplayer_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shutter_on":
		transitionplayer.play("shutter_off")
		change_level(current_level)
	elif anim_name == "shutter_off":
		level_indicators[current_level].visible = true
		uianimation.play("show_level_indicator")

func _on_uianimation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "show_level_indicator":
		uianimation.play("hide_level_indicator")

func change_level(index : int) -> void:
	for level in levels:
			level.visible = false
	levels[index].visible = true
	get_tree().paused = false

#endregion

#Fade Music
func fade_bgm() -> void:
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(bgm_1, "volume_db", -25, 20)

# END SCREEN
func show_end_screen() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/victory_cutscene.tscn")

# FAIL SCREEN
func _on_player_is_dead() -> void:
	show_fail_screen()

func show_fail_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_tutorial_timer_timeout() -> void:
	var fade : Tween = get_tree().create_tween()
	fade.tween_property(tutorial, "modulate", Color(1, 1, 1, 0), 2)
