extends Node2D

#pickups
var shield_pickup := preload("res://pickups/pick_up_shield.tscn")
var health_pickup := preload("res://pickups/pick_up_health.tscn")
var power_pickup := preload("res://pickups/pickup_energy.tscn")
var pickup_list := [shield_pickup, health_pickup, power_pickup]

# enemies
var ufo_blue := preload("res://enemies/ufo_blue.tscn")
var ufo_yellow := preload("res://enemies/ufo_yellow.tscn")
var ufo_green := preload("res://enemies/ufo_green.tscn")
var ufo_red := preload("res://enemies/ufo_red.tscn")
var enemy_list := [ufo_blue, ufo_yellow, ufo_green, ufo_red]

func spawn_enemy():
	var enemy_type = enemy_list[randi() % enemy_list.size()]
	var enemy_to_spawn = enemy_type.instantiate()
	add_child(enemy_to_spawn)
	enemy_to_spawn.global_position.y = -100

func spawn_pickup():
	var pickup_type = pickup_list[randi() % pickup_list.size()]
	var pickup_to_spawn = pickup_type.instantiate()
	add_child(pickup_to_spawn)
	pickup_to_spawn.global_position.y = -100

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()

func _on_pickup_timer_timeout() -> void:
	spawn_pickup()
