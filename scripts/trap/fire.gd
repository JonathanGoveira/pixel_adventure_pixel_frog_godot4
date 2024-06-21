extends StaticBody2D

@onready var animation: AnimationPlayer = $Animation
@onready var collision_shape = $Collision
@onready var hit_timer: Timer = $HitTimer
@onready var on_timer: Timer = $OnTimer
@onready var detection_area = $DetectionArea

var is_on = false

func _ready() -> void:
	animation.play("off")
	#detection_area.connect("body_entered", self, "on_detection_area_body_entered")
	#hit_timer.connect("timeout", self, "_on_hit_timeout")
	#on_timer.connect("timeout", self, "_on_on_timeout")

func on_detection_area_body_entered(body):
	if body.is_in_group("mask_dude"):
		print("mask dude colidiu")
		if is_body_above_trap(body):
			print("entrou aqui")
			hit()
		else:
			turn_on()

func is_body_above_trap(character):
	var trap_rect = collision_shape.shape.get_rect()
	trap_rect.position += global_position
	var character_rect = character.get_node("Collision").shape.get_rect()
	character_rect.position += character.global_position
	return character_rect.position.y + character_rect.size.y <= trap_rect.position.y

func hit():
	animation.play("hit")
	hit_timer.start(0.5) # Tempo da animação "Hit"

func turn_on():
	if not is_on:
		is_on = true
		animation.play("on")
		on_timer.start(1.0) # Tempo da animação "On"

func on_hit_timeout():
	animation.play("off")
	is_on = false

func on_on_timeout():
	animation.play("off")
	is_on = false

func on_animation_finished(anim_name: String) -> void:
	if anim_name == "hit" or anim_name == "on":
		animation.play("off")
