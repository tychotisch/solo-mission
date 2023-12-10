extends ProgressBar

@onready var ufo: Area2D = $".."


func _ready() -> void:
	ufo.HealthChanged.connect(update)
	update()

func update():
	value = ufo.enemy_health * 100 / ufo.enemy_max_health
