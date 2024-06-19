extends CanvasLayer

# emissão de sinal para chamar telas de transições como cutscenes
signal start_level

@onready var animation: AnimationPlayer = get_node("Animation")

var scene_path: String

func fade_in() -> void:
	animation.play("fade_in")

func on_animation_animation_finished(anim_name):
	if anim_name == "fade_in":
		var _change_scene: bool = get_tree().change_scene_to_file(str(scene_path))
		animation.play("fade_out")
	# emitindo o sinal na saída da cena para a próxima cena
	if anim_name == "fade_out":
		emit_signal("start_level")
