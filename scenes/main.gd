class_name Main
extends Node

@onready var state_machine: StateMachine = (
    func get_state_machine() -> StateMachine:
        return get_child(0)
).call()

@onready var level_root: LevelRoot = (
    func get_level_root() -> LevelRoot:
        return get_child(1)
).call()

@onready var ui: UI = (
    func get_ui() -> UI:
        return get_child(2)
).call()

func _ready() -> void:
    for state_node: State in state_machine.states:
        state_machine.connect_state_ui(state_node, ui.views[state_node.name])
    level_root.connect("player_died", _on_player_died)

func _on_player_died() -> void:
    level_root.current_level.player.kill()
