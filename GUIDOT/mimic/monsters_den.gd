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
@export var MainMenuLoadSlotter: Node

# For toggling visibility
@export var NavDungeonBG: Node
@export var NavDungeonBase: Node
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
	for n in States["MainMenu"].Items:
		n.show()

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
		"MainMenu-Load",
		MainMenuBG,
		MainMenuLoadSlotter,
	)
	AddState(
		"MainMenu-New",
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
	)
	#
	#	TODO: Complete the state list
	#

func PopulateTransitions() -> void:
	Transitions = {}
	# Main Menu
	AddTwoWayTransition("MainMenu","MainMenu-Opts")
	AddTwoWayTransition("MainMenu","MainMenu-New")
	AddTwoWayTransition("MainMenu","MainMenu-Load")
	AddTwoWayTransition("MainMenu-New","MainMenu-DiffSelect")
	AddTwoWayTransition("MainMenu-DiffSelect","MainMenu-TeamBuild")
	AddTwoWayTransition("MainMenu-TeamBuild","MainMenu-SkillPreview")
	# Launch
	AddOneWayTransition("MainMenu-Load","Navigation")
	AddOneWayTransition("MainMenu-TeamBuild","Navigation-Intro")
	# Exit
	AddOneWayTransition("Navigation","MainMenu")
	# Navigation
	AddOneWayTransition("Navigation-Intro","Navigation")
	#
	#	TODO: Complete the transition map
	#
	#	TODO: Bind keys to transitions right here,
	#			with "Escape" being the reverse of any two-way.
	#			Also automatically reject duplicate bindings.
	#

#############################################
##-----------------------------------------##
##         State Machine Builders          ##
##-----------------------------------------##
#############################################

func AddState(sName:String, ...shows:Array) -> void:
	assert(not States.has(sName), "uniqueness")
	States[sName] = State.New(shows)

func AddOneWayTransition(from:String, to:String) -> void:
	var tName:String = from + ">" + to
	assert(not Transitions.has(tName), "uniqueness")
	assert(States.has(from), "States.has " + from)
	assert(States.has(to), "States.has " + to)
	Transitions[tName] = Transition.New(States[from],States[to])

func AddTwoWayTransition(from:String, to:String) -> void:
	AddOneWayTransition(from,to)
	AddOneWayTransition(to,from)

#############################################
##-----------------------------------------##
##               Custom Types              ##
##-----------------------------------------##
#############################################

class State:
	var Items: Array[Node]
	static func New(a: Array) -> State:
		var s = State.new()
		for n in a:
			if n != null:
				s.Items.append(n)
		return s

class Transition:
	var Shows: Array[Node]
	var Hides: Array[Node]
	static func New(from:State, to:State) -> Transition:
		var t = Transition.new()
		for n in from.Items:
			if n not in to.Items:
				t.Hides.append(n)
		for n in to.Items:
			if n not in from.Items:
				t.Shows.append(n)
		return t
