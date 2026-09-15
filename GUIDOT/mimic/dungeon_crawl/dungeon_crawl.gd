extends Control

#
#	Put the whole game in here.
#	All UI elements exported.
#	Toggle them visible / invisible.
#	Only generalize later.
#	Classes / Scripts when convenient.
#

# For toggling visibility
@export var MainMenuBG: CanvasItem
@export var MainMenuBase: CanvasItem
@export var MainMenuOptions: CanvasItem
@export var MainMenuCredits: CanvasItem
@export var MainMenuNewSlotter: CanvasItem 
@export var MainMenuDiffSelector: CanvasItem 
@export var MainMenuTeamBuilder: CanvasItem 
@export var MainMenuSkillPreview: CanvasItem

# For actions
@export var MainMenuSlot1: CanvasItem 
@export var MainMenuSlot2: CanvasItem 
@export var MainMenuSlot3: CanvasItem 

# For toggling visibility
@export var NavDungeonBG: CanvasItem
@export var NavDungeonBase: CanvasItem
@export var NavDungeonHUD: CanvasItem
@export var NavDungeonIntro: CanvasItem
@export var NavDungeonScore: CanvasItem
@export var NavDungeonQuit: CanvasItem
@export var NavDungeonHelp: CanvasItem
@export var NavDungeonOptions: CanvasItem
@export var NavDungeonLoot: CanvasItem

# For toggling visibility
@export var InventoryBG: CanvasItem
@export var InventoryBase: CanvasItem
@export var InventoryOptions: CanvasItem
@export var InventoryQuit: CanvasItem
@export var InventoryStatUp: CanvasItem
@export var InventorySkillUp: CanvasItem

# For toggling visibility
@export var CombatBG: CanvasItem
@export var CombatBase: CanvasItem
@export var CombatOptions: CanvasItem
@export var CombatQuit: CanvasItem

# State Machine
var GameState:String = "None"
var States: Dictionary[String,State] = {}
var Transitions: Dictionary[String,Transition] = {}

# Specific State
var SaveSlot:int = 1

#############################################
##-----------------------------------------##
##               Bootstrap                 ##
##-----------------------------------------##
#############################################

func _ready() -> void:
	# Construct State Machine
	PopulateStates()
	PopulateTransitions()
	# Initialize State Machine
	for s:String in States:
		for n:CanvasItem in States[s].Items:
			n.hide()
	assert(States["MainMenu"], "Main Menu State Exists")
	GameState = "MainMenu"
	InitState()
	for n:CanvasItem in States["MainMenu"].Items:
		n.show()
	# Triggers
	S.AnyKey.connect(_onKey)

#############################################
##-----------------------------------------##
##                Triggers                 ##
##-----------------------------------------##
#############################################

func _onKey(k:String) -> void:
	var action:String = GameState + " [" + k + "]"
	# Custom actions first
	DoAction(action)
	# Then transition
	if Transitions.has(action):
		DoTransition(Transitions[action])

#############################################
##-----------------------------------------##
##                 Execute                 ##
##-----------------------------------------##
#############################################

func DoTransition(t:Transition) -> void:
	for n:CanvasItem in t.Hides:
		n.hide()
	for n:CanvasItem in t.Shows:
		n.show()
	GameState = t.To
	InitState()
	pass

func InitState() -> void:
	# Runs after any transition, and on game start
	match GameState:
		"MainMenu-Play":
			HighlightSaveSlots()

func DoAction(action:String) -> void:
	match action:
		"MainMenu [0]":
			get_tree().quit()
		"MainMenu-Play [Left]":
			match SaveSlot:
				2,3: SaveSlot -= 1
				_: SaveSlot = 3
			HighlightSaveSlots()
		"MainMenu-Play [Right]":
			match SaveSlot:
				1,2: SaveSlot += 1
				_: SaveSlot = 1
			HighlightSaveSlots()
		"MainMenu-New [2]":
			pass # TODO: Delete data in save slot

func HighlightSaveSlots() -> void:
	MainMenuSlot1.modulate = Color.DIM_GRAY
	MainMenuSlot2.modulate = Color.DIM_GRAY
	MainMenuSlot3.modulate = Color.DIM_GRAY
	match SaveSlot:
		1: MainMenuSlot1.modulate = Color.GRAY
		2: MainMenuSlot2.modulate = Color.GRAY
		3: MainMenuSlot3.modulate = Color.GRAY

