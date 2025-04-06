class_name LevelRoot
extends Node2D

signal player_died

@export var levels: Array[Level] = []

@export var current_level: Level
@export var dead_sound: AudioStreamPlayer

var index = 0
var death_zone: Area2D
var player: Player

var may_reset = false

func _ready():
    death_zone = current_level.death_zone
    player = current_level.player

func change_level(level_index: int) -> void:
    index = level_index
    current_level = levels[level_index]
    death_zone = current_level.death_zone
    player = current_level.player

func _process(_delta: float) -> void:
    if death_zone.overlaps_body(player):
        player_died.emit()

        if may_reset == false and dead_sound.playing == false:
            dead_sound.play()
            may_reset = true
