extends Area2D

class_name Bullet

@export var damage: int
@export var speed: int
@export var pierce_count: int = 0 #How many enemies can one bullet go through, default none
@export var lifetime: float = 4.0 #Seconds before the bullet is automatically unloaded

var direction: Vector2
var pierced_bodies: Array = [] #Tracks how many enemies have been pierced.
var explosion_scene = preload("res://scenes/explosion.tscn")

func _ready() -> void:
	#Remember to add each new bullet to the bullet group.
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = lifetime
	timer.start()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body in pierced_bodies:
		return
	if body.is_in_group("alive"):
		on_hit_target(body)
		pierced_bodies.append(body)
		
		if pierced_bodies.size() > pierce_count:
			on_destroyed()
			queue_free()

func on_hit_target(body: Node2D) -> void:
	body.take_damage(damage)

func on_destroyed() -> void:
	#This function can be overrided to add custom destruction effects per enemy subclass.
	explode()

func explode() -> void:
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	explosion.emitting = true
	explosion.lifetime = randf_range(0.5, 0.7)
	get_tree().root.get_node("Game").add_child(explosion)

func _on_timer_timeout() -> void:
	on_destroyed()
	queue_free()
	print("Removed bullet")
