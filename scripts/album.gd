extends Control

var current_picture : int = 0
@export_multiline var image_titles : Array[String]
@onready var image_title: Label = $ImageTitle
@onready var current_picture_label: Label = $current_picture_label

@onready var images : Array[Node] = $Images.get_children()
var image_paths : Array[String] = ["res://pictures/pic1.jpg", "res://pictures/pic2.jpg", "res://pictures/pic3.jpeg","res://pictures/pic4.jpeg", "res://pictures/pic5.jpg"]

@onready var image_change_sfx: AudioStreamPlayer = $ImageChangeSFX
@onready var bgm: AudioStreamPlayer = $BGM

@onready var file_dialog: FileDialog = $FileDialog
@onready var download_button: TextureButton = $DownloadButton

func _ready() -> void:
	current_picture = 0
	current_picture_label.text = str(current_picture + 1)
	
	if Globals.is_image_unlocked[current_picture]:
		image_title.text = image_titles[current_picture]
		download_button.disabled = false
	else:
		image_title.text = "Locked"
	
	for i in Globals.is_image_unlocked.size():
		if Globals.is_image_unlocked[i]:
			images[i].material.set_shader_parameter("pixelSize", 1)
			images[i].get_child(0).visible = false
	
	fade_in_bgm()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		move_left()
	if event.is_action_pressed("right"):
		move_right()

func change_picture(index : int) -> void:
	
	if index < 0 or index > 4:
		return
	
	for image in images:
		image.visible = false
	
	images[index].visible = true
	
	image_change_sfx.play()
	
	if Globals.is_image_unlocked[index]:
		image_title.text = image_titles[index]
		download_button.disabled = false
	else:
		image_title.text = "Locked"
		download_button.disabled = true

func move_right() -> void:
	if current_picture == 4:
		return
	
	current_picture += 1
	current_picture_label.text = str(current_picture + 1)
	change_picture(current_picture)

func move_left() -> void:
	if current_picture == 0:
		return
	
	current_picture -= 1
	current_picture_label.text = str(current_picture + 1)
	change_picture(current_picture)

func _on_right_button_pressed() -> void:
	move_right()

func _on_left_button_pressed() -> void:
	move_left()

func fade_in_bgm() -> void:
	bgm.play()
	var fade_in = get_tree().create_tween()
	fade_in.tween_property(bgm, "volume_db", -13, 6)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_back_button_mouse_entered() -> void:
	image_change_sfx.play()

func _on_file_dialog_dir_selected(dir: String) -> void:
	print(dir)

func _on_file_dialog_file_selected(path: String) -> void:
	print("SAVED " + path)
	
	var text : CompressedTexture2D = load(image_paths[current_picture])
	var temp : Image = text.get_image()
	
	temp.save_png(path)

func _on_download_button_pressed() -> void:
	file_dialog.show()
	file_dialog.set_current_file(image_titles[current_picture] + ".png")
