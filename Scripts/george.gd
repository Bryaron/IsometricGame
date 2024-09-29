extends CharacterBody2D

@onready var hp_bar = $HPBar

var max_hp:int = 400
var current_hp:int
var percentage_hp:float

func _ready() -> void:
	$AnimationPlayer.play("Idle_SW")
	current_hp = max_hp

func OnHit(damage):
	current_hp -= damage
	HPBarUpdate()
	if current_hp <= 0:
		OnDeath()

func HPBarUpdate():
	percentage_hp = int((float(current_hp)/ max_hp) * 100)
	var tween:Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property($HPBar, "value", percentage_hp, 0.1)
	tween.set_parallel()
	if percentage_hp >= 60:
		tween.tween_property($HPBar, "tint_progress", Color("#14e114"), 0.1)
	elif percentage_hp <= 60 and percentage_hp >= 25:
		tween.tween_property($HPBar, "tint_progress", Color("#e1be32"), 0.1)
	else:
		hp_bar.set_tint_progress(Color("#e11e1e"))


func OnDeath():
	$CollisionShape2D.set_deferred('disabled', true)
	$AnimationPlayer.play("Death_SW")
	hp_bar.hide()
