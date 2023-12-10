extends Area2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var explosion_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

var speed := 1300
var direction := 1

func _physics_process(delta):
	position -= transform.y * speed * delta * direction

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void: #player damage
	sprite.hide()
	speed = 0
	animation.visible = true
	explosion_sound.play()
	animation.play("explosion")
	if body.has_method("take_damage"):
		body.take_damage(1)

func _on_animated_sprite_2d_animation_finished() -> void:
	animation.stop()
	animation.hide()
	queue_free()

func _on_area_entered(body: Area2D) -> void: # enemy damage
	sprite.hide()
	speed = 0
	animation.visible = true
	explosion_sound.play()
	animation.play("explosion")
	if body.has_method("take_damage"):
		body.take_damage(2)
