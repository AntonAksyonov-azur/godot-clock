class_name Clock
extends RigidBody2D

enum StartTimeMode { 
	SYSTEM_TIME, 
	RANDOM_TIME, 
	FIXED_TIME,
	OFFSET_TIME
}

@export_group("Clock Parts")
@export var _collision_shape := CollisionShape2D
@export var _visualization := Node2D;
@export var _arm_hour := Node2D;
@export var _arm_minute := Node2D;
@export var _arm_second := Node2D;

@export_group("Clock Mode")
@export var _startTime := StartTimeMode.SYSTEM_TIME

@export_group("Clock Instances")
@export var time_scale_min := -10.0
@export var time_scale_max := 10.0
@export var _timeScale := 1.0

@export_group("Fixed or Offset Start Time. Doesnt apply for SYSTEM_TIME, RANDOM_TIME")
@export_range(-11, 11) var _startHour := 0 
@export_range(0, 59) var _startMinute := 0 
@export_range(0, 59) var _startSecond := 0 

@onready var _armSeconds := $Face/ArmSeconds as Node2D;
@onready var _armMinute := $Face/ArmMinute as Node2D;
@onready var _armHour := $Face/ArmHour as Node2D; 

var _currentSeconds := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initializeByMode()
	_currentSeconds = getInitialTimeByMode()
	
	updateCurrentTime(0.0)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateCurrentTime(delta)
	pass

#
func getInitialTimeByMode() -> float:
	if _startTime == StartTimeMode.SYSTEM_TIME:
		var currentTime: Dictionary = Time.get_time_dict_from_system()
		var currentSeconds = currentTime["second"] + currentTime["minute"] * 60 + currentTime["hour"] * 3600
		return currentSeconds
	
	elif _startTime == StartTimeMode.RANDOM_TIME:
		var randomTime: float = randf_range(0.0, 60.0 * 60.0 * 12.0 / 2.0);
		return randomTime
		
	elif _startTime == StartTimeMode.FIXED_TIME:
		var currentSeconds: float = _startSecond + _startMinute * 60 + _startHour * 3600
		return currentSeconds
	
	elif _startTime == StartTimeMode.OFFSET_TIME:
		var currentTime: Dictionary = Time.get_time_dict_from_system()
		var currentSystemSeconds = currentTime["second"] + currentTime["minute"] * 60 + currentTime["hour"] * 3600
		var currentStartSeconds: float = _startSecond + _startMinute * 60 + _startHour * 3600
		return currentSystemSeconds + currentStartSeconds
		
	else:
		return 0

func initializeByMode() -> void:
	if _startTime == StartTimeMode.RANDOM_TIME:
		_timeScale = randf_range(time_scale_min, time_scale_max)
	pass

func updateCurrentTime(delta: float) -> void:
	_currentSeconds += delta * _timeScale
	_armSeconds.rotation = fmod(_currentSeconds, 60) * TAU / 60.0 
	_armMinute.rotation = fmod(_currentSeconds / 60, 60) * TAU / 60.0 
	_armHour.rotation = fmod(_currentSeconds / 3600, 12) * TAU / 12.0
	pass
	
func setUniformScale(scale_factor: float) -> void:
	_visualization.scale = Vector2(scale_factor, scale_factor)
	_collision_shape.scale = Vector2(scale_factor, scale_factor)
