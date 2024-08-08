extends Node

var is_music_on : bool

var is_image_unlocked : Array[bool]
var max_image_num : int

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var memory_unlock_sound: AudioStreamPlayer = $MemoryUnlockSound

var is_cheating : bool
var cheat_code : String = "IMJUSTAGIRL"

func _ready():
	is_cheating = false
	is_music_on = true
	is_image_unlocked = [false, false, false, false, false]
	max_image_num = 4
	
func unlock_image(index: int) -> void:
	if index > max_image_num or index < 0:
		return
	
	if is_image_unlocked[index]:
		return
	
	is_image_unlocked[index] = true
	animation_player.play("unlock_animation")
	memory_unlock_sound.play()

func toggle_cheat() -> void:
	if is_cheating:
		is_cheating = false
	else:
		is_cheating = true
