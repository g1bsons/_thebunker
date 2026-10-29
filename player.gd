extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

const SPEED := 130.0
const ACCELERATION := 800.0
const FRICTION := 1000.0
const GRAVITY := 1000.0
const FALL_GRAVITY := 1500.0
const JUMP_VELOCITY := -350.0


#func control_my_animations(direction: float) -> void:
	#if direction:
		#animation_player.play("run")
		#animated_sprite_2d.flip_h = direction < 0
	#else:
		#animation_player.play("idle")
		#
	#if not is_on_floor():
		#animation_player.play("idle")


func control_animations(directions: float) -> void:
	if not is_on_floor():
		animated_sprite_2d.play("idle")
	elif directions != 0:
		animated_sprite_2d.play("run")
		animated_sprite_2d.flip_h = directions < 0
	else:
		animated_sprite_2d.play("idle")



func calc_gravity(current_velocity: Vector2) -> float:
	if current_velocity.y < 0 :
		return GRAVITY
	return FALL_GRAVITY


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += calc_gravity(velocity) * delta
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)


	control_animations(direction)
	move_and_slide()
