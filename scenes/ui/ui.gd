class_name UI
extends Node

@export_group("Dependencies")
@export var state_machine: StateMachine
@export var level_root: Node2D

@export_group("Overlays")
@export var boot: View
@export var splash: View
@export var menu: View
@export var playing: View
@export var paused: View
@export var win: View
@export var lose: View

var views: Dictionary[String, View]:
    get:
        return {
            States.BOOT: boot,
            States.SPLASH: splash,
            States.MENU: menu,
            States.PLAYING: playing,
            States.PAUSED: paused,
            States.WIN: win,
            States.LOSE: lose,
        }

func _ready() -> void:
    state_machine.state_changed.connect(_on_state_changed)
    boot.ui_context = self
    splash.ui_context = self
    menu.ui_context = self
    playing.ui_context = self
    paused.ui_context = self
    win.ui_context = self
    lose.ui_context = self

func _on_state_changed(_previous: String, next: String) -> void:
    match next:
        States.BOOT:
            _hide_all()
            boot.show()
        States.SPLASH:
            _hide_all()
            splash.show()
        States.MENU:
            _hide_all()
            menu.show()
        States.PLAYING:
            _hide_all()
            playing.show()
        States.PAUSED:
            paused.show()
        States.WIN:
            win.show()
        States.LOSE:
            lose.show()

func _hide_all() -> void:
    boot.hide()
    splash.hide()
    menu.hide()
    playing.hide()
    paused.hide()
    win.hide()
    lose.hide()
