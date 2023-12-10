extends Area2D
@onready var pickup_health: Area2D = $"."

var speed := 400
var off_screen_pos_y : = 1900
var random_x_start := randi() % 1200
var random_x_destination := randi() % 2500

func _ready() -> void:
	randomize()

func _physics_process(delta):
	pickup_health.global_position.x = random_x_start
	move_to_random_x(delta)

func move_to_random_x(delta):
	pickup_health.global_position = pickup_health.global_position.move_toward(Vector2(random_x_destination, off_screen_pos_y), speed * delta)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_health"):
		body.take_health(5)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
