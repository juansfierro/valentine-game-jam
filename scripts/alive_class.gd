extends CharacterBody2D

class_name Alive

@export var max_health: int
@export var speed: int

var current_health: int

func _init(health: int = 100, spd: int = 50) -> void:
	max_health = health
	speed = spd

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	current_health -= amount
	
	if current_health <= 0:
		die()
	else:
		flash_red()

func flash_red() -> void:
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE

func die() -> void:
	queue_free()
