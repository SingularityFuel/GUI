# Set as a Global Autoload in project
# so it can be accessed from anywhere.

# S Class Signal Nexus

extends Node

signal NumKey(i:int)
signal AbcKey(k:String)
signal OddKey(k:String)

func _init() -> void:
	NumKey.connect(L.logNumKey)
	AbcKey.connect(L.logAbcKey)
	OddKey.connect(L.logOddKey)
