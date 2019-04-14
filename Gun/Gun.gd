extends Node2D

enum GunTypes {LIGHT, MEDIUM, HEAVY}
var type

var rate : float
var power : float

func _ready():
	pass

func shoot():
	print('boom!')
