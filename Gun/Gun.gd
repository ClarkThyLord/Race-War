extends Node2D 

var Bullet = preload("res://Bullet/Bullet.tscn")

var Owner

enum GunTypes {LIGHT, MEDIUM, HEAVY}
var type

var rate : float=1
var power : float=250

var Time :float=0
var delay:bool = false

func _process(delta):
	if delay==true:
		Time+=delta
	if Time >= rate:
		delay=false

func _input(event):
	if event is InputEventKey and event.scancode == KEY_SPACE and event.is_pressed():
		 shoot()

func shoot(): 
	if delay==false:
		var bullet = Bullet.instance()
		bullet.Owner = Owner
		get_tree().get_root().add_child(bullet)
		bullet.get_node('Texture').scale = Owner.scale
		bullet.get_node('Texture').rotation = Owner.rotation
		bullet.position = Owner.position
		bullet.CreateType(0, Vector2(cos(Owner.rotation), sin(Owner.rotation)) * power)
		delay=true
