extends CharacterBody2D

@export var stats: Stats
@export var player: Node2D
var current_health: float
var knockback: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if not player or not stats:
		return
	if knockback != Vector2.ZERO:
		knockback = knockback.move_toward(Vector2.ZERO, stats.speed * 5.0 * delta)
		velocity = knockback
	elif player:
		# Normal movement towards the player
		var direction: Vector2 = global_position.direction_to(player.global_position)
		velocity = direction * stats.speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
func _ready():
	if stats:
		stats = stats.duplicate(true)
		current_health = stats.max_health
	if not player:
		player = get_tree().get_first_node_in_group("player") as Node2D

func take_damage(amount: float, knockback_force: Vector2) -> void:
	current_health -= amount
	knockback = knockback_force
	if current_health <= 0:
		queue_free() # Destroys only this specific enemy

func _on_boobrie_dmg_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var damage: float = 10.0
		var knockback_strength: float = 400.0
		
		var knockback_direction1: Vector2 = global_position.direction_to(body.global_position)
		var knockback_direction2: Vector2 = -global_position.direction_to(body.global_position)
		
		var knockback_vector1: Vector2 = knockback_direction1 * knockback_strength
		var knockback_vector2: Vector2 = knockback_direction2 * knockback_strength
		
		body.take_damage(damage, knockback_vector1)
		self.take_damage(damage, knockback_vector2)
