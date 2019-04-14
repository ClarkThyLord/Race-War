extends KinematicBody2D

export(bool) var Current : bool = false setget set_current
func set_current(current):
	$Camera2D.current = current
	if current and has_node("/root/HUD"):
		get_node("/root/HUD").get_node("Movement").connect("start",self,"start_moving")
		get_node("/root/HUD").get_node("Movement").connect("update",self,"move")
		get_node("/root/HUD").get_node("Movement").connect("stop",self,"stop_moving")
		
		get_node("/root/HUD").get_node("Shooting").connect("start",self,"rotate_gun")
		get_node("/root/HUD").get_node("Shooting").connect("update",self,"rotate_gun")
	if !current and Current:
		get_node("/root/HUD").get_node("Movement").disconnect("start",self,"start_moving")
		get_node("/root/HUD").get_node("Movement").disconnect("update",self,"move")
		get_node("/root/HUD").get_node("Movement").disconnect("stop",self,"stop_moving")
		
		get_node("/root/HUD").get_node("Shooting").disconnect("start",self,"rotate_gun")
		get_node("/root/HUD").get_node("Shooting").disconnect("update",self,"rotate_gun")
	
	Current = current

export (float) var SPEED
export (float) var ACCELERATION 
export (float) var LIFE 
var direction = Vector2() 
var time = 0
var movimientoAnterior = Vector2() 
var CurrentSpeed 
func _ready():
	$Gun.Owner = self
	set_current(Current) 
	CurrentSpeed=SPEED
func _process(delta):
	var velocity = Vector2(SPEED,0).rotated(rotation)
	var backwards = false
	var angleCursor = floor(rad2deg(direction.angle())*10)/10
	
	if angleCursor < 0:
		angleCursor = angleCursor + 180 + 180
	var angleRotation = floor(((rotation_degrees / 360) - floor(rotation_degrees / 360)) * 360)
	if direction.length() != 0:
		if time * ACCELERATION < CurrentSpeed:
			time+=1
		elif time*ACCELERATION > CurrentSpeed:
			time = floor(CurrentSpeed/ACCELERATION)
		if abs(angleCursor - angleRotation) > 6:
			if  rad2deg(velocity.angle_to(direction))>0 and abs(rad2deg(velocity.angle_to(direction)))<110:
				rotation_degrees+=5
				backwards = false
			elif  abs(abs(rad2deg(velocity.angle_to(direction))) - 180) < 6:
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
	else:
		time = 0	
	if backwards:
		velocity = Vector2(-time*ACCELERATION*.3,0).rotated(rotation)
	else:
		velocity = Vector2(time*ACCELERATION,0).rotated(rotation)
	
	move_and_collide(velocity*delta)

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

func move(Action):
	direction = Action

func rotate_gun(Action=null):
	if Action == null:
		Action = get_node("/root/HUD").get_node("Shooting").get_action()
	
	$Gun.look_at(to_global(Action))
	$Gun.shoot()
	 
func ModifySpeed(Rate):
	CurrentSpeed=SPEED*Rate
