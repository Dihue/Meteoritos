class_name Proyectil
extends Area2D


## ATRIBUTOS
var velicidad:Vector2 = Vector2.ZERO
var danio:float


## CONSTRUCTOR
func crear(pos: Vector2, dir: float, vel: float, danio_p: int) -> void:
	position = pos
	rotation = dir
	velicidad = Vector2(vel, 0).rotated(dir)


## METODOS
func _physics_process(delta: float) -> void:
	# Movimiento del proyectil
	position += velicidad * delta


## SEÑALES
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
