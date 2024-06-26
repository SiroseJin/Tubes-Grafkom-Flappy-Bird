extends Node

enum GameState { IDLE, RUNNING, ENDED }

var game_state

@onready var pipe_spawner = $"../PipeSpawner" as PipeSpawner
@onready var bird = get_node("../Bird") as Bird
@onready var ground = $"../Ground" as Ground
@onready var ground2 = $"../ground2" as Ground
@onready var ground3 = $"../ground3" as Ground
@onready var fade = $"../Fade" as Fade
@onready var ui = $"../UI" as UI
@onready var background_1 = $"../World/Background1"
@onready var background_2 = $"../World/Background2"
@onready var background_3 = $"../World/Background3"
@onready var label = $"../UI/Label"

var points = 0

func _ready():
	game_state = GameState.IDLE
	bird.game_started.connect(on_game_started)
	pipe_spawner.bird_crashed.connect(end_game)
	ground.bird_crashed.connect(end_game)
	pipe_spawner.point_scored.connect(point_scored)
	label.show()

func on_game_started():
	label.hide()
	game_state = GameState.RUNNING
	pipe_spawner.start_spawning_pipes()
	points = 0
	ui.update_points(points)
	switch_ground()

func end_game():
	game_state = GameState.ENDED
	if fade != null:
		fade.play()
	bird.kill()
	pipe_spawner.stop()
	ground.stop()
	ground2.stop()
	ground3.stop()
	ui.on_game_over()

func point_scored():
	points += 1
	ui.update_points(points)
	switch_ground()

func switch_ground():
	if points <= 1:
		ground.show()
		ground2.hide()
		ground3.hide()
		background_1.show()
		background_2.hide()
		background_3.hide()
	elif points <= 3:
		ground.hide()
		ground2.show()
		ground3.hide()
		background_1.hide()
		background_2.show()
		background_3.hide()
	else:
		ground.hide()
		ground2.hide()
		ground3.show()
		background_1.hide()
		background_2.hide()
		background_3.show()
