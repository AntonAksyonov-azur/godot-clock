extends Node

@export_group("Clock Rain")
@export var clock_scene: PackedScene
@export var clock_radius := 128.0
@export_range(0.1, 1.0) var _clockScaleMin := 0.1 
@export_range(0.1, 1.0) var _clockScaleMax := 1.0 

func _ready() -> void:
	get_window().size_changed.connect(_on_size_changed)
	_on_size_changed()
	pass

func _process(delta: float) -> void:
	pass

func _on_bottom_body_entered(body: Node2D) -> void:	
	body.queue_free()


func _on_timer_timeout() -> void:
	spawn_clock()
	pass

func _on_size_changed() -> void:
	var window_size: Vector2i = get_window().size
	($Bottom as Node2D).position.y = window_size.y + 2.0 * clock_radius
	
	var ground: Node2D = $Ground as Node2D
	ground.scale = Vector2(window_size.x, clock_radius)
	ground.position = Vector2(window_size.x / 2.0, window_size.y + clock_radius / 2.0)

# methods
func spawn_clock() -> void:
	# Clock
	var clock := clock_scene.instantiate() as Clock
	clock._startTime = Clock.StartTimeMode.RANDOM_TIME
	clock.setUniformScale(randf_range(_clockScaleMin, _clockScaleMax))
	
	# Position
	var window_size: Vector2i = get_window().size
	
	var minPositionX: float = window_size.x - clock_radius
	var maxPositionX: float = clock_radius
	var targetPositionX: float = randf_range(minPositionX, maxPositionX)
	
	var minPositionY: float = -clock_radius * 4
	var maxPositionY: float = -clock_radius * 3
	var targetPositionY: float = randf_range(minPositionY, maxPositionY)
	
	clock.position = Vector2(targetPositionX, targetPositionY)
	
	add_child(clock)
