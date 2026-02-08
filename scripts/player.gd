extends Alive

class_name Player

var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var is_reloading = false
@onready var shooty_part = $ShootyPart

func _init(health: int = 100, spd: int = 200, dmg: int = 100.0):
	super._init(health, spd, dmg)

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	#========================== Movement ======================================
	velocity.x = Input.get_axis("left", "right") * speed
	velocity.y = Input.get_axis("up", "down") * speed
	velocity = lerp(get_real_velocity(), velocity, 0.1)
	
	#========================== Shooting =======================================
	if Input.is_action_just_pressed("shoot"):
		var bullet = bullet_scene.instantiate()
		bullet.global_position = shooty_part.global_position
		bullet.direction = (get_global_mouse_position() - global_position).normalized()
		$/root/Game.add_child(bullet)

	move_and_slide()

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
	
		if collision.get_collider().is_in_group("enemies"):
			if current_health > 0:
				take_damage(20)
				print(current_health)
			else:
				die()

func die() -> void:
	if not is_reloading:
		is_reloading = true
		get_tree().reload_current_scene()
		
