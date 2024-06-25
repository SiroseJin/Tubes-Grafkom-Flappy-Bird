extends Node

class_name PipeSpawner

signal bird_crashed
signal point_scored

var pipe_pair_scene = preload("res://Scene/pipe_pair.tscn")

@export var pipe_speed = -150
@onready var spawn_timer = $SpawnTimer

# spawn time pipa
@export var initial_spawn_interval = 3.0
@export var minimum_spawn_interval = 1.0
@export var interval_decrease_rate = 0.02

@onready var game_manager = get_parent().get_node("GameManager")

func _ready():
	spawn_timer.timeout.connect(spawn_pipe)
	spawn_timer.wait_time = initial_spawn_interval

func start_spawning_pipes():
	spawn_timer.start()

func spawn_pipe():
	if game_manager.game_state != game_manager.GameState.RUNNING:
		return

	var pipe = pipe_pair_scene.instantiate() as PipePair
	add_child(pipe)
	
	var viewport_rect = get_viewport().get_camera_2d().get_viewport_rect()
	var half_height = viewport_rect.size.y / 2
	pipe.position.x = viewport_rect.end.x
	pipe.position.y = randf_range(viewport_rect.size.y * 0.15 - half_height, viewport_rect.size.y * 0.65 - half_height)
	
	pipe.bird_entered.connect(on_bird_entered)
	pipe.point_scored.connect(on_point_scored)
	pipe.set_speed(pipe_speed)
	
	# Kurangi delay spawn pipa tapi tidak bisa melebihi minimum
	if spawn_timer.wait_time > minimum_spawn_interval:
		spawn_timer.wait_time = max(minimum_spawn_interval, spawn_timer.wait_time - interval_decrease_rate)

func on_bird_entered():
	bird_crashed.emit()
	stop()

func stop():
	spawn_timer.stop()
	for pipe in get_children().filter(func (child): return child is PipePair):
		(pipe as PipePair).speed = 0

func on_point_scored():
	point_scored.emit()
