extends Node2D

@export var scene_path: String
# este código exemplifica a adição de cenas de transição como cutscenes
func _ready() -> void:
	transition_scene.scene_path = scene_path
	transition_scene.connect(
		"start_level", Callable(self, "start_level")
	)

func start_level() -> void:
	pass
