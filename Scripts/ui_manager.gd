# ui_manager.gd
extends CanvasLayer

# --- Экспортируемые поля (настройка через Инспектор) ---
@export var player: CharacterBody2D
@export var font_size: int = 24  # Размер шрифта по умолчанию

@onready var _butterflies_label: Label = $Label
@onready var _coins_label: Label = $Label2

# Приватная ссылка на инвентарь
var _inventory: Cat_Inventory

func _ready() -> void:
	_apply_font_settings()
	
	if player and player.has_method("get_inventory"):
		_inventory = player.get_inventory()
		_inventory.butterflies_count_changed.connect(_on_butterflies_count_changed)
		_inventory.coin_count_changed.connect(_on_coins_count_changed)  # ← Добавлено
		
		# Начальное обновление UI
		_update_butterflies_label(_inventory.get_quantity())
		_update_coins_label(_inventory.get_coin_quantity())
	else:
		push_warning("Игрок не найден или не имеет метода get_inventory()")

func _on_butterflies_count_changed(new_count: int) -> void:
	_update_butterflies_label(new_count)

func _on_coins_count_changed(new_coins_count: int) -> void:
	_update_coins_label(new_coins_count)

func _update_butterflies_label(count: int) -> void:
	_butterflies_label.text = "🦋: %d" % count

func _update_coins_label(coins_count: int) -> void:
	_coins_label.text = "🪙: %d" % coins_count

# --- Приватные методы ---

func _apply_font_settings() -> void:
	# Применяем размер шрифта из экспортируемой переменной
	_butterflies_label.add_theme_font_size_override("font_size", font_size)
	_coins_label.add_theme_font_size_override("font_size", font_size)  # ← Добавлено
