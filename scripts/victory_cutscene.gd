extends Node2D

@onready var bgm: AudioStreamPlayer = $BGM

func _ready() -> void:
	if Globals.is_music_on:
		bgm.play()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func unlock_final() -> void:
	Globals.unlock_image(4)
