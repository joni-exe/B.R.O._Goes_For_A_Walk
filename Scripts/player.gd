extends CharacterBody2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var attack_area: Area2D = $Area2D
@onready var cooldown_timer: Timer = $Timer

#@onready var attack_texture: Sprite2D = $TowerMecha2

var knockback: Vector2 = Vector2.ZERO

func _ready() -> void:
	attack_area.monitoring = false
	#attack_texture.visible = false
	

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * PlayerData.stats.speed
	if knockback != Vector2.ZERO:
		knockback = knockback.move_toward(Vector2.ZERO, PlayerData.stats.speed * 5.0 * delta)
		velocity = knockback
	else:
		velocity = direction * PlayerData.stats.speed

	move_and_slide()

func take_damage(amount: float, knockback_force: Vector2) -> void:
	PlayerData.stats.max_health -= amount
	knockback = knockback_force
	if PlayerData.stats.max_health <= 0:
		queue_free() 

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack") && cooldown_timer.is_stopped():
		perform_attack()
		var overlapping_bodies = attack_area.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body.has_method("take_damage") and !body.is_in_group("player"):
				var knockback_direction = global_position.direction_to(body.global_position)
				var knockback_strength = 400.0
				body.take_damage(PlayerData.attack_damage, knockback_direction * knockback_strength)
		cooldown_timer.start(PlayerData.attack_cooldown)
func perform_attack():
	animation.play("attack")
	
	

func _player_attack_area_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player"):
		var knockback_direction = global_position.direction_to(body.global_position)
		var knockback_strength = 400.0
		body.take_damage(50.0, knockback_direction * knockback_strength)
