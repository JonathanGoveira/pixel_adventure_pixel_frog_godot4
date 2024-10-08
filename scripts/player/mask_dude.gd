extends CharacterBody2D

@onready var sprite: Sprite2D = get_node("Texture")
@onready var stomp_area_collision: CollisionShape2D = get_node("StompArea/Collision")

@export var move_speed: float = 32.0
@export var gravity_speed: float = 128.0
@export var jump_speed: float = -64.0
@export var damage: int = 5

var jump_count: int = 0
var total_score: int = 0
var knockback_direction: Vector2
var is_on_double_jump: bool = false
var on_knockback: bool = false
var is_dead: bool = false

func _physics_process(delta: float) -> void:
	if is_dead:
		return
		
	velocity.y += delta * gravity_speed
	if on_knockback:
		knockback_move()
		return
		
	move()
	move_and_slide()
	jump()
	sprite.animate(velocity)

func move() -> void:
	var direction: float = get_direction()
	velocity.x = direction * move_speed
	
func get_direction() -> float:
	return Input.get_axis("walk_left", "walk_right")

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

func knockback_move() -> void:
	velocity = (knockback_direction * move_speed) * 0.75
	move_and_slide()
	sprite.animate(velocity)

func on_stomp_area_body_entered(body) -> void:
	if body.is_in_group("trap"):
		#if body.turn_on():
		#	body.turn_on()
		#var trap = body
		#trap.fire(self)
		return
		#trap.activate_hit()

func update_score(score: int):
	total_score += score
	get_tree().call_group("interface", "update_score", total_score)
