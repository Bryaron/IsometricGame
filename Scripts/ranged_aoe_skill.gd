extends Area2D

var skill_name:String
var damage:int = 180
var animation:String = "Cryo_Bomb"
var damage_delay_time = 0.4
var remove_delay_time = 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AOE_attack()
	

func AOE_attack() -> void:
	$AnimationPlayer.play(animation)
	await get_tree().create_timer(damage_delay_time).timeout
	var targets = get_overlapping_bodies()
	for target in targets:
		target.OnHit(damage)
	await get_tree().create_timer(remove_delay_time).timeout
	self.queue_free()
