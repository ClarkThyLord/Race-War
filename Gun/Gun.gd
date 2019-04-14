extends Node2D 
enum GunTypes {LIGHT, MEDIUM, HEAVY}
var type
var Bullet = preload("res://Bullet/Bullet.tscn")
var delay:bool = false
var rate : float=1
var power : float=1
var Time :float=0 
func _ready():
	pass 
func _process(delta):
	if delay==true:
		Time+=delta
	if Time >= rate:
		delay=false 
func shoot(): 
	if delay==false:
		print('boom!')  
		var bullet = Bullet.instance()  
		get_parent().add_child(bullet)
		bullet.position = position 
		bullet.CreateType(0, Vector2(-456,-72))
		delay=true
	else:
		print('No Boom :c')  
func _input(event):
	if Input.is_key_pressed(KEY_SPACE):
		 shoot()
