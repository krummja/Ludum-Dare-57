class_name Paused
extends State

func handle_input(event: InputEvent) -> void:
    if event.is_action_pressed("pause"):
        get_tree().paused = false
        machine._transition_to_next_state(States.PLAYING)

func update(_delta: float) -> void:
    pass

func physics_update(_delta: float) -> void:
    pass
