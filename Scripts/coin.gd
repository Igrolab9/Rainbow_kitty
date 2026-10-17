extends BaseCollectible

class_name CoinCollectible

const GRAVITY: float = 400.0
const GROUND_Y: float = 500.0
const LIFETIME: float = 3.0  # ← время жизни монетки

@onready var _coin_animation: AnimatedSprite2D = $AnimatedSprite2D

var _velocity: Vector2 = Vector2.ZERO

signal coin_collected

func _ready() -> void:
	_coin_animation.play()
	_start_lifetime()

func _physics_process(delta: float) -> void:
	if position.y >= GROUND_Y:
		position.y = GROUND_Y
		return

	_velocity.y += GRAVITY * delta
	position += _velocity * delta

func collect() -> void:
	coin_collected.emit()
	queue_free()

func _start_lifetime() -> void:
	await get_tree().create_timer(LIFETIME).timeout
	# Если монетку уже собрали — её нет в дереве, ничего не делаем
	if is_inside_tree():
		queue_free()
