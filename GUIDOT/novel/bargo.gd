extends Control

@export var BottomBar:Bar

var GameState:String

func _ready() -> void:
	if BottomBar == null:
		L.logError("bottom bar nonexistent")
	# Triggers
	S.AnyKey.connect(_onKey)
	# Initialize
	ChangeState("Main Menu")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#############################################
##-----------------------------------------##
##                Triggers                 ##
##-----------------------------------------##
#############################################

func _onKey(k:String) -> void:
	var action:String = GameState + " [" + k + "]"
	DoAction(action)

#############################################
##-----------------------------------------##
##                 Execute                 ##
##-----------------------------------------##
#############################################

func DoAction(action:String) -> void:
	match action:
		"Main Menu [Escape]":
			get_tree().quit()
		"Main Menu [1]":
			ChangeState("Save Slot Select")
		"Main Menu [2]":
			ChangeState("Options")
		"Main Menu [3]":
			ChangeState("Credits")
		"Options [Escape]":
			ChangeState("Main Menu")
		"Credits [Escape]":
			ChangeState("Main Menu")
		"Save Slot Select [Left]":
			pass
		"Save Slot Select [Right]":
			pass
		"Save Slot Select [Escape]":
			ChangeState("Main Menu")

func ChangeState(state:String) -> void:
	BottomBar.ChangeState(state)
	GameState = state
