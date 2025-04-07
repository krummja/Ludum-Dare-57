class_name Main
extends Node

@onready var level_root: LevelRoot = (
    func get_level_root() -> LevelRoot:
        return get_child(0)
).call()

@onready var ui: UI = (
    func get_ui() -> UI:
        return get_child(1)
).call()

func _ready() -> void:
    level_root.connect("player_died", _on_player_died)
    level_root.paused.connect(ui._on_pause)
    level_root.unpaused.connect(ui._on_unpause)
    ui.connect("level_selected", _on_level_selected)

func _on_player_died() -> void:
    level_root.current_scene.player.kill()

func _on_level_selected(level: LevelRoot.Levels) -> void:
    level_root.change_level(level)
