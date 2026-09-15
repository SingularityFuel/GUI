class_name BarState
extends Object

var State: String
var Txts: Array[String] 
var Cols: Array[Color]

static func Get(state:String) -> BarState:
	var bs = BarState.new()
	bs.State = state
	match state:
		"Main Menu":
			bs.Txts = [
				"Play (1)",
				"Options (2)",
				"Credits (3)",
				"Quit (Esc)",
			] as Array[String]
			bs.Cols = [
				Color.GREEN,
				Color.WHITE,
				Color.WHITE,
				Color.RED,
			] as Array[Color]
		"Options","Credits":
			bs.Txts = [
				"Back (Esc)",
			] as Array[String]
			bs.Cols = [
				Color.RED,
			] as Array[Color]
		"Save Slot Select":
			bs.Txts = [
				"Back (Esc)",
				"Select (Arrows)",
				"Launch (1)"
			] as Array[String]
			bs.Cols = [
				Color.RED,
				Color.BLUE,
				Color.GREEN,
			] as Array[Color]
	return bs
