class_name Player
extends RigidBody2D


## ATRIBUTOS EXPORT
export var potencia_motor:int = 20
export var potencia_rotacion:int = 280


## ATRIBUTOS ONREADY
onready var canion:Canion = $Canion
onready var laser:RayoLaser = $LaserBeam2D


## ATRIBUTOS
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0


## METODOS
func _unhandled_input(event: InputEvent) -> void:
	# Disparo rayo
	if event.is_action_pressed("disparo_secundario"):
		# Al detectar el evento presionado, activa el laser
		laser.set_is_casting(true)
	if event.is_action_released("disparo_secundario"):
		# Al soltar el evento presionaado, desactiva el laser
		laser.set_is_casting(false)


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	# Para el manejo de la rotacion del RigidBody
	apply_torque_impulse(dir_rotacion * potencia_rotacion)
	# Para el manejo del empuje de un RigidBody (adelante/atras)
	apply_central_impulse(empuje.rotated(rotation))


func _process(delta: float) -> void:
	player_input()


## METODOS CUSTOM
func player_input() -> void:
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
