extends CanvasLayer
class_name Authors_scene

# Константа — путь к сцене уровня (без магических строк в коде)
const MAIN_MENU_PATH: String = "res://Scenes/main_menu.tscn"

@onready var back_button: Button = $Button

func _ready() -> void:
	# Подписка на сигнал кнопки
	back_button.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	_change_scene(MAIN_MENU_PATH)

func _change_scene(scene_path: String) -> void:
	if not FileAccess.file_exists(scene_path):
		push_error("MainMenu: файл сцены не найден — %s" % scene_path)
		return
	
	var error: int = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("MainMenu: ошибка смены сцены, код %d" % error)
