extends Alive

class_name Enemy

@export var bullet_scene: PackedScene #Assign Bullet Scene in inspector
@export var shoot_interval: float = 1.0 #For shooting enemies, seconds between each shot fired
@export var min_distance_from_player: float #Minimum distance to keep from the Player
@export var max_distance_from_player: float #Maximum distance to keep from the Player

@onready var shooty_part = $ShootyPart

var player: Node2D = null
var is_awake: bool = false # Enemies are asleep by default
var shoot_timer: Timer
var can_shoot: bool = true #Makes sure the Enemy fire interval and bullet instantiation are synced

#===================================

func _init(health: int = 100, spd: int = 50) -> void:
	super._init(health, spd)

func _ready() -> void:
	super._ready()
	#Remember to add new enemies to the "enemies" group
	player = get_tree().get_first_node_in_group("player")
	
	shoot_timer = Timer.new()
	shoot_timer.wait_time = shoot_interval
	shoot_timer.one_shot = false
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	add_child(shoot_timer)

func wake_up() -> void: #wake up wake up wake up wake up wake up kawe up wake up wake up
	is_awake = true
	shoot_timer.start()

func _physics_process(delta: float) -> void:
	if not is_awake or not player:
		return
	look_at(player.global_position)
	maintain_distance()
	
	if can_shoot:
		shoot()
	
	move_and_slide()

func maintain_distance() -> void:
	var direction = (player.global_position - global_position)
	var distance = direction.length()
	direction = direction.normalized()
	
	# Enemy too close, proceed to back away
	if distance < min_distance_from_player:
		velocity = -direction * speed
	elif distance > max_distance_from_player:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

func shoot() -> void:
	if not bullet_scene:
		return
	can_shoot = false
	
	var bullet = bullet_scene.instantiate()
	bullet.direction = (player.global_position - global_position).normalized()
	bullet.global_position = shooty_part.global_position
	
	get_tree().root.get_node("Game").add_child(bullet)

func chase_player(_delta: float) -> void:
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed


func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func die() -> void:
	shoot_timer.stop()
	super.die()
