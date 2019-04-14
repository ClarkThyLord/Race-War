extends RigidBody2D   

var BulletTypes = [ [1] ]

var Owner

func _process(delta):
	if position.distance_to(Owner.position) > 200:
		queue_free()

func _on_Bullet_body_entered(body):  
	if body.is_in_group("Bullets") or (body != Owner and body.is_in_group("Cars")):
		queue_free()

func CreateType(BulletType, Angle):
	 mass = BulletTypes[BulletType][0] 
	 linear_velocity = Angle