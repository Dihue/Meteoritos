class_name Nivel
extends Node

## ATRIBUTOS EXPORT
export var explosion:PackedScene = null


## ATRIBUTOS ONREADY
onready var contenedor_proyectiles:Node


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


func crear_contenedores() -> void:
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name = "ContenedorProyectiles"
	add_child(contenedor_proyectiles)


## SEÑAL CUSTOM
func _on_disparo(proyectil:Proyectil) -> void:
	add_child(proyectil)


func _on_nave_destruida(posicion: Vector2, num_explosiones: int) -> void:
	for i in range(num_explosiones):
		# Variable que se le asigna una instancia de la explosion
		var new_explosion:Node2D = explosion.instance()
		# Asignar la posicion de la nave para la explosion
		new_explosion.global_position = posicion
		# Agregar la instancia de la escena de la explosion
		add_child(new_explosion)
		# Frena al for en cada iteracion
		yield(get_tree().create_timer(0.6),"timeout")
