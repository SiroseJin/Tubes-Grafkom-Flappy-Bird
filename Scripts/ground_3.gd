extends Node2D

class_name Ground3

signal bird_crashed

var speed = -150
var active_speed = -150

@onready var sprite1 = $Ground1/Sprite1
@onready var sprite2 = $Ground2/Sprite2

func _ready():
	sprite2.global_position.x = sprite1.global_position.x + sprite1.texture.get_width()
	$CollisionShape2D.connect("body_entered", Callable(self, "_body_entered"))

func _process(delta):
	if speed != 0:
		sprite1.global_position.x += speed * delta
		sprite2.global_position.x += speed * delta
		if sprite1.global_position.x < -sprite1.texture.get_width():
			sprite1.global_position.x = sprite2.global_position.x + sprite2.texture.get_width()
		if sprite2.global_position.x < -sprite2.texture.get_width():
			sprite2.global_position.x = sprite1.global_position.x + sprite1.texture.get_width()

func _body_entered(body):
	bird_crashed.emit()
	(body as Bird).stop()

func stop():
	speed = 0

func start():
	speed = active_speed
