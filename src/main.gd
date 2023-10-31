extends Node2D

@onready var dice_spawner = preload("res://components/die.tscn")
@onready var dice_container: GridContainer = $DicePool
@onready var habitat : Habitat = $Habitat


@export var max_dice = 60

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_seed_pool()
	
func _seed_pool():
	var dice_count = dice_container.get_child_count()
	
	if (dice_count >= max_dice):
		return
	
	for i in range(max_dice - dice_count):
		var die = dice_spawner.instantiate() as Die
		die.randomize_family()
				
		dice_container.add_child(die)

func _roll_dice():
	for die in _dice_pool():
		die.roll()

func _competition():
	var dice_pool = _dice_pool()
	
	dice_pool.shuffle()
	
	for i in dice_pool.size():
		var d1 = dice_pool[i]
		var d2 = dice_pool[(i+1) % dice_pool.size()]
		
		d1.interact(d2)

func _habitat():
	var f: Callable = [habitat.kill_big, habitat.kill_small, habitat.kill_odds].pick_random()
	
	for d in _dice_pool():
		f.call(d)

func _mutate():
	for d in _dice_pool():
		d.mutate()

func _check_health():
	for d in _dice_pool():
		if (d.health <= 0):
			d.kill()
		elif (d.health > 1):
			d.happy()
		else:
			d.neutral()

func _dice_pool() -> Array[Die]:
	var dice_pool: Array[Die]
	
	for c in dice_container.get_children():
		dice_pool.push_back(c as Die)
	
	return dice_pool

var phase_count = 0

func _on_proceed_pressed() -> void:
	match phase_count:
		0:
			$Proceed.text = "competition"
			_roll_dice()
			_habitat()
			_check_health()
		1:
			$Proceed.text = "mutate"
			_competition()
			_check_health()
		2:
			$Proceed.text = "habitat"
			_mutate()
	
	phase_count += 1
	
	if phase_count > 2:
		phase_count = 0
	













