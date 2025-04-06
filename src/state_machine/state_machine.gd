class_name StateMachine
extends Node

signal state_changed(previous: String, next: String)

@export var initial_state: State

@onready var state: State = (
    func get_initial_state() -> State:
        return initial_state if initial_state != null else get_child(0)
).call()

var states: Array[State]:
    get:
        var _children: Array[State] = []
        for _child_node: State in find_children("*", "State"):
            _children.append(_child_node)
        return _children

func connect_state_ui(_state_node: State, ui: Control) -> void:
    _state_node.ui = ui

func _ready() -> void:
    for _state_node in states:
        _state_node.finished.connect(_transition_to_next_state)

    await owner.ready
    state.enter("")

func _transition_to_next_state(target: String, data: Dictionary = {}) -> void:
    if not has_node(target):
        printerr(owner.name + ": Trying to transition to state " + target + " but it does not exist.")
        return

    var previous_state := state.name
    state.exit()
    state = get_node(target)
    state.enter(previous_state, data)

    state_changed.emit(previous_state, state.name)

func _unhandled_input(event: InputEvent) -> void:
    state.handle_input(event)

func _process(delta: float) -> void:
    state.update(delta)

func _physics_process(delta: float) -> void:
    state.physics_update(delta)
