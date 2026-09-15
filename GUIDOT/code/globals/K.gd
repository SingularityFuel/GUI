# Set as a Global Autoload in project
# so it can be accessed from anywhere.

# K Class Keyboard Event Router

extends Node

var LETTERS: Array[String] = [
	"A","B","C","D","E",
	"F","G","H","I","J",
	"K","L","M","N","O",
	"P","Q","R","S","T",
	"U","V","W","X","Y",
	"Z"]

var ODDKEYS: Array[String] = [
	"Escape",
	"Up",
	"Down",
	"Left",
	"Right",
	"Space"
]

func _unhandled_key_input(event: InputEvent) -> void:
	if event is not InputEventKey:
		return
	var kvent: InputEventKey = event as InputEventKey
	var kcode: Key = kvent.keycode
	if not kvent.pressed:
		return
	if event.is_echo():
		return
	if kcode >= KEY_0 and kcode <= KEY_9:
		# regular number keys
		var digit: int = kcode - KEY_0
		S.NumKey.emit(digit)
		S.AnyKey.emit(str(digit))
		return
	if kcode >= KEY_KP_0 and kcode <= KEY_KP_9:
		# numpad number keys
		var digit: int = kcode - KEY_KP_0
		S.NumKey.emit(digit)
		S.AnyKey.emit(str(digit))
		return
	if kcode >= KEY_A and kcode <= KEY_Z:
		# 26 letter keys
		# ignores shift, option, etc
		# always emits capital letter
		var index: int = kcode - KEY_A
		S.AbcKey.emit(LETTERS[index])
		S.AnyKey.emit(LETTERS[index])
		return
	if event.as_text() in ODDKEYS:
		# only the ones we listen for
		# blocked by shift, option, etc
		S.OddKey.emit(event.as_text())
		S.AnyKey.emit(event.as_text())
		return
