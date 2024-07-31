extends CanvasLayer

@onready var health_bar = $MarginContainer/Rows/TopRow/HealthSection/HealthBar

var player: Player = null
@onready var ingredient_count1 = $MarginContainer/Rows/TopRow/IngredientCont1/Counters/Number
@onready var ingredient_count2 = $MarginContainer/Rows/TopRow/IngredientCont2/Counters/Number
@onready var ingredient_count3 = $MarginContainer/Rows/TopRow/IngredientCont3/Counters/Number

func set_player(a_player: Player):
	self.player = a_player
	set_new_health_value(player.health_stat.health)
	player.player_health_changed.connect(self.set_new_health_value)
	player.ingredient_picked.connect(self.set_ingredients_count)

func set_new_health_value(a_new_health: int):
	#Should I use .get this frequently?
	var health_bar_fill_theme = health_bar.get("theme_override_styles/fill")
	var highlight_color = Color("ffcccc")
	var tween = get_tree().create_tween()
	
	tween.tween_property(health_bar, "value", a_new_health, 0.3)
	tween.parallel().tween_property(health_bar_fill_theme, "bg_color", highlight_color, 0.15)
	tween.tween_property(health_bar_fill_theme, "bg_color", calc_health_color(a_new_health), 0.15)

func calc_health_color(a_new_health: int) -> Color:
	var r = abs(a_new_health * 0.01 - 1.0)
	var g = a_new_health * 0.01
	var b = 0.0
	return Color(r, g, b)

func set_ingredients_count(ingredients_dict: Dictionary):
	ingredient_count1.text = str(ingredients_dict["i1"])
	ingredient_count2.text = str(ingredients_dict["i2"])
	ingredient_count3.text = str(ingredients_dict["i3"])
