class_name MeteoritoSpawner
extends Position2D


## VARIABLES EXPORT
export var direccion:Vector2 = Vector2(1, 1)
export var rango_tamanio_meteorito:Vector2 = Vector2(0.5, 2.2)


## METODOS
func _ready() -> void:
	yield(owner,"ready")
	spawnear_meteoritos()


## METODOS CUSTOM
func spawnear_meteoritos() -> void:
	Eventos.emit_signal(
		"spawn_meteoritos",
		global_position,
		direccion,
		tamanio_meteorito_aleatorio())


func tamanio_meteorito_aleatorio() -> float:
	randomize()
	return rand_range(rango_tamanio_meteorito[0], rango_tamanio_meteorito[1])
