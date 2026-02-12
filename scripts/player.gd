extends Alive

class_name Player

var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var is_reloading = false
@onready var shooty_part = $ShootyPart


func _init(health: int = 100, spd: int = 200):
	super._init(health, spd)

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

func take_damage(amount: int) -> void:
	print("Took damage ", amount, "=", current_health)
	current_health -= amount
	
	if current_health <= 0:
		die.call_deferred()
	else:
		flash_red()

func die() -> void:
	if not is_reloading:
		is_reloading = true
		get_tree().reload_current_scene()
		
