extends Node2D

@onready var player: CharacterBody2D = get_node("MaskDude")
@onready var interface: CanvasLayer = get_node("Interface")
@export var scene_path: String
#@export var scene: PackedScene = null
# este código exemplifica a adição de cenas de transição como cutscenes
func _ready() -> void:
#	interface.update_health(player.max_health)
	transition_scene.scene_path = scene_path
	
	transition_scene.connect(
		"start_level", Callable(self, "start_level")
	)

func start_level() -> void:
	# add tela de transição entre as cenas
	#print(scene.resource_path)
	pass
