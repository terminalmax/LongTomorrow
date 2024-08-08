extends Control

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var select_sfx: AudioStreamPlayer = $SelectSFX
@onready var bgm: AudioStreamPlayer = $BGM
@onready var lamp_light: PointLight2D = $LampLight
@onready var title: Label = $Title

@onready var cat: AnimatedSprite2D = $cat
@onready var tp_positions : Array[Marker2D] = [$Position1, $Position2, $Position3]
@onready var cat_sfx : Array[AudioStreamPlayer] = [$CatSFX1, $CatSFX2]
@onready var tp_particles: CPUParticles2D = $cat/CPUParticles2D

var cheat_index : int

func _ready() -> void:
	cheat_index = 0
	animation.play("opening_animation")
	bgm.play()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if Globals.cheat_code[cheat_index] == event.as_text_keycode():
			cheat_index += 1
			if cheat_index == Globals.cheat_code.length():
				Globals.toggle_cheat()
				toggle_cheat_look()
				cheat_index = 0
		else:
			cheat_index = 0
			
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_album_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/album.tscn")

func _on_start_button_mouse_entered() -> void:
	select_sfx.play()

func _on_album_button_mouse_entered() -> void:
	select_sfx.play()

func _on_music_check_box_toggled(toggled_on: bool) -> void:
	Globals.is_music_on = toggled_on

func teleport_cat() -> void:
	var tp_pos = tp_positions.pick_random()
	
	while tp_pos.global_position == cat.global_position:
		tp_pos = tp_positions.pick_random()
	
	cat.global_position = tp_pos.global_position
	cat_sfx.pick_random().play()
	tp_particles.emitting = true

func toggle_cheat_look() -> void:
	lamp_light.color = Color(1, 0.25, 0.45, 1)
	title.modulate = Color(1, 0.5, 0.98, 1)

func _on_area_2d_mouse_entered() -> void:
	print("MOUSE")
	teleport_cat()
