extends Node2D

func _on_player_detector_body_entered(body: Node2D) -> void:
	Events.room_entered.emit(self)
	wake_enemies()

func wake_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.get_parent() == self:
			enemy.wake_up()
	
