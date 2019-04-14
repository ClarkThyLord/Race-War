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
	get_node("/root/HUD").get_node("Movement").connect("start",self,"start_moving")
	get_node("/root/HUD").get_node("Movement").connect("update",self,"move")
	get_node("/root/HUD").get_node("Movement").connect("stop",self,"stop_moving")
	screensize = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2(SPEED,0).rotated(rotation)
	var backwards = false
	var angleCursor = floor(rad2deg(direction.angle())*10)/10
	
	if angleCursor < 0:
		angleCursor = angleCursor + 180 + 180
	var angleRotation = floor(((rotation_degrees / 360) - floor(rotation_degrees / 360)) * 360)
	if movement:
		if time * ACCELERATION < SPEED:
			time+=1
		#print(str(angleCursor) +" "+ str( abs(rad2deg(velocity.angle_to(direction)))))
		if angleCursor != angleRotation:
			if  rad2deg(velocity.angle_to(direction))>0 and abs(rad2deg(velocity.angle_to(direction)))<110:
				rotation_degrees+=5
				backwards = false
			elif  abs(rad2deg(velocity.angle_to(direction))) > 178 and abs(rad2deg(velocity.angle_to(direction))) < 183:
				backwards = true
			elif  rad2deg(velocity.angle_to(direction))<0 and  abs(rad2deg(velocity.angle_to(direction)))<110:
				rotation_degrees-=5
				backwards = false
			elif  rad2deg(velocity.angle_to(direction))>0 and abs(rad2deg(velocity.angle_to(direction)))>=110:
				rotation_degrees-=5
				backwards = true
			else:
				rotation_degrees+=5
				backwards = true
#		movement = false
	else:
		time = 0	
	if backwards:
		velocity = Vector2(-time*ACCELERATION*.3,0).rotated(rotation)
	else:
		velocity = Vector2(time*ACCELERATION,0).rotated(rotation)
	position += velocity*delta
func _input(event):
	direction = Vector2()
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		movement = true
	else:
		movement = false

func start_moving():
	movement = true

func stop_moving():
	movement = false

func move(Action):
	print(str(Action))
	direction = Action
	direction.y *= -1