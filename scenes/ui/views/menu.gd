class_name MenuView
extends View

signal level_selected(level: LevelRoot.Levels)

@export var buttons: Dictionary[String, Button]

func _ready() -> void:
    for key in buttons:
        var button = buttons[key]
        var button_ident = "_".join(key.to_lower().split(" "))
        var listener = Callable(self, "on_%s_pressed" % button_ident)
        button.pressed.connect(listener)

func on_level_1_pressed() -> void:
    level_selected.emit(LevelRoot.Levels.LEVEL_1)

func on_level_2_pressed() -> void:
    level_selected.emit(LevelRoot.Levels.LEVEL_2)

func on_level_3_pressed() -> void:
    level_selected.emit(LevelRoot.Levels.LEVEL_3)

func on_level_4_pressed() -> void:
    level_selected.emit(LevelRoot.Levels.LEVEL_4)

func on_level_5_pressed() -> void:
    level_selected.emit(LevelRoot.Levels.LEVEL_5)

func on_level_6_pressed() -> void:
    level_selected.emit(LevelRoot.Levels.LEVEL_6)

func on_level_7_pressed() -> void:
    level_selected.emit(LevelRoot.Levels.LEVEL_7)

func on_level_8_pressed() -> void:
    level_selected.emit(LevelRoot.Levels.LEVEL_8)

func on_level_9_pressed() -> void:
    level_selected.emit(LevelRoot.Levels.LEVEL_9)
