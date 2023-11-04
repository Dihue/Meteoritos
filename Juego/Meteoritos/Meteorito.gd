class_name Meteorito
extends RigidBody2D


## ATRIBUTOS EXPORT
export var vel_lineal_base:Vector2 = Vector2(300.0, 300.0)
export var vel_angular_base:float = 3.0
export var hitpoints_base:float = 10.0


## ATRIBUTOS ONREADY
onready var impacto_sfx:AudioStreamPlayer2D = $ImpactoSFX
onready var animacion:AnimationPlayer = $AnimationPlayer


## ATRIBUTOS
var hitpoints:float


## CONSTRUCTOR
func crea(pos: Vector2, dir: Vector2, tamanio: float) -> void:
	position = pos
	# Calcular la Masa, el Tamaño del Sprite y el del Colisionador
	mass *= tamanio
	$Sprite.scale = Vector2.ONE * tamanio
	
	# Variables para el radio de la forma del Colisionador
	var radio:int = int($Sprite.texture.get_size().x / 2.2 * tamanio)
	var forma_colision:CircleShape2D = CircleShape2D.new()
	forma_colision.radius = radio
	$CollisionShape2D.shape = forma_colision
	
	# Calcular velocidades
	linear_velocity = (vel_lineal_base * dir / tamanio) * aleatorizar_velocidad()
	angular_velocity = (vel_angular_base / tamanio) * aleatorizar_velocidad()
	
	# Calcular hitpoints
	hitpoints = hitpoints_base * tamanio


## METODOS
func _ready() -> void:
	pass


## METODOS CUSTOM
func recibir_danio(danio: float) -> void:
	hitpoints -= danio
	if hitpoints  <= 0.0:
		destruir()
		
	impacto_sfx.play()
	animacion.play("impacto")


func destruir() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	Eventos.emit_signal("meteorito_destruido", global_position)
	queue_free()


func aleatorizar_velocidad() -> float:
	randomize()
	return rand_range(1.1, 1.4)
