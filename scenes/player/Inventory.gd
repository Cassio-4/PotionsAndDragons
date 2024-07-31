extends Node

var ingredients = {"i1": 0, "i2": 0, "i3": 0}

func item_pickup(item_type):
	if item_type == 1:
		ingredients["i1"] += 1
	elif item_type == 2:
		ingredients["i2"] += 1
	elif item_type == 3:
		ingredients["i3"] += 1
	else:
		return
