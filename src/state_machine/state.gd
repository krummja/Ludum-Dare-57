class_name State
extends Node

signal finished(next_state_path: String, data: Dictionary)

@export var ui: Control

@onready var machine: StateMachine = (
    func get_state_machine() -> StateMachine:
        return get_parent()
).call()

func handle_input(_event: InputEvent) -> void:
    pass

func update(_delta: float) -> void:
    pass

func physics_update(_delta: float) -> void:
    pass

func enter(previous_state_path: String, data := {}) -> void:
    ui.show()

func exit() -> void:
    ui.hide()
