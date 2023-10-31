extends Control
class_name Die

class Face:
	var type: FaceType
	var value: int

enum Family {
	Kanine,
	Bird,
	Insect,
	Reptile
}

enum FaceType{ # Trigger special effects
	Normal,
	Unknown,
	Predator
}

@onready var face_sprites: AnimatedSprite2D = $Faces

var faces: Array[Face] = []
var face : Face
var health := 1
var family: Family

func roll() -> Face:
	var face_idx = randi_range(1, 6);
	self.face = faces[face_idx]
	self.face_sprites.frame = self.face.value
	
	return self.face

func randomize_family():
	self.family = randi_range(0, Die.Family.size()-1) as Die.Family
	
	
	$Family.clear()
	$Family.append_text("[center]" + str(Family.keys()[self.family]))

func kill():
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, 'modulate', Color.RED, 1.0)
	tween.tween_callback(queue_free)

func happy():
	var tween = create_tween().set_ease(Tween.EASE_IN)	
	tween.tween_property(self, 'modulate', Color.GREEN, 1.0)

func neutral():
	var tween = create_tween()
	tween.tween_property(self, 'modulate', Color.WHITE, .4)

func thrive():
	self.health += 1

func languish():
	self.health -= 1

func interact(other : Die):
	if (other.family == self.family):
		other.thrive()
		self.thrive()
	else:
		if (other.face.value >= self.face.value):
			self.languish()
		if (other.face.value <= self.face.value):
			other.languish()

func mutate():
	print("Mutate!")
	var chance = randi_range(0, 5)
	
	match chance:
		0:
			self.randomize_family()
		1:
			self.face.value = (self.face.value + 1) % (faces.size() - 1)
			self.face_sprites.frame = self.face.value
			print ("Changed value to ", self.face.value)
		2:
			self.face.value = (self.face.value - 1) % (faces.size() - 1)
			self.face_sprites.frame = self.face.value
			print ("Changed value to ", self.face.value)
	

func _ready() -> void:
	for i in range(11):
		var f = Face.new()
		if i == 10:
			f.type = FaceType.Unknown
		else:
			f.type = FaceType.Normal
		
		f.value = i
		
		self.faces.push_back(f)
		
	self.face = self.faces[10]

