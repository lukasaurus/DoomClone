extends CharacterBody3D

@export_category("Movement")
@export var move_speed : float = 5.0
@export var gravity : float = 20.0

@export_category("Look")
@export var mouse_sensitivity: float = 0.002
@export var pitch_limit : float = 85.0

@export_category("Shooting")
@export var fire_rate 	: float = 0.15
@export var damage 		: float = 25.0
@export var max_ammo 	: int = 30

@onready var camera  	= $Camera3D
@onready var raycaast 	= $Camera3D/RayCast3D
@onready var gun_sprite = $CanvasLayer/AnimatedSprite2D

var current_ammo 	: int
var can_fire 		: bool = true
var pitch_angle 	: float = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	current_ammo = max_ammo
	gun_sprite.play("default")
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pitch_angle = clamp(
			pitch_angle - event.relative.y * mouse_sensitivity,
			-deg_to_rad(pitch_limit),
			deg_to_rad(pitch_limit)
		)
		camera.rotation.x = pitch_angle
	
func handle_movement():
	var input_dir  = Input.get_vector("strafe_left","strafe_right","move_forward","move_back")
	var direction = (transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized()
	var speed = move_speed 
	if direction :
		velocity = direction * speed
	else:
		velocity = Vector3.ZERO
		
func _physics_process(delta: float) -> void:
	handle_movement()
	move_and_slide()
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
