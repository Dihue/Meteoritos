class_name Meteorito
extends RigidBody2D


## ATRIBUTOS EXPORT
export var vel_lineal_base:Vector2 = Vector2(300.0, 300.0)
export var vel_angular_base:float = 3.0


## METODOS
func _ready() -> void:
	linear_velocity = vel_lineal_base
	angular_velocity = vel_angular_base
