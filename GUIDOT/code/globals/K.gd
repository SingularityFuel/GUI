# Set as a Global Autoload in project
# so it can be accessed from anywhere.

# K Class Keyboard Event Router

extends Node

var LETTERS = [
	"A","B","C","D","E",
	"F","G","H","I","J",
	"K","L","M","N","O",
	"P","Q","R","S","T",
	"U","V","W","X","Y",
	"Z"]

var ODDKEYS = [
	"Escape",
	"Space"
]

func _unhandled_key_input(event: InputEvent) -> void:
	if event is not InputEventKey:
		return
	if not event.pressed:
		return
	if event.is_echo():
		return
	if event.keycode >= KEY_0 and event.keycode <= KEY_9:
		# regular number keys
		var digit: int = event.keycode - KEY_0
		S.NumKey.emit(digit)
		S.AnyKey.emit(str(digit))
		return
	if event.keycode >= KEY_KP_0 and event.keycode <= KEY_KP_9:
		# numpad number keys
		var digit: int = event.keycode - KEY_KP_0
		S.NumKey.emit(digit)
		S.AnyKey.emit(str(digit))
		return
	if event.keycode >= KEY_A and event.keycode <= KEY_Z:
		# 26 letter keys
		# ignores shift, option, etc
		# always emits capital letter
		var index: int = event.keycode - KEY_A
		S.AbcKey.emit(LETTERS[index])
		S.AnyKey.emit(LETTERS[index])
		return
	if event.as_text() in ODDKEYS:
		# only the ones we listen for
		# blocked by shift, option, etc
		S.OddKey.emit(event.as_text())
		S.AnyKey.emit(event.as_text())
		return
