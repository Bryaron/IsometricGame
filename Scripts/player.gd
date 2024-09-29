extends CharacterBody2D

#var spell = preload("res://Scenes/SupportScenes/RangedSingleTargetSkill.tscn")

@onready var animation_tree:AnimationTree = get_node('AnimationTree')
@onready var animation_mode = animation_tree.get('parameters/playback')

var anim_direction:String = 'S'
var anim_mode:String = 'Idle'
var animation:String

var selected_skill

var can_fire:bool = true
var rate_of_fire:float = 0.4
var is_shooting:bool = false
var fire_direction

var max_speed:float = 300
var speed:float = 0
var acceleration:float = 900
var move_direction:float # ANGULO DEL JUGADOR
var destination:Vector2 = Vector2()
var movement:Vector2 = Vector2()
var is_moving:bool = false
var is_attacking:bool = false

func _physics_process(delta: float) -> void:
	MovementLoop(delta)
	#print(str(move_direction) +' '+ str(animation))

func _process(delta: float) -> void:
	#AnimationLoop()
	#SkillLoop()
	pass

func SkillLoop() -> void:
	if Input.is_action_pressed('Shoot') and can_fire == true:
		can_fire = false
		is_shooting = true
		speed = 0
		fire_direction = (get_angle_to(get_global_mouse_position()) / 3.14) * 180
		$TurnAxis.rotation = get_angle_to(get_global_mouse_position())
		match selected_skill:
			"Ice_Ball", "Ice_Spear":
				var skill = load("res://Scenes/SupportScenes/RangedSingleTargetSkill.tscn")
				var skill_instance = skill.instantiate()
				skill_instance.skill_name = selected_skill
				skill_instance.fire_direction = fire_direction
				skill_instance.rotation = get_angle_to(get_global_mouse_position())
				skill_instance.position = %CastPoint.get_global_position()
				get_parent().add_child(skill_instance)
			"Cryo_Bomb":
				var skill = load("res://Scenes/SupportScenes/RangedAOESkill.tscn")
				var skill_instance = skill.instantiate()
				skill_instance.skill_name = selected_skill
				skill_instance.position = %CastPoint.get_global_position()
				get_parent().add_child(skill_instance)
		
		await get_tree().create_timer(rate_of_fire).timeout
		can_fire = true
		is_shooting = false
		speed = 200

func _unhandled_input(event) -> void:
	if event.is_action_pressed('Click'):
		is_moving = true
		destination = get_global_mouse_position()
	elif event.is_action_pressed("Attack"):
		is_moving = false
		is_attacking = true
		print(position.direction_to(get_global_mouse_position()).normalized())
		animation_tree.set("parameters/Melee/blend_position", position.direction_to(get_global_mouse_position()).normalized())
		animation_tree.set("parameters/Idle/blend_position", position.direction_to(get_global_mouse_position()).normalized())
		Attack()

func MovementLoop(delta) -> void:
	if is_moving == false or is_attacking == true:
		speed = 0
	else:
		speed += acceleration * delta
		if speed > max_speed:
			speed = max_speed
		velocity = position.direction_to(destination) * speed
		move_direction = rad_to_deg((destination - position).angle())
		if position.distance_to(destination) > 10:
			move_and_slide()
			#velocity = velocity
			animation_tree.set("parameters/Walk/blend_position", velocity.normalized())
			animation_tree.set("parameters/Idle/blend_position", velocity.normalized())
			animation_mode.travel('Walk')
		else:
			is_moving = false
			animation_mode.travel('Idle')

func Attack() -> void:
	can_fire = false
	is_shooting = true
	speed = 0
	fire_direction = (get_angle_to(get_global_mouse_position()) / 3.14) * 180
	$TurnAxis.rotation = get_angle_to(get_global_mouse_position())
	match selected_skill:
		"Ice_Ball", "Ice_Spear":
			var skill = load("res://Scenes/SupportScenes/RangedSingleTargetSkill.tscn")
			var skill_instance = skill.instantiate()
			skill_instance.skill_name = selected_skill
			#skill_instance.fire_direction = fire_direction
			skill_instance.rotation = get_angle_to(get_global_mouse_position())
			skill_instance.position = %CastPoint.get_global_position()
			get_parent().add_child(skill_instance)
		"Cryo_Bomb":
			var skill = load("res://Scenes/SupportScenes/RangedAOESkill.tscn")
			var skill_instance = skill.instantiate()
			skill_instance.skill_name = selected_skill
			#skill_instance.fire_direction = fire_direction
			skill_instance.position = get_global_mouse_position()
			get_parent().add_child(skill_instance)
	animation_mode.travel('Melee')
	await get_tree().create_timer(rate_of_fire).timeout
	can_fire = true
	#is_shooting = false
	is_attacking = false
	speed = 200
	
	#$TurnAxis.rotation = get_angle_to(get_global_mouse_position() - Vector2(0, -20))
	#var skill = load("res://Scenes/SupportScenes/RangedSingleTargetSkill.tscn")
	#var skill_instance = skill.instantiate()
	#skill_instance.rotation = get_angle_to(get_global_mouse_position() - Vector2(0, -20))
	#skill_instance.position = %CastPoint.get_global_position()
	#icespear_instance.direction = %CastPoint.get_global_position().direction_to(get_global_mouse_position().normalized())
	#skill_instance.skill_name = selected_skill
	#get_parent().add_child(skill_instance)
	#animation_mode.travel('Melee')
	#await get_tree().create_timer(0.4).timeout
	#is_attacking = false

# NO ESTOY USANDO EL CODIGO DE ESTA FUNCION DEBIDO AL ANIMATIONTREE (STATEMACHINE-BLENDSPACE2D)
func AnimationLoop() -> void:
	if is_shooting == true:
		anim_mode = 'Idle'
	else:
		if move_direction <= 15 and move_direction >= -15:
			anim_direction = 'E'
		elif move_direction <= 60 and move_direction >= 15:
			anim_direction = 'SE'
		elif move_direction <= 120 and move_direction >= 60:
			anim_direction = 'S'
		elif move_direction <= 165 and move_direction >= 120:
			anim_direction = 'SW'
		elif move_direction >= -60 and move_direction <= -15:
			anim_direction = 'NE'
		elif move_direction >= -120 and move_direction <= -60:
			anim_direction = 'N'
		elif move_direction >= -165 and move_direction <= -120:
			anim_direction = 'NW'
		elif move_direction <= -165 or move_direction >= 165:
			anim_direction = 'W'
		
		if is_moving == true:
			anim_mode = 'Walk'
		elif is_moving == false:
			anim_mode = 'Idle'
	
	animation = anim_mode + '_' + anim_direction
	get_node('AnimationPlayer').play(animation)
