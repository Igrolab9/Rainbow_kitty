extends CanvasLayer
class_name MainMenu

# Константа — путь к сцене уровня (без магических строк в коде)
const LEVEL_01_PATH: String = "res://Scenes/level_01.tscn"
const AUTHORS_PATH: String = "res://Scenes/authors_scene.tscn"

@onready var start_game_button: Button = $Start_button
@onready var authors_button: Button = $Authors_button

func _ready() -> void:
	# Подписка на сигнал кнопки
	start_game_button.pressed.connect(_on_start_game_pressed)
	authors_button.pressed.connect(_on_authors_pressed)

func _on_start_game_pressed() -> void:
	_change_scene(LEVEL_01_PATH)
	
func _on_authors_pressed() -> void:
	_change_scene(AUTHORS_PATH)

func _change_scene(scene_path: String) -> void:
	if not FileAccess.file_exists(scene_path):
		push_error("MainMenu: файл сцены не найден — %s" % scene_path)
		return
	
	var error: int = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("MainMenu: ошибка смены сцены, код %d" % error)
