class_name Motor
extends AudioStreamPlayer2D


## VARIABLES EXPORT
export var tiempo_transicion:float = 0.5
export var volumen_apagado:float = -30.0


## VARIABLES ONREADY
onready var tween_sonido:Tween = $Tween


## VARIABLES
var volumen_original:float


## METODOS
func _ready() -> void:
	volumen_original = volume_db
	volume_db = volumen_apagado


## METODOS CUSTOM
func sonido_on() -> void:
	# Si no esta sonando, ejecutar sonido
	if not playing:
		play()

	# Efecto de transicion ON
	efecto_transicion(volume_db, volumen_original)


func sonido_off() -> void:
	# Efecto de transicion OFF
	efecto_transicion(volume_db, volumen_apagado)


func efecto_transicion(desde_vol: float, hasta_vol: float) -> void:
	tween_sonido.interpolate_property(
		self,
		"volume_db",
		desde_vol,
		hasta_vol,
		tiempo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT_IN
	)
	tween_sonido.start()
