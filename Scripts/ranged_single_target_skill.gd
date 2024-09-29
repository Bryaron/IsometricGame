extends RigidBody2D

@onready var animation_tree = get_node('AnimationTree')

var projectile_speed = 400
var life_time = 3
var direction
var skill_name
var impulse_rotation
var damage = 90

var fire_direction:float
var animation

func _ready() -> void:
	#damage = GameData.skill_data["Ice Spear"].Damage
	#print(damage)
	
	match skill_name:
		"Ice_Ball":
			damage = 250
			projectile_speed = 200
		"Ice_Spear":
			damage = 90
			projectile_speed = 400
	#var skill_texture =load("res://Assets/Skills/" + skill_name + "_icon.png")
	#get_node("Projectile").set_texture(skill_texture)
	
	apply_impulse(Vector2(projectile_speed, 0).rotated(rotation), Vector2.ZERO)
	SelfDestruct()
	SetAnimation()

func SetAnimation() -> void:
	if fire_direction <= 15 and fire_direction >= -15:
		animation = "Fire_E"
	elif fire_direction <= 60 and fire_direction >= 15:
		animation = 'Fire_SE'
		$Projectile.rotation_degrees -= 30
	elif fire_direction <= 120 and fire_direction >= 60:
		animation = 'Fire_S'
		$Projectile.rotation_degrees -= 90
	elif fire_direction <= 165 and fire_direction >= 120:
		animation = 'Fire_SW'
		$Projectile.rotation_degrees -= 150
	elif fire_direction >= -60 and fire_direction <= -15:
		animation = 'Fire_NE'
		$Projectile.rotation_degrees += 30
	elif fire_direction >= -120 and fire_direction <= -60:
		animation = 'Fire_N'
		$Projectile.rotation_degrees += 90
	elif fire_direction >= -165 and fire_direction <= -120:
		animation = 'Fire_NW'
		$Projectile.rotation_degrees += 150
	elif fire_direction <= -165 and fire_direction >= 165:
		animation = 'Fire_W'
		$Projectile.rotation_degrees -= 180
	$AnimationPlayer.play(animation)

func SelfDestruct() -> void:
	await get_tree().create_timer(life_time).timeout
	queue_free()

func _on_body_entered(body: Node) -> void:
	$CollisionPolygon2D.set_deferred('disabled', true)
	if body.is_in_group('Enemies'):
		body.OnHit(damage)
		print('hit')
	self.hide()
