extends StaticBody2D

@onready var state_timer: Timer = get_node("StateTimer")
@onready var animation: AnimationPlayer = get_node("Animation")

@export var damage: int

var current_state: String = "off"
var is_invincible: bool = false

func on_state_timer_timeout():
	state_timer.start()
	if current_state == "off":
		current_state = "on"
		is_invincible = true
		animation.play(current_state)
		return
	if current_state == "on":
		current_state = "off"
		is_invincible = false
		animation.play(current_state)
		return


func on_detection_area_body_entered(body) -> void:
	if body.is_in_group("mask_dude"):
		body.update_health(global_position, damage, "decrease")
		
func update_health(value: int) -> void:
	if is_invincible:
		return
	print("dano: ",str(value))
