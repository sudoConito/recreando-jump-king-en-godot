extends CharacterBody2D
#no tocar por favor esto es en la laptop buena
var SPEED = 300.0
var JUMP_VELOCITY = -400.0
@onready var presionando=false
var tiempo=0
var fuerzaDeSalto=150
#hacer el sistema de jump king al mantener presionado el boton de saltar que sea por tiempo y mientras mas mantienes presionado mas alto saltara fin
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("saltar")and is_on_floor():
		presionando=true
	if not presionando:
		var direction := Input.get_axis("izquierda", "derecha")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	#aqui documentando que si presionas puedes obtener mas fuerza al saltar
	if presionando:
		print(tiempo)
		if tiempo<2:
			tiempo+=delta
	if Input.is_action_just_released("saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY-(150*tiempo)
		fuerzaDeSalto=0
		tiempo=0
		presionando=false

	move_and_slide()
