extends Area2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	global_position = get_global_mouse_position()


func _on_body_entered(body):
	if body.name == "Slime":
		$AnimatedSprite2D.play("locked_on")
	else:
		$AnimatedSprite2D.play("default")
