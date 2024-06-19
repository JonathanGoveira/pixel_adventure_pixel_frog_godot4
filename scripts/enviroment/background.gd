extends ParallaxBackground

@onready var parallax_layer: ParallaxLayer = get_node("ParallaxLayer")
@onready var background_layer: TextureRect = get_node("ParallaxLayer/BackgroundLayer")

@export var direction: Vector2
@export var speed: float
var background_images_list: Array = [
	"res://assets/Pixel Adventure 1/Background/Blue.png",
	"res://assets/Pixel Adventure 1/Background/Brown.png",
	"res://assets/Pixel Adventure 1/Background/Gray.png",
	"res://assets/Pixel Adventure 1/Background/Green.png",
	"res://assets/Pixel Adventure 1/Background/Pink.png",
	"res://assets/Pixel Adventure 1/Background/Purple.png",
	"res://assets/Pixel Adventure 1/Background/Yellow.png",
]

func _ready() -> void:
	background_layer.texture = load(
		background_images_list[
			randi() % background_images_list.size()
		]
	)
func _physics_process(delta):
	parallax_layer.motion_offset += direction * delta * speed
