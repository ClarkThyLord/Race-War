extends RigidBody2D   
var BulletTypes = [ [1, preload("res://icon.png") ] ] 
func _on_Bullet_body_entered(body):  
	if body.is_in_group("Bullets"): 
		queue_free() 
	if body.is_in_group("Cars"):
		#body.get_parent
		queue_free()
func CreateType(BulletType, Angle):
	 mass=BulletTypes[BulletType][0] 
	 $Texture.texture=BulletTypes[BulletType][1] 
	 linear_velocity =Angle
 
 
