extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null

var enemy_health = 100
var player_in_attack_zone = false
var enemy_vulnerable = true
var enemy_dead = false

func _physics_process(delta: float) -> void:
	deal_with_damage()
	
func enemy():
	pass

func deal_with_damage():
	if(enemy_vulnerable):	
		if(player_in_attack_zone and Global.player_current_attack):				
			enemy_health -= 20		
			if (enemy_health<=0):
				queue_free()
			print("enemy health:" + str(enemy_health))			
			$enemy_invulnerability_timer.start()
			enemy_vulnerable = false

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	print("hitbox entered")
	if body.has_method("player"):
		player_in_attack_zone = true
		print(player_in_attack_zone)


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = false


func _on_enemy_invulnerability_timer_timeout() -> void:
	enemy_vulnerable = true
	$enemy_invulnerability_timer.stop()
