class_name Nivel
extends Node


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


func crear_contenedores() -> void:
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name = "ContenedorProyectiles"
	add_child(contenedor_proyectiles)


## SEÑAL CUSTOM
func _on_disparo(proyectil:Proyectil) -> void:
	add_child(proyectil)
