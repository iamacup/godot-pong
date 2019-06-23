extends Node

var player_speed = 650
var npc_speed = 450

var ball_speed = 600

var top_score = 0
var bottom_score = 0

export (PackedScene) var Ball
var ball_instance

func _ready():
	randomize()
	spawn_ball()

func force_positions():
	$PlayerBat.linear_velocity = Vector2($PlayerBat.linear_velocity.x, 0)
	$NPCBat.linear_velocity = Vector2($NPCBat.linear_velocity.x, 0)
	$PlayerBat.position.y = 50
	$NPCBat.position.y = 974

func _physics_process (delta):
	force_positions()

func _process(delta):
	# Handle the player movement
	if Input.is_action_pressed("ui_right"):
		$PlayerBat.linear_velocity = Vector2(player_speed, 0)
	elif Input.is_action_pressed("ui_left"):
		$PlayerBat.linear_velocity = Vector2(-player_speed, 0)
	
	force_positions()

func _on_Ball_body_entered(obj):
	if obj.name == "TopBumper":
		ball_instance.queue_free()
		bottom_score += 1
		$HUD/BottomScore.text = str(bottom_score)
		yield(get_tree().create_timer(1), 'timeout')
		spawn_ball()
	elif obj.name == "BottomBumper":
		ball_instance.queue_free()
		top_score += 1
		$HUD/TopScore.text = str(top_score)
		yield(get_tree().create_timer(1), 'timeout')
		spawn_ball()

func spawn_ball():
	ball_instance = Ball.instance()
	add_child(ball_instance)

	ball_instance.position.x = 512
	ball_instance.position.y = 512

	var random_direction = rand_range(-ball_speed, ball_speed)

	if randi() % 2 == 0:
		ball_instance.linear_velocity = Vector2( random_direction, -ball_speed )
	else:
		ball_instance.linear_velocity = Vector2( random_direction, ball_speed )
	
	ball_instance.connect("body_entered", self, "_on_Ball_body_entered")

