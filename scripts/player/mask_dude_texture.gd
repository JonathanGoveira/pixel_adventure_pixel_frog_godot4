extends Sprite2D

var double_jump: bool = false
@export var animation: AnimationPlayer = null
@export var mask_dude: CharacterBody2D = null
#
func animate(velocity: Vector2) -> void:
	flip(velocity.x)
	if double_jump:
		return
		
	if velocity.y != 0:
		vertical_move_behavior(velocity.y)
		return
	horizontal_move_behavior(velocity.x)
	double_jump = false
#	
func horizontal_move_behavior(direction: float) -> void:
	if (direction != 0):
		animation.play("run")
		return
	animation.play("idle")
#	
func vertical_move_behavior(direction: float) -> void:
	if (direction > 0):
		animation.play("fall")
	if (direction < 0):
		animation.play("jump")
#
func action_behavior(action: String) -> void:
	double_jump = true
	animation.play(action)
	
#
func flip(direction: float) -> void:
	if (direction > 0):
		flip_h = false
	if (direction < 0):
		flip_h = true


func on_animation_finished(animation_name: String):
	double_jump = false
	if animation_name == "hit":
		mask_dude.on_knockback = false
	if animation_name == "dead":
		hide()
		transition_scene.fade_in()
		#var _reload: bool = get_tree().reload_current_scene()
