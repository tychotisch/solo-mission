extends ParallaxBackground


func _process(delta: float) -> void:
	scroll_offset.y += 100 * delta
