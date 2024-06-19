extends Area2D

@export var fruits: Array[Texture2D]
@export var fruit_effect_collected: PackedScene = null
@onready var sprite: Sprite2D = get_node("Texture")

var score_list: Array = [1,2,3,4,5,6,7,8]
var health_list: Array = [4,3,3,2,2,1,1,1]
var cure: int = 0
var score: int = 0

func _ready() -> void:
	randomize()
	var random_index = randi() % fruits.size()
	var random_fruit = fruits[random_index]
	sprite.texture = load(random_fruit.resource_path)
	score = score_list[random_index]
	cure = score_list[random_index]

func on_body_entered(body):
	if body.is_in_group("mask_dude"):
		body.update_score(score)
		body.update_health(Vector2.ZERO, cure, "increase")
		spaw_effect_fruit_collected()
		queue_free()
		
		
func spaw_effect_fruit_collected() -> void:
	var effect = fruit_effect_collected.instantiate()
	effect.global_position = global_position
	get_tree().root.call_deferred("add_child", effect)
