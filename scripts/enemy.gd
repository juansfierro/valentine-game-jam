extends Alive

class_name Enemy

var bullet_scene = preload("res://scenes/bullet.tscn")
var player: Node2D = null

func _init(health: float = 100.0, spd: float = 50.0, dmg: float = 10.0) -> void:
	super._init(health, spd, dmg)

func _ready() -> void:
	current_health = max_health
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(delta: float) -> void:
	if player:
		chase_player(delta)
	move_and_slide()
	
func chase_player(_delta: float) -> void:
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed

#func shoot() -> void:
	#var bullet = bullet_scene.instantiate()
	#bullet.global_position = global_position
	#bullet.direction = player.global_position
	#$/root/Game.add_child(bullet)
