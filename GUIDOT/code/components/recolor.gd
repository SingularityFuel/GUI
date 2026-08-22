class_name ReColor
extends Control

@export var color:Color = Color.DIM_GRAY

func _ready() -> void:
	ReColor(color)

func ReColor(c:Color) -> void:
	if c != null:
		color = c
		modulate = c
