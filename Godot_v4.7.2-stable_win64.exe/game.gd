extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -400.0
@export var roll_speed = 600.0

func _physics_process(delta: float) -> void:
	# 1. Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Salto (usa tu acción "jump")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# 3. Movimiento horizontal (usa tus acciones "move_left" y "move_right")
	var direction := Input.get_axis("move_left", "move_right")
	
	# Velocidad extra si presionas "roll"
	var current_speed = speed
	if Input.is_action_pressed("roll"):
		current_speed = roll_speed

	if direction != 0:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

	# 4. Animaciones
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	if direction != 0:
		$AnimatedSprite2D.flip_h = direction < 0

	if not is_on_floor():
		$AnimatedSprite2D.animation = "jump"
	elif direction != 0:
		$AnimatedSprite2D.animation = "walk"

	# 5. Aplicar física y colisiones
	move_and_slide()

func start(pos: Vector2) -> void:
	position = pos
	show()
	$CollisionShape2D.disabled = false
