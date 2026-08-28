class_name ReLabel
extends ReColor

@export var L: Label
@export var text: String = "---"

func _ready() -> void:
	ReLabel(color,text)

func ReLabel(c:Color,t:String) -> void:
	if L != null && t != null:
		text = t
		L.text = t
	ReColor(c)
