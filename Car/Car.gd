extends KinematicBody2D

export (float) var SPEED
export (float) var ACCELERATION 
var velocity = Vector2()
var screensize 
var time = 0
var movimientoAnterior = Vector2()
func _ready():
	screensize = get_viewport_rect().size

func _process(delta):
	var backwards = false
	var cursorRotation = Vector2()
	if Input.is_action_pressed("ui_right"):
		cursorRotation.x += 1
	if Input.is_action_pressed("ui_left"):
		cursorRotation.x -= 1 
	if Input.is_action_pressed("ui_up"):
		cursorRotation.y -= 1 
	if Input.is_action_pressed("ui_down"):
		cursorRotation.y += 1
	var angleCursor = floor(rad2deg(cursorRotation.angle()))
	if angleCursor < 0:
		angleCursor = angleCursor + 180 + 180
	var angleRotation = floor(((rotation_degrees / 360) - floor(rotation_degrees / 360)) * 360)
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		if time * ACCELERATION < SPEED:
			time+=1
		if  angleCursor != angleRotation:
			velocity = Vector2(SPEED,0).rotated(rotation)
			if velocity.angle_to(cursorRotation)>0 and abs(rad2deg(velocity.angle_to(cursorRotation)))<91:
				rotation_degrees+=2
			elif velocity.angle_to(cursorRotation)<0 and  abs(rad2deg(velocity.angle_to(cursorRotation)))<91:
				rotation_degrees-=2
			elif  abs(rad2deg(velocity.angle_to(cursorRotation)))==180:
				backwards = true
			elif velocity.angle_to(cursorRotation)>0 and abs(rad2deg(velocity.angle_to(cursorRotation)))>=91:
				rotation_degrees-=2
				backwards = true
			else:
				rotation_degrees+=2
				backwards = true
		if backwards:
			velocity = Vector2(-time*ACCELERATION*.3,0).rotated(rotation)
		else:
			velocity = Vector2(time*ACCELERATION,0).rotated(rotation)
		position+=velocity*delta
		position.x = clamp(position.x, 0, screensize.x)
		position.y = clamp(position.y, 0, screensize.y)
	