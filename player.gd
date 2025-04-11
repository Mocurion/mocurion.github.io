extends CharacterBody2D

const SPEED = 300.0
@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var player_health = 100
var player_alive = true

var player_attack_in_progress = false

var last_direction:String = "none"

func player():
	pass
		
func _physics_process(delta: float) -> void:	
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
		last_direction = "left"
		_animated_sprite.flip_h = true
		_animated_sprite.play("walk_right")
	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
		last_direction = "right"
		_animated_sprite.flip_h = false
		_animated_sprite.play("walk_right")
	if Input.is_action_pressed("ui_up"):
		input_dir.y -= 1	
		last_direction = "up"	
		_animated_sprite.play("walk_up")
	if Input.is_action_pressed("ui_down"):
		input_dir.y += 1
		last_direction = "down"
		_animated_sprite.play("walk_down")
	if(input_dir == Vector2.ZERO):	
		if(!player_attack_in_progress):
			match last_direction:
				"left":
					_animated_sprite.flip_h = true
					_animated_sprite.play("idle_right")
				"right":
					_animated_sprite.flip_h = false
					_animated_sprite.play("idle_right")
				"up":
					_animated_sprite.play("idle_up")
				"down":			
					_animated_sprite.play("idle_down")
				"none":
					_animated_sprite.stop()
		else:
			match last_direction:
					"left":
						_animated_sprite.flip_h = true
						_animated_sprite.play("attack_right")
					"right":
						_animated_sprite.flip_h = false
						_animated_sprite.play("attack_right")
					"up":
						_animated_sprite.play("attack_up")
					"down":
						_animated_sprite.play("attack_down")
					"none":
						_animated_sprite.stop()
						
	velocity = input_dir.normalized() * SPEED
	
	if player_health <= 0:
		player_alive = false
		player_health = 0		
	
	move_and_collide(velocity * delta)
	enemy_attack()	
	attack()

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = false

func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown:				
		player_health -= 20		
		$"../HUD/Control/health_label".text = "health: " + str(player_health)
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("playerhealth:" + str(player_health))

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
	$attack_cooldown.stop()
	
func attack():	
	if Input.is_action_just_pressed("attack"):
		$attack_duration_timer.start()
		Global.player_current_attack = true
		player_attack_in_progress = true
	
func _on_attack_duration_timer_timeout() -> void:
	$attack_duration_timer.stop()
	Global.player_current_attack = false
	player_attack_in_progress = false	

func _on_ready() -> void:
	$"../HUD/Control/health_label".text = "health: " + str(player_health)
