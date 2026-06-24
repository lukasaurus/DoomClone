extends CharacterBody3D

@export_category("Movement")
@export var move_speed : float = 5.0
@export var gravity : float = 20.0
@export var jump_force : float = 5.0

@export_category("Look")
@export var mouse_sensitivity: float = 0.002
@export var pitch_limit : float = 85.0

@export_category("Shooting")
var can_shoot = true

@export var fire_rate 	: float = 0.15
@export var damage 		: float = 25.0
@export var max_ammo 	: int = 30

@onready var camera  	= $Camera3D
@onready var raycast 	= $Camera3D/RayCast3D
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
	apply_gravity(delta)
	handle_jump()
	handle_shooting()#<------------------------
	move_and_slide()
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
func handle_jump():
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y += jump_force
			
func fire():
	can_fire = false
	current_ammo -= 1
	gun_sprite.play("fire")
	if raycast.is_colliding():
		var hit_collider = raycast.get_collider()
		print(hit_collider.name) #<------------------------- ADD THIS
		if hit_collider.has_method("take_damage"):
			hit_collider.take_damage(damage)
	await gun_sprite.animation_finished
	can_fire = true
	gun_sprite.play("default")

func handle_shooting():
	var should_fire = Input.is_action_just_pressed("shoot")
	if should_fire and can_fire and current_ammo > 0:
		fire()
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
