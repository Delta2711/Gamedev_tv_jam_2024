extends CharacterBody2D

var is_dead = false
var health = 3

@onready var anim_sprite = $AnimatedSprite2D
@onready var player = get_node("/root/World/Pausable/Player")


func _physics_process(delta):
	if is_dead == true:
		return
	
	var direction = global_position.direction_to(player.global_position)
	
	velocity = direction * 25
	
	if player.global_position > global_position:
		anim_sprite.flip_h = true
	else:
		anim_sprite.flip_h = false
	move_and_slide()
	

func take_damage():
	health -= 1
	anim_sprite.play("hit")
	await get_tree().create_timer(0.1).timeout
	anim_sprite.play("move")
	if health <= 0:
		queue_free()
