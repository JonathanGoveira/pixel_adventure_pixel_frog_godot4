extends StaticBody2D

@onready var animation: AnimationPlayer = $Animation
@onready var collision_shape = $Collision
@onready var detection_area = $DetectionArea
@onready var timer_on: Timer = get_node("TimerOn")
@onready var timer_off: Timer = get_node("TimerOff")

var current_state: String = 'off'
var is_on: bool = false

func _ready() -> void:
	animation.play("off")

func on_detection_area_body_entered(body):
	print(body.name)
	if body.is_in_group("mask_dude"):
		if not is_body_above_trap(body) and current_state == "off":
			hit()
		
func on_fire_area_body_entered(body):
	if body.is_in_group("mask_dude"):
		if not is_body_above_trap(body) and current_state == "on":
			print("Player tomou dano")
			body.sprite.action_behavior("dead")
			
func is_body_above_trap(character):
	var trap_rect = collision_shape.shape.get_rect()
	trap_rect.position += global_position
	var character_rect = character.get_node("Collision").shape.get_rect()
	character_rect.position += character.global_position
	var colider_above_trap = character_rect.position.y >= trap_rect.position.y and character_rect.position.y <= trap_rect.position.y + trap_rect.size.y
	#print(character_rect.position.y + character_rect.size.y <= trap_rect.position.y)
	#print(not character_rect.position.y >= trap_rect.position.y and character_rect.position.y <= trap_rect.position.y + trap_rect.size.y)
	return colider_above_trap

# chama a animação de hit
func hit():
	animation.play("hit")
	is_on = true # coloca a armadilha para poder ser acionada no estado on
	
# função que verifica se uma animação acabou
# só funciona para animações que não estão em loop
func on_animation_finished(anim_name: String) -> void:
	if anim_name == "hit" and is_on: # verifica se a animção de hit acabou juntamente se a variavel is_on está ativa, ou seja se a armadilha pode ser ativada
		timer_on.start() # aciona o sinal timer_on

		
# função ligada a um sinal de timoeut configurada como oneshot
func on_timer_off_timeout(): # função para o timeout de off
	if current_state == "on": # verifica se o estado atual da animação é on
		current_state = "off" # muda a variavel de estado atual da animação para off
		animation.play(current_state) # troca a animação atual para off
		is_on = false # coloca a varivavel is_on para false para não ligar a animção on novamente

# função ligada a um sinal de timoeut configurada como oneshot
func on_timer_on_timeout(): # função para o timeout de on
	if current_state == "off": # verifica se o estuado atual da animação é off
		current_state = "on" # muda a variavel de estado atual para on
		animation.play(current_state) # troca a animação para on
		timer_off.start() # aciona o sinal timer_off