#############################################
##-----------------------------------------##
##         Specific Game Structure         ##
##-----------------------------------------##
#############################################

func PopulateStates() -> void:
	States = {}
	AddState(
		"MainMenu",
		MainMenuBG,
		MainMenuBase,
	)
	AddState(
		"MainMenu-Opts",
		MainMenuBG,
		MainMenuOptions,
	)
	AddState(
		"MainMenu-Creds",
		MainMenuBG,
		MainMenuCredits,
	)
	AddState(
		"MainMenu-Play",
		MainMenuBG,
		MainMenuNewSlotter,
	)
	AddState(
		"MainMenu-DiffSelect",
		MainMenuBG,
		MainMenuDiffSelector,
	)
	AddState(
		"MainMenu-TeamBuild",
		MainMenuBG,
		MainMenuTeamBuilder,
	)
	AddState(
		"MainMenu-SkillPreview",
		MainMenuBG,
		MainMenuTeamBuilder,
		MainMenuSkillPreview,
	)
	AddState(
		"Navigation-Intro",
		NavDungeonBG,
		NavDungeonIntro,
	)
	AddState(
		"Navigation",
		NavDungeonBG,
		NavDungeonBase,
		NavDungeonHUD,
	)
	#
	#	TODO: Complete the state list
	#

func PopulateTransitions() -> void:
	Transitions = {}
	# Main Menu
	AddTwoWayTransition("1","MainMenu","MainMenu-Play")
	AddTwoWayTransition("2","MainMenu","MainMenu-Opts")
	AddTwoWayTransition("3","MainMenu","MainMenu-Creds")
	AddTwoWayTransition("1","MainMenu-Play","MainMenu-DiffSelect")
	AddTwoWayTransition("1","MainMenu-DiffSelect","MainMenu-TeamBuild")
	AddTwoWayTransition("2","MainMenu-TeamBuild","MainMenu-SkillPreview")
	# Launch
	AddOneWayTransition("1","MainMenu-TeamBuild","Navigation-Intro")
	# Exit
	AddOneWayTransition("Escape","Navigation","MainMenu")
	# Navigation
	AddOneWayTransition("Escape","Navigation-Intro","Navigation")
	#
	#	TODO: Complete the transition map
	#

#############################################
##-----------------------------------------##
##         State Machine Builders          ##
##-----------------------------------------##
#############################################

func AddState(sName:String, ...shows:Array) -> void:
	assert(not States.has(sName), "uniqueness")
	var typed:Array[CanvasItem] = []
	for s:Object in shows:
		if s is CanvasItem:
			typed.append(s as CanvasItem)
		elif s != null:
			L.logError("AddState: shows not CanvasItem")
	States[sName] = State.New(sName, typed)

func AddOneWayTransition(key:String,from:String, to:String) -> void:
	var tName:String = from + " [" + key + "]"
	assert(not Transitions.has(tName), "uniqueness")
	assert(States.has(from), "States.has " + from)
	assert(States.has(to), "States.has " + to)
	Transitions[tName] = Transition.New(States[from],States[to])

func AddTwoWayTransition(key:String, from:String, to:String) -> void:
	AddOneWayTransition(key,from,to)
	AddOneWayTransition("Escape",to,from)

#############################################
##-----------------------------------------##
##               Custom Types              ##
##-----------------------------------------##
#############################################

class State:
	var Name: String
	var Items: Array[CanvasItem]
	static func New(nm:String, a: Array[CanvasItem]) -> State:
		var s:State = State.new()
		s.Name = nm
		for n:CanvasItem in a:
			if n != null:
				s.Items.append(n)
		return s

class Transition:
	var From: String
	var To: String
	var Shows: Array[CanvasItem]
	var Hides: Array[CanvasItem]
	static func New(from:State, to:State) -> Transition:
		var t:Transition = Transition.new()
		t.From = from.Name
		t.To = to.Name
		for n:CanvasItem in from.Items:
			if n not in to.Items:
				t.Hides.append(n)
		for n:CanvasItem in to.Items:
			if n not in from.Items:
				t.Shows.append(n)
		return t
