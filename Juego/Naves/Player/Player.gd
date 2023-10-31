class_name Player
extends RigidBody2D

## ENUMS
enum ESTADO {SPAWN, VIVO, INVENCIBLE, MUERTO}


## ATRIBUTOS EXPORT
export var potencia_motor:int = 20
export var potencia_rotacion:int = 280
export var estela_maxima:int = 120


## ATRIBUTOS ONREADY
onready var canion:Canion = $Canion
onready var laser:RayoLaser = $LaserBeam2D
onready var estela_centro:Estela = $PuntoInicioCentro/Trail2D
onready var estela_izquierda:Estela = $PuntoInicioIzquierda/Trail2D
onready var estela_derecha:Estela = $PuntoInicioDerecha/Trail2D
onready var motor_sfx:Motor = $MotorSFX
onready var colisionador:CollisionShape2D = $ColisionadorNave


## ATRIBUTOS
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0
var estado_actual:int = ESTADO.SPAWN


## METODOS
func _ready() -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	# Control del estado actual de la nave
	if not esta_input_activo():
		return
	
	# Disparo rayo
	if event.is_action_pressed("disparo_secundario"):
		# Al detectar el evento presionado, activa el laser
		laser.set_is_casting(true)
	if event.is_action_released("disparo_secundario"):
		# Al soltar el evento presionaado, desactiva el laser
		laser.set_is_casting(false)
	
	# Control de las estelas y sonido motor
	if event.is_action_pressed("mover_adelante"):
		# Longitud estela, yendo hacia adelante
		estela_centro.set_max_points(estela_maxima)
		estela_izquierda.set_max_points(estela_maxima - 100)
		estela_derecha.set_max_points(estela_maxima - 100)
		# Sonido del motor avanzando
		motor_sfx.sonido_on()
	elif event.is_action_pressed("mover_atras"):
		# Longitud estela, yendo hacia atras
		estela_centro.set_max_points(0)
		estela_izquierda.set_max_points(0)
		estela_derecha.set_max_points(0)
		# Sonido del motor retrocediendo
		motor_sfx.sonido_on()
	
	# Control del sonido del motor para apagarlo
	if (event.is_action_released("mover_adelante")
	 or event.is_action_released("mover_atras")):
		motor_sfx.sonido_off()


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	# Para el manejo de la rotacion del RigidBody
	apply_torque_impulse(dir_rotacion * potencia_rotacion)
	# Para el manejo del empuje de un RigidBody (adelante/atras)
	apply_central_impulse(empuje.rotated(rotation))


func _process(delta: float) -> void:
	player_input()


## METODOS CUSTOM
func controlar_estados(nuevo_estado: int) -> void:
	# Control de los distintos estados de la nave
	match nuevo_estado:
		ESTADO.SPAWN:
			colisionador.set_deferred("disabled", true)
			canion.set_puede_disparar(false)
		ESTADO.VIVO:
			colisionador.set_deferred("disabled", false)
			canion.set_puede_disparar(true)
		ESTADO.INVENCIBLE:
			colisionador.set_deferred("disabled", true)
		ESTADO.MUERTO:
			colisionador.set_deferred("disabled", true)
			canion.set_puede_disparar(false)
			# Emite la señal que viene del Autoload
			Eventos.emit_signal("nave_destruida", global_position, 3)
			queue_free()
		_:
			printerr("Error de estado")

	estado_actual = nuevo_estado


func player_input() -> void:
	# Control del estado actual de la nave
	if not esta_input_activo():
		return
	
	# Empuje
	empuje = Vector2.ZERO
	# Control para el empuje de la nave
	if Input.is_action_pressed("mover_adelante"):
		# Movimiento hacia adelante usando el eje x del vector
		empuje = Vector2(potencia_motor, 0)
	elif Input.is_action_pressed("mover_atras"):
		# Movimiento hacia atras usando el eje -x del vector
		empuje = Vector2(-potencia_motor, 0)

	# Rotacion
	dir_rotacion = 0
	# Control para la rotacion de la nave
	if Input.is_action_pressed("rotar_horario"):
		# Rotacion en sentido horario
		dir_rotacion += 1
	elif Input.is_action_pressed("rotar_antihorario"):
		# Rotacion en sentido antihorario
		dir_rotacion -= 1

	# Disparo
	if Input.is_action_pressed("disparo_principal"):
		# Cambio de variable booleana al presionar boton
		canion.set_esta_disparando(true)
	if Input.is_action_just_released("disparo_principal"):
		# Cambio de variable booleanda al soltar el boton
		canion.set_esta_disparando(false)


func esta_input_activo() -> bool:
	if estado_actual in [ESTADO.MUERTO, ESTADO.SPAWN]:
		return false
	
	return true


func destruir() -> void:
	controlar_estados(ESTADO.MUERTO)


## SEÑALES INTERNAS
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controlar_estados(ESTADO.VIVO)
