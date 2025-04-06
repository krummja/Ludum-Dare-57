class_name Player
extends CharacterBody2D

enum AnimationState {
    RUN,
    JUMP,
    IDLE,
    DEAD,
}

@export_group("Kinematics")
@export var speed = 1200
@export var jump_speed = -1800
@export var gravity = 4000

@export_group("Graphics")
@export var sprite: AnimatedSprite2D

@export_group("Audio")
@export var jump_sound: AudioStreamPlayer

var alive = true
var animation_state: AnimationState = AnimationState.IDLE

func _physics_process(delta: float) -> void:
    velocity.y += gravity * delta

    if alive:
        var h_input = Input.get_axis("walk_left", "walk_right")
        velocity.x = h_input * speed

        run_animations(h_input)

        if Input.is_action_just_pressed("jump") and is_on_floor():
            if jump_sound.playing == false:
                jump_sound.play()
            velocity.y = jump_speed

    move_and_slide()

func _process(_delta: float) -> void:
    match animation_state:
        AnimationState.IDLE:
            sprite.play("idle")
        AnimationState.RUN:
            sprite.play("run")
        AnimationState.JUMP:
            sprite.play("jump")
            if sprite.animation_finished:
                sprite.stop()

func run_animations(h_input: float) -> void:
    if h_input > 0:
        sprite.flip_h = false
    elif h_input < 0:
        sprite.flip_h = true

    if h_input > 0 and is_on_floor():
        animation_state = AnimationState.RUN
    elif h_input < 0 and is_on_floor():
        animation_state = AnimationState.RUN
    elif is_on_floor():
        animation_state = AnimationState.IDLE
    else:
        animation_state = AnimationState.JUMP

func kill() -> void:
    alive = false
    sprite.flip_v = true
