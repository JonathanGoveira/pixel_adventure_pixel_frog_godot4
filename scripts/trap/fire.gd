extends StaticBody2D

const max_health: int = 25
@onready var state_timer: Timer = get_node("StateTimer")
@onready var animation: AnimationPlayer = get_node("Animation")

@export var damage: int = 0
@export var health: int = 15

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
	if is_invincible: # verifica se a trap está invencivel
		return # return para sair da função e não executar os processos abaixo
	
	health = clamp(health - value, 0, max_health) # atualiza a vida entre os valores 0 e max_health
	
	if health == 0: # verifica se a vida é igual a 0
	
		state_timer.stop() # para o timer para não haver mais transições de animação
		current_state = "off" # seta a animação para off
		animation.play(current_state) # atualiza a animação
		return # return para sair da função
		
	animation.play("hit"); # atualiza a animação para o hit caso a trap tenha tomado um hit
	

func on_animation_finished(anim_name: String) -> void:
	if anim_name == "hit":
		animation.play(current_state)
