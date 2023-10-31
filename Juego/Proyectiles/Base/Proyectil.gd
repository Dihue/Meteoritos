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
	danio = danio_p


## METODOS
func _physics_process(delta: float) -> void:
	# Movimiento del proyectil
	position += velicidad * delta


## METODOS CUSTOM
func daniar(otro_cuerpo: CollisionObject2D) -> void:
	# Si tiene el metodo por el cual estamos preguntado
	if otro_cuerpo.has_method("recibir_danio"):
		otro_cuerpo.recibir_danio(danio)
	
	queue_free()


## SEÑALES INTERNAS
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	daniar(area)


func _on_body_entered(body: Node) -> void:
	daniar(body)
