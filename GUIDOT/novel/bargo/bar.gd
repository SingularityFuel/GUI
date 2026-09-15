extends HBoxContainer

@export var Refs: Array[Label]
var Txts: Array[String]
var Cols: Array[Color]

func _ready() -> void:
	Init() # populate txts, cols from referenced labels
	Refresh() # no-op if working, early bug alarm if not

func Init() -> void:
	Txts = []
	Cols = []
	for l in Refs:
		Txts.append(l.text)
		Cols.append(l.modulate)

func Refresh() -> void:
	for i in Refs.size():
		Refs[i].text = Txts[i]
		Refs[i].modulate = Cols[i]
