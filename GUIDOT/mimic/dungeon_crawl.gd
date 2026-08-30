extends Control

#
#	Put the whole game in here.
#	All UI elements exported.
#	Toggle them visible / invisible.
#	Only generalize later.
#	Classes / Scripts when convenient.
#

# For toggling visibility
@export var MainMenuBG: Node
@export var MainMenuBase: Node
@export var MainMenuOptions: Node
@export var MainMenuNewSlotter: Node 
@export var MainMenuDiffSelector: Node 
@export var MainMenuTeamBuilder: Node 
@export var MainMenuSkillPreview: Node

# For actions
@export var MainMenuSlot1: Node 
@export var MainMenuSlot2: Node 
@export var MainMenuSlot3: Node 

# For toggling visibility
@export var NavDungeonBG: Node
@export var NavDungeonBase: Node
@export var NavDungeonHUD: Node
@export var NavDungeonIntro: Node
@export var NavDungeonScore: Node
@export var NavDungeonQuit: Node
@export var NavDungeonHelp: Node
@export var NavDungeonOptions: Node
@export var NavDungeonLoot: Node

# For toggling visibility
@export var InventoryBG: Node
@export var InventoryBase: Node
@export var InventoryOptions: Node
@export var InventoryQuit: Node
@export var InventoryStatUp: Node
@export var InventorySkillUp: Node

# For toggling visibility
@export var CombatBG: Node
@export var CombatBase: Node
@export var CombatOptions: Node
@export var CombatQuit: Node

# State Machine
var GameState:String = "None"
var States: Dictionary[String,State] = {}
var Transitions: Dictionary[String,Transition] = {}

# Specific State
var SaveSlot = 1

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
	for s in States:
		for n in States[s].Items:
			n.hide()
	assert(States["MainMenu"], "Main Menu State Exists")
	GameState = "MainMenu"
	InitState()
	for n in States["MainMenu"].Items:
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
	for n in t.Hides:
		n.hide()
	for n in t.Shows:
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
		"MainMenu [Escape]":
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
		NavDungeonBase,
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
	States[sName] = State.New(sName, shows)

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
	var Items: Array[Node]
	static func New(nm:String, a: Array) -> State:
		var s = State.new()
		s.Name = nm
		for n in a:
			if n != null:
				s.Items.append(n)
		return s

class Transition:
	var From: String
	var To: String
	var Shows: Array[Node]
	var Hides: Array[Node]
	static func New(from:State, to:State) -> Transition:
		var t = Transition.new()
		t.From = from.Name
		t.To = to.Name
		for n in from.Items:
			if n not in to.Items:
				t.Hides.append(n)
		for n in to.Items:
			if n not in from.Items:
				t.Shows.append(n)
		return t
