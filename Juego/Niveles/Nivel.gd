class_name Nivel
extends Node

## ATRIBUTOS EXPORT
export var explosion:PackedScene = null
export var meteorito:PackedScene = null
export var explosion_meteorito:PackedScene = null


## ATRIBUTOS ONREADY
onready var contenedor_proyectiles:Node
onready var contenedor_meteoritos:Node


## METODOS
func _ready() -> void:
	conectar_seniales()
	crear_contenedores()


## METODOS CUSTOM
func conectar_seniales() -> void:
	# Conexion de la señal para el disparo
	Eventos.connect("disparo", self, "_on_disparo")
	# Conexion de la señal para la destruccion de la nave
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")
	# Conexion de la señal para el spawn de los meteoritos
	Eventos.connect("spawn_meteoritos", self, "_on_spawn_meteoritos")
	# Conexion de la señal de animacion de la destruccion del meteorito
	Eventos.connect("meteorito_destruido", self, "_on_meteorito_destruido")


func crear_contenedores() -> void:
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name = "ContenedorProyectiles"
	add_child(contenedor_proyectiles)
	
	contenedor_meteoritos = Node.new()
	contenedor_meteoritos.name = "ContenedorMeteoritos"
	add_child(contenedor_meteoritos)


## CONEXION SEÑALES EXTERNAS CUSTOM
func _on_disparo(proyectil:Proyectil) -> void:
	add_child(proyectil)


func _on_nave_destruida(posicion: Vector2, num_explosiones: int) -> void:
	for _i in range(num_explosiones):
		# Variable que se le asigna una instancia de la explosion
		var new_explosion:Node2D = explosion.instance()
		# Asignar la posicion de la nave para la explosion
		new_explosion.global_position = posicion
		# Agregar la instancia de la escena de la explosion
		add_child(new_explosion)
		# Frena al for en cada iteracion
		yield(get_tree().create_timer(0.6),"timeout")


func _on_spawn_meteoritos(pos_spawn: Vector2, dir_meteorito: Vector2, tamanio: float) -> void:
	var new_meteorito:Meteorito = meteorito.instance()
	new_meteorito.crea(
		pos_spawn,
		dir_meteorito,
		tamanio
	)
	contenedor_meteoritos.add_child(new_meteorito)


func _on_meteorito_destruido(pos: Vector2) -> void:
	var new_explosion:ExplosionMeteorito = explosion_meteorito.instance()
	new_explosion.global_position = pos
	add_child(new_explosion)
