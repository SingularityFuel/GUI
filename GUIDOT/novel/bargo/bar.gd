class_name Bar
extends HBoxContainer

@export var StateHint: Label
@export var Refs: Array[Label]
var Txts: Array[String]
var Cols: Array[Color]

func _ready() -> void:
	Init() # populate txts, cols from referenced labels
	Refresh() # no-op if working, early bug alarm if not

func Init() -> void:
	if StateHint == null:
		L.logError("Bar.Init(): StateHint was null")
	Txts = []
	Cols = []
	for l:Label in Refs:
		Txts.append(l.text)
		Cols.append(l.modulate)

func Refresh() -> void:
	for i:int in Refs.size():
		Refs[i].text = Txts[i]
		Refs[i].modulate = Cols[i]

# depends on bar_state.gd
func ChangeState(s:String) -> void:
	var bs:BarState = BarState.Get(s)
	StateHint.text = bs.State
	for i:int in Txts.size():
		Txts[i] = ""
		if bs.Txts.size() > i:
			Txts[i] = bs.Txts[i]
	for i:int in Cols.size():
		Cols[i] = Color.WHITE
		if bs.Cols.size() > i:
			Cols[i] = bs.Cols[i]
	Refresh()
