extends CharacterBody2D

class_name Alive

@export var max_health: float
@export var speed: float
@export var damage: float

var current_health: float

func _init(health: float = 100.0, spd: float = 50.0, dmg: float = 10.0) -> void:
	max_health = health
	speed = spd
	damage = dmg

func _ready() -> void:
	current_health = max_health

func take_damage(amount: float) -> void:
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
