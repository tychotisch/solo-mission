extends CharacterBody2D

@onready var ship: Sprite2D = $Sprite2D
@onready var player: CharacterBody2D = $"."
@onready var spawn1: Marker2D = $Sprite2D/Spawn1
@onready var spawn2: Marker2D = $Sprite2D/Spawn2
@onready var spawn3: Marker2D = $Sprite2D/Spawn3
@onready var shoot_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var explosion: AnimatedSprite2D = $Explosion
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var shield: Area2D = $Shield
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var shield_timer: Timer = $Shield/ShieldTimer
@onready var energy_timer: Timer = $EnergyTimer

signal HealthChanged

const SPEED = 1000.0

var rotation_speed := 0.2
var max_angle := deg_to_rad(40)
var Bullet := preload("res://player_bullet.tscn")
var drag_factor := 0.1
var within_bounds := true
var energy := false
var player_health := 14
var player_max_health := 14
var player_level := 0

func _ready() -> void:
	explosion.hide()
	Events.connect("Level_up", level_up)
	Events.connect("Escaped", level_down)
	Events.connect("Energy", activate_energy)
	deativate_shield()

func _physics_process(_delta: float) -> void:
		playable_area()
		if player_health > 0:
			if Input.is_action_just_pressed("shoot"):
				if player_level == 0:
					shoot()
				if player_level == 1:
					shoot()
					shoot2()
				if player_level == 2:
					shoot()
					shoot2()
					shoot3()

			var direction := Input.get_vector("left", "right", "up", "down")
			var desired_velocity := SPEED * direction
			var steering := desired_velocity - velocity
			velocity += steering * drag_factor
			move_and_slide()

func playable_area():
	if player.position.x < 70:
		player.position.x = 70
	if player.position.x > 1410:
		player.position.x = 1410
	if player.position.y < 40:
		player.position.y = 40
	if player.position.y > 1800:
		player.position.y = 1800

func shoot():
	var bullet = Bullet.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_transform = spawn1.global_transform
	shoot_sound.play()
func shoot2():
	var bullet = Bullet.instantiate()
	get_tree().root.add_child(bullet)
	bullet.speed = 1500
	bullet.global_transform = spawn2.global_transform
	shoot_sound.play()
func shoot3():
	var bullet = Bullet.instantiate()
	get_tree().root.add_child(bullet)
	bullet.speed = 1500
	bullet.global_transform = spawn3.global_transform
	shoot_sound.play()

func take_damage(damage):
	player_health -= damage
	animation.play("taking_damage")
	emit_signal("HealthChanged")
	if player_health <= 0:
		ship.hide()
		progress_bar.hide()
		explosion.visible = true
		player.collision_layer = 0
		player.collision_mask = 0
		explosion.play("explode")

func take_health(value):
	player_health += value
	emit_signal("HealthChanged")

func _on_explosion_animation_finished() -> void:
	explosion.stop()
	explosion.hide()
	Events.emit_signal("Player_died")

func level_up():
	player_level += 1
	if player_level >= 2:
		player_level = 2

func level_down():
	player_level -= 1
	if player_level <= 0:
		player_level = 0

func activate_shield():
	shield.visible = true
	shield.set_deferred("monitorable", true)
	shield.set_deferred("monitoring", true)
	shield_timer.start()
	

func deativate_shield():
	shield.visible = false
	shield.set_deferred("monitorable", false)
	shield.set_deferred("monitoring", false)

func activate_energy():
	energy_timer.start()
	activate_shield()
	take_health(5)
	player_level = 2

func _on_shield_timer_timeout() -> void:
	deativate_shield()

func _on_energy_timer_timeout() -> void:
	energy = false
	player_level = 0

func _follow_mouse(delta):
	var mouse = get_local_mouse_position()
	var angle = snappedf(mouse.angle(), PI/4) / (PI/4)
	angle = wrapi(int(angle), 0, 8)
	
	if mouse.length() > 5:
		velocity = mouse * SPEED * delta
		_rotate_to_direction()

func _rotate_to_direction():
	if velocity.x > 0:
		rotation += deg_to_rad(10) * rotation_speed
		if rotation > max_angle:
			rotation = max_angle
	if velocity.x < 0:
		rotation -= deg_to_rad(10) * rotation_speed
		if rotation < max_angle * -1:
			rotation = max_angle * -1
