extends Node2D

## VARIABLES
var hitpoints:float = 10.0


## METODOS
func _process(delta: float) -> void:
	$Canion.set_esta_disparando(true)


## METODOS CUSTOM
func recibir_danio(danio: float) -> void:
	hitpoints -= danio

	if hitpoints <= 0.0:
		queue_free()


## SEÑALES
func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		body.destruir()
