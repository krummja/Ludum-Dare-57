class_name Playing
extends State

func handle_input(event: InputEvent) -> void:
    if event.is_action_pressed("reset"):
        if get_tree().paused:
            get_tree().paused = false
        get_tree().reload_current_scene()

    if event.is_action_pressed("pause"):
        get_tree().paused = true
        machine._transition_to_next_state(States.PAUSED)

func update(_delta: float) -> void:
    pass

func physics_update(_delta: float) -> void:
    pass
