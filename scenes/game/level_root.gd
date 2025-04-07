class_name LevelRoot
extends Node2D

enum Levels {
    LEVEL_1,
    LEVEL_2,
    LEVEL_3,
    LEVEL_4,
    LEVEL_5,
    LEVEL_6,
    LEVEL_7,
    LEVEL_8,
    LEVEL_9,
    LEVEL_END,
}

signal player_won(level_number: int)
signal player_died
signal paused
signal unpaused

@export var levels: Array[PackedScene] = []
@export var dead_sound: AudioStreamPlayer
@export var win_sound: AudioStreamPlayer
@export var ending: Sprite2D
@export var debug: DebugOverlay
@export var current_level: Levels = Levels.LEVEL_1

var death_zone: Area2D
var exit: Area2D
var player: Player

var playing = false
var dead_sound_finished = false
var win_sound_finished = false
var may_continue = false
var current_scene: Level

func _ready():
    ending.hide()
    change_level(current_level)
    current_scene.process_mode = Node.PROCESS_MODE_DISABLED
    current_scene.hide()
    playing = false
    player_won.connect(on_player_won)

func change_level(level_index: Levels) -> void:
    dead_sound_finished = false
    playing = true
    var previous_scene = current_scene

    current_level = level_index

    var next_scene = levels[level_index].instantiate() as Level
    add_child(next_scene)
    current_scene = next_scene

    if previous_scene != null:
        previous_scene.queue_free()

    if current_scene.process_mode == Node.PROCESS_MODE_DISABLED:
        current_scene.process_mode = Node.PROCESS_MODE_PAUSABLE

    debug.player = current_scene.player
    death_zone = current_scene.death_zone
    exit = current_scene.exit
    player = current_scene.player

func _process(_delta: float) -> void:
    if !playing:
        return

    if death_zone.overlaps_body(player) and current_level != Levels.LEVEL_END:
        player_died.emit()

        if !dead_sound_finished and !dead_sound.playing:
            dead_sound.play()
            dead_sound_finished = true

    elif death_zone.overlaps_body(player) and current_level == Levels.LEVEL_END:
        ending.show()

        if !win_sound_finished and !win_sound.playing:
            win_sound.play()
            win_sound_finished = true

    if exit.overlaps_body(player):
        player_won.emit()

        if !win_sound_finished and !win_sound.playing:
            win_sound.play()
            win_sound_finished = true

func _input(event: InputEvent) -> void:
    if !playing:
        return

    if event.is_action_pressed("reset"):
        current_scene.queue_free()
        change_level(current_level)

    if event.is_action_pressed("pause"):

        if current_scene.process_mode == Node.PROCESS_MODE_DISABLED:
            current_scene.process_mode = Node.PROCESS_MODE_PAUSABLE
            unpaused.emit()
        else:
            paused.emit()
            current_scene.process_mode = Node.PROCESS_MODE_DISABLED

func on_player_won() -> void:
    if current_level < len(levels):
        win_sound_finished = false
        change_level(current_level + 1)
    else:
        change_level(Levels.LEVEL_END)

func toggle_debug() -> void:
    if !debug.visible:
        debug.show()
    else:
        debug.hide()

func on_quit_requested() -> void:
    debug.hide()
    playing = false
    remove_child(current_scene)
    current_scene.queue_free()
