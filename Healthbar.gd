extends ProgressBar
@onready var player: CharacterBody2D = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.HealthChanged.connect(update)
	update()


func update():
	value = player.player_health * 100 / player.player_max_health
