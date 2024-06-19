extends Sprite2D

var on_action: bool = false

@export var animation: AnimationPlayer = null
@export var mask_dude: CharacterBody2D = null
@export var dust_particles: GPUParticles2D = null
#
func animate(velocity: Vector2) -> void:
	flip(velocity.x)
	if on_action:
		dust_particles.emitting = false
		return
		
	if velocity.y != 0:
		dust_particles.emitting = false
		vertical_move_behavior(velocity.y)
		return
	horizontal_move_behavior(velocity.x)
	on_action = false
#	
func horizontal_move_behavior(direction: float) -> void:
	if (direction != 0):
		animation.play("run")
		dust_particles.emitting = true
		return
	animation.play("idle")
	dust_particles.emitting = false
#	
func vertical_move_behavior(direction: float) -> void:
	if (direction > 0):
		animation.play("fall")
	if (direction < 0):
		animation.play("jump")	
#
func action_behavior(action: String) -> void:
	on_action = true
	animation.play(action)
	
#
func flip(direction: float) -> void:
	if (direction > 0):
		flip_h = false
	if (direction < 0):
		flip_h = true

func on_animation_finished(animation_name: String):
	on_action = false
	if animation_name == "hit":
		mask_dude.on_knockback = false
	if animation_name == "dead":
		hide()
		transition_scene.fade_in()
		#var _reload: bool = get_tree().reload_current_scene()
