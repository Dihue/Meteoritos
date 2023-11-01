class_name Escudo
extends Area2D


## VARIABLES EXPORT
export var energia:float = 8.0
export var radio_desgaste:float = -1.6


## VARIABLES ONREADY
onready var animaciones:AnimationPlayer = $AnimationPlayer


## VARIABLES
var esta_activado:bool = false setget ,get_esta_activado


## SETTERS Y GETTERS
func get_esta_activado() -> bool:
	return esta_activado


## METODOS
func _ready() -> void:
	# Desartiva el metodo process
	set_process(false)
	controlar_colisionador(true)


func _process(delta: float) -> void:
	# Calculo del desgaste de energia
	energia += radio_desgaste * delta
	# Una vez que se queda sin enegia, desactiva el escudo
	if energia <= 0.0:
		desactivar()


## METODOS CUSTOM
# Metodo para el control del colisionador del escudo
func controlar_colisionador(esta_desactivado: bool) -> void:
	$CollisionShape2D.set_deferred("disabled", esta_desactivado)


# Metodo para activar el escudo
func activar() -> void:
	# Control de que no tenga energia
	if energia <= 0.0:
		return
	# Cambio de la variable
	esta_activado = true
	controlar_colisionador(false)
	animaciones.play("activando")


# Metodo para desactivar el escudo
func desactivar() -> void:
	# Detener el metodo process
	set_process(false)
	# Cambio de variable
	esta_activado = false
	controlar_colisionador(true)
	animaciones.play_backwards("activando")


## SEÑALES INTERNAS
# Una vez terminada la animacion, se cumple con las condiciones
# y llama a la siguiente animacion
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "activando" and esta_activado:
		animaciones.play("activado")
		# Activar el metodo process
		set_process(true)


func _on_Escudo_body_entered(body: Node) -> void:
	body.queue_free()
