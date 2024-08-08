extends RigidBody2D
class_name Obstacle

@onready var arrow: Node2D = $Arrow
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var direction : Vector2 = Vector2.RIGHT
const speed : float = 100.0

func _ready() -> void:
	var rotateby : float = randf_range(0, TAU)
	arrow.rotate(rotateby)
	direction = direction.rotated(rotateby)
	animation.play("telegraph")

func _on_telegraph_over_timeout() -> void:
	animation.play("show")
	arrow.queue_free()
	self.linear_velocity = direction * speed

func _activate_collision():
	collision_shape_2d.set_deferred("disabled", false)

func _on_body_entered(_body: Node) -> void:
	var angle : float = self.linear_velocity.angle()
	
	if abs(angle) <= PI/2:
		sprite.flip_h = false
		sprite.rotation = angle
	elif angle > PI/2 :
		sprite.flip_h = true
		sprite.rotation = PI - angle
	elif angle < -PI/2 :
		sprite.flip_h = true
		sprite.rotation = PI + angle


func _on_telegraph_timeout() -> void:
	animation.play("show")
	arrow.queue_free()
	self.linear_velocity = direction * speed

func destroy() -> void:
	self.queue_free()
