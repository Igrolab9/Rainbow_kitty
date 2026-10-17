extends BaseCollectible
class_name ButterflyCollectible
signal butterfly_collected

const FLY_SPEED: float = 150.0
const WAVE_HEIGHT: float = 40.0
const WAVE_FREQUENCY: float = 3.0
const LEFT_BOUNDARY: float = 0.0
const RIGHT_BOUNDARY: float = 1150.0

@onready var _butterfly_animation: AnimatedSprite2D = $Butterfly_animattion

var _time_passed: float = 0.0
var _direction: int = 1
var _base_y: float = 0.0  # Запоминаем начальную Y

func _ready() -> void:
	_base_y = position.y  # Сохраняем позицию, заданную спавнером
	_butterfly_animation._play_butterfly_animation()

func _process(delta: float) -> void:
	_time_passed += delta * WAVE_FREQUENCY
	
	position.x += FLY_SPEED * _direction * delta
	
	# Колебания относительно начальной позиции
	position.y = _base_y + (sin(_time_passed) * WAVE_HEIGHT)
	
	if position.x > RIGHT_BOUNDARY:
		_direction = -1
		_butterfly_animation.scale.x = -1 
	elif position.x < LEFT_BOUNDARY:
		_direction = 1
		_butterfly_animation.scale.x = 1 

func collect() -> void:
	butterfly_collected.emit()
	queue_free()
