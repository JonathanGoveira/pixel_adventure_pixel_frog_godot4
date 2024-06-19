extends CharacterBody2D

const  max_health: float = 25.0

@onready var sprite: Sprite2D = get_node("Texture")
@onready var stomp_area_collision: CollisionShape2D = get_node("StompArea/Collision")

@export var move_speed: float = 32.0
@export var gravity_speed: float = 128.0
@export var jump_speed: float = -64.0
@export var health: float = max_health
@export var damage: int = 5

var jump_count: int = 0
var knockback_direction: Vector2
var is_on_double_jump: bool = false
var on_knockback: bool = false
var is_dead: bool = false
var trap_effect: bool = false

func _physics_process(delta: float) -> void:
	if is_dead:
		return
		
	velocity.y += delta * gravity_speed
	if on_knockback:
		knockback_move()
		return
	# adicionar barra de vida aqui
	trampolim()
	move()
	var _move = move_and_slide()
	jump()
	sprite.animate(velocity)
	
func move() -> void:
	var direction: float = get_direction()
	velocity.x = direction * move_speed
	
func get_direction() -> float:
	return (Input.get_axis("walk_left", "walk_right"))

func jump() -> void:
	if is_on_floor():
		jump_count = 0
		is_on_double_jump = false
		stomp_area_collision.set_deferred("disabled", true)
	if Input.is_action_just_pressed("jump") and jump_count < 2:
		stomp_area_collision.set_deferred("disabled", false)
		velocity.y = jump_speed
		jump_count += 1
	if jump_count == 2 and not is_on_double_jump:
		sprite.action_behavior("double_jump")
		is_on_double_jump = true
		
func update_health(target_position: Vector2, value: int, damage_type: String) -> void:
	if is_dead:
		return
	
	if damage_type == "decrease":
		knockback_direction = (global_position - target_position).normalized()
		sprite.action_behavior("hit")
		on_knockback = true
		health = clamp(health - value, 0, max_health)
		if health == 0:
			is_dead = true
			sprite.action_behavior("dead")
		return
	if damage_type == "increase":
		health = clamp(health + value, 0, max_health)
		
func knockback_move() -> void:
	velocity = (knockback_direction * move_speed) * 0.75 
	var _move := move_and_slide()
	sprite.animate(velocity)
	
func trampolim() -> void:
	if trap_effect:
		velocity.y = -600
		trap_effect = false
		return

func on_stomp_area_body_entered(body) -> void:
	# mudar futuramente para causar dano nos inimigos,
	# e as traps irão ter outros efeitos ao pular em cima, como o fire ser um trampolim
	if body.is_in_group("inimigo"):
		#on_knockback = true
		trap_effect = true
		body.update_health(damage)
		#sprite.action_behavior("hit")
		
	
