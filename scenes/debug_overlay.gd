class_name DebugOverlay
extends Node2D

@export var line: Line2D

var player: Player


func _process(_delta: float) -> void:
    if visible or player != null:
        line.set_point_position(1, player.debug_target.global_position - line.position)
