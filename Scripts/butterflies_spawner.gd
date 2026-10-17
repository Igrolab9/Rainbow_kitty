# butterflies_spawner.gd
extends Node2D

const MIN_SPAWN_INTERVAL: float = 0.5
const MAX_SPAWN_INTERVAL: float = 3.0
const Y_OFFSET_RANGE: float = 50.0  # Диапазон случайного смещения по Y

@export var Butterflies_scene: Array[PackedScene]

var _spawn_timer: float = 0.0
var _next_spawn_time: float = 0.0

func _ready() -> void:
	_validate_scenes()
	_schedule_next_spawn()

func _process(delta: float) -> void:
	_spawn_timer += delta
	
	if _spawn_timer >= _next_spawn_time:
		_spawn_butterfly()
		_schedule_next_spawn()

func _spawn_butterfly() -> void:
	if Butterflies_scene.is_empty():
		push_warning("Массив Butterflies_scene пуст!")
		return
	
	var random_scene: PackedScene = Butterflies_scene.pick_random()
	var butterfly: Node2D = random_scene.instantiate()
	
	# Случайное смещение по Y в диапазоне ±15 единиц
	var random_y_offset: float = randf_range(-Y_OFFSET_RANGE, Y_OFFSET_RANGE)
	
	# Спавн в позиции спавнера со случайным смещением по высоте
	butterfly.global_position = Vector2(
		global_position.x,
		global_position.y + random_y_offset
	)
	
	add_child(butterfly)

func _schedule_next_spawn() -> void:
	_next_spawn_time = randf_range(MIN_SPAWN_INTERVAL, MAX_SPAWN_INTERVAL)
	_spawn_timer = 0.0

func _validate_scenes() -> void:
	if Butterflies_scene.is_empty():
		push_error("Добавь сцены бабочек в массив Butterflies_scene!")
