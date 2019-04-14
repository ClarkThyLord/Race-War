extends KinematicBody2D

export (float) var SPEED
export (float) var ACCELERATION 
export (float) var LIFE 
var direction = Vector2()
var screensize 
var time = 0
var movimientoAnterior = Vector2()
var movement = false

func _ready():
	
	get_node("/root/HUD").get_node("Movement").connect("update",self,"move")
	screensize = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2()
	var backwards = false
	var angleCursor = floor(rad2deg(direction.angle()))
	if angleCursor < 0:
		angleCursor = angleCursor + 180 + 180
	var angleRotation = floor(((rotation_degrees / 360) - floor(rotation_degrees / 360)) * 360)
	if movement:
		if time * ACCELERATION < SPEED:
			time+=1
		if angleCursor != angleRotation:
			velocity = Vector2(SPEED,0).rotated(rotation)
			if velocity.angle_to(direction)>0 and abs(rad2deg(velocity.angle_to(direction)))<91:
				rotation_degrees+=2
			elif velocity.angle_to(direction)<0 and  abs(rad2deg(velocity.angle_to(direction)))<91:
				rotation_degrees-=2
			elif  abs(rad2deg(velocity.angle_to(direction)))==180:
				backwards = true
			elif velocity.angle_to(direction)>0 and abs(rad2deg(velocity.angle_to(direction)))>=91:
				rotation_degrees-=2
				backwards = true
			else:
				rotation_degrees+=2
				backwards = true
		if backwards:
			velocity = Vector2(-time*ACCELERATION*.3,0).rotated(rotation)
			print(velocity.x)
		else:
			velocity = Vector2(time*ACCELERATION,0).rotated(rotation)
			print(velocity.x)
		position += velocity*delta
		direction = Vector2()
		movement = false

func move(Action):
	direction = Action
	direction.y *= -1  
	movement = true

func _input(event):
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		movement = true
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		movement = true 
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
		movement = true 
	if Input.is_action_pressed("ui_down"):
		direction.y += 1		
		movement = true

func updateDirectionJoystick(Action):
	direction = Action