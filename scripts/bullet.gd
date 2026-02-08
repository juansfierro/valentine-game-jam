extends Area2D

class_name Bullet

@export var damage: int
@export var speed: int

var direction: Vector2
var explosion_scene = preload("res://scenes/explosion.tscn")

func _init(dmg: int = 100, spd: int = 10):
	damage = dmg
	speed = spd

func _physics_process(_delta: float) -> void:
	global_position += direction * speed

func _on_body_entered(body: Node2D) -> void:
	explode()
	if body.is_in_group("alive"):
		body.take_damage(100)

func explode() -> void:
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	explosion.emitting = true
	explosion.lifetime = randf_range(0.5, 0.7)

	$/root/Game.add_child(explosion)
