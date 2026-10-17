extends Node2D
class_name CoinSpawner


@export var coin_scene: PackedScene
@export var cat_player: CharacterBody2D
@export var spawn_offset_x: float = 500.0
@export var coin_count_per_spawn: int = 5 # ← сколько монеток падает за раз
@export var BUTTERFLIES_THRESHOLD: int = 5 # ← сколько бабочек надо собрать

var _last_spawned_at: int = 0

func _ready() -> void:
	if coin_scene == null:
		push_error("CoinSpawner: не назначена coin_scene")
		return
	
	if cat_player == null:
		push_error("CoinSpawner: не назначен cat_player")
		return
	
	if coin_count_per_spawn < 1:
		push_warning("CoinSpawner: coin_count_per_spawn должен быть >= 1, установлено 1")
		coin_count_per_spawn = 1
	
	var inventory: Cat_Inventory = cat_player.get_inventory()
	inventory.butterflies_count_changed.connect(_on_butterflies_count_changed)

func _on_butterflies_count_changed(new_count: int) -> void:
	if new_count >= _last_spawned_at + BUTTERFLIES_THRESHOLD:
		_last_spawned_at = _last_spawned_at + BUTTERFLIES_THRESHOLD
		call_deferred("_spawn_coins")

func _spawn_coins() -> void:
	for _i in coin_count_per_spawn:
		var coin: Node2D = coin_scene.instantiate()
		coin.global_position = _calculate_random_position()
		get_parent().add_child(coin)

func _calculate_random_position() -> Vector2:
	var random_x: float = randf_range(-spawn_offset_x, spawn_offset_x)
	return Vector2(global_position.x + random_x, global_position.y)
