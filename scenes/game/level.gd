class_name Level
extends Node2D

enum Layers {
    LAYER_1,
    LAYER_2,
    LAYER_3,
}

@export_group("Dependencies")
@export var player: CharacterBody2D
@export var death_zone: Area2D
@export var exit: Area2D

@export_group("Layers")
@export var layer_1: CanvasGroup
@export var layer_2: CanvasGroup
@export var layer_3: CanvasGroup

@export_group("Transitions")
@export var lerp_speed: float = 0.2

@export_group("Sounds")
@export var zoom: AudioStreamPlayer

var ui_view: PlayingView

var tiles_1: TileMapLayer
var tiles_2: TileMapLayer
var tiles_3: TileMapLayer

var current_layer_index: int = 1
var lerp_time: float = 0.0
var switching_layer: bool = false

func _ready() -> void:
    tiles_1 = layer_1.get_child(0)
    tiles_2 = layer_2.get_child(0)
    tiles_3 = layer_3.get_child(0)

    _set_layer(_layer_for_index(current_layer_index))
    _switch_collision_layer(_layer_for_index(current_layer_index))

func _process(delta: float) -> void:
    if switching_layer:
        _switch_layer(_layer_for_index(current_layer_index), delta)

        if lerp_time > lerp_speed:
            switching_layer = false
            lerp_time = 0.0

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("switch_layer_back"):
        current_layer_index = min(max(0, current_layer_index - 1), 2)
        switching_layer = true

    if event.is_action_pressed("switch_layer_forward"):
        current_layer_index = min(max(0, current_layer_index + 1), 2)
        switching_layer = true

    _switch_collision_layer(_layer_for_index(current_layer_index))

func _set_layer(layer: Layers) -> void:
    if ui_view == null:
        var main = get_tree().root.get_child(0)
        var ui_node = main.get_child(2)
        ui_view = ui_node.playing

    match layer:
        Layers.LAYER_1:
            ui_view.focus_label.text = "Focus: Far  "
            _transition_modulate(layer_1, Color(1.0, 1.0, 1.0))
            _transition_modulate(layer_2, Color(0.8, 0.8, 0.8))
            _transition_modulate(layer_3, Color(0.5, 0.5, 0.5))
            _transition_blur(layer_1, 0.0)
            _transition_blur(layer_2, 5.0)
            _transition_blur(layer_3, 10.0)
            player.z_index = 0
        Layers.LAYER_2:
            ui_view.focus_label.text = "Focus: Mid  "
            _transition_modulate(layer_1, Color(0.8, 0.8, 0.8))
            _transition_modulate(layer_2, Color(1.0, 1.0, 1.0))
            _transition_modulate(layer_3, Color(0.8, 0.8, 0.8))
            _transition_blur(layer_1, 5.0)
            _transition_blur(layer_2, 0.0)
            _transition_blur(layer_3, 5.0)
            player.z_index = 1
        Layers.LAYER_3:
            ui_view.focus_label.text = "Focus: Close"
            _transition_modulate(layer_1, Color(0.5, 0.5, 0.5))
            _transition_modulate(layer_2, Color(0.8, 0.8, 0.8))
            _transition_modulate(layer_3, Color(1.0, 1.0, 1.0))
            _transition_blur(layer_1, 10.0)
            _transition_blur(layer_2, 5.0)
            _transition_blur(layer_3, 0.0)
            player.z_index = 2

func _switch_layer(layer: Layers, time: float) -> void:
    lerp_time += time
    zoom.play()

    match layer:
        Layers.LAYER_1:
            ui_view.focus_label.text = "Focus: Far  "
            _transition_modulate(layer_1, Color(1.0, 1.0, 1.0), lerp_time)
            _transition_modulate(layer_2, Color(0.8, 0.8, 0.8), lerp_time)
            _transition_modulate(layer_3, Color(0.5, 0.5, 0.5), lerp_time)
            _transition_blur(layer_1, 0.0, lerp_time)
            _transition_blur(layer_2, 5.0, lerp_time)
            _transition_blur(layer_3, 10.0, lerp_time)
            player.z_index = 0
        Layers.LAYER_2:
            ui_view.focus_label.text = "Focus: Mid  "
            _transition_modulate(layer_1, Color(0.8, 0.8, 0.8), lerp_time)
            _transition_modulate(layer_2, Color(1.0, 1.0, 1.0), lerp_time)
            _transition_modulate(layer_3, Color(0.8, 0.8, 0.8), lerp_time)
            _transition_blur(layer_1, 5.0, lerp_time)
            _transition_blur(layer_2, 0.0, lerp_time)
            _transition_blur(layer_3, 5.0, lerp_time)
            player.z_index = 1
        Layers.LAYER_3:
            ui_view.focus_label.text = "Focus: Close"
            _transition_modulate(layer_1, Color(0.5, 0.5, 0.5), lerp_time)
            _transition_modulate(layer_2, Color(0.8, 0.8, 0.8), lerp_time)
            _transition_modulate(layer_3, Color(1.0, 1.0, 1.0), lerp_time)
            _transition_blur(layer_1, 10.0, lerp_time)
            _transition_blur(layer_2, 5.0, lerp_time)
            _transition_blur(layer_3, 0.0, lerp_time)
            player.z_index = 2

func _switch_collision_layer(layer: Layers) -> void:
    match layer:
        Layers.LAYER_1:
            tiles_1.set_collision_enabled(true)
            tiles_2.set_collision_enabled(false)
            tiles_3.set_collision_enabled(false)
        Layers.LAYER_2:
            tiles_1.set_collision_enabled(false)
            tiles_2.set_collision_enabled(true)
            tiles_3.set_collision_enabled(false)
        Layers.LAYER_3:
            tiles_1.set_collision_enabled(false)
            tiles_2.set_collision_enabled(false)
            tiles_3.set_collision_enabled(true)

func _layer_for_index(index: int) -> Layers:
    return [
        Layers.LAYER_1,
        Layers.LAYER_2,
        Layers.LAYER_3,
    ][index]

func _transition_modulate(layer: CanvasGroup, target: Color, time: float = -1.0) -> void:
    var new_color: Color
    var current_color = layer.get_child(0).modulate

    if time == -1.0:
        new_color = target
    else:
        new_color = Utils.lerp_color(current_color, target, time)
        if time >= lerp_speed and new_color != target:
            new_color = target

    layer.get_child(0).modulate = new_color

func _transition_blur(layer: CanvasGroup, target: float, time: float = -1.0) -> void:
    var new_blur: float
    var current_blur = layer.material.get("shader_parameter/strength")

    if time == -1.0:
        new_blur = target
    else:
        new_blur = Utils.lerp_float(current_blur, target, time)
        if time >= lerp_speed and new_blur != target:
            new_blur = target

    layer.material.set("shader_parameter/strength", new_blur)

func _on_option_button_item_selected(index: int) -> void:
    _set_layer(index)
    _switch_collision_layer(index)
