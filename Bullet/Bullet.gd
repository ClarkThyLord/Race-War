extends RigidBody2D   

var BulletTypes = [ [1] ]

var Owner

func _process(delta):
	if position.distance_to(Owner.position) > 200:
		queue_free()

func _on_Bullet_body_entered(body):
	if (body.is_in_group("Bullets") and body.Owner != Owner) or (body != Owner and body.is_in_group("Cars")) or body is TileMap:
		queue_free()
	elif body.is_in_group("Cars"):
		body.Life -= mass * angular_velocity
		queue_free()

func CreateType(Owner, BulletType, Angle):
	self.Owner = Owner
	
	add_collision_exception_with(Owner)
	
	mass = BulletTypes[BulletType][0] 
	linear_velocity = Angle
	
	Owner.get_tree().get_root().add_child(self)
	get_node('Texture').scale = Owner.scale
	get_node('Texture').rotation = Owner.get_node('Gun').rotation
	position = to_global(Owner.position)