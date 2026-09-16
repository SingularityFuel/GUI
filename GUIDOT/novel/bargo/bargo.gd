extends Control

@export var BottomBar:Bar
@export var CreditsPanel:CanvasItem
@export var OptionsPanel:CanvasItem

var GameState:String

func _ready() -> void:
	# Things that should be project settings
	get_window().min_size = Vector2i(800, 600)
	# Check
	if BottomBar == null:
		L.logError("bottom bar nonexistent")
	# Triggers
	S.AnyKey.connect(_onKey)
	# Hide Components
	CreditsPanel.hide()
	OptionsPanel.hide()
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
	LeaveState(GameState)
	BottomBar.ChangeState(state)
	GameState = state
	EnterState(GameState)

func LeaveState(state:String) -> void:
	match state:
		"Credits":
			CreditsPanel.hide()
		"Options":
			OptionsPanel.hide()

func EnterState(state:String) -> void:
	match state:
		"Credits":
			CreditsPanel.show()
		"Options":
			OptionsPanel.show()
