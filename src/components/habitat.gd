extends Node2D
class_name Habitat

func kill_odds(die: Die):
	if die.face.value % 2 == 1:
		die.languish()

func kill_small(die: Die):
	if die.face.value <= 2:
		die.languish()

func kill_big(die: Die):
	if die.face.value == 6:
		die.languish()
	elif die.face.value == 1:
		die.thrive()
