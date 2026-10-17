extends CharacterBody2D

# Константы вместо магических чисел
const SPEED: float = 300.0
const JUMP_VELOCITY: float = -700.0

@onready var _cat_animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var _pickup_area: Area2D = $PickupArea

@onready var _idle_sound: AudioStreamPlayer2D = $Idle_sound
@onready var _jump_sound: AudioStreamPlayer2D = $Jump_sound
@onready var _coin_sound: AudioStreamPlayer2D = $Coin_sound

var _inventory: Cat_Inventory

func _ready() -> void:
	_cat_animations.play("Idle")
	_idle_sound.play()
	# Инициализация RefCounted компонентов
	_inventory = Cat_Inventory.new()
	
	# Подписка на зону подбора
	_pickup_area.area_entered.connect(_on_pickup_area_area_entered)

func _on_pickup_area_area_entered(area: Area2D) -> void:
	if area is CoinCollectible:
		var coin := area as CoinCollectible
		coin.coin_collected.connect(_inventory._add_coin)
		coin.collect()
		_coin_sound.play()
	elif area is ButterflyCollectible:
		var butterfly := area as ButterflyCollectible
		butterfly.butterfly_collected.connect(_inventory.add_butterflies)
		butterfly.collect()

func _physics_process(delta: float) -> void:
	_handle_jump_input()
	_handle_movement_input()
	_handle_sprite_flip()
	_apply_gravity(delta)
	
	move_and_slide()

func _handle_movement_input() -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			_cat_animations._play_walk_animation()
			_idle_sound.stop()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			_cat_animations._play_idle_animation()
			if not _idle_sound.playing:
				_idle_sound.play()

func _handle_jump_input() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		_cat_animations._play_jump_animation()
		_jump_sound.play()
		_idle_sound.stop()

func _handle_sprite_flip() -> void:
	if velocity.x < 0:
		_cat_animations.scale.x = -1
	elif velocity.x > 0:
		_cat_animations.scale.x = 1

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		if not Input.is_action_just_pressed("ui_accept"):
			if _cat_animations.animation != "Jump":
				_cat_animations._play_jump_animation()

func _on_butterflies_count_changed(new_count: int) -> void:
	print("Бабочек собрано: ", new_count)
	
func _on_coins_count_changed(new_count: int) -> void:
	print("Монеток собрано: ", new_count)

func get_crystal_quantity() -> int:
	return _inventory.get_quantity()
	
func get_coin_quantity() -> int:
	return _inventory.get_coin_quantity()
	
func get_inventory() -> Cat_Inventory:
	return _inventory
