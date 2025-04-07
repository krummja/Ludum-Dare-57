class_name UI
extends Node


@export_group("Dependencies")
@export var level_root: Node2D

@export_group("Overlays")
@export var menu: MenuView
@export var playing: PlayingView
@export var paused: PausedView

signal level_selected(level: LevelRoot.Levels)
signal quit_requested
signal debug_toggled

var views: Dictionary[String, View]:
    get:
        return {
            States.MENU: menu,
            States.PLAYING: playing,
            States.PAUSED: paused,
        }

func _ready() -> void:
    menu.ui_context = self
    playing.ui_context = self
    paused.ui_context = self

    var echo_level_select = func (level: LevelRoot.Levels) -> void:
        level_selected.emit(level)
        menu.hide()
    menu.level_selected.connect(echo_level_select)

    quit_requested.connect(_on_quit_requested)
    debug_toggled.connect(_on_debug_toggled)

func _hide_all() -> void:
    menu.hide()
    playing.hide()
    paused.hide()

func _on_pause() -> void:
    paused._on_pause()

func _on_unpause() -> void:
    paused._on_unpause()

func _on_debug_toggled() -> void:
    level_root.toggle_debug()

func _on_quit_requested() -> void:
    playing.hide()
    paused.hide()
    menu.show()
    level_root.on_quit_requested()
