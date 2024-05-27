extends CharacterBody2D

var health = 100

var is_dead = false
var pos
var rot

@export var speed = 100

@onready var anim_sprite = $AnimatedSprite2D
@onready var magic_ball_scene = preload("res://scenes/magic_ball.tscn")
@onready var wand_pivot = $WandPivot
@onready var wand = $WandPivot/Wand
@onready var magic_point = $WandPivot/MagicPoint
@onready var health_bar = $CanvasLayer/MarginContainer/VBoxContainer/Health


func _process(delta):
	
	if is_dead == true:
		return
	
	health_bar.value = health
	
	target_mouse()


func _physics_process(delta):
	if is_dead == true:
		return
	
	if Input.is_action_just_pressed("shoot"):
		instance_ball()
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	velocity = direction * speed
	
	if velocity != Vector2.ZERO:
		anim_sprite.play("run")
	else:
		anim_sprite.play("idle")
	
	if get_global_mouse_position().x > global_position.x:
		anim_sprite.flip_h = false
	else:
		anim_sprite.flip_h = true
		
	const DAMAGE_RATE = 50
	var overlapping_mobs = $HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		if health <= 0:
			kill()
	
	
	move_and_slide()

func kill():
	is_dead = true
	wand_pivot.queue_free()
	anim_sprite.play("die")
	
	await get_tree().create_timer(1.5).timeout
	
	get_tree().reload_current_scene()

func target_mouse():
	var mouse_movement = get_global_mouse_position()
	pos = global_position
	wand_pivot.look_at(mouse_movement)
	rot = rad_to_deg((mouse_movement - pos).angle())
	
func instance_ball():
	var magic_ball = magic_ball_scene.instantiate()
	magic_ball.direction = magic_point.global_position - wand_pivot.global_position
	magic_ball.global_position = magic_point.global_position
	get_tree().root.add_child(magic_ball)
