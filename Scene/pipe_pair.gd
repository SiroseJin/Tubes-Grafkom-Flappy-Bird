extends Node2D

class_name PipePair

var speed = 0 
@onready var point_audio = $Scored/PointAudio
@onready var hit = $TopPipe/hit
@onready var die = $TopPipe/die


signal bird_entered
signal point_scored

func set_speed(new_speed):
	speed = new_speed
	
func _process(delta):
	position.x += speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	bird_entered.emit()
	hit.play()
	await get_tree().create_timer(0.3).timeout
	die.play()


func _on_scored_body_entered(body):
	point_scored.emit()
	point_audio.play()
