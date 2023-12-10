extends Area2D

@onready var ufo: Area2D = $"."
@onready var player_detection: RayCast2D = $Sprite2D/PlayerDetection
@onready var bullet_spawn: Marker2D = $BulletSpawn
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var player_detection_2: RayCast2D = $Sprite2D/PlayerDetection2
@onready var explosion_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $ProgressBar

signal HealthChanged
signal Escaped

var Bullet := preload("res://bullet.tscn")
var random_x_destination := randi() % 1200
var random_x_start := randi() % 1200
var off_screen_pos_y : = 1900
var speed := randi() % 350 + 150
var target := CharacterBody2D
var enemy_health := 10
var enemy_max_health := 10
var max_bullets := 10
var shoot_cooldown := 75
var last_shot = 0

func _ready() -> void:
	randomize()
	ufo.global_position.x = random_x_start

func _process(delta: float) -> void:
	move_to_random_x(delta)
	if enemy_health > 0:
		shoot_at_player()

func move_to_random_x(delta):
	ufo.global_position = ufo.global_position.move_toward(Vector2(random_x_destination, off_screen_pos_y), speed * delta)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	Events.emit_signal("Escaped")
	queue_free()

func shoot():
	if max_bullets > 0: 
		max_bullets -= 1
		var bullet = Bullet.instantiate()
		get_tree().root.add_child(bullet)
		bullet.direction = -1
		bullet.sprite.flip_v = true
		bullet.position = bullet_spawn.position
		bullet.global_transform = bullet_spawn.global_transform

func shoot_at_player():
	var time = Time.get_ticks_msec()
	if player_detection.is_colliding():
		if time - last_shot > shoot_cooldown:
			last_shot = time
			bullet_spawn.global_transform = player_detection.global_transform
			shoot()
	if player_detection_2.is_colliding():
		if time - last_shot > shoot_cooldown:
			last_shot = time
			bullet_spawn.global_transform = player_detection_2.global_transform
			shoot()

func take_damage(damage):
	enemy_health -= damage
	animation.play("taking_damage")
	emit_signal("HealthChanged")
	if enemy_health <= 0:
		Events.emit_signal("Died")
		sprite.hide()
		health_bar.visible = false
		explosion_animation.visible = true
		ufo.collision_layer = 0
		ufo.collision_mask = 0
		explosion_animation.play("explode")

func _on_animated_sprite_2d_animation_finished() -> void:
	explosion_animation.stop()
	explosion_animation.hide()
	queue_free()

func _on_animation_player_animation_finished(anim) -> void:
	if anim == "taking_damage":
		animation.play("rotating")
	
