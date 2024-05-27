extends Area2D

@export var speed = 25
var direction = Vector2.RIGHT


func _process(delta):
	translate(direction * speed * delta)


func _on_visible_screen_exited():
	queue_free()

func _on_body_entered(body):
	queue_free()
	if body.is_in_group("Enemy"):
		body.take_damage()
