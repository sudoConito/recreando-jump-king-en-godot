extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $CollisionShape2D/AnimatedSprite2D
@onready var medidorF: VSlider = $"../visualCanvas/VSlider"

const SPEED := 300.0
const SALTO_MIN := -400.0     # salto con toque rápido
const FUERZA_EXTRA := 150.0   # se multiplica por el tiempo cargado
const TIEMPO_MAX := 2.0
const REBOTE := 0.6
var presionando := false
var tiempo := 0.0
const TIEMPO_CHOQUE := 0.3
var _fin_choque := 0.0
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Empezar a cargar
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		presionando = true
		tiempo = 0.0
	# Cargar / soltar / cancelar
	if presionando:
		if not is_on_floor():
			presionando = false          # se cayó mientras cargaba
			tiempo = 0.0
		elif Input.is_action_just_released("saltar"):
			velocity.y = SALTO_MIN - FUERZA_EXTRA * tiempo
			presionando = false
			tiempo = 0.0
		else:
			tiempo = min(tiempo + delta, TIEMPO_MAX)
			velocity.x = 0.0
	medidorF.value = tiempo
	var direction := 0.0
	if is_on_floor() and not presionando:
		direction = Input.get_axis("izquierda", "derecha")
		velocity.x = direction * SPEED
		if direction != 0.0:
			anim.flip_h = direction < 0.0
	var vx_antes := velocity.x
	move_and_slide()
	if is_on_wall() and not is_on_floor() and abs(vx_antes) > 10.0:
		var normal := get_wall_normal()
		velocity.x = normal.x * abs(vx_antes) * REBOTE
		anim.flip_h = !velocity.x < 0.0
		_fin_choque = Time.get_ticks_msec() / 1000.0 + TIEMPO_CHOQUE
	_actualizar_animacion(direction)
func _actualizar_animacion(direction: float) -> void:
	var nueva := "idle"
	var ahora := Time.get_ticks_msec() / 1000.0

	if ahora < _fin_choque and not is_on_floor():
		nueva = "choque"
	elif not is_on_floor():
		nueva = "saltando" if velocity.y < 0.0 else "cayendo"
	elif presionando:
		nueva = "jump"
	elif direction != 0.0:
		nueva = "run"

	if anim.animation != nueva:
		anim.play(nueva)
