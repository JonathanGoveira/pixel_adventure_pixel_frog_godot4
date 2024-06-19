extends CanvasLayer

@onready var score: Label = get_node("Score")
@onready var health: Label = get_node("Health")

func _ready() -> void:
	score.text = 'Score 0'

func update_health(value: int) -> void:
	health.text = str(value) + " health"
	
func update_score(value: int) -> void:
	score.text = "Score " + str(value)
