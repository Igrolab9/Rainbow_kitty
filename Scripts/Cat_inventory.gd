class_name Cat_Inventory
extends RefCounted

# Правильное написание — butterflies
signal butterflies_count_changed(new_count: int)
signal coin_count_changed(new_count: int)

var _butterflies_quantity: int = 0
var _coin_quantity: int = 0

func add_butterflies() -> void:
	_butterflies_quantity += 1
	butterflies_count_changed.emit(_butterflies_quantity)

func _add_coin() -> void:
	_coin_quantity += 1
	coin_count_changed.emit(_coin_quantity)

func get_quantity() -> int:
	return _butterflies_quantity

func get_coin_quantity() -> int:
	return _coin_quantity
