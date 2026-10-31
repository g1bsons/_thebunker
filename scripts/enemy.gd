
extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var floor_ray = $FloorRayCast2D

const SPEED := 50.0
const GRAVITY := 1000.0

# -1 = left, 1 = right
var direction := -1


func _ready() -> void:
	# Start facing left.
	animated_sprite_2d.flip_h = false


func _physics_process(delta: float) -> void:

	# Apply gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Turn around at walls or edges.
	if is_on_floor():
		if is_on_wall() or not floor_ray.is_colliding():
			turn_around()

	# Move left or right.
	velocity.x = direction * SPEED

	# Face the direction of movement.
	animated_sprite_2d.flip_h = direction < 0

	# Play walking animation.
	animated_sprite_2d.play("walk")

	move_and_slide()


func turn_around() -> void:
	# Reverse direction.
	direction *= -1

	# Move raycast to the opposite side.
	floor_ray.position.x *= -1
