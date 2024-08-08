extends CharacterBody2D

signal is_dead

@export var speed : float = 100
@export var dash_multiplier : float = 6

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

@export var is_invincible : bool = false
var is_dashing : bool = false
var dash_cooldown : bool = false
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var dash_trail: CPUParticles2D = $DashTrail
@onready var dash_sfx: AudioStreamPlayer = $DashSFX

func _ready() -> void:
	animation.play("flying")

func _physics_process(_delta: float) -> void:

	var direction : Vector2 = Input.get_vector("left", "right", "up", "down")
	self.velocity = direction * speed
	
	if Input.is_action_just_pressed("dash") and not dash_cooldown:
		dash()
	
	if is_dashing:
		self.velocity *= dash_multiplier
	
	if direction.x < 0:
		animation.flip_h = true
	if direction.x > 0:
		animation.flip_h = false
	
	move_and_slide()

func dash() -> void:
	if is_dashing or dash_cooldown:
		return
	
	dash_trail.emitting = true
	animation.material.set("shader_parameter/is_active", false)
	
	is_dashing = true
	dash_cooldown = true
	dash_timer.start()
	dash_cooldown_timer.start()

func _on_dashtimer_timeout() -> void:
	is_dashing = false
	
	
func _on_dash_cooldown_end() -> void:
	dash_cooldown = false
	animation.material.set("shader_parameter/is_active", true)

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if is_invincible or is_dashing:
		return
	
	if body.is_in_group("obstacle"):
		is_dead.emit()
		#self.queue_free()


