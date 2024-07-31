extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	self.get("theme_override_styles/background").bg_color = Color.ROSY_BROWN
	self.get("theme_override_styles/fill").bg_color = Color.GREEN
