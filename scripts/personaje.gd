extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $CollisionShape2D/AnimatedSprite2D
#comunicacion sin emocion y una voz en off
#no tocar por favor esto es en la laptop buena
@onready var medidorF:VSlider=$"../visualCanvas/VSlider"
var SPEED = 300.0
var JUMP_VELOCITY = -400.0
@onready var presionando=false
#variable de tiempo de presion para medir la fuerza de salto
var tiempo=0
var fuerzaDeSalto=150
#hacer el sistema de jump king al mantener presionado el boton de saltar que sea por tiempo y mientras mas mantienes presionado mas alto saltara fin
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("saltar")and is_on_floor():
		anim.play("jump")
		presionando=true
	if presionando:
		if tiempo<2:
			tiempo+=delta
	medidorF.value=tiempo
	if Input.is_action_just_released("saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY-(150*tiempo)
		fuerzaDeSalto=0
		tiempo=0
		presionando=false
	if not presionando:
		var direction := Input.get_axis("izquierda", "derecha")
		velocity.x = direction * SPEED
		if direction != 0:
			anim.play("run")
			$CollisionShape2D/AnimatedSprite2D.flip_h = direction < 0
		else:
			anim.play("idle")   # o anim.stop() si no tienes idle
	if not is_on_floor():
		velocity += get_gravity() * delta
		anim.play("cayendo")
	move_and_slide()
