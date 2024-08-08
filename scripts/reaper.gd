extends RigidBody2D
class_name Reaper

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@export var speed : float = 400

func _ready() -> void:
	self.linear_velocity = Vector2.RIGHT.rotated(randf()) * speed

func _process(_delta: float) -> void:
	if self.linear_velocity.x > 0:
		animation.flip_h = false
	elif self.linear_velocity.x < 0:
		animation.flip_h = true
