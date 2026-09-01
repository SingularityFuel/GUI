# Set as a Global Autoload in project
# so it can be accessed from anywhere.

# L Class Logger

extends Node

var LogNumKeys:bool = false
var LogAbcKeys:bool = false
var LogOddKeys:bool = false
var LogAnyKeys:bool = false

func logNumKey(i:int) -> void:
	if LogNumKeys:
		print("KEY: ",i)

func logAbcKey(s:String) -> void:
	if LogAbcKeys:
		print("KEY: ",s)

func logOddKey(s:String) -> void:
	if LogOddKeys:
		print("KEY: ",s)

func logAnyKey(s:String) -> void:
	if LogAnyKeys:
		print("KEY: ",s)
