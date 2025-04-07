class_name PausedView
extends View

@export var quit_button: Button
@export var debug_button: Button

func _ready() -> void:
    quit_button.pressed.connect(_on_quit)
    debug_button.pressed.connect(_on_debug)

func _on_pause() -> void:
    show()

func _on_unpause() -> void:
    hide()

func _on_debug() -> void:
    ui_context.debug_toggled.emit()

func _on_quit() -> void:
    ui_context.quit_requested.emit()
