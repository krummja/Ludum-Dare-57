extends Control

@export var player: Player

@export var speed_slider: HSlider
@export var jump_slider: HSlider
@export var gravity_slider: HSlider

var speed_label: Label
var jump_label: Label
var gravity_label: Label


func _ready() -> void:
    speed_slider.value = float(player.speed)
    jump_slider.value = float(player.jump_speed)
    gravity_slider.value = float(player.gravity)

    speed_slider.connect("value_changed", _on_speed_slider_changed)
    jump_slider.connect("value_changed", _on_jump_slider_changed)
    gravity_slider.connect("value_changed", _on_gravity_slider_changed)

    speed_label = speed_slider.get_parent().get_child(0)
    jump_label = jump_slider.get_parent().get_child(0)
    gravity_label = gravity_slider.get_parent().get_child(0)

    speed_label.text = str(speed_slider.value)
    jump_label.text = str(jump_slider.value)
    gravity_label.text = str(gravity_slider.value)


func _on_speed_slider_changed(value: float) -> void:
    player.speed = value
    speed_label.text = str(value)


func _on_jump_slider_changed(value: float) -> void:
    player.jump_speed = -value
    jump_label.text = str(value)


func _on_gravity_slider_changed(value: float) -> void:
    player.gravity = value
    gravity_label.text = str(value)
